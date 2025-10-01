import 'package:blood_bank_test_project/widgets/top_header.dart';
import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Reusable Header
            CustomHeader(title: "Reset Password",showBack: true,),

            SizedBox(height: SizeConfig.blockHeight * 3),

            // Form Section
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Enter your new password",
                      style: TextStyle(
                        fontSize: SizeConfig.blockWidth * 5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 0.5),
                  const Center(
                    child: Text(
                      "Please set a strong password to secure your account",
                      style: TextStyle(color: AppColors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 3),

                  // New Password
                  CustomTextField(
                    label: "New Password",
                    hint: "********",
                    obscureText: true,
                    suffixIcon:
                    const Icon(Icons.visibility_off, color: AppColors.primary),
                  ),

                  // Confirm Password
                  CustomTextField(
                    label: "Confirm Password",
                    hint: "********",
                    obscureText: true,
                    suffixIcon:
                    const Icon(Icons.visibility_off, color: AppColors.primary),
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 3),

                  // Reset Button
                  CustomButton(
                    text: "Reset Password",
                    onPressed: () {
                      // Reset logic here
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
