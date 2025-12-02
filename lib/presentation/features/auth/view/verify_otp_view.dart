import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../common/widgets/app_button.dart';
import '../viewmodel/auth_viewmodel.dart';

/// OTP Verification View - Pure UI, no business logic
/// All logic is handled by AuthViewModel
class VerifyOtpView extends GetView<AuthViewModel> {
  const VerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          title: const Text('Verify OTP'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              _buildIcon(),
              const SizedBox(height: 32),
              _buildTitle(),
              const SizedBox(height: 16),
              _buildDescription(),
              const SizedBox(height: 32),
              _buildOtpFields(),
              const SizedBox(height: 24),
              _buildVerifyButton(),
              const SizedBox(height: 16),
              _buildResendLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.verified_user,
        size: 50,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Enter Verification Code',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription() {
    return Obx(() => Text(
          'We sent a verification code to\n${controller.emailController.text}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ));
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        6,
        (index) => SizedBox(
          width: 45,
          child: TextField(
            controller: controller.otpControllers[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              if (value.length == 1 && index < 5) {
                FocusScope.of(Get.context!).nextFocus();
              }
              if (value.isEmpty && index > 0) {
                FocusScope.of(Get.context!).previousFocus();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Obx(() => AppButton(
          text: controller.isLoading ? 'Verifying...' : 'Verify',
          onPressed: controller.isLoading ? null : controller.verifyOtp,
          isLoading: controller.isLoading,
        ));
  }

  Widget _buildResendLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Didn't receive code? "),
        GestureDetector(
          onTap: controller.resendOtp,
          child: const Text(
            'Resend',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
