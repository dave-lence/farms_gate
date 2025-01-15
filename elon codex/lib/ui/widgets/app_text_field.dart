// ignore_for_file: avoid_print, must_be_immutable, unnecessary_null_comparison

import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FormFieldSetter<String>? onSaved;
  final Function(String)? onTextChange;
  final inputFormatters;
  Widget prefixWidget;
  Widget suffixWidget;
  Icon prefixIcon;
  Icon suffixIcon;
  bool obscureText;
  bool showPrefixIcon;
  bool showsuffixIcon;
  bool obscureTextFormField;
  bool compulsoryField;
  bool phoneNumber;
  String initialNumber;
  String initialCod;
  bool isAppBar;
  bool enabled;

  AppTextField(
      {super.key,
      this.phoneNumber = false,
      required this.labelText,
      this.isAppBar = false,
      required this.hintText,
      required this.controller,
      this.compulsoryField = false,
      this.initialNumber = '',
      this.inputFormatters,
      this.initialCod = '',
      this.showPrefixIcon = false,
      this.obscureTextFormField = false,
      this.prefixWidget = const SizedBox(),
      this.suffixWidget = const SizedBox(),
      this.prefixIcon = const Icon(
        Icons.abc,
        color: Colors.white,
      ),
      this.suffixIcon = const Icon(
        Icons.abc,
        color: Colors.white,
      ),
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.showsuffixIcon = false,
      this.enabled = true,
      this.onTextChange,
      this.onSaved});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  String phoneNumber = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              text: widget.labelText,
              style: Theme.of(context).copyWith().textTheme.bodyLarge,
              children: [
                widget.compulsoryField == true
                    ? const TextSpan(
                        text: ' *',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                            fontSize: 14))
                    : const TextSpan(
                        text: ' ',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                            fontSize: 14))
              ]),
        ),
        const SizedBox(height: 2),
        SizedBox(
          height: 40,
          child: TextFormField(
           inputFormatters: widget.inputFormatters,
            onSaved: widget.onSaved,
            enabled: widget.enabled, 
            style: GoogleFonts.figtree(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xff101828)),
            cursorColor: AppColors.primary,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            onChanged: widget.onTextChange,
            decoration: InputDecoration(
              enabledBorder: widget.isAppBar
                  ? OutlineInputBorder(borderRadius: BorderRadius.circular(8))
                  : null,
              focusedBorder: widget.isAppBar
                  ? OutlineInputBorder(borderRadius: BorderRadius.circular(8))
                  : null,
              fillColor: Colors.white,
              filled: true,
              
              suffix: widget.suffixWidget,
              prefixIcon:
                  //  widget.prefixWidget != null
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(left: 8.0),
                  //         child: widget.prefixWidget,
                  //       ) :
                  widget.showPrefixIcon ? widget.prefixIcon : null,
              prefix: widget.prefixWidget,
              suffixIcon: widget.obscureTextFormField
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                      icon: Icon(
                        widget.obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                        size: 16,
                      ))
                  : widget.suffixIcon,
              hintText: widget.hintText,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
