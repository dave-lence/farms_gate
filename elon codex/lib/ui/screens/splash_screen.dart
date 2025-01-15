import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: 3000,
        splash: Image.asset('assets/market_place_logo.png', width: 200, height: 100,),
        nextScreen: const LandingScreen(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: const Color(0xFF052F00));
  }
}
