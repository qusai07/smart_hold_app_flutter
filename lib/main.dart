import 'package:flutter/material.dart';
import 'package:smart_hold_app/Security/SecureStorage.dart';
import 'package:smart_hold_app/screens/UserProfile.dart';
import 'package:smart_hold_app/screens/VerifyOtpPage.dart';
import 'package:smart_hold_app/screens/homeScreen.dart';
import 'package:smart_hold_app/screens/signupScreen.dart';
import 'package:smart_hold_app/screens/welcome_screen.dart';
import 'package:smart_hold_app/screens/login_screen.dart';
import 'Language/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  // Call this to change app language
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Vehicle',
      navigatorKey: navigatorKey,
      theme: ThemeData(primarySwatch: Colors.blue),
      locale: _locale, // Current app locale
      supportedLocales: const [Locale('en', ''), Locale('ar', '')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return const Locale('en', '');
      },
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(onLocaleChange: setLocale),
        '/login': (context) => const LoginScreen(),
        '/signupScreen': (context) => const SignUpScreen(),
        '/verify-otp': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return VerifyOtpPage(id: args['id'], otpCode: args['otpCode']);
        },
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
