import 'package:flutter/material.dart';

import '../constant/size_helper.dart';

class BloodRequestCard extends StatelessWidget {
  final String bloodType;
  final String title;
  final String hospital;
  final String date;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const BloodRequestCard({
    super.key,
    required this.bloodType,
    required this.title,
    required this.hospital,
    required this.date,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: SizeConfig.blockWidth * 4,
                backgroundColor: Color(0xFF8B0000),
                child: Text(
                  bloodType,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.blockWidth * 3.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.blockWidth * 3),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.blockWidth * 4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.blockHeight * 1.5),
          Row(
            children: [
              Icon(Icons.home_work_outlined, size: SizeConfig.blockWidth * 3.5, color: Colors.grey),
              SizedBox(width: SizeConfig.blockWidth),
              Text(
                hospital,
                style: TextStyle(fontSize: SizeConfig.blockWidth * 3.5, color: Colors.grey),
              ),
              SizedBox(width: SizeConfig.blockWidth * 4),
              Icon(Icons.calendar_today, size: SizeConfig.blockWidth * 3.5, color: Colors.grey),
              SizedBox(width: SizeConfig.blockWidth),
              Text(
                date,
                style: TextStyle(fontSize: SizeConfig.blockWidth * 3.5, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.blockHeight * 2),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    padding: EdgeInsets.symmetric(vertical: SizeConfig.blockHeight * 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Accept",style: TextStyle(color: Colors.white),),
                ),
              ),
              SizedBox(width: SizeConfig.blockWidth * 4),
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: SizeConfig.blockHeight * 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Decline"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}