import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../viewmodel/splash_viewmodel.dart';

/// Splash View - Pure UI, no business logic
/// Shows app logo and loading state while checking auth
class SplashView extends GetView<SplashViewModel> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                _buildLogo(),
                const SizedBox(height: 24),
                _buildAppName(),
                const Spacer(),
                _buildLoadingIndicator(),
                const SizedBox(height: 16),
                _buildStatusMessage(),
                const Spacer(),
                _buildFooter(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.bloodtype,
        size: 60,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildAppName() {
    return const Column(
      children: [
        Text(
          'Blood Bank',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Donate Blood, Save Lives',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Obx(() => controller.isLoading
        ? const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          )
        : const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 40,
          ));
  }

  Widget _buildStatusMessage() {
    return Obx(() => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            controller.statusMessage,
            key: ValueKey(controller.statusMessage),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ));
  }

  Widget _buildFooter() {
    return const Column(
      children: [
        Text(
          'Version 1.0.0',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}
