import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/size_helper.dart';
import '../controller/bottom_nav_controller.dart';
import '../controller/auth_controller.dart';
import '../widgets/center_image_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color primaryRed = const Color(0xFF8B0000);
  final AuthController controller = Get.find();
  final TextEditingController nameController = TextEditingController();
  bool _isLoading = true;

  bool switch1 = true;
  bool switch2 = false;
  bool switch3 = true;

  @override
  void initState() {
    super.initState();
    final NavController navController = Get.find();
    navController.currentIndex.value = 3;
    print("ProfileScreen LOG: initState - Set nav index to 3 (Profile)");

    Future.delayed(const Duration(milliseconds: 500), () {
      final User? user = FirebaseAuth.instance.currentUser;
      print("ProfileScreen LOG: initState - User is ${user != null ? 'not null' : 'null'}");
      if (user != null) {
        print("ProfileScreen LOG: User email: ${user.email ?? 'null'}, displayName: ${user.displayName ?? 'null'}, photoURL: ${user.photoURL ?? 'null'}");
      } else {
        print("ProfileScreen LOG: No user found in initState, will redirect in build");
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _showEditProfileDialog() {
    final User? user = FirebaseAuth.instance.currentUser;
    print("ProfileScreen LOG: Opening edit dialog, user: ${user?.email ?? 'null'}");
    nameController.text = user?.displayName ?? '';

    Get.dialog(
      AlertDialog(
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Display Name",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              print("ProfileScreen LOG: Edit dialog cancelled");
              Get.back();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                print("ProfileScreen LOG: Saving new display name: ${nameController.text.trim()}");
                await controller.updateProfile(nameController.text.trim());
                setState(() {}); // Refresh UI
                Get.back();
              } else {
                Get.snackbar("Error", "Name cannot be empty");
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget bloodStatsCard() {
    print("ProfileScreen LOG: Building bloodStatsCard");
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

  Widget switchItem(String title, bool value, Function(bool) onChanged) {
    print("ProfileScreen LOG: Building switchItem: $title");
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
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return primaryRed;
              }
              return Colors.white;
            }),
            trackOutlineColor: MaterialStateProperty.all(Colors.grey[300]),
            overlayColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return primaryRed.withOpacity(0.2);
              }
              return Colors.grey.withOpacity(0.2);
            }),
            value: value,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            thumbIcon: MaterialStateProperty.resolveWith((states) {
              if (!states.contains(MaterialState.selected)) {
                return Icon(
                  Icons.circle,
                  color: Colors.white,
                  size: SizeConfig.blockWidth * 6,
                  shadows: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                );
              }
              return null;
            }),
          ),
        ],
      ),
    );
  }

  Widget forwardItem(String title, Function() onTap) {
    print("ProfileScreen LOG: Building forwardItem: $title");
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print("ProfileScreen LOG: build - SizeConfig initialized");

    if (_isLoading) {
      print("ProfileScreen LOG: Showing loading indicator while auth settles");
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final User? user = FirebaseAuth.instance.currentUser;
    print("ProfileScreen LOG: build - User is ${user != null ? 'not null' : 'null'}");
    if (user == null) {
      print("ProfileScreen LOG: User is null, redirecting to login");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("ProfileScreen LOG: Executing redirect to /login");
        Get.offAllNamed('/login');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    print("ProfileScreen LOG: Building profile UI with email: ${user.email ?? 'null'}, displayName: ${user.displayName ?? 'null'}, photoURL: ${user.photoURL ?? 'null'}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: SizeConfig.blockHeight * 12),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CustomCenterProfileHeader(
                  title: user.displayName ?? "No Name",
                  userId: user.email ?? "No Email",
                  avatarUrl: user.photoURL ?? "assets/user1.png",
                  showBack: true,
                  onBackTap: () {
                    print("ProfileScreen LOG: Back button tapped");
                    Get.back();
                  },
                  onEditTap: _showEditProfileDialog,
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
            forwardItem("Manage Address", () {}),
            forwardItem("History", () {}),
            forwardItem("Contact Details", () {}),
            SizedBox(height: SizeConfig.blockHeight * 1),
            GestureDetector(
              onTap: () {
                print("ProfileScreen LOG: Logout tapped");
                controller.signOut();
              },
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
      bottomNavigationBar: const CustomBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {},
        backgroundColor: primaryRed,
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