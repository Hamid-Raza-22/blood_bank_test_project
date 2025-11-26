import 'package:blood_bank_test_project/screens/need_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/size_helper.dart';
import '../controller/option_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/top_header.dart';
import 'donor_screen.dart';
import 'home_screen.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    final OptionController controller = Get.put(OptionController());

    // Initialize SizeConfig
    SizeConfig().init(context);

    return Scaffold(
      body: Column(
        children: [
          // 🔹 Reusable Header
          const CustomHeader(title: "Choose Option", showBack: true),

          SizedBox(height: SizeConfig.blockHeight * 3),

          // 🔹 Two Cards (Need Blood / Find Donor)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockWidth * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Card for Needing Blood
                CustomCard(
                  icon: Icons.clean_hands_outlined,
                  text: "Need Blood",
                  onTap: () {
                    controller.navigateToNeedBlood();
                  },
                ),
                // Card for Finding Donor
                CustomCard(
                  icon: Icons.bloodtype_rounded,
                  text: "Find Donor",
                  onTap: () {
                    controller.navigateToFindDonor();
                  },
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
                controller.navigateToHome();
              },
            ),
          ),
        ],
      ),
    );
  }
}