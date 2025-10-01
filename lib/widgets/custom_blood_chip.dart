import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';

class CustomBloodChip extends StatelessWidget {
  final String bloodType;

  const CustomBloodChip({super.key, required this.bloodType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.bloodtype, color: AppColors.primary, size: SizeConfig.blockWidth * 8),
        Text(
          bloodType,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
