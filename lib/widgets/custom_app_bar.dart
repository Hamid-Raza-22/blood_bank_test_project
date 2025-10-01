// 📌 updated
import 'package:flutter/material.dart';
import '../constant/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,

        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: AppColors.white),
          onPressed: onTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
