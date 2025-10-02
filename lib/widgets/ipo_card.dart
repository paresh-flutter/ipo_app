import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ipo_model.dart';
import '../screens/ipo_detail_screen.dart';
import '../screens/ipo_application_screen.dart';

class IpoCard extends StatelessWidget {
  final IpoModel ipo;

  const IpoCard({
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

  Color _getSectorColor(String? sector) {
    if (sector == null) return Colors.grey.shade300;
    
    final colors = [
      const Color(0xFFE3F2FD), // Light Blue
      const Color(0xFFE8F5E8), // Light Green
      const Color(0xFFFFF3E0), // Light Orange
      const Color(0xFFF3E5F5), // Light Purple
      const Color(0xFFE0F2F1), // Light Teal
      const Color(0xFFFCE4EC), // Light Pink
    ];
    
    return colors[sector.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('dd MMM yyyy');
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IpoDetailScreen(ipo: ipo),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: _getStatusColor(ipo.status).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Status Header with Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: _getStatusGradient(ipo.status),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(ipo.status),
                    color: Colors.white,
                    size: 24,
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (ipo.sector != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            ipo.sector!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Text(
                      ipo.statusString,
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
            
            // Main Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // IPO Type and Issue Size
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getSectorColor(ipo.sector),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(ipo.status).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          ipo.ipoTypeString,
                          style: TextStyle(
                            color: _getStatusColor(ipo.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          ipo.issueSize,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Subscription Status (if available)
                  if (ipo.totalSubscription != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ipo.isOversubscribed 
                            ? Colors.green.shade50 
                            : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ipo.isOversubscribed 
                              ? Colors.green.shade200 
                              : Colors.orange.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            ipo.isOversubscribed 
                                ? Icons.trending_up 
                                : Icons.trending_flat,
                            color: ipo.isOversubscribed 
                                ? Colors.green.shade700 
                                : Colors.orange.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ipo.subscriptionStatusText,
                            style: TextStyle(
                              color: ipo.isOversubscribed 
                                  ? Colors.green.shade700 
                                  : Colors.orange.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Price Band, Lot Size, and GMP
                  Row(
                    children: [
                      Expanded(
                        child: _ModernInfoTile(
                          icon: Icons.currency_rupee,
                          label: 'Price Band',
                          value: ipo.priceBand,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ModernInfoTile(
                          icon: Icons.inventory_2_outlined,
                          label: 'Lot Size',
                          value: '${ipo.lotSize}',
                          color: Colors.purple.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ModernInfoTile(
                          icon: Icons.trending_up,
                          label: 'GMP',
                          value: ipo.gmpText,
                          color: ipo.gmpColor,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Dates
                  Row(
                    children: [
                      Expanded(
                        child: _ModernInfoTile(
                          icon: Icons.calendar_today_outlined,
                          label: 'Open Date',
                          value: dateFormatter.format(ipo.openDate),
                          color: Colors.green.shade600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ModernInfoTile(
                          icon: Icons.event_available_outlined,
                          label: 'Close Date',
                          value: dateFormatter.format(ipo.closeDate),
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                  
                  // Listing Date (if available)
                  if (ipo.listingDate != null) ...[
                    const SizedBox(height: 12),
                    _ModernInfoTile(
                      icon: Icons.launch_outlined,
                      label: 'Listing Date',
                      value: dateFormatter.format(ipo.listingDate!),
                      color: Colors.indigo.shade600,
                      fullWidth: true,
                    ),
                  ],
                  
                  // Apply Now Button for Ongoing IPOs
                  if (ipo.status == IpoStatus.ongoing) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IpoApplicationScreen(ipo: ipo),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getStatusColor(ipo.status),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_card, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Apply Now',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (ipo.gmp != null && ipo.gmp! > 0) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  ipo.gmpPercentage,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  // Performance indicator for Listed IPOs
                  if (ipo.status == IpoStatus.listed && ipo.listingGains != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ipo.listingGains! > 0 
                            ? Colors.green.shade50 
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ipo.listingGains! > 0 
                              ? Colors.green.shade200 
                              : Colors.red.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            ipo.listingGains! > 0 
                                ? Icons.trending_up 
                                : Icons.trending_down,
                            color: ipo.listingGains! > 0 
                                ? Colors.green.shade700 
                                : Colors.red.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Listing Gains: ${ipo.listingGainsText}',
                            style: TextStyle(
                              color: ipo.listingGains! > 0 
                                  ? Colors.green.shade700 
                                  : Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class _ModernInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool fullWidth;

  const _ModernInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Legacy widget for backward compatibility
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
