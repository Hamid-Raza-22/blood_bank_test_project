import 'package:blood_bank_test_project/widgets/custom_otp_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/size_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/top_header.dart';
import '../controller/auth_controller.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final otpController = TextEditingController();

    SizeConfig().init(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomHeader(title: "Verify OTP", showBack: true),
            SizedBox(height: SizeConfig.blockHeight * 5),

            Padding(
              padding: EdgeInsets.all(SizeConfig.blockWidth * 5),
              child: Column(
                children: [
                  Text(
                    "Enter the 6-digit OTP sent to your email",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: SizeConfig.blockWidth * 4,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 3),
                 CustomOtpField(onCompleted: (otp) {
                    controller.verifyOtp(otp, "");
                  },
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 4),
                  Obx(() => CustomButton(
                    text: controller.isLoading.value
                        ? "Verifying..."
                        : "Verify OTP",
                    onPressed: () {
                      controller.verifyOtp(otpController.text.trim(), "");
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
