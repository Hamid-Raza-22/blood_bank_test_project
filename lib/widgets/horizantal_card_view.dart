import 'package:flutter/material.dart';

import '../constant/size_helper.dart';

class HorizantalCardView extends StatelessWidget {
  const HorizantalCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("You can become a Blood Donor in",
                    style: TextStyle(fontSize: SizeConfig.blockWidth * 3.5)),
                SizedBox(height: SizeConfig.blockHeight * 0.5),
                Text("2 Easy Steps",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockWidth * 4.5)),
                Text("Become a Donor Now",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: SizeConfig.blockWidth * 3.5)),
              ],
            ),
          ),
          Image.network(
            "https://cdn-icons-png.flaticon.com/512/2966/2966486.png",
            height: SizeConfig.blockHeight * 7,
          )
        ],
      ),
    );
  }
}