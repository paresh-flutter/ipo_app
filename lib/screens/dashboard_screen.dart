import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/ipo_bloc.dart';
import '../bloc/ipo_event.dart';
import '../bloc/ipo_state.dart';
import '../models/ipo_model.dart';
import '../widgets/ipo_card.dart';
import 'ipo_detail_screen.dart';
import 'ipo_application_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<IpoBloc>().add(LoadAllIpos());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // App Bar with Gradient
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.trending_up,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'IPO Market',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Track & Apply for IPOs',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: Add notifications
                              },
                              icon: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: const Color(0xFF1976D2),
          ),
          
          // Market Overview Cards
          SliverToBoxAdapter(
            child: BlocBuilder<IpoBloc, IpoState>(
              builder: (context, state) {
                if (state is IpoLoaded) {
                  return _buildMarketOverview(state.ipos);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          
          // Quick Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          title: 'My Applications',
                          subtitle: 'Track your IPO bids',
                          icon: Icons.assignment_outlined,
                          color: Colors.green,
                          onTap: () {
                            // TODO: Navigate to applications
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionCard(
                          title: 'Watchlist',
                          subtitle: 'Monitor IPOs',
                          icon: Icons.bookmark_outline,
                          color: Colors.orange,
                          onTap: () {
                            // TODO: Navigate to watchlist
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          title: 'IPO Calendar',
                          subtitle: 'Upcoming dates',
                          icon: Icons.calendar_today_outlined,
                          color: Colors.blue,
                          onTap: () {
                            // TODO: Navigate to calendar
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionCard(
                          title: 'Market News',
                          subtitle: 'Latest updates',
                          icon: Icons.newspaper_outlined,
                          color: Colors.purple,
                          onTap: () {
                            // TODO: Navigate to news
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Trending IPOs Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trending IPOs',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to all IPOs
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),
          
          // IPO List
          BlocBuilder<IpoBloc, IpoState>(
            builder: (context, state) {
              if (state is IpoLoading) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              
              if (state is IpoLoaded) {
                // Show only trending IPOs (ongoing and upcoming)
                final trendingIpos = state.ipos
                    .where((ipo) => 
                        ipo.status == IpoStatus.ongoing || 
                        ipo.status == IpoStatus.upcoming)
                    .take(3)
                    .toList();
                
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _TrendingIpoCard(ipo: trendingIpos[index]);
                    },
                    childCount: trendingIpos.length,
                  ),
                );
              }
              
              return const SliverToBoxAdapter(
                child: Center(
                  child: Text('No IPOs available'),
                ),
              );
            },
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketOverview(List<IpoModel> ipos) {
    final ongoingCount = ipos.where((ipo) => ipo.status == IpoStatus.ongoing).length;
    final upcomingCount = ipos.where((ipo) => ipo.status == IpoStatus.upcoming).length;
    final totalSubscription = ipos
        .where((ipo) => ipo.totalSubscription != null)
        .map((ipo) => ipo.totalSubscription!)
        .fold(0.0, (sum, sub) => sum + sub);
    final avgSubscription = totalSubscription / ipos.where((ipo) => ipo.totalSubscription != null).length;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Market Overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _OverviewCard(
                  title: 'Ongoing IPOs',
                  value: ongoingCount.toString(),
                  icon: Icons.play_circle_filled,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OverviewCard(
                  title: 'Upcoming IPOs',
                  value: upcomingCount.toString(),
                  icon: Icons.schedule,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _OverviewCard(
                  title: 'Avg Subscription',
                  value: '${avgSubscription.toStringAsFixed(1)}x',
                  icon: Icons.trending_up,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OverviewCard(
                  title: 'Total IPOs',
                  value: ipos.length.toString(),
                  icon: Icons.business,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _OverviewCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingIpoCard extends StatelessWidget {
  final IpoModel ipo;

  const _TrendingIpoCard({required this.ipo});

  Color _getStatusColor(IpoStatus status) {
    switch (status) {
      case IpoStatus.ongoing:
        return const Color(0xFF00C853);
      case IpoStatus.upcoming:
        return const Color(0xFF2196F3);
      case IpoStatus.closed:
        return const Color(0xFF757575);
      case IpoStatus.listed:
        return const Color(0xFF9C27B0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('dd MMM');
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IpoDetailScreen(ipo: ipo),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ipo.companyName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (ipo.sector != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          ipo.sector!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(ipo.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(ipo.status).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    ipo.statusString,
                    style: TextStyle(
                      color: _getStatusColor(ipo.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    label: 'Price Band',
                    value: ipo.priceBand,
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    label: 'Issue Size',
                    value: ipo.issueSize,
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    label: 'Closes',
                    value: dateFormatter.format(ipo.closeDate),
                  ),
                ),
              ],
            ),
            
            if (ipo.totalSubscription != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ipo.isOversubscribed 
                      ? Colors.green.shade50 
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ipo.isOversubscribed 
                        ? Colors.green.shade200 
                        : Colors.orange.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      ipo.isOversubscribed 
                          ? Icons.trending_up 
                          : Icons.trending_flat,
                      color: ipo.isOversubscribed 
                          ? Colors.green.shade700 
                          : Colors.orange.shade700,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ipo.subscriptionStatusText,
                      style: TextStyle(
                        color: ipo.isOversubscribed 
                            ? Colors.green.shade700 
                            : Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ipo.status == IpoStatus.ongoing ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IpoApplicationScreen(ipo: ipo),
                    ),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getStatusColor(ipo.status),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  ipo.status == IpoStatus.ongoing 
                      ? 'Apply Now' 
                      : ipo.status == IpoStatus.upcoming 
                          ? 'Coming Soon'
                          : 'View Details',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
