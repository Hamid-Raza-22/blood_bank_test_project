import 'package:blood_bank_test_project/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../../constant/colors.dart';
import '../../constant/size_helper.dart';
import '../../screens/signup_screen.dart';
import '../../widgets/custom_button.dart';

class FourthOnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const FourthOnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.blockWidth * 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          SizedBox(height: SizeConfig.blockHeight * 5),

          // ✅ Buttons
          CustomButton(
            text: "Sign Up",
            color: AppColors.primary,
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
          ),
          SizedBox(height: SizeConfig.blockHeight * 2),
          CustomButton(
            text: "Login",
            color: Colors.white,
            textColor: AppColors.primary,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
            },
          ),
        ],
      ),
    );
  }
}