import 'package:flutter/material.dart';
import 'package:smart_hold_app/Models/OtpVerification.dart';
import 'package:smart_hold_app/Security/SecureStorage.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiAuthentication.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiService.dart';

class VerifyOtpPage extends StatefulWidget {
  final String id;
  final String otpCode;

  const VerifyOtpPage({super.key, required this.id, required this.otpCode});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  late final ApiAuthentication authService;
  late final ApiService apiService;

  final otpController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    authService = ApiAuthentication(
      apiService: apiService,
      secureStorage: SecureStorage(),
    );
  }

  Future<void> verifyOtp() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final enteredOtp = otpController.text.trim();

      if (enteredOtp.isEmpty) {
        setState(() => errorMessage = "Please enter the OTP code");
        return;
      }

      final request = SignupVerifyOtpRequest(
        id: widget.id,
        otpCode: enteredOtp,
      );

      final response = await authService.verifyOtp(request);

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account verified successfully!')),
        );

        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() => errorMessage = response.message);
      }
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Color.fromRGBO(108, 167, 193, 1),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Verify Your Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(108, 167, 193, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter the OTP sent to your email or phone",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // OTP Input
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "OTP Code",
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                      filled: true,
                      fillColor: const Color.fromRGBO(44, 83, 100, 0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (errorMessage != null)
                    Text(errorMessage!, style: const TextStyle(color: Colors.redAccent)),
                  const SizedBox(height: 20),
                  // Verify Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(108, 167, 193, 1),
                        shadowColor: Colors.black.withOpacity(0.5),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Verify",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Received OTP: ${widget.otpCode}",
                    style: const TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
