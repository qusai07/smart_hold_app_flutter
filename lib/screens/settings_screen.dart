import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_hold_app/Language/app_localizations.dart';
import 'package:smart_hold_app/Services/SettingsService/settings_service.dart';
import 'package:smart_hold_app/Security/secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsService _settingsService;
  bool notificationsEnabled = true;
  String selectedLanguage = 'ar';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _settingsService = SettingsService(secureStorage: SecureStorage());
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final lang = await _settingsService.getLanguage();
      final notifications = await _settingsService.getNotifications();

      if (!mounted) return;

      setState(() {
        selectedLanguage = lang;
        notificationsEnabled = notifications;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading settings: $e')));
    }
  }

  Future<void> _saveSettings() async {
    await _settingsService.saveLanguage(selectedLanguage);
    await _settingsService.setNotifications(notificationsEnabled);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.settingsSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: topPadding + 12),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.tealAccent),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _sectionTitle(AppLocalizations.of(context)!.general),
                          _settingsCard(
                            child: Column(
                              children: [
                                _languageTile(context),
                                const Divider(color: Colors.white24),
                                _notificationTile(context),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          _sectionTitle(
                            AppLocalizations.of(context)!.preferences,
                          ),
                          _settingsCard(
                            child: ListTile(
                              leading: const Icon(
                                Icons.info_outline,
                                color: Colors.tealAccent,
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.appVersion,
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: const Text(
                                'v1.0.0',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _saveButton(context),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _settingsCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: child,
    );
  }

  Widget _languageTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language, color: Colors.tealAccent),
      title: Text(
        AppLocalizations.of(context)!.select_language,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: const Color(0xFF203A43),
          value: selectedLanguage,
          items: const [
            DropdownMenuItem(value: 'ar', child: Text('العربية')),
            DropdownMenuItem(value: 'en', child: Text('English')),
          ],
          onChanged: (value) {
            setState(() => selectedLanguage = value!);
          },
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _notificationTile(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        AppLocalizations.of(context)!.notifications,
        style: const TextStyle(color: Colors.white),
      ),
      value: notificationsEnabled,
      onChanged: (value) {
        setState(() => notificationsEnabled = value);
      },
      activeThumbColor: Colors.tealAccent,
      activeTrackColor: Colors.tealAccent.withOpacity(0.4),
    );
  }
Widget _saveButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
            ),
          ),
          child: ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.save,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

}
