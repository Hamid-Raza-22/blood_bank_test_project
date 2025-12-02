import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text_field.dart';
import '../viewmodel/auth_viewmodel.dart';

/// Forgot Password View - Pure UI, no business logic
/// All logic is handled by AuthViewModel
class ForgotPasswordView extends GetView<AuthViewModel> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          title: const Text('Forgot Password'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildIcon(),
              const SizedBox(height: 32),
              _buildTitle(),
              const SizedBox(height: 16),
              _buildDescription(),
              const SizedBox(height: 32),
              _buildEmailField(),
              const SizedBox(height: 24),
              _buildSendButton(),
              const SizedBox(height: 16),
              _buildBackToLogin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.lock_reset,
          size: 50,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Center(
      child: Text(
        'Reset Your Password',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return const Center(
      child: Text(
        'Enter your email address and we\'ll send you a link to reset your password.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return AppTextField(
      controller: controller.emailController,
      labelText: 'Email',
      hintText: 'Enter your email',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined),
    );
  }

  Widget _buildSendButton() {
    return Obx(() => AppButton(
          text: controller.isLoading ? 'Sending...' : 'Send Reset Link',
          onPressed:
              controller.isLoading ? null : controller.sendPasswordResetEmail,
          isLoading: controller.isLoading,
        ));
  }

  Widget _buildBackToLogin() {
    return Center(
      child: TextButton(
        onPressed: () => Get.back(),
        child: const Text(
          'Back to Login',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
