import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SuccessfulSignupScreen extends StatefulWidget {
  const SuccessfulSignupScreen({super.key});

  @override
  State<SuccessfulSignupScreen> createState() => _SuccessfulSignupScreenState();
}

class _SuccessfulSignupScreenState extends State<SuccessfulSignupScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
              ),
              Center(
                  child: Image.asset(
                'assets/success_signup.png',
                width: 220,
                height: 280,
              )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              SizedBox(
                width: 292,
                child: Center(
                  child: Text(
                    'Congratulations',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
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
                    child: CustomButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signin_screen');
                      },
                      text: 'Start Shopping!',
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
