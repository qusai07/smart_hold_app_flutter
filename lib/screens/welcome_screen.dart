import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                title: "Smart Vehicle Hold",
                body:
                    "Secure your vehicle at home instead of traditional impoundment.",
                image: buildImage("assets/images/welcome2.png"),
                decoration: getPageDecoration(),
              ),
              PageViewModel(
                title: "24/7 Vehicle Monitoring",
                body:
                    "Easily track your vehicle's status and location through the app.",
                image: buildImage("assets/images/welcome2.png"),
                decoration: getPageDecoration(),
              ),
              PageViewModel(
                title: "Instant Alerts",
                body:
                    "We will notify you immediately if any violation occurs during the hold period.",
                image: buildImage("assets/images/welcome3.png"),
                decoration: getPageDecoration(),
              ),
            ],
            showSkipButton: true,
            skip: const Text("Skip", style: TextStyle(color: Colors.white)),
            next: const Icon(Icons.arrow_forward, color: Colors.white),
            done: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => goToLogin(context),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  "Start Now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            onDone: () => goToLogin(context),
            onSkip: () => goToLogin(context),
            dotsDecorator: getDotDecoration(),
            globalBackgroundColor: Colors.transparent,
            curve: Curves.easeInOut,
            animationDuration: 600,
          ),
        ),
      ),
    );
  }

  Widget buildImage(String path) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(path, height: 200, width: 200, fit: BoxFit.contain),
    ),
  );

  PageDecoration getPageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Roboto', // استخدم نفس الخط لو حابب
      ),
      bodyTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.white70,
        height: 1.4,
      ),
      imagePadding: EdgeInsets.zero,
      pageColor: Colors.transparent,
      contentMargin: EdgeInsets.symmetric(horizontal: 30),
      bodyPadding: EdgeInsets.only(bottom: 20),
    );
  }

  DotsDecorator getDotDecoration() => const DotsDecorator(
    color: Colors.white38,
    activeColor: Colors.white,
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
    ),
  );
}
