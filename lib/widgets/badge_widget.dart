import 'package:flutter/material.dart';

/// BadgeWidget - Displays a badge/bubble with count on top of a child widget
/// 
/// Usage:
/// ```dart
/// BadgeWidget(
///   count: 5,
///   child: Icon(Icons.chat),
/// )
/// ```
class BadgeWidget extends StatelessWidget {
  /// The widget to display the badge on
  final Widget child;
  
  /// The count to display in the badge
  final int count;
  
  /// Badge background color
  final Color? badgeColor;
  
  /// Badge text color
  final Color? textColor;
  
  /// Badge size (diameter)
  final double? size;
  
  /// Position offset from top-right
  final double? topOffset;
  final double? rightOffset;
  
  /// Whether to show the badge even when count is 0
  final bool showZero;
  
  /// Maximum count to display (shows "99+" if exceeded)
  final int maxCount;

  /// Custom badge text (overrides count)
  final String? customText;

  const BadgeWidget({
    super.key,
    required this.child,
    this.count = 0,
    this.badgeColor,
    this.textColor,
    this.size,
    this.topOffset,
    this.rightOffset,
    this.showZero = false,
    this.maxCount = 99,
    this.customText,
  });

  @override
  Widget build(BuildContext context) {
    final shouldShow = showZero || count > 0 || customText != null;
    
    if (!shouldShow) {
      return child;
    }

    final displayText = customText ?? _formatCount(count);
    final badgeSize = size ?? (displayText.length > 2 ? 22.0 : 18.0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: topOffset ?? -4,
          right: rightOffset ?? -4,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Container(
              key: ValueKey(displayText),
              constraints: BoxConstraints(
                minWidth: badgeSize,
                minHeight: badgeSize,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: displayText.length > 2 ? 4 : 2,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: badgeColor ?? Colors.red,
                borderRadius: BorderRadius.circular(badgeSize / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  displayText,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: displayText.length > 2 ? 9 : 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count <= 0) return '';
    if (count > maxCount) return '$maxCount+';
    return count.toString();
  }
}

/// BadgeDot - A simple dot badge without count
/// 
/// Usage:
/// ```dart
/// BadgeDot(
///   show: true,
///   child: Icon(Icons.notifications),
/// )
/// ```
class BadgeDot extends StatelessWidget {
  final Widget child;
  final bool show;
  final Color? color;
  final double? size;
  final double? topOffset;
  final double? rightOffset;

  const BadgeDot({
    super.key,
    required this.child,
    this.show = true,
    this.color,
    this.size,
    this.topOffset,
    this.rightOffset,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return child;

    final dotSize = size ?? 10.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: topOffset ?? 0,
          right: rightOffset ?? 0,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: color ?? Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// IconWithBadge - Convenience widget for icons with badges
/// 
/// Usage:
/// ```dart
/// IconWithBadge(
///   icon: Icons.chat,
///   count: 3,
///   onTap: () {},
/// )
/// ```
class IconWithBadge extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback? onTap;
  final Color? iconColor;
  final double? iconSize;
  final Color? badgeColor;

  const IconWithBadge({
    super.key,
    required this.icon,
    this.count = 0,
    this.onTap,
    this.iconColor,
    this.iconSize,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BadgeWidget(
        count: count,
        badgeColor: badgeColor,
        child: Icon(
          icon,
          color: iconColor ?? Colors.white,
          size: iconSize ?? 24,
        ),
      ),
    );
  }
}
