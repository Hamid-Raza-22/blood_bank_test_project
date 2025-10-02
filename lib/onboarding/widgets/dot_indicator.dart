import 'package:flutter/material.dart';
import '../../constant/size_helper.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int count;
  final Color activeColor;
  final Color inactiveColor;

  const DotIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
    this.activeColor = Colors.white,
    this.inactiveColor = Colors.white54,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockWidth * 1),
          width: currentIndex == index
              ? SizeConfig.blockWidth * 6
              : SizeConfig.blockWidth * 3,
          height: SizeConfig.blockWidth * 3,
          decoration: BoxDecoration(
            color: currentIndex == index ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}
