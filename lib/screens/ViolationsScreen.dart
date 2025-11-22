import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_hold_app/Language/app_localizations.dart';
import 'package:smart_hold_app/Models/Vehicles/RequestsModel/HoldRequest.dart';
import 'package:smart_hold_app/Models/Vehicles/ResponseModel/ViolationResponseAfterIntegration.dart';
import 'package:smart_hold_app/Services/UserService/ViolationService.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiService.dart';
import 'package:smart_hold_app/Security/SecureStorage.dart';

class ViolationsScreen extends StatefulWidget {
  const ViolationsScreen({super.key});

  @override
  State<ViolationsScreen> createState() => _ViolationsScreenState();
}

class _ViolationsScreenState extends State<ViolationsScreen> {
  late ViolationService _violationService;
  List<ViolationResponseAfterIntegration> _afterviolations = [];

  bool _isLoading = true;
  String? _error;
  String? plateNumber;

  @override
  void initState() {
    super.initState();
    _violationService = ViolationService(
      apiService: ApiService(),
      secureStorage: SecureStorage(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (plateNumber == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        plateNumber = args;
        _loadViolations();
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Plate number not provided';
        });
      }
    }
  }

  Future<void> _loadViolations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (plateNumber == null) throw Exception('No plate number provided');

      List<ViolationResponseAfterIntegration> violations =
          await _violationService.getMyViolations();

      if (violations.isEmpty) {
        final possibleViolations = await _violationService
            .getMyViolationsByNationalNumber(plateNumber!, true);

        if (possibleViolations.isNotEmpty) {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.noViolationsFound),
              content: Text(
                AppLocalizations.of(context)!.violation_found_message,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(AppLocalizations.of(context)!.no),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(AppLocalizations.of(context)!.yes),
                ),
              ],
            ),
          );

          if (confirm == true) {
            await _violationService.getMyViolationsByNationalNumber(
              plateNumber!,
              false,
            );
            violations = await _violationService.getMyViolations();
          }
        }
      }

      setState(() => _afterviolations = violations);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _requestHold(HoldRequest request) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _violationService.requestHold(request);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.holdRequestSubmitted),
          ),
        );
      }
      _loadViolations();
    } catch (e) {
      setState(() => _error = e.toString());
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.vehicleViolations),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadViolations,
          ),
        ],
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
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.tealAccent),
                )
              : _error != null
              ? _buildErrorWidget()
              : _afterviolations.isEmpty
              ? const Center(
                  child: Text(
                    'No violations found',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadViolations,
                  color: Colors.tealAccent,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _afterviolations.length,
                    itemBuilder: (context, index) =>
                        _buildViolationCard(_afterviolations[index]),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error ?? '', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadViolations,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 191, 165),
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildViolationCard(ViolationResponseAfterIntegration violation) {
    final holdRequest = violation.holdRequest;
    final DateTime now = DateTime.now();

    bool isActiveHold = holdRequest != null && holdRequest.isStart;
    bool isPendingHold = holdRequest != null && !holdRequest.isStart;
    DateTime startDate = holdRequest?.startDate ?? violation.violationDate;
    DateTime endDate = startDate.add(Duration(days: violation.holdDuration));

    Duration totalDuration = endDate.difference(startDate);
    Duration remainingDuration = endDate.difference(now);

    double progress = isActiveHold
        ? 1 -
              (remainingDuration.inSeconds / totalDuration.inSeconds).clamp(
                0.0,
                1.0,
              )
        : 0.0;

    String formatDuration(Duration d) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D223C).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(60, 12, 123, 175)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isActiveHold
                ? AppLocalizations.of(context)!.reservation_message
                : (isPendingHold
                      ? AppLocalizations.of(context)!.holdRequestUnderReview
                      : AppLocalizations.of(
                          context,
                        )!.holdRequestNotUnderReview),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.violationDate +
                " " +
                ': ${DateFormat('yyyy-MM-dd').format(violation.violationDate)}',
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            AppLocalizations.of(context)!.holdDuration +
                " " +
                ': ${violation.holdDuration} days',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),

          if (isActiveHold) ...[
            // Timer و Progress bar كما هو
            Center(
              child: SizedBox(
                width: 250,
                height: 150,
                child: Lottie.asset(
                  'assets/images/parking.json',
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              color: Colors.tealAccent,
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "${AppLocalizations.of(context)!.timeremaining} : ${formatDuration(remainingDuration)}",
                style: const TextStyle(
                  color: Colors.tealAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else if (isPendingHold) ...[
            Center(
              child: Text(
                AppLocalizations.of(context)!.holdRequestUnderReview,
                style: TextStyle(
                  color: Colors.orangeAccent.shade200,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else ...[
            ElevatedButton(
              onPressed: () async {
                final request = await showHoldRequestDialog(
                  context,
                  violation.vehicleId,
                );
                if (request != null) _requestHold(request);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
              ),
              child: Text(AppLocalizations.of(context)!.button_Request_Hold),
            ),
          ],
        ],
      ),
    );
  }

  Future<HoldRequest?> showHoldRequestDialog(
    BuildContext context,
    String vehicleId,
  ) async {
    final TextEditingController locationController = TextEditingController();
    DateTime? selectedDate;

    return showDialog<HoldRequest>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF0D223C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppLocalizations.of(context)!.selectStartDate,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () async {
                  DateTime now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now.add(const Duration(days: 1)),
                    firstDate: now.add(const Duration(days: 1)),
                    lastDate: now.add(const Duration(days: 30)),
                  );
                  if (picked != null) setState(() => selectedDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                            : AppLocalizations.of(context)!.selectStartDate,
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
                  labelText: AppLocalizations.of(context)!.location,
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
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0D223C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (selectedDate == null || locationController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.selectdateAndlocation,
                      ),
                    ),
                  );
                  return;
                }
                Navigator.pop(
                  context,
                  HoldRequest(
                    startDate: selectedDate!,
                    location: locationController.text,
                    vehicleId: vehicleId,
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        ),
      ),
    );
  }
}
