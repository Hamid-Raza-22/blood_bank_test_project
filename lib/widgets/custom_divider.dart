import 'package:flutter/material.dart';

import '../constant/colors.dart';
import '../constant/size_helper.dart';

class CustomDivider extends StatelessWidget {
  final String text;

  const CustomDivider({super.key, this.text = "OR"});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 🔹 Left Line
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey.shade400,
            indent: SizeConfig.blockWidth * 2,
            endIndent: SizeConfig.blockWidth * 2,
          ),
        ),

        // 🔹 Center Text
        Text(
          text,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.blockWidth * 4,
          ),
        ),

        // 🔹 Right Line
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey.shade400,
            indent: SizeConfig.blockWidth * 2,
            endIndent: SizeConfig.blockWidth * 2,
          ),
        ),
      ],
    );
  }
}
