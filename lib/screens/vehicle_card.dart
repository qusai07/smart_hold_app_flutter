import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_hold_app/Models/Vehicles/ResponseModel/vehical_response.dart';

class VehicleCard extends StatelessWidget {
  final VehicleResponse vehicle;
  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_car, size: 40),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${vehicle.model} ${vehicle.type}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      vehicle.plateNumber,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Color: ${vehicle.color}'),
                Text(
                  'Registered: ${DateFormat('yyyy-MM-dd').format(vehicle.registrationDate)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
