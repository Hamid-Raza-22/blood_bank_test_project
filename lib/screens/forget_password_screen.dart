// lib/screens/auth/forget_password_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/colors.dart';
import '../../constant/size_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/top_header.dart';
import '../../controller/auth_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final emailController = TextEditingController();
    final AuthController controller = Get.find();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomHeader(title: "Forgot Password", showBack: true),
            SizedBox(height: SizeConfig.blockHeight * 3),
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text("Reset your password",
                          style: TextStyle(
                              fontSize: SizeConfig.blockWidth * 5,
                              fontWeight: FontWeight.bold))),
                  const Center(
                    child: Text(
                        "Enter your email to receive reset instructions",
                        style: TextStyle(color: AppColors.grey)),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 3),
                  CustomTextField(
                      label: "Email",
                      hint: "example@gmail.com",
                      controller: emailController),
                  SizedBox(height: SizeConfig.blockHeight * 2),
                  CustomButton(
                    text: "Send Code",
                    onPressed: () {
                      controller.sendResetOtp(emailController.text.trim());
                      // If you want to show verification UI, navigate accordingly
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
