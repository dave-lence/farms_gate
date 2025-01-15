import 'package:farms_gate_marketplace/ui/screens/sign_up_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Center(
            child: SizedBox(
              height: 442,
              width: 375,
              child: Image.asset('assets/landing_img.png'),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 292,
            child: Center(
              child: Text(
                'Bringing the farm closer to you',
                textAlign: TextAlign.center,
                style:TextStyle(
          fontStyle: GoogleFonts.plusJakartaSans().fontStyle,
          fontSize: 32,
          letterSpacing: -1,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF248D0E)),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 320,
            child: Center(
              child: Text(
                'Fresh, quality produce from sellers you trust. Welcome to Farmsgate!',
                textAlign: TextAlign.center,
                style: Theme.of(context).copyWith().textTheme.bodyLarge,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
          ),
          Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: 49,
                  child: CustomButton(
                    text: 'Get Started',
                    onPressed: () {
                       PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const SignUpScreen(),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                        customPageRoute: PageRouteBuilder(
                          // settings:
                          //     const RouteSettings(name: '/bottom_nav_bar'),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SignUpScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            final tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            final offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                     
                    },
                  )))
        ],
      ),
    );
  }
}
