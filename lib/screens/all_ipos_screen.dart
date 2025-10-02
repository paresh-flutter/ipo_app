import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ipo_bloc.dart';
import '../bloc/ipo_event.dart';
import '../bloc/ipo_state.dart';
import '../models/ipo_model.dart';
import '../widgets/ipo_card.dart';

class AllIposScreen extends StatefulWidget {
  const AllIposScreen({super.key});

  @override
  State<AllIposScreen> createState() => _AllIposScreenState();
}

class _AllIposScreenState extends State<AllIposScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'name'; // name, gmp, subscription, size
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<IpoBloc>().add(LoadAllIpos());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
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
                                Icons.business_center,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'All IPOs',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Browse and filter IPOs',
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
                                  _showSortDialog();
                                },
                                icon: const Icon(
                                  Icons.sort,
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
            
            // Search Bar
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
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
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search IPOs by company name...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),
            
            // Tab Bar
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF1976D2),
                  unselectedLabelColor: Colors.grey.shade600,
                  indicatorColor: const Color(0xFF1976D2),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  unselectedLabelStyle: const TextStyle(fontSize: 12),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.play_circle_filled, size: 20),
                      text: 'Ongoing',
                    ),
                    Tab(
                      icon: Icon(Icons.schedule, size: 20),
                      text: 'Upcoming',
                    ),
                    Tab(
                      icon: Icon(Icons.check_circle, size: 20),
                      text: 'Closed',
                    ),
                    Tab(
                      icon: Icon(Icons.trending_up, size: 20),
                      text: 'Listed',
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: BlocBuilder<IpoBloc, IpoState>(
          builder: (context, state) {
            if (state is IpoLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (state is IpoLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildIpoList(state.ipos, IpoStatus.ongoing),
                  _buildIpoList(state.ipos, IpoStatus.upcoming),
                  _buildIpoList(state.ipos, IpoStatus.closed),
                  _buildIpoList(state.ipos, IpoStatus.listed),
                ],
              );
            }
            
            return const Center(
              child: Text('Error loading IPOs'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIpoList(List<IpoModel> allIpos, IpoStatus status) {
    // Filter IPOs by status and search query
    var filteredIpos = allIpos.where((ipo) {
      final matchesStatus = ipo.status == status;
      final matchesSearch = _searchQuery.isEmpty || 
          ipo.companyName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();

    // Sort IPOs
    filteredIpos = _sortIpos(filteredIpos);

    if (filteredIpos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getStatusIcon(status),
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'No IPOs found for "${_searchQuery}"'
                  : 'No ${status.name} IPOs available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
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
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        itemCount: filteredIpos.length,
        itemBuilder: (context, index) {
          return IpoCard(ipo: filteredIpos[index]);
        },
      ),
    );
  }

  List<IpoModel> _sortIpos(List<IpoModel> ipos) {
    switch (_sortBy) {
      case 'name':
        ipos.sort((a, b) => _sortAscending 
            ? a.companyName.compareTo(b.companyName)
            : b.companyName.compareTo(a.companyName));
        break;
      case 'gmp':
        ipos.sort((a, b) {
          final aGmp = a.gmp ?? 0;
          final bGmp = b.gmp ?? 0;
          return _sortAscending ? aGmp.compareTo(bGmp) : bGmp.compareTo(aGmp);
        });
        break;
      case 'subscription':
        ipos.sort((a, b) {
          final aSub = a.totalSubscription ?? 0;
          final bSub = b.totalSubscription ?? 0;
          return _sortAscending ? aSub.compareTo(bSub) : bSub.compareTo(aSub);
        });
        break;
      case 'size':
        ipos.sort((a, b) {
          // Extract numeric value from issue size for sorting
          final aSize = _extractNumericValue(a.issueSize);
          final bSize = _extractNumericValue(b.issueSize);
          return _sortAscending ? aSize.compareTo(bSize) : bSize.compareTo(aSize);
        });
        break;
    }
    return ipos;
  }

  double _extractNumericValue(String issueSize) {
    final regex = RegExp(r'[\d.]+');
    final match = regex.firstMatch(issueSize);
    return match != null ? double.tryParse(match.group(0)!) ?? 0 : 0;
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

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort IPOs'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Company Name'),
              value: 'name',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('GMP (Grey Market Premium)'),
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
              title: const Text('Subscription Level'),
              value: 'subscription',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Issue Size'),
              value: 'size',
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
}
