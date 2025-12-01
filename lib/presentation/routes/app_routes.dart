import 'package:get/get.dart';

// Import existing screens
import '../../screens/splash_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/signup_screen.dart';
import '../../screens/main_navigation_screen.dart';
import '../../screens/chat_screen.dart';
import '../../screens/chat_list_screen.dart';
import '../../screens/notification_screen.dart';
import '../../screens/public_need_screen.dart';
import '../../screens/all_donors_screen.dart';
import '../../screens/donor_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/forget_password_screen.dart';
import '../../screens/reset_password_screen.dart';
import '../../screens/blood_instruction_screen.dart';
import '../../screens/option_screen.dart';
import '../../screens/need_screen.dart';
import '../../screens/blood_request_screen.dart';
import '../../screens/email_verification_screen.dart';
import '../../onboarding/onboarding_screens/onboarding_screen1.dart';

import '../bindings/app_bindings.dart';

/// App route names - centralized route constants
class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  // Initial routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // Auth routes
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotPassword';
  static const String resetPassword = '/resetPassword';
  static const String verifyOtp = '/verifyOtp';

  // Main app routes
  static const String option = '/option';
  static const String home = '/home';

  // Feature routes
  static const String chat = '/chat';
  static const String chatList = '/chatList';
  static const String notifications = '/notifications';
  static const String publicNeed = '/publicNeed';
  static const String donors = '/donors';
  static const String allDonors = '/alldonors';
  static const String need = '/need';
  static const String request = '/request';
  static const String profile = '/profile';
  static const String bloodInstructions = '/bloodInstruction';
}

/// App pages/routes configuration with proper bindings
class AppPages {
  // Prevent instantiation
  AppPages._();

  static final List<GetPage> pages = [
    // ==================== INITIAL ROUTES ====================
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      transition: Transition.rightToLeft,
    ),

    // ==================== AUTH ROUTES ====================
    GetPage(
      name: AppRoutes.login,
      page: () => const SignInScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignUpScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgetPasswordScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.verifyOtp,
      page: () => const VerifyOtpScreen(),
      transition: Transition.rightToLeft,
    ),

    // ==================== MAIN APP ROUTES ====================
    GetPage(
      name: AppRoutes.option,
      page: () => const OptionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainNavigationScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),

    // ==================== FEATURE ROUTES ====================
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatScreen(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.chatList,
      page: () => const ChatListScreen(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.publicNeed,
      page: () => const PublicNeedScreen(),
      binding: PublicNeedBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.donors,
      page: () => const DonorScreen(),
      binding: DonorBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.allDonors,
      page: () => const AllDonorsScreen(),
      binding: DonorBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.need,
      page: () => const BloodNeededScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.request,
      page: () => const BloodRequestScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.bloodInstructions,
      page: () => const BloodInstructionScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
