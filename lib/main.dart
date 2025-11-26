// main.dart
// ============================================================================
// BLOOD BANK APP - MVVM + DDD ARCHITECTURE
// ============================================================================
// 
// Architecture Overview:
// ├── core/           -> Constants, Utils, DI, Errors
// ├── data/           -> DataSources, Models (DTOs), Repository Implementations
// ├── domain/         -> Entities, Repository Interfaces, Use Cases
// └── presentation/   -> Features (View + ViewModel), Common Widgets, Routes
//
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';

// Legacy Controllers (for backward compatibility during migration)
import 'controller/auth_controller.dart';
import 'controller/home_controller.dart';
import 'controller/request_controller.dart';
import 'controller/bottom_nav_controller.dart';

// Services
import 'services/notification_service.dart';

// Screens (Legacy - will be moved to presentation/features)
import 'onboarding/onboarding_screens/onboarding_screen1.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/email_verification_screen.dart';
import 'screens/forget_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/donor_screen.dart';
import 'screens/need_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/option_screen.dart';
import 'screens/all_donors_screen.dart';
import 'screens/blood_instruction_screen.dart';
import 'screens/blood_request_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/public_need_screen.dart';
import 'screens/notification_screen.dart';

// === WEB FIREBASE CONFIG ===
const firebaseConfig = {
  "apiKey": "YOUR_API_KEY",
  "authDomain": "your-project.firebaseapp.com",
  "projectId": "your-project",
  "storageBucket": "your-project.appspot.com",
  "messagingSenderId": "123456789",
  "appId": "1:123456789:web:abcdef123456"
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: firebaseConfig["apiKey"]!,
        authDomain: firebaseConfig["authDomain"]!,
        projectId: firebaseConfig["projectId"]!,
        storageBucket: firebaseConfig["storageBucket"]!,
        messagingSenderId: firebaseConfig["messagingSenderId"]!,
        appId: firebaseConfig["appId"]!,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Initialize Dependency Injection Container (MVVM + DDD)
  await sl.init();

  // Initialize Legacy Controllers (for backward compatibility)
  Get.put(AuthController(), permanent: true);
  Get.put(NavController(), permanent: true);
  Get.put(HomeController(), permanent: true);
  Get.put(RequestController(), permanent: true);

  // Initialize notification service (not on web)
  if (!kIsWeb) {
    await Get.putAsync(() => NotificationService().init(), permanent: true);
  }

  // Check onboarding and auth status (can be used for dynamic routing)
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
  final currentUser = FirebaseAuth.instance.currentUser;

  // Determine initial route based on auth state
  String initialRoute;
  if (!onboardingCompleted) {
    initialRoute = '/splash';
  } else if (currentUser != null) {
    initialRoute = '/home';
  } else {
    initialRoute = '/login';
  }
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Bank App',
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/splash', page: () => const SplashView()),
        GetPage(name: '/onboarding', page: () => const OnboardingView()),
        GetPage(name: '/login', page: () => const SignInScreen()),
        GetPage(name: '/signup', page: () => const SignUpScreen()),
        GetPage(name: '/verifyOtp', page: () => const VerifyOtpScreen()),
        GetPage(name: '/verifyResetOtp', page: () => const VerifyOtpScreen()),
        GetPage(name: '/resetPassword', page: () => const ForgetPasswordScreen()),
        GetPage(name: '/option', page: () => const OptionScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/donors', page: () => const DonorScreen()),
        GetPage(name: '/need', page: () => const BloodNeededScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
        GetPage(name: '/request', page: () => const BloodRequestScreen()),
        GetPage(name: '/notifications', page: () => const NotificationScreen()),
        GetPage(name: '/chatList', page: () => const ChatListScreen()),
        GetPage(name: '/chat', page: () => const ChatScreen()),
        GetPage(name: '/publicNeed', page: () => const PublicNeedScreen()),
        GetPage(name: '/bloodInstruction', page: () => const BloodInstructionScreen()),
        GetPage(name: '/alldonors', page: () => const AllDonorsScreen()),
      ],
      theme: AppTheme.lightTheme,
    );
  }
}