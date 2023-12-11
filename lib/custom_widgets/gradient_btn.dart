import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnText;
  final Color btnTextColor;
  final List<Color> gradientColors;

  const GradientButton({
    required this.onPressed,
    required this.btnText,
    required this.btnTextColor,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(btnText, style: TextStyle(color: btnTextColor)),
        ),
      ),
    );
  }
}
