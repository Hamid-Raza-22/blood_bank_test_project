import 'package:get/get.dart';
import 'app_routes.dart';

// Views
import '../features/splash/view/splash_view.dart';
import '../features/auth/view/views.dart';
import '../features/home/view/home_view.dart';
import '../features/home/view/main_navigation_view.dart';
import '../features/chat/view/chat_view.dart';
import '../features/chat/view/chat_list_view.dart';
import '../features/donors/view/donor_view.dart';
import '../features/donors/view/all_donors_view.dart';
import '../features/notifications/view/notification_view.dart';
import '../features/profile/view/profile_view.dart';
import '../features/public_needs/view/public_need_view.dart';

// Bindings
import '../bindings/bindings.dart';

// Legacy screens (for backward compatibility during migration)
import '../../onboarding/onboarding_screens/onboarding_screen1.dart';
import '../../screens/option_screen.dart';
import '../../screens/need_screen.dart';
import '../../screens/blood_request_screen.dart';
import '../../screens/blood_instruction_screen.dart';

/// App Pages - Route configuration with proper bindings
///
/// Each route is configured with:
/// - Route name from AppRoutes
/// - View widget
/// - Binding for dependency injection
/// - Transition animation
class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    // ===================== INITIAL ROUTES =====================
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

    // ===================== AUTH ROUTES =====================
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.verifyOtp,
      page: () => const VerifyOtpView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),

    // ===================== MAIN APP ROUTES =====================
    GetPage(
      name: AppRoutes.option,
      page: () => const OptionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainNavigationView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),

    // ===================== FEATURE ROUTES =====================
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.chatList,
      page: () => const ChatListView(),
      binding: ChatBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.publicNeed,
      page: () => const PublicNeedView(),
      binding: PublicNeedBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.donors,
      page: () => const DonorView(),
      binding: DonorBinding(),
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: AppRoutes.allDonors,
      page: () => const AllDonorsView(),
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
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.bloodInstructions,
      page: () => const BloodInstructionScreen(),
      transition: Transition.circularReveal,
    ),
  ];
}
