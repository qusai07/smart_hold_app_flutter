import 'package:flutter/material.dart';
import 'package:smart_hold_app/Language/app_localizations.dart';
import 'package:smart_hold_app/Models/signup_model.dart';
import 'package:smart_hold_app/Security/secure_storage.dart';
import 'package:smart_hold_app/Services/BackEndService/api_authentication.dart';
import 'package:smart_hold_app/Services/BackEndService/api_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nationalNumberController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  late final ApiAuthentication authService;
  late final ApiService apiService;

  bool isLoading = false;
  String? errorMessage;

  Future<void> signUp() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final request = SignUpRequest(
        fullName: fullNameController.text.trim(),
        userName: userNameController.text.trim(),
        mobileNumber: mobileNumberController.text.trim(),
        emailAddress: emailController.text.trim(),
        nationalNumber: nationalNumberController.text.trim(),
        password: passwordController.text.trim(),
        userRole: 2,
      );

      if (passwordController.text != confirmPasswordController.text) {
        setState(() {
          errorMessage = "Passwords do not match";
          isLoading = false;
        });
        return;
      }

      if (userNameController.text.isEmpty ||
          emailController.text.isEmpty ||
          nationalNumberController.text.isEmpty ||
          passwordController.text.isEmpty) {
        setState(() {
          errorMessage = "Please fill all the fields";
          isLoading = false;
        });
        return;
      }

      final response = await authService.signUp(request);

      if (mounted) {
        Navigator.pushNamed(
          context,
          '/verify-otp',
          arguments: {'id': response.data.Id, 'otpCode': response.data.otpCode},
        );
      }
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    nationalNumberController.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C5364),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF203A43),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C5364),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 52, 100, 120),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Icon(
                      Icons.person_add_alt_1_outlined,
                      size: 80,
                      color: Color.fromARGB(255, 108, 167, 193),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.label_create_account,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 108, 167, 193),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.body_create_account,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 108, 167, 193),
                  ),
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  controller: userNameController,
                  label: AppLocalizations.of(context)!.userName_textFields,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: fullNameController,
                  label: AppLocalizations.of(context)!.fullName_textFields,

                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: emailController,
                  label: AppLocalizations.of(context)!.email_textFields,

                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: nationalNumberController,
                  label: AppLocalizations.of(context)!.nationalId_textFields,

                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: mobileNumberController,
                  label: AppLocalizations.of(context)!.phoneNumber_textFields,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: passwordController,
                  label: AppLocalizations.of(context)!.password_textFields,

                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: confirmPasswordController,
                  label: AppLocalizations.of(
                    context,
                  )!.confirmPassword_textFields,

                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(
                        108,
                        167,
                        193,
                        1,
                      ), 
                      shadowColor: Colors.black,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            AppLocalizations.of(context)!.signUp,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, 
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "${AppLocalizations.of(context)!.alreadyHaveAccount} ${AppLocalizations.of(context)!.button_Login}",
                    style: TextStyle(
                      color: Color.fromARGB(255, 108, 167, 193),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
