import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';
import '../onboarding/onboarding_screens/onboarding_screen1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // 🔹 Dark Red Background
      body: Center(
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: SizeConfig.blockWidth * 10, // Responsive font size
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
            children: [
              const TextSpan(text: "D"),
              const TextSpan(text: "O"),

              const TextSpan(text: "N"),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,

                child: Icon(
                  Icons.bloodtype, // Blood drop icon
                  color: Colors.red,
                  size: SizeConfig.blockWidth * 10,
                ),
              ),
              const TextSpan(text: "R"),
            ],
          ),
        ),
      ),
    );
  }
}
