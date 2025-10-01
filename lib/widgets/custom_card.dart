import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double cardSize = SizeConfig.blockWidth * 28; // responsive square size

    return GestureDetector(
      onTap: onTap,
      child: Card(
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
                  overflow: TextOverflow.ellipsis, // ⚡ overflow fix
                  maxLines: 2, // max 2 lines
                  style: TextStyle(
                    fontSize: SizeConfig.blockWidth * 3.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
