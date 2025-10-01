import 'package:flutter/material.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/size_helper.dart';
import '../widgets/center_image_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color primaryRed = const Color(0xFF8B0000);

  // Switch states
  bool switch1 = true;
  bool switch2 = false;
  bool switch3 = true;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // Card view widget
    Widget bloodStatsCard() {
      return Container(
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockWidth * 4,
            vertical: SizeConfig.blockHeight * 1),
        padding: EdgeInsets.all(SizeConfig.blockWidth * 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side
            Column(
              children: [
                Icon(Icons.favorite,
                    color: primaryRed, size: SizeConfig.blockWidth * 6),
                SizedBox(height: SizeConfig.blockHeight * 0.5),
                Text(
                  "3 Life Saved",
                  style: TextStyle(fontSize: SizeConfig.blockWidth * 3.2),
                ),
              ],
            ),
            // Center
            Column(
              children: [
                Icon(Icons.bloodtype,
                    color: primaryRed, size: SizeConfig.blockWidth * 6),
                SizedBox(height: SizeConfig.blockHeight * 0.5),
                Text(
                  "A+",
                  style: TextStyle(fontSize: SizeConfig.blockWidth * 3.2),
                ),
              ],
            ),
            // Right side
            Column(
              children: [
                Text(
                  "12 Sep 2024",
                  style: TextStyle(
                      fontSize: SizeConfig.blockWidth * 3.2,
                      color: Colors.grey[600]),
                ),
                SizedBox(height: SizeConfig.blockHeight * 0.5),
                Text(
                  "Next Donation",
                  style: TextStyle(
                      fontSize: SizeConfig.blockWidth * 3.2,
                      color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Switch item
    Widget switchItem(String title, bool value, Function(bool) onChanged) {
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockWidth * 4,
            vertical: SizeConfig.blockHeight * 1.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: SizeConfig.blockHeight * 0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: SizeConfig.blockWidth * 4),
            ),
            Switch(
              activeColor: primaryRed,
              value: value,
              onChanged: onChanged,
            )
          ],
        ),
      );
    }

    // Forward item
    Widget forwardItem(String title, Function() onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockWidth * 4,
              vertical: SizeConfig.blockHeight * 1.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2))
            ],
          ),
          margin: EdgeInsets.symmetric(vertical: SizeConfig.blockHeight * 0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: SizeConfig.blockWidth * 4),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: SizeConfig.blockWidth * 4, color: Colors.grey[600])
            ],
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.blockHeight * 12),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomCenterProfileHeader(
                    title: "Ali Khan",
                    userId: "UserID: 12345",
                    avatarUrl: "assets/user1.png",
                    showBack: true,
                    onBackTap: () => Navigator.pop(context),
                    onEditTap: () {},
                  ),
                  Positioned(
                    top: SizeConfig.blockHeight * 20,
                    left: 0,
                    right: 0,
                    child: bloodStatsCard(),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockHeight * 14),
              // Switches
              switchItem("Available to donate", switch1, (val) {
                setState(() {
                  switch1 = val;
                });
              }),
              switchItem("Notification", switch2, (val) {
                setState(() {
                  switch2 = val;
                });
              }),
              switchItem("Allow Talking", switch3, (val) {
                setState(() {
                  switch3 = val;
                });
              }),
              SizedBox(height: SizeConfig.blockHeight * 1),
              // Forward items
              forwardItem("Manage Address", () {}),
              forwardItem("History", () {}),
              forwardItem("Contact Details", () {}),
              SizedBox(height: SizeConfig.blockHeight * 1),
              // Logout button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockWidth * 4,
                      vertical: SizeConfig.blockHeight * 1.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  margin: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockHeight * 0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: SizeConfig.blockWidth * 4,
                            color: primaryRed,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryRed,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
