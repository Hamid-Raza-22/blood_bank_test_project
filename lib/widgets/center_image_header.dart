import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';

class CustomCenterProfileHeader extends StatelessWidget {
  final String title; // Name, nullable
  final String userId; // User ID, nullable
  final String avatarUrl; // Profile Image URL (http or asset path)
  final bool showBack;
  final VoidCallback? onBackTap;
  final VoidCallback? onEditTap;

  const CustomCenterProfileHeader({
    super.key,
    required this.title,
    required this.userId,
    required this.avatarUrl,
    this.showBack = true,
    this.onBackTap,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: SizeConfig.blockHeight * 5,
        left: SizeConfig.blockWidth * 4,
        right: SizeConfig.blockWidth * 4,
        bottom: SizeConfig.blockHeight * 4,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary, // dark red (0xFF8B0000)
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔹 Left: Back Arrow
          if (showBack)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: onBackTap,
            )
          else
            SizedBox(width: SizeConfig.blockWidth * 8),

          // 🔹 Center: Profile Image + Name + UserID + Rating
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: SizeConfig.blockWidth * 8,
                  backgroundImage: avatarUrl.startsWith('http')
                      ? NetworkImage(avatarUrl)
                      : AssetImage(avatarUrl) as ImageProvider,
                ),
                SizedBox(height: SizeConfig.blockHeight * 1),
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: SizeConfig.blockWidth * 4.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.blockHeight * 0.5),
                Text(
                  userId,
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.8),
                    fontSize: SizeConfig.blockWidth * 3.5,
                  ),
                ),
                SizedBox(height: SizeConfig.blockHeight * 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                        (index) => Icon(
                      Icons.star,
                      size: SizeConfig.blockWidth * 3.5,
                      color: index < 4 ? Colors.amber : Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Right: Edit Icon
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.white),
            onPressed: onEditTap,
          ),
        ],
      ),
    );
  }
}