import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/colors.dart';
import '../../constant/size_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/social_button.dart';
import '../../widgets/top_header.dart';
import '../controller/auth_controller.dart';
import 'signup_screen.dart';
import 'forget_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController controller = Get.find();

  bool rememberMe = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 🔹 Reusable Custom Header
              const CustomHeader(title: "Log In", showBack: false),

              SizedBox(height: SizeConfig.blockHeight * 3),

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
                    SizedBox(height: SizeConfig.blockHeight * 1),
                    const Center(
                      child: Text(
                        "Let's login to continue exploring",
                        style: TextStyle(color: AppColors.grey),
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockHeight * 3),

                    // 🔹 Email Field
                    CustomTextField(
                      label: "Email",
                      hint: "example@gmail.com",
                      controller: emailController,
                    ),

                    // 🔹 Password Field with Toggle
                    CustomTextField(
                      label: "Password",
                      hint: "********",
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockHeight * 1.5),

                    // 🔹 Remember & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              activeColor: AppColors.primary,
                              onChanged: (v) =>
                                  setState(() => rememberMe = v ?? false),
                            ),
                            Text(
                              "Remember Me",
                              style: TextStyle(
                                fontSize: SizeConfig.blockWidth * 3.5,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () =>
                              Get.to(() => const ForgetPasswordScreen()),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 🔹 Login Button
                    Obx(() => CustomButton(
                      text: controller.isLoading.value
                          ? "Signing In..."
                          : "Sign In",
                      onPressed: () {
                        controller.signIn(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      },
                    )),

                    SizedBox(height: SizeConfig.blockHeight * 4),

                    // 🔹 OR Divider
                    const CustomDivider(text: "or"),

                    SizedBox(height: SizeConfig.blockHeight * 3),

                    // 🔹 Social Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SocialButton(
                          assetPath: "assets/icons/google.png",
                          onPressed: () {
                            controller.signInWithGoogle(isSignUp: false); // Pass isSignUp: false
                          },
                        ),
                        SocialButton(
                          assetPath: "assets/icons/facebook.png",
                          onPressed: () {},
                        ),
                        SocialButton(
                          assetPath: "assets/icons/apple.png",
                          onPressed: () {},
                        ),
                      ],
                    ),

                    SizedBox(height: SizeConfig.blockHeight * 3),

                    // 🔹 Bottom Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account? "),
                        GestureDetector(
                          onTap: () => Get.to(() => const SignUpScreen()),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}