import 'package:blood_bank_test_project/screens/need_screen.dart';
import 'package:flutter/material.dart';
import '../constant/size_helper.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/top_header.dart';
import 'find_donor_screen.dart';
import 'home_screen.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔹 Reusable Header
          const CustomHeader(title: "Choose Option", showBack: true),

          SizedBox(height: SizeConfig.blockHeight * 3),

          // 🔹 Two Cards in a Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockWidth * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [
                CustomCard(
                  icon: Icons.clean_hands_outlined,
                  text: "Need ",
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>BloodNeededScreen()));},
                ),
                CustomCard(
                  icon: Icons.bloodtype_rounded,
                  text: "Donor",
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>FindDonorScreen()));},
                ),
              ],
            ),
          ),

          const Spacer(),

          // 🔹 Next Button
          Padding(
            padding: EdgeInsets.all(SizeConfig.blockWidth * 5),
            child: CustomButton(
              text: "Next",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
              },
            ),
          )
        ],
      ),
    );
  }
}
