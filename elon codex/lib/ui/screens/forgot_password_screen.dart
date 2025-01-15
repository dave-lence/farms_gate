// ignore_for_file: use_build_context_synchronously

import 'package:farms_gate_marketplace/providers/forgot_passwordProvider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/widgets/app_text_field.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  final TextEditingController emailController = TextEditingController();
  bool buttonLoader = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final forgotPassProvider = Provider.of<ForgotPasswordProvider>(context);

    void sendOtp() async {
      FocusScope.of(context).unfocus();
      FocusScope.of(context).requestFocus(FocusNode());
      if (formKey.currentState!.validate()) {
        setState(() {
          buttonLoader = true;
        });
        formKey.currentState!.save();

        final success =
            await forgotPassProvider.forgotPassword(formData, context);

        if (success) {
          Navigator.pushNamed(context, '/verification_screen', arguments: emailController.text);
        }

        setState(() {
          buttonLoader = false;
        });
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.17,
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
                  child: Text('Forgot Password ?',
                      style: Theme.of(context)
                          .copyWith()
                          .textTheme
                          .headlineMedium),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text('Please enter your email address',
                      style: Theme.of(context).copyWith().textTheme.bodyMedium),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  child: Form(
                    key: formKey,
                    child: AppTextField(
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: Colors.grey,
                        size: 20,
                      ),
                      showPrefixIcon: true,
                      obscureTextFormField: false,
                      labelText: 'Email Address',
                      hintText: 'taiwobolagi@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      onSaved: (value) => formData['email'] = value,
                    ),
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
                          buttonLoading: buttonLoader,
                          text: 'Send Verification code',
                          onPressed: buttonLoader ? null : sendOtp)),
                ),
                SizedBox(
                  height: screenHeight * 0.27,
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
