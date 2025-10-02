import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/ipo_bloc.dart';
import '../bloc/ipo_event.dart';
import '../bloc/ipo_state.dart';
import '../models/ipo_model.dart';

class GMPTrackerScreen extends StatefulWidget {
  const GMPTrackerScreen({super.key});

  @override
  State<GMPTrackerScreen> createState() => _GMPTrackerScreenState();
}

class _GMPTrackerScreenState extends State<GMPTrackerScreen> {
  String _sortBy = 'gmp'; // gmp, percentage, company
  bool _sortAscending = false;
  String _filterStatus = 'All'; // All, Ongoing, Upcoming

  @override
  void initState() {
    super.initState();
    context.read<IpoBloc>().add(LoadAllIpos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('GMP Tracker'),
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<IpoBloc>().add(LoadAllIpos());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('GMP data refreshed')),
              );
            },
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'sort') {
                _showSortDialog();
              } else if (value == 'filter') {
                _showFilterDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort),
                    SizedBox(width: 8),
                    Text('Sort'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'filter',
                child: Row(
                  children: [
                    Icon(Icons.filter_list),
                    SizedBox(width: 8),
                    Text('Filter'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // GMP Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isTablet = constraints.maxWidth > 600;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isTablet ? 4 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isTablet ? 1.2 : 1.5,
                  children: [
                    _GMPSummaryCard(
                      title: 'Avg GMP',
                      value: '₹45',
                      subtitle: '+12.5%',
                      color: Colors.green,
                      icon: Icons.trending_up,
                    ),
                    _GMPSummaryCard(
                      title: 'Highest GMP',
                      value: '₹120',
                      subtitle: 'Tata Tech',
                      color: Colors.blue,
                      icon: Icons.arrow_upward,
                    ),
                    _GMPSummaryCard(
                      title: 'Active IPOs',
                      value: '8',
                      subtitle: 'With GMP',
                      color: Colors.orange,
                      icon: Icons.business,
                    ),
                    _GMPSummaryCard(
                      title: 'Market Trend',
                      value: 'Bullish',
                      subtitle: '↗ +8.2%',
                      color: Colors.purple,
                      icon: Icons.analytics,
                    ),
                  ],
                );
              },
            ),
          ),
          
          // GMP List
          Expanded(
            child: BlocBuilder<IpoBloc, IpoState>(
              builder: (context, state) {
                if (state is IpoLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state is IpoLoaded) {
                  return _buildGMPList(state.ipos);
                }
                
                return const Center(child: Text('Error loading GMP data'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGMPList(List<IpoModel> allIpos) {
    // Filter IPOs with GMP data
    var filteredIpos = allIpos.where((ipo) {
      final hasGMP = ipo.gmp != null && ipo.gmp! > 0;
      if (!hasGMP) return false;
      
      if (_filterStatus == 'All') return true;
      if (_filterStatus == 'Ongoing') return ipo.status == IpoStatus.ongoing;
      if (_filterStatus == 'Upcoming') return ipo.status == IpoStatus.upcoming;
      return false;
    }).toList();

    // Sort IPOs
    filteredIpos = _sortGMPList(filteredIpos);

    if (filteredIpos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No GMP data available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<IpoBloc>().add(LoadAllIpos());
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filteredIpos.length,
        itemBuilder: (context, index) {
          return _GMPCard(ipo: filteredIpos[index]);
        },
      ),
    );
  }

  List<IpoModel> _sortGMPList(List<IpoModel> ipos) {
    switch (_sortBy) {
      case 'company':
        ipos.sort((a, b) => _sortAscending 
            ? a.companyName.compareTo(b.companyName)
            : b.companyName.compareTo(a.companyName));
        break;
      case 'percentage':
        ipos.sort((a, b) {
          final aPercent = _calculateGMPPercentage(a);
          final bPercent = _calculateGMPPercentage(b);
          return _sortAscending ? aPercent.compareTo(bPercent) : bPercent.compareTo(aPercent);
        });
        break;
      case 'gmp':
      default:
        ipos.sort((a, b) {
          final aGmp = a.gmp ?? 0;
          final bGmp = b.gmp ?? 0;
          return _sortAscending ? aGmp.compareTo(bGmp) : bGmp.compareTo(aGmp);
        });
        break;
    }
    return ipos;
  }

  double _calculateGMPPercentage(IpoModel ipo) {
    if (ipo.gmp == null || ipo.gmp! <= 0) return 0;
    final priceRange = ipo.priceBand.split('-');
    if (priceRange.length != 2) return 0;
    
    final maxPrice = double.tryParse(priceRange[1].replaceAll('₹', '').trim()) ?? 0;
    if (maxPrice <= 0) return 0;
    
    return (ipo.gmp! / maxPrice) * 100;
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort GMP Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('GMP Amount'),
              value: 'gmp',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('GMP Percentage'),
              value: 'percentage',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Company Name'),
              value: 'company',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Ascending Order'),
              value: _sortAscending,
              onChanged: (value) {
                setState(() {
                  _sortAscending = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter IPOs'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('All IPOs'),
              value: 'All',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() {
                  _filterStatus = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Ongoing IPOs'),
              value: 'Ongoing',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() {
                  _filterStatus = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Upcoming IPOs'),
              value: 'Upcoming',
              groupValue: _filterStatus,
              onChanged: (value) {
                setState(() {
                  _filterStatus = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _GMPSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _GMPSummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _GMPCard extends StatelessWidget {
  final IpoModel ipo;

  const _GMPCard({required this.ipo});

  @override
  Widget build(BuildContext context) {
    final gmpPercentage = _calculateGMPPercentage();
    final isPositive = (ipo.gmp ?? 0) > 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ipo.companyName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ipo.priceBand,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(ipo.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ipo.status.name.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(ipo.status),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // GMP Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPositive ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 300;
                return Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          color: isPositive ? Colors.green : Colors.red,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Grey Market Premium',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '₹${ipo.gmp?.toStringAsFixed(0) ?? '0'}',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 18 : 20,
                                      fontWeight: FontWeight.bold,
                                      color: isPositive ? Colors.green.shade700 : Colors.red.shade700,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${gmpPercentage.toStringAsFixed(1)}%)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isPositive ? Colors.green.shade600 : Colors.red.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Additional Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _InfoChip(
                          label: 'Lot Size',
                          value: '${ipo.lotSize}',
                          icon: Icons.layers,
                        ),
                        _InfoChip(
                          label: 'Subscription',
                          value: '${ipo.totalSubscription?.toStringAsFixed(1)}x',
                          icon: Icons.people,
                        ),
                        _InfoChip(
                          label: 'Days Left',
                          value: _getDaysLeft(),
                          icon: Icons.schedule,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _calculateGMPPercentage() {
    if (ipo.gmp == null || ipo.gmp! <= 0) return 0;
    final priceRange = ipo.priceBand.split('-');
    if (priceRange.length != 2) return 0;
    
    final maxPrice = double.tryParse(priceRange[1].replaceAll('₹', '').trim()) ?? 0;
    if (maxPrice <= 0) return 0;
    
    return (ipo.gmp! / maxPrice) * 100;
  }

  String _getDaysLeft() {
    final now = DateTime.now();
    final targetDate = ipo.status == IpoStatus.upcoming ? ipo.openDate : ipo.closeDate;
    final difference = targetDate.difference(now).inDays;
    
    if (difference < 0) return 'Closed';
    if (difference == 0) return 'Today';
    return '${difference}d';
  }

  Color _getStatusColor(IpoStatus status) {
    switch (status) {
      case IpoStatus.ongoing:
        return Colors.green;
      case IpoStatus.upcoming:
        return Colors.blue;
      case IpoStatus.closed:
        return Colors.grey;
      case IpoStatus.listed:
        return Colors.purple;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
