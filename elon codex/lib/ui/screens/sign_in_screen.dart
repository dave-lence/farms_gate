// ignore_for_file: use_build_context_synchronously

import 'package:farms_gate_marketplace/providers/login_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/forgot_password_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/app_text_field.dart';
import 'package:farms_gate_marketplace/ui/widgets/bottom_nav_bar.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool buttonLoader = false;

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final loginProvider = Provider.of<LoginProvider>(context);

    void loginUser() async {
      FocusScope.of(context).unfocus();
      FocusScope.of(context).requestFocus(FocusNode());
      if (formKey.currentState!.validate()) {
        setState(() {
          buttonLoader = true;
        });
        formKey.currentState!.save();
        
        final success = await loginProvider.loginUser(formData, context);


        if (success) {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: const BottomNavBar(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.fade,
            customPageRoute: PageRouteBuilder(
              settings: const RouteSettings(name: '/bottom_nav_bar'),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const BottomNavBar(),
              // transitionsBuilder:
              //     (context, animation, secondaryAnimation, child) {
              //   const begin = Offset(1.0, 0.0);
              //   const end = Offset.zero;
              //   const curve = Curves.ease;

              //   final tween = Tween(begin: begin, end: end)
              //       .chain(CurveTween(curve: curve));
              //   final offsetAnimation = animation.drive(tween);

              //   return SlideTransition(
              //     position: offsetAnimation,
              //     child: child,
              //   );
              // },
            ),
          );
        }else{
          setState(() {
            buttonLoader = false;
          });
        }
      }

      setState(() {
        buttonLoader = false;
      });
    }

    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight * 0.10,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 40,
                      height: 43.2,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Text('Hello again!',
                        style: Theme.of(context)
                            .copyWith()
                            .textTheme
                            .headlineLarge),
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: SizedBox(
                        width: screenWidth,
                        height: 46,
                        child: CustomButton(
                            text: 'Login',
                            buttonLoading: buttonLoader,
                            onPressed: buttonLoader ? null : loginUser)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()));
                    },
                    child: Center(
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Forgot Password?',
                            style: Theme.of(context)
                                .copyWith()
                                .textTheme
                                .labelLarge),
                        TextSpan(
                          text: '  Reset It',
                          style: TextStyle(
                              fontStyle:
                                  GoogleFonts.plusJakartaSans().fontStyle,
                              fontSize: 16,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500),
                        )
                      ])),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'OR',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 1, 46)),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/google.png',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            'with Google',
                            style: Theme.of(context)
                                .copyWith()
                                .textTheme
                                .labelLarge,
                          )
                        ],
                      )),
                  SizedBox(
                    height: screenHeight * 0.06,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup_screen');
                    },
                    child: Center(
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Don’t have an account?',
                            style: Theme.of(context)
                                .copyWith()
                                .textTheme
                                .labelLarge),
                        TextSpan(
                          text: ' Register ',
                          style: TextStyle(
                              fontStyle:
                                  GoogleFonts.plusJakartaSans().fontStyle,
                              fontSize: 16,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500),
                        )
                      ])),
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
}
