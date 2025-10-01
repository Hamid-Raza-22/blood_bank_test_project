// 🔘 Custom Button (Responsive) → ✅ UPDATED
import 'package:flutter/material.dart';

import '../constant/colors.dart';
import '../constant/size_helper.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.primary,
    this.textColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.blockHeight * 6, // ✅ responsive height
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: SizeConfig.blockWidth * 4, // ✅ responsive font
          ),
        ),
      ),
    );
  }
}
