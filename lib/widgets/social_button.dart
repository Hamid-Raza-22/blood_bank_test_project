import 'package:flutter/material.dart';

import '../constant/colors.dart';

class SocialButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.assetPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 55,
        height: 55,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Image.asset(assetPath),
      ),
    );
  }
}
