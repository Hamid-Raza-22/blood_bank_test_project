// lib/screens/auth/reset_password_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/colors.dart';
import '../../constant/size_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/top_header.dart';
import '../../controller/auth_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final newPassword = TextEditingController();
    final AuthController controller = Get.find();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomHeader(title: "Reset Password", showBack: true),
            SizedBox(height: SizeConfig.blockHeight * 3),
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text("Enter your new password",
                          style: TextStyle(
                              fontSize: SizeConfig.blockWidth * 5,
                              fontWeight: FontWeight.bold))),
                  CustomTextField(
                    label: "New Password",
                    hint: "********",
                    controller: newPassword,
                    obscureText: true,
                    suffixIcon: const Icon(Icons.visibility_off,
                        color: AppColors.primary),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 3),
                  CustomButton(
                      text: "Reset Password",
                      onPressed: () {
                        controller.resetPassword(newPassword.text.trim());
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
