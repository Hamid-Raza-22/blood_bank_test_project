/// App Route Names - Centralized route constants
/// 
/// Single source of truth for all route names in the app.
/// Use these constants instead of hardcoding route strings.
abstract class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  // ===================== INITIAL ROUTES =====================
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // ===================== AUTH ROUTES =====================
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotPassword';
  static const String resetPassword = '/resetPassword';
  static const String verifyOtp = '/verifyOtp';

  // ===================== MAIN APP ROUTES =====================
  static const String option = '/option';
  static const String home = '/home';

  // ===================== FEATURE ROUTES =====================
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
