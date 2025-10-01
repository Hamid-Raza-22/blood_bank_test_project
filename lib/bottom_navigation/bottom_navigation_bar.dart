import 'package:flutter/material.dart';

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
    final double fabSpace = MediaQuery.of(context).size.width * 0.18; // ✅ responsive gap

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.home,
              label: "Home",
              index: 0,
              isSelected: currentIndex == 0,
              onTap: onTap,
            ),
            _buildNavItem(
              icon: Icons.favorite,
              label: "Donors",
              index: 1,
              isSelected: currentIndex == 1,
              onTap: onTap,
            ),
            SizedBox(width: fabSpace), // ✅ FAB ke liye responsive jagah
            _buildNavItem(
              icon: Icons.bloodtype_outlined,
              label: "Need",
              index: 2,
              isSelected: currentIndex == 2,
              onTap: onTap,
            ),
            _buildNavItem(
              icon: Icons.person,
              label: "Profile",
              index: 3,
              isSelected: currentIndex == 3,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required Function(int) onTap,
  }) {
    return InkWell(
      onTap: () => onTap(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.red : Colors.grey,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.red : Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
