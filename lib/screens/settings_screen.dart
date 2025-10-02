import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _gmpAlertsEnabled = true;
  bool _allotmentAlertsEnabled = true;
  bool _listingAlertsEnabled = false;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;
  String _defaultUpiId = 'user@paytm';
  String _preferredLanguage = 'English';
  String _currency = 'INR';
  double _notificationTime = 9.0; // 9 AM

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.grey.shade700,
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
                // Notifications Section
                _buildSectionHeader('Notifications'),
                _buildSettingsCard([
                  _buildSwitchTile(
                    'Push Notifications',
                    'Receive alerts for IPO updates',
                    _notificationsEnabled,
                    (value) => setState(() => _notificationsEnabled = value),
                    Icons.notifications,
                  ),
                  _buildSwitchTile(
                    'GMP Alerts',
                    'Get notified when GMP changes significantly',
                    _gmpAlertsEnabled,
                    (value) => setState(() => _gmpAlertsEnabled = value),
                    Icons.trending_up,
                  ),
                  _buildSwitchTile(
                    'Allotment Alerts',
                    'Notifications for allotment results',
                    _allotmentAlertsEnabled,
                    (value) => setState(() => _allotmentAlertsEnabled = value),
                    Icons.assignment_turned_in,
                  ),
                  _buildSwitchTile(
                    'Listing Alerts',
                    'Get notified when IPOs get listed',
                    _listingAlertsEnabled,
                    (value) => setState(() => _listingAlertsEnabled = value),
                    Icons.list_alt,
                  ),
                ]),

                const SizedBox(height: 24),

                // Notification Time
                _buildSectionHeader('Notification Timing'),
                _buildSettingsCard([
                  ListTile(
                    leading: Icon(Icons.schedule, color: Colors.blue.shade600),
                    title: const Text('Daily Alert Time'),
                    subtitle: Text('${_notificationTime.toInt()}:00 ${_notificationTime >= 12 ? 'PM' : 'AM'}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showTimePickerDialog(),
                  ),
                ]),

                const SizedBox(height: 24),

                // App Preferences Section
                _buildSectionHeader('App Preferences'),
                _buildSettingsCard([
                  _buildSwitchTile(
                    'Dark Mode',
                    'Use dark theme for the app',
                    _darkModeEnabled,
                    (value) => setState(() => _darkModeEnabled = value),
                    Icons.dark_mode,
                  ),
                  ListTile(
                    leading: Icon(Icons.language, color: Colors.green.shade600),
                    title: const Text('Language'),
                    subtitle: Text(_preferredLanguage),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showLanguageDialog(),
                  ),
                  ListTile(
                    leading: Icon(Icons.currency_rupee, color: Colors.orange.shade600),
                    title: const Text('Currency'),
                    subtitle: Text(_currency),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showCurrencyDialog(),
                  ),
                ]),

                const SizedBox(height: 24),

                // Security Section
                _buildSectionHeader('Security'),
                _buildSettingsCard([
                  _buildSwitchTile(
                    'Biometric Authentication',
                    'Use fingerprint or face unlock',
                    _biometricEnabled,
                    (value) => setState(() => _biometricEnabled = value),
                    Icons.fingerprint,
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance, color: Colors.purple.shade600),
                    title: const Text('Default UPI ID'),
                    subtitle: Text(_defaultUpiId),
                    trailing: const Icon(Icons.edit, size: 16),
                    onTap: () => _showUpiEditDialog(),
                  ),
                ]),

                const SizedBox(height: 24),

                // Data & Storage Section
                _buildSectionHeader('Data & Storage'),
                _buildSettingsCard([
                  ListTile(
                    leading: Icon(Icons.cloud_sync, color: Colors.blue.shade600),
                    title: const Text('Sync Data'),
                    subtitle: const Text('Last synced: Just now'),
                    trailing: const Icon(Icons.sync, size: 16),
                    onTap: () => _syncData(),
                  ),
                  ListTile(
                    leading: Icon(Icons.storage, color: Colors.green.shade600),
                    title: const Text('Clear Cache'),
                    subtitle: const Text('Free up storage space'),
                    trailing: const Icon(Icons.delete_outline, size: 16),
                    onTap: () => _showClearCacheDialog(),
                  ),
                  ListTile(
                    leading: Icon(Icons.backup, color: Colors.orange.shade600),
                    title: const Text('Backup Settings'),
                    subtitle: const Text('Save your preferences'),
                    trailing: const Icon(Icons.backup, size: 16),
                    onTap: () => _backupSettings(),
                  ),
                ]),

                const SizedBox(height: 24),

                // Advanced Section
                _buildSectionHeader('Advanced'),
                _buildSettingsCard([
                  ListTile(
                    leading: Icon(Icons.bug_report, color: Colors.red.shade600),
                    title: const Text('Debug Mode'),
                    subtitle: const Text('Enable detailed logging'),
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Debug mode toggled')),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.refresh, color: Colors.blue.shade600),
                    title: const Text('Reset to Defaults'),
                    subtitle: const Text('Restore original settings'),
                    trailing: const Icon(Icons.restore, size: 16),
                    onTap: () => _showResetDialog(),
                  ),
                ]),

                const SizedBox(height: 24),

                // About Section
                _buildSectionHeader('About'),
                _buildSettingsCard([
                  ListTile(
                    leading: Icon(Icons.info, color: Colors.grey.shade600),
                    title: const Text('App Version'),
                    subtitle: const Text('1.0.0 (Build 100)'),
                  ),
                  ListTile(
                    leading: Icon(Icons.policy, color: Colors.grey.shade600),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showPrivacyPolicy(),
                  ),
                  ListTile(
                    leading: Icon(Icons.description, color: Colors.grey.shade600),
                    title: const Text('Terms of Service'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showTermsOfService(),
                  ),
                ]),

                const SizedBox(height: 100), // Bottom padding for navigation bar
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

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
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
        children: children.map((child) {
          final index = children.indexOf(child);
          return Column(
            children: [
              child,
              if (index < children.length - 1)
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Colors.grey.shade200,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: value ? Colors.green.shade600 : Colors.grey.shade400),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green.shade600,
      ),
    );
  }

  void _showTimePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Notification Time'),
        content: SizedBox(
          height: 200,
          child: Column(
            children: [
              const Text('Choose your preferred time for daily IPO alerts:'),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: 24,
                  itemBuilder: (context, index) {
                    final hour = index;
                    final timeString = '${hour.toString().padLeft(2, '0')}:00';
                    final displayTime = '${hour == 0 ? 12 : hour > 12 ? hour - 12 : hour}:00 ${hour >= 12 ? 'PM' : 'AM'}';
                    
                    return RadioListTile<double>(
                      title: Text(displayTime),
                      value: hour.toDouble(),
                      groupValue: _notificationTime,
                      onChanged: (value) {
                        setState(() {
                          _notificationTime = value!;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final languages = ['English', 'Hindi', 'Tamil', 'Telugu', 'Gujarati', 'Marathi'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) => RadioListTile<String>(
            title: Text(language),
            value: language,
            groupValue: _preferredLanguage,
            onChanged: (value) {
              setState(() {
                _preferredLanguage = value!;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Language changed to $value')),
              );
            },
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog() {
    final currencies = ['INR', 'USD', 'EUR', 'GBP'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((currency) => RadioListTile<String>(
            title: Text(currency),
            value: currency,
            groupValue: _currency,
            onChanged: (value) {
              setState(() {
                _currency = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showUpiEditDialog() {
    final controller = TextEditingController(text: _defaultUpiId);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit UPI ID'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'UPI ID',
            hintText: 'example@upi',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _defaultUpiId = controller.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('UPI ID updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _syncData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Syncing data...'),
        duration: Duration(seconds: 2),
      ),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data synced successfully')),
      );
    });
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data including images and temporary files. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _backupSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings backed up successfully')),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('This will reset all settings to their default values. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notificationsEnabled = true;
                _gmpAlertsEnabled = true;
                _allotmentAlertsEnabled = true;
                _listingAlertsEnabled = false;
                _darkModeEnabled = false;
                _biometricEnabled = false;
                _defaultUpiId = 'user@paytm';
                _preferredLanguage = 'English';
                _currency = 'INR';
                _notificationTime = 9.0;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'IPO Tracker Privacy Policy\n\n'
            'We are committed to protecting your privacy and ensuring the security of your personal information.\n\n'
            '1. Data Collection: We collect only necessary information for app functionality.\n'
            '2. Data Usage: Your data is used solely for providing IPO tracking services.\n'
            '3. Data Security: We implement industry-standard security measures.\n'
            '4. Data Sharing: We do not share your personal data with third parties.\n\n'
            'For complete privacy policy, visit our website.',
          ),
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

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'IPO Tracker Terms of Service\n\n'
            'By using this app, you agree to the following terms:\n\n'
            '1. The app is for informational purposes only.\n'
            '2. Investment decisions are your responsibility.\n'
            '3. We do not guarantee data accuracy.\n'
            '4. Use the app in compliance with applicable laws.\n'
            '5. We reserve the right to modify these terms.\n\n'
            'For complete terms, visit our website.',
          ),
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
