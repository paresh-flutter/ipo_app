import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ipo_model.dart';

class IpoDetailScreen extends StatelessWidget {
  final IpoModel ipo;

  const IpoDetailScreen({
    super.key,
    required this.ipo,
  });

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

  LinearGradient _getStatusGradient(IpoStatus status) {
    switch (status) {
      case IpoStatus.ongoing:
        return const LinearGradient(
          colors: [Color(0xFF00C853), Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case IpoStatus.upcoming:
        return const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF03DAC6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case IpoStatus.closed:
        return const LinearGradient(
          colors: [Color(0xFF757575), Color(0xFF9E9E9E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case IpoStatus.listed:
        return const LinearGradient(
          colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getStatusIcon(IpoStatus status) {
    switch (status) {
      case IpoStatus.ongoing:
        return Icons.play_circle_filled;
      case IpoStatus.upcoming:
        return Icons.schedule;
      case IpoStatus.closed:
        return Icons.check_circle;
      case IpoStatus.listed:
        return Icons.trending_up;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('dd MMM yyyy');
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Gradient
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: _getStatusGradient(ipo.status),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getStatusIcon(ipo.status),
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ipo.companyName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (ipo.sector != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      ipo.sector!,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Text(
                            ipo.statusString,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: _getStatusColor(ipo.status),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Key Information Section
                  _SectionHeader(
                    title: 'Key Information',
                    icon: Icons.info_outline,
                    color: _getStatusColor(ipo.status),
                  ),
                  const SizedBox(height: 16),
                  
                  _InfoGrid(
                    children: [
                      _DetailInfoTile(
                        label: 'IPO Type',
                        value: ipo.ipoTypeString,
                        icon: Icons.category_outlined,
                        color: Colors.blue.shade600,
                      ),
                      _DetailInfoTile(
                        label: 'Issue Size',
                        value: ipo.issueSize,
                        icon: Icons.account_balance_wallet_outlined,
                        color: Colors.green.shade600,
                      ),
                      _DetailInfoTile(
                        label: 'Price Band',
                        value: ipo.priceBand,
                        icon: Icons.currency_rupee,
                        color: Colors.orange.shade600,
                      ),
                      _DetailInfoTile(
                        label: 'Lot Size',
                        value: '${ipo.lotSize} shares',
                        icon: Icons.inventory_2_outlined,
                        color: Colors.purple.shade600,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Subscription Status Section
                  if (ipo.totalSubscription != null) ...[
                    _SectionHeader(
                      title: 'Subscription Status',
                      icon: Icons.trending_up_outlined,
                      color: _getStatusColor(ipo.status),
                    ),
                    const SizedBox(height: 16),
                    
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: ipo.isOversubscribed 
                              ? [Colors.green.shade50, Colors.green.shade100]
                              : [Colors.orange.shade50, Colors.orange.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ipo.isOversubscribed 
                              ? Colors.green.shade200 
                              : Colors.orange.shade200,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                ipo.isOversubscribed 
                                    ? Icons.trending_up 
                                    : Icons.trending_flat,
                                color: ipo.isOversubscribed 
                                    ? Colors.green.shade700 
                                    : Colors.orange.shade700,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ipo.subscriptionStatusText,
                                      style: TextStyle(
                                        color: ipo.isOversubscribed 
                                            ? Colors.green.shade700 
                                            : Colors.orange.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      ipo.isOversubscribed 
                                          ? 'IPO is oversubscribed'
                                          : 'IPO is undersubscribed',
                                      style: TextStyle(
                                        color: ipo.isOversubscribed 
                                            ? Colors.green.shade600 
                                            : Colors.orange.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          // Subscription Breakdown
                          if (ipo.subscriptionBreakdown.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            ...ipo.subscriptionBreakdown.map((sub) => 
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _getCategoryName(sub.category),
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    Text(
                                      '${sub.subscriptionTimes.toStringAsFixed(2)}x',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                  
                  // Timeline Section
                  _SectionHeader(
                    title: 'Timeline',
                    icon: Icons.schedule_outlined,
                    color: _getStatusColor(ipo.status),
                  ),
                  const SizedBox(height: 16),
                  
                  _TimelineItem(
                    title: 'IPO Opens',
                    date: dateFormatter.format(ipo.openDate),
                    icon: Icons.play_arrow,
                    color: Colors.green,
                    isCompleted: DateTime.now().isAfter(ipo.openDate),
                  ),
                  _TimelineItem(
                    title: 'IPO Closes',
                    date: dateFormatter.format(ipo.closeDate),
                    icon: Icons.stop,
                    color: Colors.red,
                    isCompleted: DateTime.now().isAfter(ipo.closeDate),
                  ),
                  if (ipo.allotmentDate != null)
                    _TimelineItem(
                      title: 'Allotment Date',
                      date: dateFormatter.format(ipo.allotmentDate!),
                      icon: Icons.assignment_turned_in,
                      color: Colors.blue,
                      isCompleted: DateTime.now().isAfter(ipo.allotmentDate!),
                    ),
                  if (ipo.listingDate != null)
                    _TimelineItem(
                      title: 'Listing Date',
                      date: dateFormatter.format(ipo.listingDate!),
                      icon: Icons.launch,
                      color: Colors.purple,
                      isCompleted: DateTime.now().isAfter(ipo.listingDate!),
                      isLast: true,
                    ),
                  
                  const SizedBox(height: 32),
                  
                  // Additional Information
                  if (ipo.leadManager != null || ipo.registrar != null) ...[
                    _SectionHeader(
                      title: 'Additional Information',
                      icon: Icons.business_outlined,
                      color: _getStatusColor(ipo.status),
                    ),
                    const SizedBox(height: 16),
                    
                    if (ipo.leadManager != null)
                      _DetailInfoTile(
                        label: 'Lead Manager',
                        value: ipo.leadManager!,
                        icon: Icons.business_center_outlined,
                        color: Colors.indigo.shade600,
                        fullWidth: true,
                      ),
                    
                    if (ipo.registrar != null) ...[
                      const SizedBox(height: 12),
                      _DetailInfoTile(
                        label: 'Registrar',
                        value: ipo.registrar!,
                        icon: Icons.assignment_outlined,
                        color: Colors.teal.shade600,
                        fullWidth: true,
                      ),
                    ],
                    
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(SubscriptionCategory category) {
    switch (category) {
      case SubscriptionCategory.qib:
        return 'QIB';
      case SubscriptionCategory.retail:
        return 'Retail';
      case SubscriptionCategory.nii:
        return 'NII';
      case SubscriptionCategory.others:
        return 'Others';
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final List<Widget> children;

  const _InfoGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: children,
    );
  }
}

class _DetailInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool fullWidth;

  const _DetailInfoTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String date;
  final IconData icon;
  final Color color;
  final bool isCompleted;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.date,
    required this.icon,
    required this.color,
    required this.isCompleted,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCompleted ? color : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? color : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
