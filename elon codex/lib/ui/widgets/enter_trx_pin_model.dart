import 'package:farms_gate_marketplace/repositoreis/wallet_repo.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_otp_input.dart';
import 'package:farms_gate_marketplace/utils/smsretriever_imp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_auth/smart_auth.dart';

class EnterTrxPinModel extends StatefulWidget {
  const EnterTrxPinModel({super.key});

  @override
  State<EnterTrxPinModel> createState() => _EnterTrxPinModelState();
}

class _EnterTrxPinModelState extends State<EnterTrxPinModel> {
  late final SmsRetriever smsRetriever;
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  final formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  final WalletRepo walletRepo = WalletRepo();

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);

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

    Future<void> widthrawFunds() async {
      FocusScope.of(context).unfocus();

      setState(() {
        buttonLoader = true;
      });

      try {
        await walletRepo.withdrawFunds(context, pinController.text);
      } catch (e) {
        // showCustomToast(context, '$e', '', ToastType.error);
      } finally {
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
      child: Container(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                          textAlign: TextAlign.center,
                          'Enter Transaction Pin',
                          style: Theme.of(context)
                              .copyWith()
                              .textTheme
                              .headlineMedium),
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text:
                                      'Kindly confirm transaction with OTP sent to your mail.',
                                  style: Theme.of(context)
                                      .copyWith()
                                      .textTheme
                                      .bodyLarge),
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
                        child: CustomButton(
                            buttonLoading: buttonLoader,
                            text: 'Continue',
                            onPressed:
                                buttonLoader || pinController.text.isEmpty
                                    ? null
                                    : widthrawFunds)),
                  ),
                  SizedBox(
                    height: screenHeight * 0.09,
                  ),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
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
              )),
        ),
      ),
    );
  }
}
