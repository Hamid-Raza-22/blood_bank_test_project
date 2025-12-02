import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constant/colors.dart';
import '../../../../constant/size_helper.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/custom_divider.dart';
import '../../../../widgets/social_button.dart';
import '../../../../widgets/top_header.dart';
import '../../../routes/app_routes.dart';
import '../viewmodel/auth_viewmodel.dart';

/// Login View - Pure UI, no business logic
/// Uses existing widgets, delegates all logic to AuthViewModel
class LoginView extends GetView<AuthViewModel> {
  const LoginView({super.key});

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
                      controller: controller.emailController,
                    ),

                    // 🔹 Password Field with Toggle
                    Obx(() => CustomTextField(
                          label: "Password",
                          hint: "********",
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.primary,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        )),

                    SizedBox(height: SizeConfig.blockHeight * 1.5),

                    // 🔹 Remember & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Row(
                              children: [
                                Checkbox(
                                  value: controller.rememberMe,
                                  activeColor: AppColors.primary,
                                  onChanged: (v) =>
                                      controller.setRememberMe(v ?? false),
                                ),
                                Text(
                                  "Remember Me",
                                  style: TextStyle(
                                    fontSize: SizeConfig.blockWidth * 3.5,
                                  ),
                                ),
                              ],
                            )),
                        TextButton(
                          onPressed: () =>
                              Get.toNamed(AppRoutes.forgotPassword),
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
                          text: controller.isLoading
                              ? "Signing In..."
                              : "Sign In",
                          onPressed: controller.signIn,
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
                          onPressed: controller.signInWithGoogle,
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
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.signup),
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
