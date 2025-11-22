import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_hold_app/Language/app_localizations.dart';
import '../Models/Vehicles/ResponseModel/VehicalResponse.dart';
import '../Services/BackEndService/ApiService.dart';
import '../Services/UserService/ViolationService.dart';
import '../Security/SecureStorage.dart';
import 'ViolationsScreen.dart';
import 'package:lottie/lottie.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final VehicleResponse vehicle;

  const VehicleDetailsScreen({super.key, required this.vehicle});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  late ViolationService violationService;
  late SecureStorage secureStorage;
  bool _canViewViolations = false;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    secureStorage = SecureStorage();
    violationService = ViolationService(
      apiService: ApiService(),
      secureStorage: secureStorage,
    );
  }

  Future<void> _checkVehicleHold() async {
    setState(() => _isChecking = true);
    try {
      final myViolations = await violationService.getMyViolations();
      final vehicle = widget.vehicle;
      if (myViolations.isNotEmpty) {
        setState(() => _canViewViolations = true);
      } else {
        final vehicleViolations = await violationService
            .getMyViolationsByNationalNumber(vehicle.plateNumber, true);
        if (vehicleViolations.isNotEmpty) {
          final secondCheck = await violationService
              .getMyViolationsByNationalNumber(vehicle.plateNumber, false);

          setState(() => _canViewViolations = secondCheck.isNotEmpty);
        } else {
          setState(() => _canViewViolations = true);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to check vehicle: $e')));
    } finally {
      setState(() => _isChecking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.header_vehicles),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color.fromARGB(255, 253, 253, 253),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,

            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              _buildVehicleImage(),
              const SizedBox(height: 20),
              _buildVehicleInfoCard(),
              const SizedBox(height: 20),
              _buildOwnerInfoCard(),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isChecking || _canViewViolations)
                      ? null
                      : _checkVehicleHold,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isChecking
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          AppLocalizations.of(
                            context,
                          )!.button_check_VehicleHold,
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),

              if (_canViewViolations)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ViolationsScreen(),
                            settings: RouteSettings(
                              arguments: widget.vehicle.plateNumber,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.view_Violations,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleImage() => Container(
    height: 200, // Adjust height as needed
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 31, 56, 66),
          blurRadius: 12,
          offset: const Offset(0, 0),
        ),
      ],
      color: Colors.transparent, // transparent background
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Lottie.asset(
        'assets/images/caranimation.json',
        fit: BoxFit.contain,
        repeat: true,
      ),
    ),
  );
  Widget _buildVehicleInfoCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.vehicles_Information,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Divider(color: Colors.white24),
        _buildInfoRow(
          AppLocalizations.of(context)!.vehicles_Info_Model,
          '${widget.vehicle.model} ${widget.vehicle.type}',
        ),
        _buildInfoRow(
          AppLocalizations.of(context)!.vehicles_Info_PlatNumber,
          widget.vehicle.plateNumber,
        ),
        _buildInfoRow(
          AppLocalizations.of(context)!.vehicles_Info_Color,
          widget.vehicle.color,
        ),
        _buildInfoRow(
          AppLocalizations.of(context)!.vehicles_Info_RegistrationDate,
          DateFormat('yyyy-MM-dd').format(widget.vehicle.registrationDate),
        ),
      ],
    ),
  );

  Widget _buildOwnerInfoCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.owner_Information,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Divider(color: Colors.white24),
        _buildInfoRow(
          AppLocalizations.of(context)!.nationalId_Info,
          widget.vehicle.ownerNationalNumber,
        ),
      ],
    ),
  );

  Widget _buildInfoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(value, style: const TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
