import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/bottom_nav_controller.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import 'home_screen_content.dart';
import 'donor_screen.dart';
import 'public_need_screen.dart';
import 'profile_screen.dart';

/// Main Navigation Screen - Wrapper for bottom navigation
/// 
/// This screen keeps the bottom navbar static and uses IndexedStack
/// to switch between different tab contents without rebuilding navbar.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late final NavController navController;

  @override
  void initState() {
    super.initState();
    navController = Get.find<NavController>();
    // Always reset to home tab when MainNavigationScreen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navController.goToHome();
      debugPrint("MainNavigationScreen: Reset to home tab");
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of screens for each tab
    final List<Widget> screens = [
      const HomeScreenContent(),    // Index 0: Home
      const DonorScreen(),          // Index 1: Donors
      const PublicNeedScreen(),     // Index 2: Public Needs
      const ProfileScreen(),        // Index 3: Profile
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
        index: navController.currentIndex.value,
        children: screens,
      )),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
