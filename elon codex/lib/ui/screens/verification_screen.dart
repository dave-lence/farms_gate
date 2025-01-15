import 'package:farms_gate_marketplace/providers/forgot_passwordProvider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_otp_input.dart';
import 'package:farms_gate_marketplace/utils/smsretriever_imp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_auth/smart_auth.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late final SmsRetriever smsRetriever;
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  final formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  String userId = '';
  bool textLoading = false;
  bool buttonLoader = false;

  void getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    // formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
    getUserId();

    /// In case you need an SMS autofill feature
    smsRetriever = SmsRetrieverImpl(
      SmartAuth(),
    );
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String?;
    String maskEmail(String email) {
      int atIndex = email.indexOf('@');
      String localPart = email.substring(0, atIndex);
      String domainPart = email.substring(atIndex);
      if (localPart.length > 4) {
        String maskedLocalPart =
            '${localPart.substring(0, 2)}****${localPart.substring(localPart.length - 2)}';
        return '$maskedLocalPart$domainPart';
      } else {
        return email;
      }
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    final forgotPassProvider = Provider.of<ForgotPasswordProvider>(context);

    void verifyOtp() async {
      getUserId();
      FocusScope.of(context).unfocus();
      FocusScope.of(context).requestFocus(FocusNode());

      setState(() {
        buttonLoader = true;
      });

      final data = {
        'code': int.parse(pinController.text),
        "userId": userId.toString()
      };

      final success = await forgotPassProvider.verifyOtp(data, context);

      if (success) {
        Navigator.pushNamed(context, '/reset_password_screen');
      }

      setState(() {
        buttonLoader = false;
      });
    }

    void resendOtp() async {
      getUserId();
      FocusScope.of(context).unfocus();
      FocusScope.of(context).requestFocus(FocusNode());

      setState(() {
        textLoading = true;
      });

      final data = {"email": email};

      final success = await forgotPassProvider.resendOtp(data, context);

      if (success) {
        setState(() {
          textLoading = false;
        });
        // Navigator.pushNamed(context, '/reset_password_screen');
      }

      setState(() {
        textLoading = false;
      });
    }

    // ignore: prefer_const_constructors
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 30,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: Colors.grey,
          width: 1,
        )),
      ),
    );

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
                Center(
                    child: Column(
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
                      height: 20,
                     ),
                    Text(
                        textAlign: TextAlign.center,
                        'Enter Verification Code',
                        style: Theme.of(context)
                            .copyWith()
                            .textTheme
                            .headlineMedium),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'We’ve sent a code to ',
                            style: Theme.of(context)
                                .copyWith()
                                .textTheme
                                .bodyLarge),
                        TextSpan(
                            text: '${maskEmail(email.toString())}.',
                            style: Theme.of(context)
                                .copyWith()
                                .textTheme
                                .labelLarge),
                      ])),
                    ),
                  ],
                )),
                const SizedBox(
                  height: 70,
                ),
                Center(
                  child: CustomOtpInput(
                      smsRetriever: smsRetriever,
                      pinController: pinController,
                      focusNode: focusNode,
                      defaultPinTheme: defaultPinTheme,
                      focusedBorderColor: focusedBorderColor),
                ),
                const SizedBox(
                  height: 50,
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
                          text: 'Verify Account',
                          onPressed: buttonLoader ? null : verifyOtp)),
                ),
                const SizedBox(
                  height: 60,
                ),
                Center(
                  child: Text(
                      textAlign: TextAlign.center,
                      'Experiencing issues recieving the code',
                      style: Theme.of(context).copyWith().textTheme.bodyLarge),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: resendOtp,
                  child: Center(
                      child: Column(
                    children: [
                      Text(
                        'Resend Code',
                        style: GoogleFonts.plusJakartaSans(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                            decorationThickness: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (textLoading)
                        const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 1,
                          ),
                        )
                    ],
                  )),
                ),
                SizedBox(
                  height: screenHeight * 0.10,
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
