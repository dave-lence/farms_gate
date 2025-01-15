import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class CustomOtpInput extends StatelessWidget {
  const CustomOtpInput({
    super.key,
    required this.smsRetriever,
    required this.pinController,
    required this.focusNode,
    required this.defaultPinTheme,
    required this.focusedBorderColor,
  });

  final SmsRetriever smsRetriever;
  final TextEditingController pinController;
  final FocusNode focusNode;
  final PinTheme defaultPinTheme;
  final Color focusedBorderColor;

  @override
  Widget build(BuildContext context) {
    return Pinput(
      smsRetriever: smsRetriever,
      controller: pinController,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (index) => const SizedBox(width: 8),
      // validator: (value) {
      
      // },
      
      keyboardAppearance: Brightness.light,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      onCompleted: (pin) {
        debugPrint('onCompleted: $pin');
      },
      onChanged: (value) {
        debugPrint('onChanged: $value');
      },
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 1,
            height: 30,
            color: focusedBorderColor,
          ),
        ],
      ),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: const Border(
              bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          )),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyBorderWith(
        border: const Border(
            bottom: BorderSide(
          color: Colors.red,
          width: 1,
        )),
      ),
    );
  }
}
