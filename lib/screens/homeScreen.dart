import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:smart_hold_app/Models/UserProfile.dart';
import 'package:smart_hold_app/Models/Vehicles/RequestsModel/VehicalRequest.dart';
import 'package:smart_hold_app/Models/Vehicles/ResponseModel/VehicalResponse.dart';
import 'package:smart_hold_app/Security/SecureStorage.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiService.dart';
import 'package:smart_hold_app/Services/UserService/UserServices.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_hold_app/screens/UserProfile.dart';
import 'package:smart_hold_app/screens/VehicleDetailsScreen.dart';

class HomeScreen extends StatefulWidget {
  final String nationalNumber;
  final String token;

  const HomeScreen({
    super.key,
    required this.nationalNumber,
    required this.token,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  Future<void> logout(BuildContext context) async {
    final secureStorage = SecureStorage();
    await secureStorage.clearTokens(); // Clear saved tokens
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (route) => false); // Go to login
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final SecureStorage secureStorage;
  late final Userservices userService;
  late UserProfile _userProfile = UserProfile(
    userName: '',
    emailAddress: '',
    isActive: false,
    id: '',
    fullName: '',
  );

  List<VehicleResponse> _vehicles = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    secureStorage = SecureStorage();
    userService = Userservices(
      apiService: ApiService(),
      secureStorage: secureStorage,
    );
    loadUserProfile();
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    setState(() => _isLoading = true);
    try {
      final request = VehicalRequest(
        nationalNumber: widget.nationalNumber,
        isInfo: true,
      );
      final vehicles = await userService.getMyVehicles(request);
      setState(() => _vehicles = vehicles);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> loadUserProfile() async {
    try {
      final profile = await userService.fetchUserProfile();
      setState(() => _userProfile = profile);
    } catch (_) {}
  }

  Future<void> logout(BuildContext context) async {
    final secureStorage = SecureStorage();
    await secureStorage.clearTokens(); // Clear saved tokens
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (route) => false); // Go to login
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'My Vehicles',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255), // better contrast
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout_rounded, color: Color.fromARGB(255, 235, 226, 226)),
          onPressed: () => logout(context),
        ),
      ),
      drawer: _buildDrawer(context),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _buildBodyContent(),
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_vehicles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_rounded, color: Colors.white54, size: 80),
            const SizedBox(height: 16),
            const Text(
              'No Vehicles Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Add your first vehicle to get started',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => loadVehicles(),
              icon: const Icon(Icons.add),
              label: const Text('Add Vehicle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 191, 165, 1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

  return SafeArea(
  child: AnimationLimiter(
    child: ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      itemCount: _vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = _vehicles[index];
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            horizontalOffset: 50,
            child: FadeInAnimation(
              child: Hero(
                tag: vehicle.id,
                child: _buildHorizontalVehicleCard(vehicle),
              ),
            ),
          ),
        );
      },
    ),
  ),
);

  
  }
Widget _buildHorizontalVehicleCard(VehicleResponse vehicle) {
  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VehicleDetailsScreen(vehicle: vehicle),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.car_rental,
              size: 60, color: Colors.tealAccent[400]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicle.model} ${vehicle.type}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  vehicle.plateNumber,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.tealAccent.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        vehicle.color,
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('yyyy').format(vehicle.registrationDate),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1B262C),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
              ),
            ),
            accountName: Text(
              _userProfile.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(_userProfile.emailAddress),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.tealAccent[400],
              child: Text(
                _userProfile.userName.isNotEmpty
                    ? _userProfile.userName.substring(0, 2).toUpperCase()
                    : "?",
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white70),
            title: const Text(
              'Profile',
              style: TextStyle(color: Colors.white70),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserProfileScreen(token: widget.token),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white70),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          const Spacer(),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () async {
              await secureStorage.clearTokens();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
