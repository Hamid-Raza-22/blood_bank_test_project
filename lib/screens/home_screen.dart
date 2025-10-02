import 'package:blood_bank_test_project/screens/chat_list_screen.dart';
import 'package:blood_bank_test_project/screens/find_donor_screen.dart';
import 'package:blood_bank_test_project/widgets/header_with_profie.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bottom_navigation/bottom_navigation_bar.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_request_tile.dart';
import '../widgets/horizantal_card_view.dart';
import '../constant/size_helper.dart';
import 'blood_instruction_screen.dart';
import 'need_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    Center(child: Text("Home")),
    Center(child: Text("Donor")),
    Center(child: Text("Need")),
    Center(child: Text("Profile")),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onCenterTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Center button tapped")),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // ✅ Initialize SizeConfig

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body:
      SafeArea(
        bottom: false,

        child: SingleChildScrollView(
          child: Column(
            children: [
              /// 🔹 Header + Overlapping HorizantalCardView
              Stack(
                clipBehavior: Clip.none,
                children: [
                  /// Header
                  CustomProfileHeader(
                    title: "Muhammad Ahmad",
                    userId: "User ID: 915470",
                    avatarUrl: "https://randomuser.me/api/portraits/men/32.jpg",
                    onButtonTap: (){Navigator.push(context,  MaterialPageRoute(builder: (context)=>ChatScreen()));},
                    onNotificationTap:  (){Navigator.push(context,  MaterialPageRoute(builder: (context)=>NotificationScreen()));},
                  ),

                  /// HorizantalCardView overlapped
                  Positioned(
                    bottom: -SizeConfig.blockHeight * 6, // half inside, half outside
                    left: 0,
                    right: 0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: SizeConfig.blockWidth * 2),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.8,
                            child: const HorizantalCardView(),
                          ),
                          SizedBox(width: SizeConfig.blockWidth * 2),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.8,
                            child: const HorizantalCardView(),
                          ),
                          SizedBox(width: SizeConfig.blockWidth * 2),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.8,
                            child: const HorizantalCardView(),
                          ),
                          SizedBox(width: SizeConfig.blockWidth * 2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              /// Space for overlap
              SizedBox(height: SizeConfig.blockHeight * 10),

              /// 🔹 Rest of Content
              Padding(
                padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
                child: Column(
                  children: [
                    /// 🔹 Scrollable Row of 3 Custom Cards
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CustomCard(
                            icon: Icons.search,
                            text: "Find Donors",
                            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const FindDonorScreen()));},
                          ),
                          SizedBox(width: SizeConfig.blockWidth * 4),
                          CustomCard(
                            icon: Icons.water_drop,
                            text: "Request\nfor blood",
                            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const BloodNeededScreen()));},
                          ),
                          SizedBox(width: SizeConfig.blockWidth * 4),
                          CustomCard(
                            icon: Icons.info,
                            text: "Blood\nInstructions",
                            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const BloodInstructionScreen()));},
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockHeight * 3),

                    /// 🔹 Blood Needed Section
                    Container(
                      padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Blood Needed",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.blockWidth * 4.2,
                            ),
                          ),
                          SizedBox(height: SizeConfig.blockHeight * 1.5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              _BloodTypeWidget("B+"),
                              _BloodTypeWidget("O+"),
                              _BloodTypeWidget("AB+"),
                              _BloodTypeWidget("O-"),
                              _BloodTypeWidget("AB-"),
                              _BloodTypeWidget("A+"),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: SizeConfig.blockHeight * 3),

                    /// 🔹 Donation Request Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Donation Request",
                          style: TextStyle(
                            fontSize: SizeConfig.blockWidth * 4.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "See all",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: SizeConfig.blockWidth * 3.5,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: SizeConfig.blockHeight * 2),

                    /// 🔹 Donation Request List
                    const CustomRequestTile(
                      name: "Safina Firdaus",
                      hospital: "Better Life Hospital",
                      distance: "3km",
                      bloodType: "A+",
                      imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
                    ),
                    const CustomRequestTile(
                      name: "Safina Firdaus",
                      hospital: "Better Life Hospital",
                      distance: "3km",
                      bloodType: "B+",
                      imageUrl: "https://randomuser.me/api/portraits/women/47.jpg",
                    ),
                    const CustomRequestTile(
                      name: "Safina Firdaus",
                      hospital: "Better Life Hospital",
                      distance: "3km",
                      bloodType: "O-",
                      imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      /// 🔹 Bottom Navigation
      bottomNavigationBar: CustomBottomNavBar(

        onTap: _onItemTapped,
        currentIndex: _selectedIndex,

      ),

      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: _onCenterTap,
        backgroundColor: const Color(0xFF8B0000),
        child: Icon(
          FontAwesomeIcons.plus,
          size: SizeConfig.blockWidth * 8,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

/// 🔹 BloodType Widget Responsive
class _BloodTypeWidget extends StatelessWidget {
  final String bloodType;
  const _BloodTypeWidget(this.bloodType);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.bloodtype,
          color: Colors.red,
          size: SizeConfig.blockWidth * 8,
        ),
        SizedBox(height: SizeConfig.blockHeight * 0.5),
        Text(
          bloodType,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.blockWidth * 3.8,
          ),
        ),
      ],
    );
  }
}
