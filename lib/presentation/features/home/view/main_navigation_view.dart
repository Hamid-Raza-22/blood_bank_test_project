import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/bottom_nav_controller.dart';
import '../../../../bottom_navigation/bottom_navigation_bar.dart';
import '../../../../screens/home_screen_content.dart';
import '../../../../screens/donor_screen.dart';
import '../../../../screens/public_need_screen.dart';
import '../../../../screens/profile_screen.dart';

/// Main Navigation View - Wrapper for bottom navigation
/// 
/// Uses existing screens and bottom nav from original app.
/// This keeps the exact original UI while using clean architecture.
class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  late final NavController navController;

  @override
  void initState() {
    super.initState();
    navController = Get.find<NavController>();
    // Always reset to home tab when MainNavigationScreen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navController.goToHome();
      debugPrint("MainNavigationView: Reset to home tab");
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
