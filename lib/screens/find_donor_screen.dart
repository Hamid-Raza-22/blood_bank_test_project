import 'package:blood_bank_test_project/screens/blood_request_screen.dart';
import 'package:blood_bank_test_project/screens/need_screen.dart';
import 'package:blood_bank_test_project/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_drop_down.dart';
import '../widgets/select_group_grid.dart';
import 'notification_screen.dart';

class FindDonorScreen extends StatefulWidget {
  const FindDonorScreen({super.key});

  @override
  State<FindDonorScreen> createState() => _FindDonorScreenState();
}

class _FindDonorScreenState extends State<FindDonorScreen> {
  int _selectedUnits = 1;
  final TextEditingController _locationController = TextEditingController();

  void _onItemTapped(int index) {
  }

  void _onCenterTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Center button tapped")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Initialize SizeConfig for responsiveness
    SizeConfig().init(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:  CustomAppBar(title: "Find Donor",
        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen()));},),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(SizeConfig.blockWidth * 4), // responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Grid (8 items)
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: SizeConfig.blockWidth * 2,
                mainAxisSpacing: SizeConfig.blockHeight * 2,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.8, // ✅ prevent overflow
                children: const [
                  GridItem(icon: Icons.bloodtype, text: "Blood A+"),
                  GridItem(icon: Icons.bloodtype, text: "Blood B+"),
                  GridItem(icon: Icons.bloodtype, text: "Blood O+"),
                  GridItem(icon: Icons.bloodtype, text: "Blood AB+"),
                  GridItem(icon: Icons.bloodtype, text: "Blood A-"),
                  GridItem(icon: Icons.bloodtype, text: "Blood B-"),
                  GridItem(icon: Icons.bloodtype, text: "Blood O-"),
                  GridItem(icon: Icons.bloodtype, text: "Blood AB-"),
                ],
              ),

              SizedBox(height: SizeConfig.blockHeight * 2),

              /// 🔹 Row with text + dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Blood units needed",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.blockWidth * 4,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.blockWidth * 13, // ✅ fix width dropdown
                    child: CustomDropdown(
                      value: _selectedUnits,
                      onChanged: (val) {
                        setState(() => _selectedUnits = val ?? 1);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.blockHeight * 2),

              /// 🔹 Location field
              CustomTextField(
                label: "Enter Your Location",
                hint: "select location",
                controller: _locationController,
              ),

              SizedBox(height: SizeConfig.blockHeight * 3),

              /// 🔹 Find Donor Button
              CustomButton(
                text: "Find Donor",
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>BloodRequestScreen()));
                },
              ),
            ],
          ),
        ),

        /// 🔹 Bottom Navigation
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 0,
          onTap: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: _onCenterTap,
          backgroundColor: const Color(0xFF8B0000),
          child: Icon(
            Icons.add,
            size: SizeConfig.blockWidth * 8,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
