import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../constant/colors.dart';
import '../../constant/size_helper.dart';
import '../controller/splash_controller.dart';
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController()); // ✅ Initialize Controller
    SizeConfig().init(context);

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
                  FontAwesomeIcons.droplet, // 🩸 Blood drop icon
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
