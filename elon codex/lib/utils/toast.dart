// lib/custom_toast.dart
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

enum ToastType { success, error, warning, info }

void showCustomToast(
    BuildContext context, String message, String title, ToastType type, ) {
  Color backgroundColor;
  IconData icon;

  // Determine the background color and icon based on toast type
  switch (type) {
    case ToastType.success:
      backgroundColor = AppColors.primary;
      icon = Icons.check_circle;
      break;
    case ToastType.error:
      backgroundColor = Colors.red;
      icon = Icons.error;
      break;
    case ToastType.warning:
      backgroundColor = Colors.orange;
      icon = Icons.warning;
      break;
    case ToastType.info:
    default:
      backgroundColor = Colors.blue;
      icon = Icons.info;
      break;
  }

  // Show toast using the toastification package
  Toastification().show(
    alignment: Alignment.topCenter,
    borderRadius: BorderRadius.circular(2),
    showIcon: true,
    padding: const EdgeInsets.all(10),
    closeOnClick: true,
    autoCloseDuration: const Duration(seconds: 3),
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(
        opacity: animation,
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 10, left: 3, right: 3),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,fontWeight: FontWeight.w400, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    },
    showProgressBar: true,
    title: Text(title),
    dismissDirection: DismissDirection.horizontal,
    pauseOnHover: true,
    style: ToastificationStyle.simple,
    context: context,
    description: Text(message),
    backgroundColor: backgroundColor,
    icon: Icon(icon, color: Colors.white),
    animationDuration: const Duration(seconds: 1),
  );
}
