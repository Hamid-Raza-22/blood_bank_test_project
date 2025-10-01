import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/top_header.dart';
import 'email_verification_screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Reusable Header
            const CustomHeader(title: "Forgot Password",showBack: true,),

            SizedBox(height: SizeConfig.blockHeight * 3),

            // Form Section
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Reset your password",
                      style: TextStyle(
                        fontSize: SizeConfig.blockWidth * 5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 0.5),
                  const Center(
                    child: Text(
                      "Enter your email to receive reset instructions",
                      style: TextStyle(color: AppColors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 3),

                  const CustomTextField(
                    label: "Email",
                    hint: "example@gmail.com",
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 2),

                  CustomButton(
                    text: "Send Code",
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>VerificationScreen()));
                    },
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 3),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Back to Sign In",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
