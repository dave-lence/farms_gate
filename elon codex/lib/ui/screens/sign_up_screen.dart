// ignore_for_file: use_build_context_synchronously

import 'package:farms_gate_marketplace/providers/register_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/successful_signup_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/app_text_field.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool buttonLoading = false;
  final formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String countryCode = '+234';
 
  String formatPhoneNumber(String? input) {
    if (input == null || input.isEmpty) return '';

    String phoneNumber = input.trim();
    if (phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.substring(1);
    }

    return '$countryCode$phoneNumber';
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final registerProvider = Provider.of<RegisterProvider>(context);

    void signUpUser() async {
      FocusScope.of(context).unfocus();

      if (formKey.currentState!.validate()) {
        setState(() {
          buttonLoading = true;
        });
        formKey.currentState!.save();

        final success = await registerProvider.registerUser(formData, context);

        if (success) {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: const SuccessfulSignupScreen(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.fade,
            customPageRoute: PageRouteBuilder(
              // settings: const RouteSettings(name: '/bottom_nav_bar'),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const SuccessfulSignupScreen(),
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
        }
      }

      setState(() {
        buttonLoading = false;
      });
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.08,
                ),
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 40,
                    height: 43.2,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text('Create your account ',
                      style:
                          Theme.of(context).copyWith().textTheme.headlineLarge),
                ),
                const SizedBox(
                  height: 25,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        prefixIcon: const Icon(
                          Icons.person_4,
                          color: Colors.grey,
                          size: 20,
                        ),
                        showPrefixIcon: true,
                        obscureTextFormField: false,
                        labelText: 'First Name',
                        hintText: 'Taiwo',
                        keyboardType: TextInputType.emailAddress,
                        controller: firstNameController,
                        onSaved: (value) => formData['firstName'] = value,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextField(
                        prefixIcon: const Icon(
                          Icons.person_4,
                          color: Colors.grey,
                          size: 20,
                        ),
                        showPrefixIcon: true,
                        obscureTextFormField: false,
                        labelText: 'Last Name',
                        hintText: 'Bolagi',
                        keyboardType: TextInputType.emailAddress,
                        controller: lastNameController,
                        onSaved: (value) => formData['lastName'] = value,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextField(
                        prefixIcon: const Icon(
                          Icons.mail,
                          color: Colors.grey,
                          size: 20,
                        ),
                        showPrefixIcon: true,
                        obscureTextFormField: false,
                        labelText: 'Email Address',
                        hintText: 'taiwo@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        onSaved: (value) => formData['email'] = value,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextField(
                        keyboardType: TextInputType.number,
                        labelText: 'Phone Number',
                        hintText: '080 142 386',
                        obscureText: false,
                        showPrefixIcon: true,
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.grey,
                          size: 16,
                        ),
                        obscureTextFormField: false,
                        controller: phoneController,
                        onSaved: (value) {
                          String formattedNumber = formatPhoneNumber(value);
                          formData['phoneNumber'] = formattedNumber;
                        },

                        // onSaved: (value) => formData['phoneNumber'] = value,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextField(
                        showPrefixIcon: true,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.grey,
                          size: 16,
                        ),
                        labelText: 'Password',
                        hintText: 'Enter Your Password',
                        obscureText: true,
                        obscureTextFormField: true,
                        controller: passwordController,
                        onSaved: (value) => formData['password'] = value,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextField(
                        showPrefixIcon: true,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.grey,
                          size: 16,
                        ),
                        labelText: 'Confirm Password',
                        hintText: 'Confirm Your Password',
                        obscureText: true,
                        obscureTextFormField: true,
                        controller: confirmPasswordController,
                        onSaved: (value) => formData['confirmPassword'] = value,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: SizedBox(
                      width: screenWidth,
                      height: 46,
                      child: CustomButton(
                          buttonLoading: buttonLoading,
                          text: 'Sign Up',
                          onPressed: buttonLoading ? null : signUpUser)),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signin_screen');
                  },
                  child: Center(
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Already have an account?',
                          style: Theme.of(context)
                              .copyWith()
                              .textTheme
                              .labelLarge),
                      TextSpan(
                        text: ' Log In ',
                        style: TextStyle(
                            fontStyle: GoogleFonts.plusJakartaSans().fontStyle,
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500),
                      )
                    ])),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'By creating an account , you agree to our ',
                        style: Theme.of(context).copyWith().textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Text(
                        'Terms and Conditions',
                        style: TextStyle(
                            fontStyle: GoogleFonts.plusJakartaSans().fontStyle,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                            decorationThickness: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
