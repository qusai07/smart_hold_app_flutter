import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_hold_app/Language/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  final void Function(Locale locale) onLocaleChange;

  const WelcomeScreen({super.key, required this.onLocaleChange});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _buttonAnimation;
  Locale _currentLocale = const Locale('en', 'US');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _buttonAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _toggleLanguage() {
    final newLocale = _currentLocale.languageCode == 'en'
        ? const Locale('ar', '')
        : const Locale('en', 'US');
    setState(() {
      _currentLocale = newLocale;
    });
    widget.onLocaleChange(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _currentLocale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Localizations.override(
        context: context,
        locale: _currentLocale,
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 30, 61, 72),
                  Color.fromARGB(255, 32, 61, 72),
                  Color.fromARGB(255, 20, 34, 40),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  IntroductionScreen(
                    pages: [
                      _buildPage(
                        title: AppLocalizations.of(context)!.appTitle,
                        body: AppLocalizations.of(context)!.label_desc_screen1,
                      ),
                      _buildPage(
                        title: AppLocalizations.of(
                          context,
                        )!.label_title_screen2,
                        body: AppLocalizations.of(context)!.label_desc_screen2,
                      ),
                      _buildPage(
                        title: AppLocalizations.of(
                          context,
                        )!.label_title_screen3,
                        body: AppLocalizations.of(context)!.label_desc_screen3,
                      ),
                    ],
                    showSkipButton: true,
                    skip: Text(
                      AppLocalizations.of(context)!.label_Skip,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    next: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    done: ScaleTransition(
                      scale: _buttonAnimation,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            26,
                            59,
                            69,
                          ),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: goToLogin,
                        child: Text(
                          AppLocalizations.of(context)!.start,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    onDone: goToLogin,
                    onSkip: goToLogin,
                    dotsDecorator: const DotsDecorator(
                      color: Color.fromRGBO(28, 59, 72, 0.722),
                      activeColor: Color.fromARGB(255, 26, 61, 72),
                      size: Size(10, 10),
                      activeSize: Size(22, 10),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                    ),
                    globalBackgroundColor: Colors.transparent,
                    curve: Curves.easeInOut,
                    animationDuration: 700,
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: ElevatedButton(
                      onPressed: _toggleLanguage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black45,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        _currentLocale.languageCode == 'en' ? 'AR' : 'EN',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PageViewModel _buildPage({required String title, required String body}) {
    return PageViewModel(
      titleWidget: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        ),
        child: Text(
          title,
          textAlign: _currentLocale.languageCode == 'ar'
              ? TextAlign.right
              : TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      bodyWidget: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1000),
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 15),
            child: child,
          ),
        ),
        child: Text(
          body,
          textAlign: _currentLocale.languageCode == 'ar'
              ? TextAlign.right
              : TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ),
      image: Center(
        child: SizedBox(
          width: 400,
          height: 300,
          child: Lottie.asset(
            'assets/images/caranimation.json',
            fit: BoxFit.contain,
          ),
        ),
      ),
      decoration: const PageDecoration(
        pageColor: Colors.transparent,
        imagePadding: EdgeInsets.only(top: 40, bottom: 30),
        contentMargin: EdgeInsets.symmetric(horizontal: 24),
      ),
    );
  }
}
