import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/ipo_bloc.dart';
import '../bloc/ipo_event.dart';
import '../bloc/ipo_state.dart';
import '../models/ipo_model.dart';

class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({super.key});

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  String _selectedFormat = 'PDF';
  String _selectedDataType = 'All IPOs';
  bool _includeGMP = true;
  bool _includeSubscription = true;
  bool _includeFinancials = false;
  bool _includeAnalysis = false;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  final List<String> _formats = ['PDF', 'Excel', 'CSV', 'JSON'];
  final List<String> _dataTypes = [
    'All IPOs',
    'Ongoing IPOs',
    'Upcoming IPOs',
    'My Applications',
    'Watchlist',
    'Performance Report'
  ];

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
        title: const Text('Export Data'),
        backgroundColor: Colors.brown.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Export Format Selection
                _buildSectionHeader('Export Format'),
                _buildFormatSelector(isTablet),
                
                const SizedBox(height: 24),
                
                // Data Type Selection
                _buildSectionHeader('Data to Export'),
                _buildDataTypeSelector(),
                
                const SizedBox(height: 24),
                
                // Date Range Selection
                _buildSectionHeader('Date Range'),
                _buildDateRangeSelector(),
                
                const SizedBox(height: 24),
                
                // Additional Options
                _buildSectionHeader('Include Additional Data'),
                _buildAdditionalOptions(),
                
                const SizedBox(height: 24),
                
                // Preview Section
                _buildSectionHeader('Export Preview'),
                _buildPreviewSection(),
                
                const SizedBox(height: 32),
                
                // Export Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _exportData(),
                    icon: const Icon(Icons.download),
                    label: Text('Export as $_selectedFormat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Recent Exports
                _buildRecentExports(),
                
                const SizedBox(height: 100), // Bottom padding
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildFormatSelector(bool isTablet) {
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
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: isTablet ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isTablet ? 1.5 : 2.5,
        children: _formats.map((format) {
          final isSelected = format == _selectedFormat;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFormat = format;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.brown.shade600 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.brown.shade600 : Colors.grey.shade300,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getFormatIcon(format),
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    format,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDataTypeSelector() {
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
        children: _dataTypes.map((dataType) {
          return RadioListTile<String>(
            title: Text(dataType),
            subtitle: Text(_getDataTypeDescription(dataType)),
            value: dataType,
            groupValue: _selectedDataType,
            onChanged: (value) {
              setState(() {
                _selectedDataType = value!;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
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
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Start Date'),
                  subtitle: Text(DateFormat('MMM dd, yyyy').format(_startDate)),
                  leading: const Icon(Icons.calendar_today),
                  onTap: () => _selectStartDate(),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text('End Date'),
                  subtitle: Text(DateFormat('MMM dd, yyyy').format(_endDate)),
                  leading: const Icon(Icons.calendar_today),
                  onTap: () => _selectEndDate(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _startDate = DateTime.now().subtract(const Duration(days: 7));
                      _endDate = DateTime.now();
                    });
                  },
                  child: const Text('Last 7 Days'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _startDate = DateTime.now().subtract(const Duration(days: 30));
                      _endDate = DateTime.now();
                    });
                  },
                  child: const Text('Last 30 Days'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _startDate = DateTime.now().subtract(const Duration(days: 90));
                      _endDate = DateTime.now();
                    });
                  },
                  child: const Text('Last 90 Days'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptions() {
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
        children: [
          CheckboxListTile(
            title: const Text('Include GMP Data'),
            subtitle: const Text('Grey Market Premium information'),
            value: _includeGMP,
            onChanged: (value) {
              setState(() {
                _includeGMP = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Include Subscription Data'),
            subtitle: const Text('Subscription levels and ratios'),
            value: _includeSubscription,
            onChanged: (value) {
              setState(() {
                _includeSubscription = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Include Financial Metrics'),
            subtitle: const Text('P/E ratio, ROE, debt/equity'),
            value: _includeFinancials,
            onChanged: (value) {
              setState(() {
                _includeFinancials = value!;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Include Analysis & Ratings'),
            subtitle: const Text('Expert analysis and recommendations'),
            value: _includeAnalysis,
            onChanged: (value) {
              setState(() {
                _includeAnalysis = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    return BlocBuilder<IpoBloc, IpoState>(
      builder: (context, state) {
        if (state is IpoLoaded) {
          final previewData = _getPreviewData(state.ipos);
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
                    Icon(Icons.preview, color: Colors.brown.shade600),
                    const SizedBox(width: 8),
                    const Text(
                      'Export Preview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _PreviewItem('Total Records', '${previewData['totalRecords']}'),
                _PreviewItem('File Format', _selectedFormat),
                _PreviewItem('Data Type', _selectedDataType),
                _PreviewItem('Date Range', '${DateFormat('MMM dd').format(_startDate)} - ${DateFormat('MMM dd, yyyy').format(_endDate)}'),
                _PreviewItem('Estimated Size', previewData['estimatedSize']),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Export will include ${previewData['columns']} columns with the selected data options.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildRecentExports() {
    final recentExports = [
      {'name': 'All_IPOs_2024.pdf', 'date': 'Today', 'size': '2.3 MB'},
      {'name': 'My_Applications.xlsx', 'date': 'Yesterday', 'size': '1.1 MB'},
      {'name': 'Watchlist_Report.csv', 'date': '3 days ago', 'size': '0.8 MB'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Recent Exports'),
        Container(
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
            children: recentExports.map((export) {
              return ListTile(
                leading: Icon(
                  _getFileIcon(export['name']!),
                  color: Colors.brown.shade600,
                ),
                title: Text(export['name']!),
                subtitle: Text('${export['date']} • ${export['size']}'),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'download',
                      child: Row(
                        children: [
                          Icon(Icons.download),
                          SizedBox(width: 8),
                          Text('Download Again'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share),
                          SizedBox(width: 8),
                          Text('Share'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    _handleExportAction(value.toString(), export['name']!);
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  IconData _getFormatIcon(String format) {
    switch (format) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'Excel':
        return Icons.table_chart;
      case 'CSV':
        return Icons.grid_on;
      case 'JSON':
        return Icons.code;
      default:
        return Icons.file_copy;
    }
  }

  IconData _getFileIcon(String filename) {
    if (filename.endsWith('.pdf')) return Icons.picture_as_pdf;
    if (filename.endsWith('.xlsx') || filename.endsWith('.xls')) return Icons.table_chart;
    if (filename.endsWith('.csv')) return Icons.grid_on;
    return Icons.file_copy;
  }

  String _getDataTypeDescription(String dataType) {
    switch (dataType) {
      case 'All IPOs':
        return 'Complete IPO database with all statuses';
      case 'Ongoing IPOs':
        return 'Currently open IPOs accepting applications';
      case 'Upcoming IPOs':
        return 'IPOs scheduled to open soon';
      case 'My Applications':
        return 'Your IPO applications and their status';
      case 'Watchlist':
        return 'IPOs you are tracking';
      case 'Performance Report':
        return 'Investment performance and analytics';
      default:
        return '';
    }
  }

  Map<String, dynamic> _getPreviewData(List<IpoModel> ipos) {
    int totalRecords = 0;
    int columns = 8; // Base columns
    
    switch (_selectedDataType) {
      case 'All IPOs':
        totalRecords = ipos.length;
        break;
      case 'Ongoing IPOs':
        totalRecords = ipos.where((ipo) => ipo.status == IpoStatus.ongoing).length;
        break;
      case 'Upcoming IPOs':
        totalRecords = ipos.where((ipo) => ipo.status == IpoStatus.upcoming).length;
        break;
      case 'My Applications':
        totalRecords = 5; // Mock data
        break;
      case 'Watchlist':
        totalRecords = 3; // Mock data
        break;
      case 'Performance Report':
        totalRecords = ipos.where((ipo) => ipo.status == IpoStatus.listed).length;
        break;
    }
    
    if (_includeGMP) columns += 2;
    if (_includeSubscription) columns += 3;
    if (_includeFinancials) columns += 4;
    if (_includeAnalysis) columns += 3;
    
    final estimatedSizeKB = totalRecords * columns * 0.1;
    String estimatedSize;
    if (estimatedSizeKB < 1024) {
      estimatedSize = '${estimatedSizeKB.toStringAsFixed(1)} KB';
    } else {
      estimatedSize = '${(estimatedSizeKB / 1024).toStringAsFixed(1)} MB';
    }
    
    return {
      'totalRecords': totalRecords,
      'columns': columns,
      'estimatedSize': estimatedSize,
    };
  }

  void _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _startDate = date;
      });
    }
  }

  void _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  void _exportData() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Exporting Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Preparing $_selectedFormat file...'),
          ],
        ),
      ),
    );

    // Simulate export process
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Close progress dialog
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Complete'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 48),
              const SizedBox(height: 16),
              Text('Your $_selectedFormat file has been exported successfully!'),
              const SizedBox(height: 8),
              Text(
                'File: ${_selectedDataType.replaceAll(' ', '_')}_${DateFormat('yyyyMMdd').format(DateTime.now())}.${_selectedFormat.toLowerCase()}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File shared successfully')),
                );
              },
              child: const Text('Share'),
            ),
          ],
        ),
      );
    });
  }

  void _handleExportAction(String action, String filename) {
    switch (action) {
      case 'download':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading $filename...')),
        );
        break;
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sharing $filename...')),
        );
        break;
      case 'delete':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Export'),
            content: Text('Are you sure you want to delete $filename?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$filename deleted')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
        break;
    }
  }
}

class _PreviewItem extends StatelessWidget {
  final String label;
  final String value;

  const _PreviewItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
