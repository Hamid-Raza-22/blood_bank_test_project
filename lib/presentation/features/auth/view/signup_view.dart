import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constant/colors.dart';
import '../../../../constant/size_helper.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/top_header.dart';
import '../../../routes/app_routes.dart';
import '../viewmodel/auth_viewmodel.dart';

/// SignUp View - Pure UI (exact match of original signup_screen.dart)
/// All business logic delegated to AuthViewModel
class SignupView extends GetView<AuthViewModel> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomHeader(title: "Sign Up", showBack: true),
            SizedBox(height: SizeConfig.blockHeight * 3),

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
                  const Center(
                    child: Text(
                      "Register now to create a new account",
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 3),

                  // 🧾 Text Fields
                  CustomTextField(
                    label: "Full Name",
                    hint: "John Doe",
                    controller: controller.nameController,
                  ),
                  CustomTextField(
                    label: "Email",
                    hint: "example@gmail.com",
                    controller: controller.emailController,
                  ),

                  // 🔹 Password Field (toggle eye icon)
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

                  // 🔹 Confirm Password Field (toggle eye icon)
                  Obx(() => CustomTextField(
                        label: "Confirm Password",
                        hint: "********",
                        controller: controller.confirmPasswordController,
                        obscureText: !controller.isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.primary,
                          ),
                          onPressed: controller.toggleConfirmPasswordVisibility,
                        ),
                      )),

                  SizedBox(height: SizeConfig.blockHeight * 2),

                  // 🔘 Sign Up Button
                  Obx(() => CustomButton(
                        text: controller.isLoading
                            ? "Sending OTP..."
                            : "Sign Up",
                        onPressed: controller.signUp,
                      )),

                  SizedBox(height: SizeConfig.blockHeight * 2),

                  // 🌐 Sign Up with Google Button
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockHeight * 2,
                      ),
                      side: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: controller.signInWithGoogle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/google.png",
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: SizeConfig.blockWidth * 2),
                        const Text(
                          "Sign Up with Google",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 3),

                  // 🔁 Already have an account?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.login),
                        child: const Text(
                          "Sign In",
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
    );
  }
}
