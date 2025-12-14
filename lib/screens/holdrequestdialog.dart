import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> showHoldRequestDialog(BuildContext context, String plateNumber, String vehicleId) async {
  final TextEditingController locationController = TextEditingController();
  DateTime? selectedDate;

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF0D223C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text(
              'Hold Request Details',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    DateTime now = DateTime.now();
                    DateTime firstDate = now.add(const Duration(days: 1));
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: firstDate,
                      firstDate: firstDate,
                      lastDate: now.add(const Duration(days: 30)),
                    );
                    if (picked != null) {
                      setState(() => selectedDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : 'Select Start Date',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.white70),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Location',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0D223C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (selectedDate == null || locationController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select date and location')),
                    );
                    return;
                  }
                  Navigator.pop(context, {
                    'startDate': selectedDate!.toIso8601String(),
                    'location': locationController.text,
                    'vehicleId': vehicleId,
                  });
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    },
  );
}
