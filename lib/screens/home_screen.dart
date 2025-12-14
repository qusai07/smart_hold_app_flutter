import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:smart_hold_app/Language/app_localizations.dart';
import 'package:smart_hold_app/Models/user_profile.dart';
import 'package:smart_hold_app/Models/Vehicles/RequestsModel/vehical_request.dart';
import 'package:smart_hold_app/Models/Vehicles/ResponseModel/vehical_response.dart';
import 'package:smart_hold_app/Security/secure_storage.dart';
import 'package:smart_hold_app/Services/BackEndService/api_service.dart';
import 'package:smart_hold_app/Services/UserService/user_services.dart';
import 'package:smart_hold_app/Services/BackEndService/notifications_service.dart';
import 'package:smart_hold_app/screens/notifications_screen.dart';
import 'package:smart_hold_app/screens/settings_screen.dart';
import 'package:smart_hold_app/screens/user_profile.dart';
import 'package:smart_hold_app/screens/vehicle_details_screen.dart';

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
  late final NotificationsService notificationsService;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    secureStorage = SecureStorage();
    userService = Userservices(
      apiService: ApiService(),
      secureStorage: secureStorage,
    );
    notificationsService = NotificationsService(
      apiService: ApiService(),
      secureStorage: secureStorage,
    );
    loadUserProfile();
    loadVehicles();
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    try {
      final count = await notificationsService.getUnreadCount();
      setState(() => _unreadCount = count);
    } catch (_) {}
  }

  Future<void> loadUserProfile() async {
    try {
      final profile = await userService.fetchUserProfile();
      setState(() => _userProfile = profile);
    } catch (_) {}
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

  Future<void> logout(BuildContext context) async {
    await secureStorage.clearTokens();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.header_vehicles,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  if (_unreadCount > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Center(
                          child: Text(
                            _unreadCount > 99 ? '99+' : '$_unreadCount',
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                );
                _loadUnreadCount();
              },
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () => logout(context),
          ),
        ],
      ),
      drawer: _buildDrawer(),
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

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1B262C),
      child: _userProfile.fullName.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
                      ),
                    ),
                    accountName: Text(
                      _userProfile.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      _userProfile.emailAddress,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: const Color(0xFF203A43),
                      child: Text(
                        _userProfile.userName.isNotEmpty
                            ? _userProfile.userName
                                  .substring(0, 2)
                                  .toUpperCase()
                            : "?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 2, 63, 73),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.profile,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              UserProfileScreen(token: widget.token),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Color.fromARGB(255, 2, 63, 73),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.settings,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Divider(color: Colors.white24),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.logout,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () => logout(context),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBodyContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      );
    }
    if (_vehicles.isEmpty) return _buildEmptyState();

    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _vehicles.length,
        itemBuilder: (context, index) =>
            _buildHorizontalVehicleCard(_vehicles[index]),
      ),
    );
  }

  Widget _buildEmptyState() {
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
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalVehicleCard(VehicleResponse vehicle) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VehicleDetailsScreen(vehicle: vehicle),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.car_rental, size: 60, color: Colors.tealAccent[400]),
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
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          vehicle.color,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
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
}
