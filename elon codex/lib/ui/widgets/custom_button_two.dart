import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonTwo extends StatelessWidget {
  final String text;
  final Widget? container;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final bool isWidget;
  final bool buttonLoading;
  final bool outlined;
  final bool deleteBtn;

  const CustomButtonTwo({
    super.key,
    this.deleteBtn = false,
    this.text = '',
    required this.onPressed,
    this.isDisabled = false,
    this.isWidget = false,
    this.container,
    this.buttonLoading = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.042,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: outlined
            ? ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                elevation: 0,
                disabledBackgroundColor: Colors.green.shade200,
                enableFeedback: true,
                backgroundColor: Colors.white,
                textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                shape: RoundedRectangleBorder(
                  side:  BorderSide(
                    color: deleteBtn? Colors.red : Colors.grey.shade400,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              )
            : Theme.of(context).elevatedButtonTheme.style,
        child: buttonLoading
            ? const CustomCircularLoader()
            : isWidget
                ? Container(
                    child: container,
                  )
                : Text(
                    text,
                    style: outlined
                        ? GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: deleteBtn ? Colors.red : Colors.black)
                        : Theme.of(context).copyWith().textTheme.titleMedium,
                  ),
      ),
    );
  }
}
