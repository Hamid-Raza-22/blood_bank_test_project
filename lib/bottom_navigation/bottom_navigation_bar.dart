import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../constant/colors.dart';
import '../controller/bottom_nav_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final NavController navController = Get.find<NavController>();

    print(
      "CustomBottomNavBar LOG: Building with currentIndex: ${navController.currentIndex.value}",
    );

    return Obx(
      () => BottomNavigationBar(
        currentIndex: navController.currentIndex.value,
        onTap: (index) {
          print("CustomBottomNavBar LOG: Tapped index: $index");
          navController.changeTab(index);
        },
        iconSize: 30,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        mouseCursor: SystemMouseCursors.grab,
        enableFeedback: true,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        useLegacyColorScheme: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: theme.unselectedWidgetColor,
        showUnselectedLabels: true,
        items: _navBarItems,
      ),
    );
  }

  static const List<BottomNavigationBarItem> _navBarItems = [
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.house),
      label: "Home",
      activeIcon: Icon(FontAwesomeIcons.houseMedical),
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.handHoldingDroplet),
      label: "Donors",
      activeIcon: Icon(FontAwesomeIcons.handHoldingDroplet),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bloodtype_outlined),
      label: "Need",
      activeIcon: Icon(Icons.bloodtype),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: "Profile",
      activeIcon: Icon(Icons.person),
    ),
  ];
}
