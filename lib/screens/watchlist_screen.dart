import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/ipo_bloc.dart';
import '../bloc/ipo_event.dart';
import '../bloc/ipo_state.dart';
import '../models/ipo_model.dart';
import '../widgets/ipo_card.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List<IpoModel> _watchlistIpos = [];
  List<IpoModel> _allIpos = [];

  @override
  void initState() {
    super.initState();
    context.read<IpoBloc>().add(LoadAllIpos());
    _loadWatchlistFromStorage();
  }

  void _loadWatchlistFromStorage() {
    // In a real app, this would load from SharedPreferences or a database
    // For demo purposes, we'll initialize with some IPOs
    setState(() {
      // This will be populated when IPOs are loaded
    });
  }

  void _saveWatchlistToStorage() {
    // In a real app, this would save to SharedPreferences or a database
    // For demo purposes, we'll just keep it in memory
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
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
                              Icons.bookmark,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'My Watchlist',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Track your favorite IPOs',
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
                                _showAddToWatchlistDialog();
                              },
                              icon: const Icon(
                                Icons.add_circle_outline,
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
            backgroundColor: const Color(0xFFFF6B35),
          ),
          
          // Watchlist Stats
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
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
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Total IPOs',
                      value: _watchlistIpos.length.toString(),
                      icon: Icons.bookmark_outline,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      title: 'Ongoing',
                      value: _watchlistIpos.where((ipo) => ipo.status == IpoStatus.ongoing).length.toString(),
                      icon: Icons.play_circle_filled,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      title: 'Upcoming',
                      value: _watchlistIpos.where((ipo) => ipo.status == IpoStatus.upcoming).length.toString(),
                      icon: Icons.schedule,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Watchlist Content
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
                _allIpos = state.ipos;
                // Initialize watchlist with some IPOs if empty (for demo)
                if (_watchlistIpos.isEmpty) {
                  _watchlistIpos = state.ipos.where((ipo) => 
                    ipo.companyName.contains('Advance') || 
                    ipo.companyName.contains('Purple') ||
                    ipo.companyName.contains('Systematic')
                  ).toList();
                }
                
                if (_watchlistIpos.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(40),
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
                        children: [
                          Icon(
                            Icons.bookmark_outline,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No IPOs in Watchlist',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add IPOs to your watchlist to track them easily',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              _showAddToWatchlistDialog();
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add to Watchlist'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B35),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _WatchlistIpoCard(
                        ipo: _watchlistIpos[index],
                        onRemove: () {
                          _removeFromWatchlist(_watchlistIpos[index]);
                        },
                      );
                    },
                    childCount: _watchlistIpos.length,
                  ),
                );
              }
              
              return const SliverToBoxAdapter(
                child: Center(
                  child: Text('Error loading watchlist'),
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

  void _showAddToWatchlistDialog() {
    final availableIpos = _allIpos.where((ipo) => 
      !_watchlistIpos.any((watchlistIpo) => watchlistIpo.companyName == ipo.companyName)
    ).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.add_circle, color: Colors.orange.shade600),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Add IPO to Watchlist',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search IPOs...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onChanged: (value) {
                    // Implement search functionality
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // IPO List
              Expanded(
                child: availableIpos.isEmpty
                    ? const Center(
                        child: Text('All IPOs are already in your watchlist!'),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: availableIpos.length,
                        itemBuilder: (context, index) {
                          final ipo = availableIpos[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              title: Text(ipo.companyName),
                              subtitle: Text('${ipo.priceBand} • ${ipo.statusString}'),
                              trailing: ElevatedButton(
                                onPressed: () => _addToWatchlist(ipo),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade600,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Add'),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToWatchlist(IpoModel ipo) {
    setState(() {
      _watchlistIpos.add(ipo);
    });
    _saveWatchlistToStorage();
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${ipo.companyName} added to watchlist'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {},
        ),
      ),
    );
  }

  void _removeFromWatchlist(IpoModel ipo) {
    setState(() {
      _watchlistIpos.remove(ipo);
    });
    _saveWatchlistToStorage();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${ipo.companyName} removed from watchlist'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _watchlistIpos.add(ipo);
            });
            _saveWatchlistToStorage();
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
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
    );
  }
}

class _WatchlistIpoCard extends StatelessWidget {
  final IpoModel ipo;
  final VoidCallback onRemove;

  const _WatchlistIpoCard({
    required this.ipo,
    required this.onRemove,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('dd MMM');
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
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
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(Icons.bookmark, color: Color(0xFFFF6B35)),
                      tooltip: 'Remove from watchlist',
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
                        label: 'GMP',
                        value: ipo.gmpText,
                        valueColor: ipo.gmpColor,
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
              ],
            ),
          ),
          
          if (ipo.status == IpoStatus.ongoing)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.notifications_active, 
                       color: Colors.green.shade700, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'IPO is live - Apply now!',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Ends ${dateFormatter.format(ipo.closeDate)}',
                    style: TextStyle(
                      color: Colors.green.shade600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoItem({
    required this.label,
    required this.value,
    this.valueColor,
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
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
