import 'package:flutter/material.dart';

class CustomCircularLoader extends StatelessWidget {
  final Color color;
  const CustomCircularLoader({super.key, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 30,
      width: 30,
      child: CircularProgressIndicator(
        strokeWidth: 1,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
