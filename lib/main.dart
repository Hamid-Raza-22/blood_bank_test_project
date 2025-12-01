// main.dart
// ============================================================================
// BLOOD BANK APP - MVVM + DDD ARCHITECTURE
// ============================================================================
// 
// Architecture Overview:
// ├── core/           -> Constants, Utils, DI, Errors, Theme
// ├── data/           -> DataSources, Models (DTOs), Repository Implementations
// ├── domain/         -> Entities, Repository Interfaces, Use Cases
// └── presentation/   -> Features (View + ViewModel), Common Widgets, Routes, Bindings
//
// Flow:
// main() -> Firebase Init -> DI Init -> AppBinding -> Splash -> Auth Check -> Option/Login
//
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

// Core
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';

// Presentation - Routes & Bindings
import 'presentation/routes/app_routes.dart';
import 'presentation/bindings/app_bindings.dart';

// Legacy Controllers (for backward compatibility during migration)
import 'controller/auth_controller.dart';
import 'controller/home_controller.dart';
import 'controller/request_controller.dart';
import 'controller/bottom_nav_controller.dart';

// Services
import 'services/notification_service.dart';

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
  await _initializeFirebase();

  // Initialize Dependency Injection Container (MVVM + DDD)
  await sl.init();

  // Initialize Legacy Controllers (for backward compatibility)
  _initializeLegacyControllers();

  // Initialize notification service (not on web)
  if (!kIsWeb) {
    await Get.putAsync(() => NotificationService().init(), permanent: true);
  }

  // Run app - Splash screen will handle auth state check and navigation
  runApp(const BloodBankApp());
}

/// Initialize Firebase based on platform
Future<void> _initializeFirebase() async {
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
}

/// Initialize legacy controllers for backward compatibility
void _initializeLegacyControllers() {
  Get.put(AuthController(), permanent: true);
  Get.put(NavController(), permanent: true);
  Get.put(HomeController(), permanent: true);
  Get.put(RequestController(), permanent: true);
}

/// Main App Widget with MVVM Architecture
class BloodBankApp extends StatelessWidget {
  const BloodBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // App Configuration
      debugShowCheckedModeBanner: false,
      title: 'Blood Bank App',

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Initial Binding - Initializes core ViewModels
      initialBinding: AppBinding(),

      // Initial Route - Splash handles auth check
      initialRoute: AppRoutes.splash,

      // Centralized Routes with Bindings
      getPages: AppPages.pages,

      // Default Transition
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),

      // Locale settings (can be expanded)
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}