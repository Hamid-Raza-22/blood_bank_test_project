
import 'package:flutter/material.dart';

import '../constant/colors.dart';
import '../constant/size_helper.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final IconData? icon;
  final TextEditingController? controller;


  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.controller, this.prefixIcon, this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.blockWidth * 4, // ✅ responsive font
          ),
        ),
        SizedBox(height: SizeConfig.blockHeight * 0.8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: SizeConfig.blockWidth * 3.5, // ✅ responsive hint
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            contentPadding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockWidth * 3,
              vertical: SizeConfig.blockHeight * 1.8,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        SizedBox(height: SizeConfig.blockHeight * 2),
      ],
    );
  }
}
