import 'package:flutter/material.dart';

import '../constant/colors.dart';
import '../constant/size_helper.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/top_header.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            // ✅ Reusable Header
            const CustomHeader(title: "Sign Up",showBack: true,),

            SizedBox(height: SizeConfig.blockHeight * 3),


            // Form
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Create your account",
                      style: TextStyle(
                        fontSize: SizeConfig.blockWidth * 5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 0.5),
                  const Center(
                    child: Text(
                      "Register now to create a new account",
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 3),

                  const CustomTextField(
                    label: "Name",
                    hint: "ex: omer shrief",
                  ),
                  const CustomTextField(
                    label: "Email",
                    hint: "example@gmail.com",
                  ),
                  CustomTextField(
                    label: "Password",
                    hint: "********",
                    obscureText: true,
                    suffixIcon: Icon(Icons.visibility_off,
                        color: AppColors.primary),
                  ),
                  CustomTextField(
                    label: "Confirm Password",
                    hint: "********",
                    obscureText: true,
                    suffixIcon: Icon(Icons.visibility_off,
                        color: AppColors.primary),
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 1.5),

                  CustomButton(
                    text: "Sign Up",
                    onPressed: () {},
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 3),

                  // Google button
                  CustomButton(
                    text: "Sign in with Google",
                    onPressed: () {},
                    color: AppColors.white,
                    textColor: Colors.black,
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 3),

                  // Navigation to Sign In
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignInScreen()),
                          );
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}