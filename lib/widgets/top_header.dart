import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final bool showBack; // 🔹 Optional back button

  const CustomHeader({
    super.key,
    required this.title,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockHeight * 22,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(200, 80),
          bottomRight: Radius.elliptical(200, 80),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Title in Center
          Text(
            title,
            style: TextStyle(
              color: AppColors.white,
              fontSize: SizeConfig.blockWidth * 7,
              fontWeight: FontWeight.bold,
            ),
          ),

          // 🔹 Back Button (if enabled)
          if (showBack)
            Positioned(
              top: SizeConfig.blockHeight * 5,
              left: SizeConfig.blockWidth * 3,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
        ],
      ),
    );
  }
}
