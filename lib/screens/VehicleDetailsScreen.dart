import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_hold_app/Models/Vehicles/ResponseModel/VehicalResponse.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final VehicleResponse vehicle;

  const VehicleDetailsScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المركبة'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildVehicleImage(),
            const SizedBox(height: 20),
            _buildVehicleInfoCard(),
            const SizedBox(height: 20),
            _buildOwnerInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleImage() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/images/car_placeholder.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildVehicleInfoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معلومات المركبة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildInfoRow('الموديل', '${vehicle.model} ${vehicle.type}'),
            _buildInfoRow('رقم اللوحة', vehicle.plateNumber),
            _buildInfoRow('اللون', vehicle.color),
            _buildInfoRow(
              'سنة التسجيل',
              DateFormat('yyyy-MM-dd').format(vehicle.registrationDate),
            ),
            // _buildInfoRow('الحالة', vehicle.isActive ? 'نشطة' : 'غير نشطة'),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerInfoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معلومات المالك',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildInfoRow('رقم الهوية', vehicle.ownerNationalNumber),
            _buildInfoRow('رقم المستخدم', vehicle.ownerUserId),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }
}
