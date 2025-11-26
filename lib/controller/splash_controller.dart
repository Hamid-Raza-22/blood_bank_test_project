import 'package:blood_bank_test_project/onboarding/onboarding_screens/onboarding_screen1.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 5), () {
      Get.offAll(() => const OnboardingView()); // Navigate using GetX
    });
  }
}
