import 'package:flutter/material.dart';

import '../../constant/colors.dart';
import '../../constant/size_helper.dart';

class CustomOnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final bool showSkip;
  final VoidCallback? onSkip;

  const CustomOnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.showSkip = false,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.blockWidth * 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showSkip)
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: onSkip,
                child: const Text(
                  "Skip",
                  style: TextStyle(color: AppColors.primary, fontSize: 14),
                ),
              ),
            ),
          SizedBox(height: SizeConfig.blockHeight * 3),
          Image.asset(image, height: SizeConfig.blockHeight * 35),
          SizedBox(height: SizeConfig.blockHeight * 4),
          Text(
            title,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.blockHeight * 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
