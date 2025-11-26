import 'package:get/get.dart';

// Import existing screens (will be moved to presentation layer later)
import '../../screens/splash_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/signup_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/chat_screen.dart';
import '../../screens/chat_list_screen.dart';
import '../../screens/notification_screen.dart';
import '../../screens/public_need_screen.dart';
import '../../screens/all_donors_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/forget_password_screen.dart';
import '../../screens/reset_password_screen.dart';
import '../../screens/blood_instruction_screen.dart';
import '../../screens/option_screen.dart';
import '../../onboarding/onboarding_screens/onboarding_screen1.dart';

import '../bindings/app_bindings.dart';

/// App route names
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String option = '/option';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotPassword';
  static const String resetPassword = '/resetPassword';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String chatList = '/chatList';
  static const String notifications = '/notifications';
  static const String publicNeed = '/publicNeed';
  static const String donors = '/donors';
  static const String profile = '/profile';
  static const String bloodInstructions = '/bloodInstructions';
}

/// App pages/routes configuration
class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
    ),
    GetPage(
      name: AppRoutes.option,
      page: () => const OptionScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const SignInScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignUpScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgetPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.chatList,
      page: () => const ChatListScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: AppRoutes.publicNeed,
      page: () => const PublicNeedScreen(),
      binding: PublicNeedBinding(),
    ),
    GetPage(
      name: AppRoutes.donors,
      page: () => const AllDonorsScreen(),
      binding: DonorBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.bloodInstructions,
      page: () => const BloodInstructionScreen(),
    ),
  ];
}
