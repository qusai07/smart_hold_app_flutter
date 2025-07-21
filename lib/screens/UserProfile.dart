import 'package:flutter/material.dart';
import 'package:smart_hold_app/Models/UserProfile.dart';
import 'package:smart_hold_app/Service/UserService.dart';

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

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      final fetchedProfile = await UserService.fetchUserProfile(widget.token);
      if (fetchedProfile == null) {
        setState(() {
          error = "Unauthorized or profile not found.";
          isLoading = false;
        });
      } else {
        setState(() {
          profile = fetchedProfile;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (error != null) {
      return Scaffold(body: Center(child: Text(error!)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: profile == null
            ? const Center(child: Text("No profile data"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profileItem("Full Name", profile!.fullName),
                  profileItem("User Name", profile!.userName),
                  profileItem("Email", profile!.emailAddress),
                  profileItem("Active", profile!.isActive ? "Yes" : "No"),
                ],
              ),
      ),
    );
  }

  Widget profileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF0D47A1),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
