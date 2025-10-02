import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/ipo_bloc.dart';
import '../bloc/ipo_event.dart';
import '../bloc/ipo_state.dart';
import '../models/ipo_model.dart';

class IpoCalendarScreen extends StatefulWidget {
  const IpoCalendarScreen({super.key});

  @override
  State<IpoCalendarScreen> createState() => _IpoCalendarScreenState();
}

class _IpoCalendarScreenState extends State<IpoCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  String _viewMode = 'timeline'; // timeline, monthly

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
      appBar: AppBar(
        title: const Text('IPO Calendar'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _viewMode = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'timeline',
                child: Row(
                  children: [
                    Icon(Icons.timeline),
                    SizedBox(width: 8),
                    Text('Timeline View'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'monthly',
                child: Row(
                  children: [
                    Icon(Icons.calendar_month),
                    SizedBox(width: 8),
                    Text('Monthly View'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.view_list),
          ),
        ],
      ),
      body: BlocBuilder<IpoBloc, IpoState>(
        builder: (context, state) {
          if (state is IpoLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is IpoLoaded) {
            return _viewMode == 'timeline' 
                ? _buildTimelineView(state.ipos)
                : _buildMonthlyView(state.ipos);
          }
          
          return const Center(child: Text('Error loading calendar'));
        },
      ),
    );
  }

  Widget _buildTimelineView(List<IpoModel> ipos) {
    // Group IPOs by date
    final Map<DateTime, List<IpoModel>> groupedIpos = {};
    
    for (final ipo in ipos) {
      final dates = [ipo.openDate, ipo.closeDate];
      if (ipo.listingDate != null) dates.add(ipo.listingDate!);
      if (ipo.allotmentDate != null) dates.add(ipo.allotmentDate!);
      
      for (final date in dates) {
        final dateKey = DateTime(date.year, date.month, date.day);
        groupedIpos.putIfAbsent(dateKey, () => []);
        if (!groupedIpos[dateKey]!.contains(ipo)) {
          groupedIpos[dateKey]!.add(ipo);
        }
      }
    }
    
    final sortedDates = groupedIpos.keys.toList()..sort();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dayIpos = groupedIpos[date]!;
        
        return _CalendarDayCard(
          date: date,
          ipos: dayIpos,
          onReminderSet: (ipo, eventType) {
            _setReminder(ipo, eventType, date);
          },
        );
      },
    );
  }

  Widget _buildMonthlyView(List<IpoModel> ipos) {
    return Column(
      children: [
        // Month selector
        Container(
          margin: const EdgeInsets.all(16),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
                  });
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                DateFormat('MMMM yyyy').format(_selectedDate),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
                  });
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        
        // Calendar grid
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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
              children: [
                // Week days header
                Row(
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .map((day) => Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                
                // Calendar days
                Expanded(
                  child: _buildCalendarGrid(ipos),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCalendarGrid(List<IpoModel> ipos) {
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    
    final days = <Widget>[];
    
    // Empty cells for days before month starts
    for (int i = 0; i < firstDayWeekday; i++) {
      days.add(const SizedBox());
    }
    
    // Days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(_selectedDate.year, _selectedDate.month, day);
      final hasEvents = _hasEventsOnDate(ipos, date);
      
      days.add(
        GestureDetector(
          onTap: hasEvents ? () => _showDayEvents(date, ipos) : null,
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: hasEvents ? Colors.blue.shade100 : null,
              borderRadius: BorderRadius.circular(8),
              border: hasEvents ? Border.all(color: Colors.blue.shade300) : null,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.toString(),
                    style: TextStyle(
                      fontWeight: hasEvents ? FontWeight.bold : FontWeight.normal,
                      color: hasEvents ? Colors.blue.shade800 : null,
                    ),
                  ),
                  if (hasEvents)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    return GridView.count(
      crossAxisCount: 7,
      children: days,
    );
  }

  bool _hasEventsOnDate(List<IpoModel> ipos, DateTime date) {
    for (final ipo in ipos) {
      if (_isSameDay(ipo.openDate, date) ||
          _isSameDay(ipo.closeDate, date) ||
          (ipo.listingDate != null && _isSameDay(ipo.listingDate!, date)) ||
          (ipo.allotmentDate != null && _isSameDay(ipo.allotmentDate!, date))) {
        return true;
      }
    }
    return false;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  void _showDayEvents(DateTime date, List<IpoModel> ipos) {
    final dayEvents = <String>[];
    
    for (final ipo in ipos) {
      if (_isSameDay(ipo.openDate, date)) {
        dayEvents.add('${ipo.companyName} - Opens');
      }
      if (_isSameDay(ipo.closeDate, date)) {
        dayEvents.add('${ipo.companyName} - Closes');
      }
      if (ipo.listingDate != null && _isSameDay(ipo.listingDate!, date)) {
        dayEvents.add('${ipo.companyName} - Lists');
      }
      if (ipo.allotmentDate != null && _isSameDay(ipo.allotmentDate!, date)) {
        dayEvents.add('${ipo.companyName} - Allotment');
      }
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(DateFormat('MMM dd, yyyy').format(date)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: dayEvents.map((event) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('• $event'),
          )).toList(),
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

  void _setReminder(IpoModel ipo, String eventType, DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Reminder'),
        content: Text('Set a reminder for ${ipo.companyName} $eventType on ${DateFormat('MMM dd, yyyy').format(date)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reminder set for ${ipo.companyName} $eventType'),
                  action: SnackBarAction(
                    label: 'View',
                    onPressed: () {},
                  ),
                ),
              );
            },
            child: const Text('Set Reminder'),
          ),
        ],
      ),
    );
  }
}

class _CalendarDayCard extends StatelessWidget {
  final DateTime date;
  final List<IpoModel> ipos;
  final Function(IpoModel, String) onReminderSet;

  const _CalendarDayCard({
    required this.date,
    required this.ipos,
    required this.onReminderSet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('EEE, MMM dd, yyyy');
    final isToday = _isToday(date);
    final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isToday ? Border.all(color: Colors.blue.shade300, width: 2) : null,
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
          // Date header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isToday 
                  ? Colors.blue.shade600 
                  : isPast 
                      ? Colors.grey.shade400 
                      : Colors.green.shade600,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isToday 
                      ? Icons.today 
                      : isPast 
                          ? Icons.history 
                          : Icons.event,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  dateFormatter.format(date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isToday) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'TODAY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Events list
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: ipos.map((ipo) => _buildIpoEvents(ipo)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIpoEvents(IpoModel ipo) {
    final events = <Widget>[];
    
    if (_isSameDay(ipo.openDate, date)) {
      events.add(_EventTile(
        ipo: ipo,
        eventType: 'Opens',
        icon: Icons.play_circle_filled,
        color: Colors.green,
        onReminderSet: () => onReminderSet(ipo, 'opening'),
      ));
    }
    
    if (_isSameDay(ipo.closeDate, date)) {
      events.add(_EventTile(
        ipo: ipo,
        eventType: 'Closes',
        icon: Icons.stop_circle,
        color: Colors.red,
        onReminderSet: () => onReminderSet(ipo, 'closing'),
      ));
    }
    
    if (ipo.allotmentDate != null && _isSameDay(ipo.allotmentDate!, date)) {
      events.add(_EventTile(
        ipo: ipo,
        eventType: 'Allotment',
        icon: Icons.assignment_turned_in,
        color: Colors.orange,
        onReminderSet: () => onReminderSet(ipo, 'allotment'),
      ));
    }
    
    if (ipo.listingDate != null && _isSameDay(ipo.listingDate!, date)) {
      events.add(_EventTile(
        ipo: ipo,
        eventType: 'Listing',
        icon: Icons.trending_up,
        color: Colors.purple,
        onReminderSet: () => onReminderSet(ipo, 'listing'),
      ));
    }
    
    return Column(children: events);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }
}

class _EventTile extends StatelessWidget {
  final IpoModel ipo;
  final String eventType;
  final IconData icon;
  final Color color;
  final VoidCallback onReminderSet;

  const _EventTile({
    required this.ipo,
    required this.eventType,
    required this.icon,
    required this.color,
    required this.onReminderSet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ipo.companyName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$eventType • ${ipo.priceBand}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onReminderSet,
            icon: Icon(Icons.notifications_outlined, color: color, size: 20),
            tooltip: 'Set reminder',
          ),
        ],
      ),
    );
  }
}
