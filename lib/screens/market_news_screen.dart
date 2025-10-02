import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarketNewsScreen extends StatefulWidget {
  const MarketNewsScreen({super.key});

  @override
  State<MarketNewsScreen> createState() => _MarketNewsScreenState();
}

class _MarketNewsScreenState extends State<MarketNewsScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'IPO Updates', 'Market Analysis', 'Company News', 'Regulatory'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Market News'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showSearchDialog();
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          Container(
            height: 60,
            margin: const EdgeInsets.all(16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green.shade600 : Colors.white,
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
                      category,
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
          
          // News list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Simulate refresh
                await Future.delayed(const Duration(seconds: 1));
                setState(() {});
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _getFilteredNews().length,
                itemBuilder: (context, index) {
                  final news = _getFilteredNews()[index];
                  return _NewsCard(news: news);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<NewsItem> _getFilteredNews() {
    final allNews = _getDummyNews();
    if (_selectedCategory == 'All') {
      return allNews;
    }
    return allNews.where((news) => news.category == _selectedCategory).toList();
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search News'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter keywords...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  List<NewsItem> _getDummyNews() {
    return [
      NewsItem(
        title: 'Tata Technologies IPO Sees Strong Institutional Response',
        summary: 'The IPO received bids worth ₹26,000 crores against the issue size of ₹3,043 crores, indicating strong investor interest.',
        category: 'IPO Updates',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        imageUrl: 'https://via.placeholder.com/150x100',
        source: 'Economic Times',
        isBreaking: true,
      ),
      NewsItem(
        title: 'SEBI Introduces New Guidelines for SME IPO Listings',
        summary: 'Market regulator SEBI has announced revised guidelines to streamline the SME IPO process and enhance investor protection.',
        category: 'Regulatory',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        imageUrl: 'https://via.placeholder.com/150x100',
        source: 'Business Standard',
        isBreaking: false,
      ),
      NewsItem(
        title: 'Primary Market Sees Record ₹1.7 Lakh Crore Fundraising in 2024',
        summary: 'Indian primary markets have witnessed unprecedented fundraising activity with 76 IPOs raising over ₹1.7 lakh crores this year.',
        category: 'Market Analysis',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        imageUrl: 'https://via.placeholder.com/150x100',
        source: 'Mint',
        isBreaking: false,
      ),
      NewsItem(
        title: 'Bharti Hexacom IPO Oversubscribed 28 Times on Final Day',
        summary: 'The telecom company\'s IPO received overwhelming response from retail and institutional investors on the last day of bidding.',
        category: 'IPO Updates',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        imageUrl: 'https://via.placeholder.com/150x100',
        source: 'Moneycontrol',
        isBreaking: false,
      ),
      NewsItem(
        title: 'Grey Market Premium Trends Show Positive Sentiment',
        summary: 'Most upcoming IPOs are trading at premium in grey market, indicating strong investor confidence in primary market.',
        category: 'Market Analysis',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        imageUrl: 'https://via.placeholder.com/150x100',
        source: 'Financial Express',
        isBreaking: false,
      ),
      NewsItem(
        title: 'Nexus Select Trust REIT Files Draft Papers for ₹5,000 Cr IPO',
        summary: 'The retail-focused REIT has filed preliminary papers with SEBI for its maiden public offering to raise funds for expansion.',
        category: 'Company News',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        imageUrl: 'https://via.placeholder.com/150x100',
        source: 'LiveMint',
        isBreaking: false,
      ),
      NewsItem(
        title: 'Foreign Institutional Investors Increase IPO Participation',
        summary: 'FIIs have significantly increased their participation in Indian IPOs, contributing to better price discovery and liquidity.',
        category: 'Market Analysis',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
        imageUrl: 'https://via.placeholder.com/150x100',
        source: 'Bloomberg Quint',
        isBreaking: false,
      ),
      NewsItem(
        title: 'IREDA IPO: Government Divests 25% Stake Successfully',
        summary: 'Indian Renewable Energy Development Agency\'s IPO was successfully completed with strong retail participation.',
        category: 'IPO Updates',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        imageUrl: 'https://via.placeholder.com/150x100',
        source: 'The Hindu BusinessLine',
        isBreaking: false,
      ),
    ];
  }
}

class NewsItem {
  final String title;
  final String summary;
  final String category;
  final DateTime timestamp;
  final String imageUrl;
  final String source;
  final bool isBreaking;

  NewsItem({
    required this.title,
    required this.summary,
    required this.category,
    required this.timestamp,
    required this.imageUrl,
    required this.source,
    required this.isBreaking,
  });
}

class _NewsCard extends StatelessWidget {
  final NewsItem news;

  const _NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeAgo = _getTimeAgo(news.timestamp);
    
    return GestureDetector(
      onTap: () {
        _showNewsDetail(context, news);
      },
      child: Container(
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
            // Image and breaking badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.newspaper,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
                if (news.isBreaking)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'BREAKING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category and time
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(news.category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          news.category,
                          style: TextStyle(
                            color: _getCategoryColor(news.category),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Title
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Summary
                  Text(
                    news.summary,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Source and actions
                  Row(
                    children: [
                      Icon(
                        Icons.source,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        news.source,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to bookmarks')),
                              );
                            },
                            icon: Icon(
                              Icons.bookmark_outline,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Shared successfully')),
                              );
                            },
                            icon: Icon(
                              Icons.share_outlined,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'IPO Updates':
        return Colors.blue;
      case 'Market Analysis':
        return Colors.green;
      case 'Company News':
        return Colors.orange;
      case 'Regulatory':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showNewsDetail(BuildContext context, NewsItem news) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
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
                      // Category and time
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(news.category).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              news.category,
                              style: TextStyle(
                                color: _getCategoryColor(news.category),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('MMM dd, yyyy • hh:mm a').format(news.timestamp),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Title
                      Text(
                        news.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Source
                      Row(
                        children: [
                          Icon(
                            Icons.source,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Source: ${news.source}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Content
                      Text(
                        news.summary,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Additional content (placeholder)
                      Text(
                        'This is a detailed news article about ${news.title.toLowerCase()}. The article would contain comprehensive information about the topic, including market analysis, expert opinions, and relevant data points. In a real application, this content would be fetched from a news API or content management system.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Added to bookmarks')),
                                );
                              },
                              icon: const Icon(Icons.bookmark_outline),
                              label: const Text('Bookmark'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                foregroundColor: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Shared successfully')),
                                );
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Share'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
