import 'package:flutter/material.dart';
import 'package:smart_hold_app/Security/SecureStorage.dart';
import 'package:smart_hold_app/screens/UserProfile.dart';
import 'package:smart_hold_app/screens/homeScreen.dart';
import 'package:smart_hold_app/screens/signupScreen.dart';
import 'package:smart_hold_app/screens/welcome_screen.dart';
import 'package:smart_hold_app/screens/login_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Vehicle',
      navigatorKey: navigatorKey,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signupScreen': (context) => const SignUpScreen(),
        '/UserProfile': (context) => FutureBuilder(
          future: SecureStorage().getAccessToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData && snapshot.data != null) {
              return UserProfileScreen(token: snapshot.data!);
            }
            return const LoginScreen(); // Redirect to login if no token
          },
        ),
        '/homeScreen': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return HomeScreen(
            nationalNumber: args['nationalNumber'],
            token: args['token'],
          );
        },
      },
    );
  }
}
