import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';
import 'badge_widget.dart';

/// CustomCard - A card widget with optional badge support
/// 
/// Usage:
/// ```dart
/// CustomCard(
///   icon: Icons.water_drop,
///   text: "Request for blood",
///   badgeCount: 3,
///   onTap: () {},
/// )
/// ```
class CustomCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  
  /// Optional badge count to display on the card
  final int? badgeCount;
  
  /// Badge color (defaults to red)
  final Color? badgeColor;

  const CustomCard({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.badgeCount,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    double cardSize = SizeConfig.blockWidth * 28; // responsive square size

    Widget cardContent = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Container(
        width: cardSize,
        height: cardSize,
        padding: EdgeInsets.all(SizeConfig.blockWidth * 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Icon(
                icon,
                size: SizeConfig.blockWidth * 10,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: SizeConfig.blockHeight * 1.5),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: SizeConfig.blockWidth * 3.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Wrap with badge if count is provided and > 0
    if (badgeCount != null && badgeCount! > 0) {
      cardContent = BadgeWidget(
        count: badgeCount!,
        badgeColor: badgeColor ?? Colors.red,
        topOffset: 0,
        rightOffset: 0,
        child: cardContent,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: cardContent,
    );
  }
}
