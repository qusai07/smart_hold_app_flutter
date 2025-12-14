import 'package:flutter/material.dart';
import 'package:smart_hold_app/Language/app_localizations.dart';
import 'package:smart_hold_app/Models/user_profile.dart';
import 'package:smart_hold_app/Security/secure_storage.dart';
import 'package:smart_hold_app/Services/BackEndService/api_service.dart';
import 'package:smart_hold_app/Services/UserService/user_services.dart';

class UserProfileScreen extends StatefulWidget {
  final String token;
  const UserProfileScreen({super.key, required this.token});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserProfile? profile;
  bool isLoading = true;
  String? error;
  late final SecureStorage secureStorage;
  late final Userservices userService;

  @override
  void initState() {
    super.initState();
    secureStorage = SecureStorage();
    userService = Userservices(
      apiService: ApiService(),
      secureStorage: secureStorage,
    );
    loadUserProfile();
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _performLogout();
    }
  }

  Future<void> _performLogout() async {
    try {
      await secureStorage.clearTokens();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> loadUserProfile() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final fetchedProfile = await userService.fetchUserProfile();
      setState(() {
        profile = fetchedProfile;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Error loading profile: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF203A43),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: buildContent(context),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    if (isLoading) {
      return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.button_Login,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 124, 23, 23),
                backgroundColor: const Color(0xFF203A43),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: loadUserProfile,
              child: Text(
                AppLocalizations.of(context)!.tryagain,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    }

    if (profile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.profileNotFound,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 220,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 32, 58, 67),
                    const Color.fromARGB(255, 33, 60, 70),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromARGB(76, 7, 83, 108),
                    child: Text(
                      profile!.userName.length >= 2
                          ? profile!.userName.substring(0, 2).toUpperCase()
                          : profile!.userName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(5, 171, 208, 0.31),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile!.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile!.emailAddress,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  buildProfileCard(),
                  const SizedBox(height: 24),
                  buildRefreshButton(),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget buildProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: const Color.fromARGB(255, 240, 240, 240),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildProfileItem(
              Icons.person_outline,
              AppLocalizations.of(context)!.fullName,
              profile!.fullName,
            ),
            const Divider(height: 32),
            buildProfileItem(
              Icons.alternate_email,
              AppLocalizations.of(context)!.username,
              profile!.userName,
            ),
            const Divider(height: 32),
            buildProfileItem(
              Icons.email_outlined,
              AppLocalizations.of(context)!.email,
              profile!.emailAddress,
            ),
            const Divider(height: 32),
            buildProfileItem(
              Icons.circle_outlined,
              AppLocalizations.of(context)!.status,
              profile!.isActive
                  ? AppLocalizations.of(context)!.active
                  : AppLocalizations.of(context)!.inactive,
              statusColor: profile!.isActive ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 62, 129, 152),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _confirmLogout,
                icon: const Icon(Icons.logout),
                label: Text(
                  AppLocalizations.of(context)!.logout,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileItem(
    IconData icon,
    String label,
    String value, {
    Color? statusColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 24,
            color: const Color.fromARGB(255, 124, 163, 202),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 6),
              if (statusColor != null)
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRefreshButton() {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 25, 122, 154),
        side: const BorderSide(color: Color.fromARGB(255, 9, 85, 104)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: loadUserProfile,
      icon: const Icon(Icons.refresh, size: 20),
      label: Text(
        AppLocalizations.of(context)!.refresh_profile,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
