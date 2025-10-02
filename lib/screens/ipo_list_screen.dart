import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ipo_bloc.dart';
import '../bloc/ipo_event.dart';
import '../bloc/ipo_state.dart';
import '../models/ipo_model.dart';
import '../widgets/ipo_card.dart';

class IpoListScreen extends StatefulWidget {
  final IpoStatus? filterStatus;

  const IpoListScreen({
    super.key,
    this.filterStatus,
  });

  @override
  State<IpoListScreen> createState() => _IpoListScreenState();
}

class _IpoListScreenState extends State<IpoListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadIpos();
  }

  void _loadIpos() {
    if (widget.filterStatus != null) {
      context.read<IpoBloc>().add(LoadIposByStatus(widget.filterStatus!));
    } else {
      context.read<IpoBloc>().add(LoadAllIpos());
    }
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _loadIpos();
    } else {
      if (widget.filterStatus != null) {
        context.read<IpoBloc>().add(SearchIposByStatus(query, widget.filterStatus!));
      } else {
        context.read<IpoBloc>().add(SearchIpos(query));
      }
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _loadIpos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search IPOs...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: _onSearchChanged,
              )
            : Text(_getTitle()),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: BlocBuilder<IpoBloc, IpoState>(
        builder: (context, state) {
          if (state is IpoLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Loading IPOs...',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fetching the latest market data',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is IpoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadIpos,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is IpoLoaded) {
            if (state.ipos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.isSearching ? 'No IPOs found' : 'No IPOs available',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.isSearching
                          ? 'Try adjusting your search query'
                          : 'Check back later for new IPOs',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadIpos();
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.ipos.length,
                itemBuilder: (context, index) {
                  return IpoCard(ipo: state.ipos[index]);
                },
              ),
            );
          }

          return const Center(
            child: Text('Welcome to IPO Tracker'),
          );
        },
      ),
    );
  }

  String _getTitle() {
    if (widget.filterStatus == null) return 'All IPOs';
    switch (widget.filterStatus!) {
      case IpoStatus.ongoing:
        return 'Ongoing IPOs';
      case IpoStatus.upcoming:
        return 'Upcoming IPOs';
      case IpoStatus.closed:
        return 'Closed IPOs';
      case IpoStatus.listed:
        return 'Listed IPOs';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
