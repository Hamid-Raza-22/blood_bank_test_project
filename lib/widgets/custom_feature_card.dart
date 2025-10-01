import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';

class CustomFeatureCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const CustomFeatureCard({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockHeight * 2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: SizeConfig.blockWidth * 8, color: AppColors.primary),
                SizedBox(height: SizeConfig.blockHeight * 1),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: SizeConfig.blockWidth * 3.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
