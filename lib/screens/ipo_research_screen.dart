import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/ipo_bloc.dart';
import '../bloc/ipo_event.dart';
import '../bloc/ipo_state.dart';
import '../models/ipo_model.dart';

class IpoResearchScreen extends StatefulWidget {
  const IpoResearchScreen({super.key});

  @override
  State<IpoResearchScreen> createState() => _IpoResearchScreenState();
}

class _IpoResearchScreenState extends State<IpoResearchScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedSector = 'All';
  final List<String> _sectors = ['All', 'Technology', 'Healthcare', 'Finance', 'Manufacturing', 'Energy'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<IpoBloc>().add(LoadAllIpos());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('IPO Research'),
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showResearchFilters();
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Analysis', icon: Icon(Icons.analytics, size: 16)),
            Tab(text: 'Reports', icon: Icon(Icons.description, size: 16)),
            Tab(text: 'Ratings', icon: Icon(Icons.star, size: 16)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Sector Filter
          Container(
            height: 60,
            margin: const EdgeInsets.all(16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _sectors.length,
              itemBuilder: (context, index) {
                final sector = _sectors[index];
                final isSelected = sector == _selectedSector;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSector = sector;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.indigo.shade600 : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      sector,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Content
          Expanded(
            child: BlocBuilder<IpoBloc, IpoState>(
              builder: (context, state) {
                if (state is IpoLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state is IpoLoaded) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAnalysisTab(state.ipos),
                      _buildReportsTab(state.ipos),
                      _buildRatingsTab(state.ipos),
                    ],
                  );
                }
                
                return const Center(child: Text('Error loading research data'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab(List<IpoModel> ipos) {
    final filteredIpos = _filterBySector(ipos);
    
    return RefreshIndicator(
      onRefresh: () async {
        context.read<IpoBloc>().add(LoadAllIpos());
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filteredIpos.length,
        itemBuilder: (context, index) {
          return _AnalysisCard(ipo: filteredIpos[index]);
        },
      ),
    );
  }

  Widget _buildReportsTab(List<IpoModel> ipos) {
    final filteredIpos = _filterBySector(ipos);
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredIpos.length,
      itemBuilder: (context, index) {
        return _ReportCard(ipo: filteredIpos[index]);
      },
    );
  }

  Widget _buildRatingsTab(List<IpoModel> ipos) {
    final filteredIpos = _filterBySector(ipos);
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredIpos.length,
      itemBuilder: (context, index) {
        return _RatingCard(ipo: filteredIpos[index]);
      },
    );
  }

  List<IpoModel> _filterBySector(List<IpoModel> ipos) {
    if (_selectedSector == 'All') return ipos;
    return ipos.where((ipo) => ipo.sector == _selectedSector).toList();
  }

  void _showResearchFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Research Filters',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Market Cap Range'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Small Cap', 'Mid Cap', 'Large Cap'].map((cap) => 
                FilterChip(
                  label: Text(cap),
                  selected: false,
                  onSelected: (selected) {},
                ),
              ).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Risk Level'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Low', 'Medium', 'High'].map((risk) => 
                FilterChip(
                  label: Text(risk),
                  selected: false,
                  onSelected: (selected) {},
                ),
              ).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  final IpoModel ipo;

  const _AnalysisCard({required this.ipo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade400, Colors.indigo.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ipo.companyName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ipo.sector.toString(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getRecommendation(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Analysis Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 350;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Key Metrics
                    Row(
                      children: [
                        Expanded(
                          child: _MetricTile(
                            label: 'P/E Ratio',
                            value: _getPERatio(),
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricTile(
                            label: 'ROE',
                            value: _getROE(),
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricTile(
                            label: 'Debt/Equity',
                            value: _getDebtEquity(),
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Analysis Summary
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Analysis Summary',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getAnalysisSummary(),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 13,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showDetailedAnalysis(context),
                            icon: const Icon(Icons.analytics, size: 16),
                            label: const Text('Detailed Analysis'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 8 : 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _downloadReport(context),
                            icon: const Icon(Icons.download, size: 16),
                            label: const Text('Download'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 8 : 12,
                              ),
                            ),
                          ),
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

  String _getRecommendation() {
    final gmp = ipo.gmp ?? 0;
    if (gmp > 50) return 'BUY';
    if (gmp > 0) return 'HOLD';
    return 'AVOID';
  }

  String _getPERatio() {
    return '${(15 + (ipo.companyName.hashCode % 20)).toStringAsFixed(1)}';
  }

  String _getROE() {
    return '${(10 + (ipo.companyName.hashCode % 15)).toStringAsFixed(1)}%';
  }

  String _getDebtEquity() {
    return '${(0.2 + (ipo.companyName.hashCode % 10) / 10).toStringAsFixed(1)}';
  }

  String _getAnalysisSummary() {
    return '${ipo.companyName} shows strong fundamentals with good market positioning in the ${ipo.sector} sector. The company has demonstrated consistent growth and has a solid business model. Current market conditions and GMP trends suggest ${_getRecommendation().toLowerCase()} recommendation.';
  }

  void _showDetailedAnalysis(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
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
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${ipo.companyName} - Detailed Analysis',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAnalysisSection('Business Overview', 
                  'The company operates in the ${ipo.sector} sector with a strong market presence and competitive advantages.'),
                _buildAnalysisSection('Financial Performance', 
                  'Revenue growth has been consistent over the past 3 years with improving profit margins and strong cash flow generation.'),
                _buildAnalysisSection('Market Position', 
                  'The company holds a significant market share and has established brand recognition in its target markets.'),
                _buildAnalysisSection('Risk Factors', 
                  'Key risks include market competition, regulatory changes, and economic cyclicality affecting the sector.'),
                _buildAnalysisSection('Investment Recommendation', 
                  'Based on fundamental analysis and market conditions, we recommend ${_getRecommendation().toLowerCase()} with a target price range consideration.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _downloadReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${ipo.companyName} research report...'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {},
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final IpoModel ipo;

  const _ReportCard({required this.ipo});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              Icon(Icons.description, color: Colors.indigo.shade600),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${ipo.companyName} Research Report',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _downloadReport(context),
                icon: const Icon(Icons.download),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Comprehensive analysis including financial metrics, business model evaluation, competitive positioning, and investment recommendation.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ReportTag('PDF', Colors.red),
              const SizedBox(width: 8),
              _ReportTag('15 Pages', Colors.blue),
              const SizedBox(width: 8),
              _ReportTag('Updated Today', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  void _downloadReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${ipo.companyName} report...')),
    );
  }
}

class _RatingCard extends StatelessWidget {
  final IpoModel ipo;

  const _RatingCard({required this.ipo});

  @override
  Widget build(BuildContext context) {
    final rating = _calculateRating();
    
    return Container(
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 350;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ipo.companyName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getRatingColor(rating).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: _getRatingColor(rating),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            color: _getRatingColor(rating),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Rating Breakdown
              Column(
                children: [
                  _RatingRow('Business Model', 4.2, isSmallScreen),
                  _RatingRow('Financial Health', 3.8, isSmallScreen),
                  _RatingRow('Management Quality', 4.0, isSmallScreen),
                  _RatingRow('Market Opportunity', 4.5, isSmallScreen),
                  _RatingRow('Valuation', 3.5, isSmallScreen),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Text(
                _getRatingDescription(rating),
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double _calculateRating() {
    final gmp = ipo.gmp ?? 0;
    final baseRating = 3.0;
    final gmpBonus = (gmp / 100).clamp(0.0, 2.0);
    return (baseRating + gmpBonus).clamp(1.0, 5.0);
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.0) return Colors.green;
    if (rating >= 3.0) return Colors.orange;
    return Colors.red;
  }

  String _getRatingDescription(double rating) {
    if (rating >= 4.0) return 'Strong investment opportunity with good fundamentals and growth prospects.';
    if (rating >= 3.0) return 'Moderate investment opportunity with some risks and rewards to consider.';
    return 'High-risk investment with significant concerns about fundamentals or market conditions.';
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ReportTag extends StatelessWidget {
  final String text;
  final Color color;

  const _ReportTag(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final String label;
  final double rating;
  final bool isSmallScreen;

  const _RatingRow(this.label, this.rating, this.isSmallScreen);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: isSmallScreen ? 80 : 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isSmallScreen ? 11 : 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: isSmallScreen ? 14 : 16,
                );
              }),
            ),
          ),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: isSmallScreen ? 11 : 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
