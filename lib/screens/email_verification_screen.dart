import 'package:blood_bank_test_project/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_otp_field.dart';
import '../widgets/top_header.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomHeader(title: "Verification",showBack: true,),

            SizedBox(height: SizeConfig.blockHeight * 3),

            Padding(
              padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
              child: Column(
                children: [
                  Text(
                    "Enter the 6-digit code sent to your email",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.blockWidth * 4.5,
                      color: AppColors.grey,
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 3),

                  // ✅ Reusable OTP Field
                  CustomOtpField(
                    length: 6,
                    onCompleted: (otp) {
                      debugPrint("Entered OTP: $otp");
                    },
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 4),

                  CustomButton(
                    text: "Verify",
                    onPressed: () {
                      // Handle OTP Verification

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPasswordScreen()));
                    },
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 2),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Didn’t receive code? "),
                      GestureDetector(
                        onTap: () {
                          // Handle resend
                        },
                        child: const Text(
                          "Resend",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
