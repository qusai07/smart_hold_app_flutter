import 'package:flutter/material.dart';
import 'package:smart_hold_app/Models/Vehicles/Violation.dart';
import 'package:smart_hold_app/Security/SecureStorage.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiAuthentication.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiService.dart';
import 'package:smart_hold_app/Services/UserService/ViolationService.dart';

class ViolationsScreen extends StatefulWidget {
  final String userId;

  const ViolationsScreen({super.key, required this.userId});

  @override
  State<ViolationsScreen> createState() => _ViolationsScreenState();
}

class _ViolationsScreenState extends State<ViolationsScreen> {
  late final ViolationService _violationService;
  late final ApiAuthentication authService;
  late final SecureStorage secureStorage;
  late final ApiService apiService;
  List<Violation> _violations = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    secureStorage = SecureStorage();
    authService = ApiAuthentication(
      apiService: apiService,
      secureStorage: secureStorage,
    );
    _loadViolations();
  }

  Future<void> _loadViolations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final violations = await _violationService.getViolationsForUser(
        widget.userId,
      );
      setState(() {
        _violations = violations;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Violations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadViolations,
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadViolations,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_violations.isEmpty) {
      return const Center(child: Text('No violations found'));
    }

    return ListView.builder(
      itemCount: _violations.length,
      itemBuilder: (context, index) {
        final violation = _violations[index];
        return _buildViolationCard(violation);
      },
    );
  }

  Widget _buildViolationCard(Violation violation) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Violation: ${violation.description}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Text(
            //   'Date: ${DateFormat('MMM dd, yyyy - hh:mm a').format(violation.violationDate)}',
            // ),
            Text('Status: ${violation.isResolved ? 'Resolved' : 'Active'}'),
            const SizedBox(height: 12),
            const Text(
              'Vehicle Details:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (violation.holdRequest.vehicle != null) ...[
              Text('Plate: ${violation.holdRequest.vehicle!.plateNumber}'),
              Text(
                'Model: ${violation.holdRequest.vehicle!.model} ${violation.holdRequest.vehicle!.type}',
              ),
              Text('Color: ${violation.holdRequest.vehicle!.color}'),
            ] else ...[
              Text('Plate: ${violation.holdRequest.plateNumber}'),
              const Text('Vehicle details not available'),
            ],
            const SizedBox(height: 12),
            const Text(
              'Hold Request:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Location: ${violation.holdRequest.location}'),
            // Text(
            //   'From: ${DateFormat('MMM dd, yyyy').format(violation.holdRequest.startDate)}',
            // ),
            //  Text(
            //  'To: ${DateFormat('MMM dd, yyyy').format(violation.holdRequest.endDate)}',
            // ),
            if (!violation.isResolved) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _resolveViolation(violation.id),
                  child: const Text('Mark as Resolved'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _resolveViolation(String violationId) async {
    // Implement your resolution logic here
    // You'll need to add a new method in ViolationService
    // to call your resolve violation API endpoint
  }
}
