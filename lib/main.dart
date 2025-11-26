// main.dart
import 'package:blood_bank_test_project/onboarding/onboarding_screens/onboarding_screen1.dart';
import 'package:blood_bank_test_project/screens/all_donors_screen.dart';
import 'package:blood_bank_test_project/screens/blood_instruction_screen.dart';
import 'package:blood_bank_test_project/screens/blood_request_screen.dart';
import 'package:blood_bank_test_project/screens/chat_list_screen.dart';
import 'package:blood_bank_test_project/screens/chat_screen.dart';
import 'package:blood_bank_test_project/screens/public_need_screen.dart';
import 'package:blood_bank_test_project/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blood_bank_test_project/screens/splash_screen.dart';
import 'package:blood_bank_test_project/screens/login_screen.dart';
import 'package:blood_bank_test_project/screens/signup_screen.dart';
import 'package:blood_bank_test_project/screens/email_verification_screen.dart';
import 'package:blood_bank_test_project/screens/forget_password_screen.dart';
import 'package:blood_bank_test_project/screens/home_screen.dart';
import 'package:blood_bank_test_project/screens/donor_screen.dart';
import 'package:blood_bank_test_project/screens/need_screen.dart';
import 'package:blood_bank_test_project/screens/profile_screen.dart';
import 'package:blood_bank_test_project/screens/option_screen.dart';
import 'package:blood_bank_test_project/controller/auth_controller.dart';
import 'package:blood_bank_test_project/controller/home_controller.dart';
import 'package:blood_bank_test_project/controller/request_controller.dart';
import 'package:blood_bank_test_project/controller/bottom_nav_controller.dart';
import 'package:blood_bank_test_project/services/notification_service.dart';
import 'package:flutter/foundation.dart';

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

  // Initialize ALL controllers once
  Get.put(AuthController(), permanent: true);
  Get.put(NavController(), permanent: true);
  Get.put(HomeController(), permanent: true);
  Get.put(RequestController(), permanent: true);

  // Initialize notification service (not on web)
  if (!kIsWeb) {
    await Get.putAsync(() => NotificationService().init(), permanent: true);
  }

  final prefs = await SharedPreferences.getInstance();
  final bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
  final User? user = FirebaseAuth.instance.currentUser;

  String initialRoute = '/splash';
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
      theme: ThemeData(
        primaryColor: const Color(0xFF8B0000),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF8B0000),
          secondary: Colors.grey[600],
        ),
      ),
    );
  }
}