import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';

class CustomRequestTile extends StatelessWidget {
  final String name;
  final String hospital;
  final String bloodType;
  final String distance;
  final String imageUrl;

  const CustomRequestTile({
    super.key,
    required this.name,
    required this.hospital,
    required this.bloodType,
    required this.distance,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.blockHeight * 0.8,
        horizontal: SizeConfig.blockWidth * 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 6), // 👈 shadow only at bottom
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: SizeConfig.blockWidth * 6,
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          hospital,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chip(
              label: Text(
                bloodType,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            SizedBox(height: SizeConfig.blockHeight * 0.5),
            Flexible(
              child: Text(
                distance,
                style: const TextStyle(color: Colors.green),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
