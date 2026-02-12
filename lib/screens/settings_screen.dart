import 'package:flutter/material.dart';

/// Settings screen
///
/// Allow users to configure:
/// - Notifications
/// - Language
/// - Theme
/// - About & Privacy
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'id';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: const Color(0xFF10b981),
      ),
      body: ListView(
        children: [
          // Notifications
          SwitchListTile(
            title: const Text('Notifikasi'),
            subtitle: const Text('Aktifkan pengingat harian'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // TODO: Save to preferences
            },
          ),
          const Divider(),

          // Language
          ListTile(
            title: const Text('Bahasa'),
            subtitle: Text(_selectedLanguage == 'id' ? 'Bahasa Indonesia' : 'English'),
            onTap: _changeLanguage,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Divider(),

          // Theme
          ListTile(
            title: const Text('Tema'),
            subtitle: const Text('Gelap / Terang'),
            onTap: _changeTheme,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Divider(),

          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Tentang Aplikasi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // About
          ListTile(
            title: const Text('Tentang'),
            subtitle: const Text('Versi 1.0.0'),
            onTap: _showAbout,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),

          // Privacy Policy
          ListTile(
            title: const Text('Kebijakan Privasi'),
            onTap: _openPrivacyPolicy,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),

          // Rate App
          ListTile(
            title: const Text('Beri Rating'),
            onTap: _rateApp,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _changeLanguage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Bahasa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Bahasa Indonesia'),
              onTap: () {
                setState(() => _selectedLanguage = 'id');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                setState(() => _selectedLanguage = 'en');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _changeTheme() {
    // TODO: Implement theme change
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Theme settings coming soon')),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Nabung Challenge',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 BandungResearchAI',
      children: [
        const SizedBox(height: 16),
        const Text(
          'Nabung Challenge adalah aplikasi mobile yang dirancang untuk membantu '
          'young professionals Indonesia membangun kebiasaan menabung yang konsisten '
          'melalui gamifikasi dan challenges yang menyenangkan.',
        ),
      ],
    );
  }

  void _openPrivacyPolicy() {
    // TODO: Open privacy policy in browser or webview
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening privacy policy...')),
    );
  }

  void _rateApp() {
    // TODO: Open app store rating
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening app store...')),
    );
  }
}
