import 'package:flutter/material.dart';
import 'package:smart_hold_app/Language/app_localizations.dart';
import 'package:smart_hold_app/screens/signupScreen.dart';
import 'package:smart_hold_app/screens/homeScreen.dart';
import 'package:smart_hold_app/Security/SecureStorage.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiAuthentication.dart';
import 'package:smart_hold_app/Services/BackEndService/ApiService.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? errorMessage;

  final TextEditingController usernameOrEmailController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late final ApiAuthentication authService;
  late final SecureStorage secureStorage;
  late final ApiService apiService;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    apiService = ApiService();
    secureStorage = SecureStorage();
    authService = ApiAuthentication(
      apiService: apiService,
      secureStorage: secureStorage,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();

    checkExistingToken();
  }

  @override
  void dispose() {
    _animationController.dispose();
    usernameOrEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await authService.login(
        usernameOrEmail: usernameOrEmailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final token = response.data;
      final refreshToken = token;
      await handleLoginSuccess(token, refreshToken);
    } on DioException catch (e) {
      String errorMsg = 'Something Error';
      if (e.response != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          errorMsg = data['message'].toString();
        } else if (e.response?.statusCode != null) {
          errorMsg = 'Error ${e.response?.statusCode}';
        }
      }
      setState(() => errorMessage = errorMsg);
    } catch (e) {
      setState(() => errorMessage = _getErrorMessage(e));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> handleLoginSuccess(String token, String refreshToken) async {
    await secureStorage.saveTokens(
      accessToken: token,
      refreshToken: refreshToken,
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(nationalNumber: '9991035208', token: token),
        ),
      );
    }
  }

  String _getErrorMessage(dynamic error) {
    final str = error.toString();
    if (str.contains('401')) {
      return 'Email / Password Invalid';
    } else if (str.contains('404')) {
      return 'Server Not Available';
    } else {
      return 'Something Error';
    }
  }

  Future<void> checkExistingToken() async {
    final token = await secureStorage.getAccessToken();
    if (token != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(nationalNumber: '9991035208', token: token),
        ),
      );
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(15, 32, 39, 1),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade200,
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Icon(
                          Icons.directions_car_filled,
                          size: 80,
                          color: Color.fromARGB(255, 12, 31, 60),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.label_welcome_back,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.label_Login,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 32),

                    TextFormField(
                      controller: usernameOrEmailController,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(
                          context,
                        )!.usernameOrEmail,

                        labelStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username or email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.password,
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        // if (value.length < 6) {
                        //   return 'Password must be at least 6 characters';
                        // }
                        return null;
                      },
                    ),
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
                        onPressed: isLoading ? null : login,
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                AppLocalizations.of(context)!.button_Login,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "${AppLocalizations.of(context)!.label_HaveNotAccout} ${AppLocalizations.of(context)!.signUp}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// ...existing code...