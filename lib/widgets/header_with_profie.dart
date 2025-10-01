import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';

class CustomProfileHeader extends StatelessWidget {
  final String title; // Name
  final String userId; // Subtitle
  final String avatarUrl; // Circular avatar image
  final bool showBack; // Optional back button
  final VoidCallback? onButtonTap; // Optional top-right button
  final VoidCallback? onNotificationTap; // Optional notification button

  const CustomProfileHeader({
    super.key,
    required this.title,
    required this.userId,
    required this.avatarUrl,
    this.showBack = false,
    this.onButtonTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockHeight * 22,
      width: double.infinity,
      padding: EdgeInsets.only(
        top: SizeConfig.blockHeight * 5,
        left: SizeConfig.blockWidth * 4,
        right: SizeConfig.blockWidth * 4,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(200, 80),
          bottomRight: Radius.elliptical(200, 80),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🔹 Left: Avatar + Name + UserID
              Row(
                children: [
                  CircleAvatar(

                    radius: SizeConfig.blockWidth * 6,
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                  SizedBox(width: SizeConfig.blockWidth * 3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                    ],
                  ),
                ],
              ),

              // 🔹 Right: Two Icons
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.messenger_outline, color: AppColors.white),
                    onPressed: onButtonTap,
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: AppColors.white),
                    onPressed: onNotificationTap,
                  ),
                ],
              ),
            ],
          ),

          // Optional: main title in center (if needed)
          // Center(
          //   child: Text(
          //     'Your main title here',
          //     style: TextStyle(
          //       color: AppColors.white,
          //       fontSize: SizeConfig.blockWidth * 7,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
