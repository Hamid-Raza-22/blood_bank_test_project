import 'package:blood_bank_test_project/screens/signup_screen.dart';
import 'package:blood_bank_test_project/widgets/custom_divider.dart';
import 'package:flutter/material.dart';

import '../constant/colors.dart';
import '../constant/size_helper.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_button.dart';
import '../widgets/top_header.dart';
import 'forget_password_screen.dart';
import 'option_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔴 Top Header
            // ✅ Reusable Header
            const CustomHeader(title: "Log In",showBack: true,),

            SizedBox(height: SizeConfig.blockHeight * 3),

            // 📝 Form Fields
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: SizeConfig.blockWidth * 5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 0.5),
                  const Center(
                    child: Text(
                      "Let's login for explore continues" ,
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 3),

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

                  SizedBox(height: SizeConfig.blockHeight * 1.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember Me
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            activeColor: AppColors.primary,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value ?? false;
                              });
                            },
                          ),
                          Text(
                            "Remember Me",
                            style: TextStyle(
                              fontSize: SizeConfig.blockWidth * 3.5,
                            ),
                          ),
                        ],
                      ),

                      // Forgot Password
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const ForgetPasswordScreen()),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: SizeConfig.blockWidth * 3.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  CustomButton(
                    text: "Sign In",
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>OptionScreen()));
                    },
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 4),

                  // --- OR Divider ---
                 CustomDivider(text: "or"),

                  SizedBox(height: SizeConfig.blockHeight * 3),

                  // 🌐 Social Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialButton(
                        assetPath: "assets/images/google.png",
                        onPressed: () {},
                      ),
                      SocialButton(
                        assetPath: "assets/images/facebook.png",
                        onPressed: () {},
                      ),
                      SocialButton(
                        assetPath: "assets/images/apple.png",
                        onPressed: () {},
                      ),
                    ],
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 3),

                  // Navigation to Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don’t have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
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
  }}