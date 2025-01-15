import 'package:farms_gate_marketplace/providers/forgot_passwordProvider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/widgets/app_text_field.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool buttonLoader = false;
  String userId = '';

  void getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
    print(userId);
  }

  @override
  void initState() {
    getUserId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final forgotPassProvider = Provider.of<ForgotPasswordProvider>(context);

    void resetPassword() async {
      getUserId();
      FocusScope.of(context).unfocus();
      FocusScope.of(context).requestFocus(FocusNode());

      setState(() {
        buttonLoader = true;
      });

      final data = {
        "password": passwordController.text,
        "confirmPassword": confirmPasswordController.text,
        "userId": userId.toString()
      };

      final success = await forgotPassProvider.resetPassword(data, context);

      if (success) {
        Navigator.pushNamed(context, '/signin_screen');
      }

      setState(() {
        buttonLoader = false;
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
                  height: MediaQuery.of(context).size.height * 0.17,
                ),
                Center(
                    child: Icon(
                  Icons.lock_outline,
                  color: Colors.grey.shade200,
                  size: 52,
                )),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text('Create New Password',
                      style: Theme.of(context)
                          .copyWith()
                          .textTheme
                          .headlineMedium),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text('Choose a new password for your account.',
                      style: Theme.of(context).copyWith().textTheme.bodyMedium),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  child: AppTextField(
                      showPrefixIcon: true,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey.shade400,
                      ),
                      obscureText: true,
                      obscureTextFormField: true,
                      labelText: 'Password',
                      hintText: 'Enter Your New Password',
                      keyboardType: TextInputType.emailAddress,
                      controller: passwordController),
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextField(
                    showPrefixIcon: true,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey.shade400,
                    ),
                    labelText: 'Confirm Password',
                    hintText: 'Confirm Your Password',
                    obscureText: true,
                    obscureTextFormField: true,
                    controller: confirmPasswordController),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: SizedBox(
                      width: screenWidth,
                      height: 46,
                      child: CustomButton(
                          buttonLoading: buttonLoader,
                          text: 'Reset Password',
                          onPressed: buttonLoader ? null : resetPassword)),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.10,
                ),
                Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Go Back',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
