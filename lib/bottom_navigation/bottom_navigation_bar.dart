import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A custom bottom navigation bar widget.
///
/// This widget is designed to be reusable and customizable.
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      iconSize: 30,
      selectedFontSize: 14,
      unselectedFontSize: 12,
      mouseCursor: SystemMouseCursors.grab,
      enableFeedback: true,
      landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
      useLegacyColorScheme: true,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.red,
      // selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.unselectedWidgetColor,
      showUnselectedLabels: true, // Explicitly show labels for all items
      items: _navBarItems,
    );
  }

  // Using a private getter for the list of items improves readability
  // and keeps the build method cleaner.
  static const List<BottomNavigationBarItem> _navBarItems = [
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.house),
      label: "Home",
      activeIcon: Icon(FontAwesomeIcons.houseMedical), // Example of an active icon
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
