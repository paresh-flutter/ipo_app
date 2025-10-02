import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _sortBy = 'date'; // date, company, amount
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('My Applications'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'sort') {
                _showSortDialog();
              } else if (value == 'export') {
                _showExportDialog();
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
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Export'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Applied'),
            Tab(text: 'Allotted'),
            Tab(text: 'Not Allotted'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Total Applied',
                    value: '12',
                    subtitle: '₹2,45,000',
                    color: Colors.blue,
                    icon: Icons.assignment,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'Allotted',
                    value: '8',
                    subtitle: '₹1,85,000',
                    color: Colors.green,
                    icon: Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'Profit/Loss',
                    value: '+₹45,200',
                    subtitle: '+24.4%',
                    color: Colors.purple,
                    icon: Icons.trending_up,
                  ),
                ),
              ],
            ),
          ),
          
          // Applications list
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildApplicationsList(_getAllApplications()),
                _buildApplicationsList(_getApplicationsByStatus('Applied')),
                _buildApplicationsList(_getApplicationsByStatus('Allotted')),
                _buildApplicationsList(_getApplicationsByStatus('Not Allotted')),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showApplicationTips();
        },
        backgroundColor: Colors.orange.shade600,
        icon: const Icon(Icons.lightbulb_outline),
        label: const Text('Tips'),
      ),
    );
  }

  Widget _buildApplicationsList(List<ApplicationItem> applications) {
    if (applications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No applications found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    final sortedApplications = _sortApplications(applications);

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: sortedApplications.length,
        itemBuilder: (context, index) {
          return _ApplicationCard(
            application: sortedApplications[index],
            onTap: () => _showApplicationDetail(sortedApplications[index]),
          );
        },
      ),
    );
  }

  List<ApplicationItem> _sortApplications(List<ApplicationItem> applications) {
    switch (_sortBy) {
      case 'company':
        applications.sort((a, b) => _sortAscending 
            ? a.companyName.compareTo(b.companyName)
            : b.companyName.compareTo(a.companyName));
        break;
      case 'amount':
        applications.sort((a, b) => _sortAscending 
            ? a.bidAmount.compareTo(b.bidAmount)
            : b.bidAmount.compareTo(a.bidAmount));
        break;
      case 'date':
      default:
        applications.sort((a, b) => _sortAscending 
            ? a.applicationDate.compareTo(b.applicationDate)
            : b.applicationDate.compareTo(a.applicationDate));
        break;
    }
    return applications;
  }

  List<ApplicationItem> _getAllApplications() {
    return [
      ApplicationItem(
        companyName: 'Tata Technologies',
        applicationDate: DateTime.now().subtract(const Duration(days: 5)),
        bidAmount: 15000,
        lotSize: 10,
        bidPrice: 500,
        category: 'Retail',
        status: 'Allotted',
        allottedShares: 10,
        listingPrice: 650,
        currentPrice: 720,
        upiId: 'user@paytm',
      ),
      ApplicationItem(
        companyName: 'Bharti Hexacom',
        applicationDate: DateTime.now().subtract(const Duration(days: 12)),
        bidAmount: 25000,
        lotSize: 20,
        bidPrice: 570,
        category: 'Retail',
        status: 'Allotted',
        allottedShares: 20,
        listingPrice: 620,
        currentPrice: 685,
        upiId: 'user@paytm',
      ),
      ApplicationItem(
        companyName: 'IREDA',
        applicationDate: DateTime.now().subtract(const Duration(days: 20)),
        bidAmount: 12000,
        lotSize: 30,
        bidPrice: 32,
        category: 'Retail',
        status: 'Not Allotted',
        allottedShares: 0,
        upiId: 'user@paytm',
      ),
      ApplicationItem(
        companyName: 'Nexus Select Trust',
        applicationDate: DateTime.now().subtract(const Duration(days: 8)),
        bidAmount: 50000,
        lotSize: 50,
        bidPrice: 100,
        category: 'HNI',
        status: 'Applied',
        upiId: 'user@paytm',
      ),
      ApplicationItem(
        companyName: 'Purple Style Labs',
        applicationDate: DateTime.now().subtract(const Duration(days: 3)),
        bidAmount: 18000,
        lotSize: 15,
        bidPrice: 450,
        category: 'Retail',
        status: 'Applied',
        upiId: 'user@paytm',
      ),
    ];
  }

  List<ApplicationItem> _getApplicationsByStatus(String status) {
    return _getAllApplications().where((app) => app.status == status).toList();
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Applications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Application Date'),
              value: 'date',
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
            RadioListTile<String>(
              title: const Text('Bid Amount'),
              value: 'amount',
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

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Applications'),
        content: const Text('Export your application data in various formats for record keeping and analysis.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export started. You will be notified when ready.')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showApplicationDetail(ApplicationItem application) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ApplicationDetailSheet(application: application),
    );
  }

  void _showApplicationTips() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('IPO Application Tips'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('💡 Pro Tips for IPO Applications:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text('• Apply early to avoid last-minute rush'),
              Text('• Use multiple UPI IDs for better chances'),
              Text('• Check GMP trends before applying'),
              Text('• Apply for full lot size in retail category'),
              Text('• Keep funds ready 2-3 days before closing'),
              Text('• Monitor subscription levels regularly'),
              SizedBox(height: 12),
              Text('📊 Allotment Strategy:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Retail category has better allotment chances'),
              Text('• Oversubscribed IPOs use lottery system'),
              Text('• Apply through multiple family members'),
              Text('• Check allotment status on registrar website'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class ApplicationItem {
  final String companyName;
  final DateTime applicationDate;
  final double bidAmount;
  final int lotSize;
  final double bidPrice;
  final String category;
  final String status;
  final int? allottedShares;
  final double? listingPrice;
  final double? currentPrice;
  final String upiId;

  ApplicationItem({
    required this.companyName,
    required this.applicationDate,
    required this.bidAmount,
    required this.lotSize,
    required this.bidPrice,
    required this.category,
    required this.status,
    this.allottedShares,
    this.listingPrice,
    this.currentPrice,
    required this.upiId,
  });

  double? get profitLoss {
    if (allottedShares != null && allottedShares! > 0 && currentPrice != null && listingPrice != null) {
      return (currentPrice! - bidPrice) * allottedShares!;
    }
    return null;
  }

  double? get profitLossPercentage {
    if (profitLoss != null) {
      return (profitLoss! / bidAmount) * 100;
    }
    return null;
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _SummaryCard({
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

class _ApplicationCard extends StatelessWidget {
  final ApplicationItem application;
  final VoidCallback onTap;

  const _ApplicationCard({
    required this.application,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(application.status);
    final profitLoss = application.profitLoss;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    application.companyName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    application.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Details
            Row(
              children: [
                Expanded(
                  child: _DetailItem(
                    label: 'Bid Amount',
                    value: '₹${NumberFormat('#,##,###').format(application.bidAmount)}',
                  ),
                ),
                Expanded(
                  child: _DetailItem(
                    label: 'Lot Size',
                    value: '${application.lotSize} shares',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: _DetailItem(
                    label: 'Category',
                    value: application.category,
                  ),
                ),
                Expanded(
                  child: _DetailItem(
                    label: 'Applied On',
                    value: DateFormat('MMM dd').format(application.applicationDate),
                  ),
                ),
              ],
            ),
            
            // Profit/Loss for allotted applications
            if (profitLoss != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: profitLoss >= 0 ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      profitLoss >= 0 ? Icons.trending_up : Icons.trending_down,
                      color: profitLoss >= 0 ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'P&L: ${profitLoss >= 0 ? '+' : ''}₹${NumberFormat('#,##,###').format(profitLoss.abs())} (${profitLoss >= 0 ? '+' : ''}${application.profitLossPercentage?.toStringAsFixed(1)}%)',
                        style: TextStyle(
                          color: profitLoss >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Applied':
        return Colors.blue;
      case 'Allotted':
        return Colors.green;
      case 'Not Allotted':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({
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
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ApplicationDetailSheet extends StatelessWidget {
  final ApplicationItem application;

  const _ApplicationDetailSheet({required this.application});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
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
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            application.companyName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(application.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            application.status,
                            style: TextStyle(
                              color: _getStatusColor(application.status),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Application Details
                    _buildDetailSection('Application Details', [
                      _buildDetailRow('Application Date', DateFormat('MMM dd, yyyy').format(application.applicationDate)),
                      _buildDetailRow('Bid Amount', '₹${NumberFormat('#,##,###').format(application.bidAmount)}'),
                      _buildDetailRow('Bid Price', '₹${application.bidPrice}'),
                      _buildDetailRow('Lot Size', '${application.lotSize} shares'),
                      _buildDetailRow('Category', application.category),
                      _buildDetailRow('UPI ID', application.upiId),
                    ]),
                    
                    // Allotment Details (if applicable)
                    if (application.status == 'Allotted') ...[
                      const SizedBox(height: 24),
                      _buildDetailSection('Allotment Details', [
                        _buildDetailRow('Allotted Shares', '${application.allottedShares} shares'),
                        if (application.listingPrice != null)
                          _buildDetailRow('Listing Price', '₹${application.listingPrice}'),
                        if (application.currentPrice != null)
                          _buildDetailRow('Current Price', '₹${application.currentPrice}'),
                      ]),
                    ],
                    
                    // Performance (if applicable)
                    if (application.profitLoss != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: application.profitLoss! >= 0 ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: application.profitLoss! >= 0 ? Colors.green.shade200 : Colors.red.shade200,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  application.profitLoss! >= 0 ? Icons.trending_up : Icons.trending_down,
                                  color: application.profitLoss! >= 0 ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Performance',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: application.profitLoss! >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${application.profitLoss! >= 0 ? '+' : ''}₹${NumberFormat('#,##,###').format(application.profitLoss!.abs())}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: application.profitLoss! >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                              ),
                            ),
                            Text(
                              '${application.profitLoss! >= 0 ? '+' : ''}${application.profitLossPercentage?.toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontSize: 16,
                                color: application.profitLoss! >= 0 ? Colors.green.shade600 : Colors.red.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 30),
                    
                    // Action buttons
                    if (application.status == 'Applied') ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Application cancelled successfully')),
                            );
                          },
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text('Cancel Application'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Application details downloaded')),
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('Download'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                foregroundColor: Colors.grey.shade700,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Application details shared')),
                                );
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Share'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Applied':
        return Colors.blue;
      case 'Allotted':
        return Colors.green;
      case 'Not Allotted':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
