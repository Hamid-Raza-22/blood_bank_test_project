import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';

class GridItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const GridItem({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: isSelected? Colors.grey.shade300: Colors.transparent,

                child: Icon(
                  icon,
                  color:  AppColors.primary,

                  size: 28,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : Colors.black,
                ),
              ),
            ],
          ),
          if (isSelected)
            Positioned(
              right: -SizeConfig.blockWidth * 1,
              top: -SizeConfig.blockHeight * 1,
              child: Container(
                width: SizeConfig.blockWidth * 2,
                height: SizeConfig.blockWidth * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors
                      .primary, // Changes to primary color when selected
                ),
              ),
            ),
        ],
      ),
    );
  }
}
