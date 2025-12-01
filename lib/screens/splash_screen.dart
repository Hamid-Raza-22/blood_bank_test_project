import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../constant/size_helper.dart';
import '../presentation/features/splash/viewmodel/splash_viewmodel.dart';

/// Splash Screen - Entry point that checks auth state and navigates accordingly
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get ViewModel from binding
    final viewModel = Get.find<SplashViewModel>();
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: SizeConfig.blockWidth * 10,
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
                      FontAwesomeIcons.droplet,
                      color: Colors.red,
                      size: SizeConfig.blockWidth * 10,
                    ),
                  ),
                  const TextSpan(text: "R"),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Loading indicator
            Obx(() => viewModel.isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : const SizedBox.shrink()),
            
            const SizedBox(height: 20),
            
            // Status message
            Obx(() => Text(
                  viewModel.statusMessage,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
