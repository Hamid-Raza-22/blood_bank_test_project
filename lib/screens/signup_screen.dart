import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/colors.dart';
import '../../constant/size_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/top_header.dart';
import '../controller/auth_controller.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthController controller = Get.find();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

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
                    controller: nameController,
                  ),
                  CustomTextField(
                    label: "Email",
                    hint: "example@gmail.com",
                    controller: emailController,
                  ),

                  // 🔹 Password Field (toggle eye icon)
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

                  // 🔹 Confirm Password Field (toggle eye icon)
                  CustomTextField(
                    label: "Confirm Password",
                    hint: "********",
                    controller: confirmPasswordController,
                    obscureText: !isConfirmPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: SizeConfig.blockHeight * 2),

                  // 🔘 Sign Up Button
                  Obx(() => CustomButton(
                    text: controller.isLoading.value
                        ? "Sending OTP..."
                        : "Sign Up",
                    onPressed: () {
                      if (passwordController.text.trim() !=
                          confirmPasswordController.text.trim()) {
                        Get.snackbar(
                            "Error", "Passwords do not match!",
                            backgroundColor: Colors.red.shade100);
                        return;
                      }

                      controller.sendOtp(emailController.text.trim());
                    },
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
                    onPressed: () {
                      controller.signInWithGoogle(isSignUp: true); // Pass isSignUp: true
                    },
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
                        onTap: () => Get.to(() => const SignInScreen()),
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