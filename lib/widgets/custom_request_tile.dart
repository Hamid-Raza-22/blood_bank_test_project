import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/size_helper.dart';

class CustomRequestTile extends StatelessWidget {
  final String name;
  final String hospital;
  final String distance;
  final String bloodType;
  final String imageUrl;
  final bool isDonor;
  final String? donorId;
  final VoidCallback? onTap;

  const CustomRequestTile({
    super.key,
    required this.name,
    required this.hospital,
    required this.distance,
    required this.bloodType,
    required this.imageUrl,
    required this.isDonor,
    this.donorId, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDonor
          ? () {
        debugPrint("CustomRequestTile LOG: Donor selected with ID: $donorId");
        Get.toNamed('/need', arguments: {'donorId': donorId});
      }
          : null,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: SizeConfig.blockHeight * 1),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.blockWidth * 2),
          child: Row(
            children: [
              CircleAvatar(
                radius: SizeConfig.blockWidth * 6,
                backgroundImage: imageUrl.startsWith('assets')
                    ? AssetImage(imageUrl)
                    : NetworkImage(imageUrl) as ImageProvider,
              ),
              SizedBox(width: SizeConfig.blockWidth * 3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: SizeConfig.blockWidth * 4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      hospital,
                      style: TextStyle(fontSize: SizeConfig.blockWidth * 3.5),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bloodType,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: SizeConfig.blockWidth * 4,
                    ),
                  ),
                  Text(
                    distance,
                    style: TextStyle(fontSize: SizeConfig.blockWidth * 3.5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}