import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_request_tile.dart';
import '../widgets/header_with_profie.dart';
import '../widgets/horizantal_card_view.dart';
import '../constant/size_helper.dart';
import '../controller/home_controller.dart';
import '../controller/request_controller.dart';
import '../controller/badge_controller.dart';

/// Home Screen Content - Used inside MainNavigationScreen
/// 
/// This is the home tab content without its own bottom navbar.
class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  @override
  void initState() {
    super.initState();
    // Ensure controllers are available
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController());
    }
    if (!Get.isRegistered<RequestController>()) {
      Get.put(RequestController());
    }
    debugPrint("HomeScreenContent LOG: initState");
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    Location location = Location();
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          debugPrint("HomeScreenContent LOG: Location services disabled");
          return;
        }
      }
      PermissionStatus permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission != PermissionStatus.granted) {
          debugPrint("HomeScreenContent LOG: Location permission denied");
          return;
        }
      }
      LocationData loc = await location.getLocation();
      Get.find<RequestController>().setCoordinates(loc.latitude!, loc.longitude!);
      debugPrint("HomeScreenContent LOG: User location set - Lat: ${loc.latitude}, Lng: ${loc.longitude}");
    } catch (e) {
      debugPrint("HomeScreenContent LOG: Failed to get location: $e");
      Get.find<RequestController>().setCoordinates(31.5204, 74.3587);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final User? user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      debugPrint("HomeScreenContent LOG: User is null, redirecting to login");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/login');
      });
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Obx(() {
                  var userData = Get.find<HomeController>().userData;
                  return CustomProfileHeader(
                    title: userData['name'] ?? user.displayName ?? "No Name",
                    userId: user.email ?? "No Email",
                    avatarUrl: user.photoURL?.isNotEmpty ?? false
                        ? user.photoURL!
                        : (userData['photoUrl']?.isNotEmpty ?? false
                        ? userData['photoUrl']
                        : "assets/user1.png"),
                    onButtonTap: () {
                      debugPrint("HomeScreenContent LOG: Messenger button tapped");
                      Get.toNamed('/chatList');
                    },
                    onNotificationTap: () {
                      debugPrint("HomeScreenContent LOG: Notification button tapped");
                      Get.toNamed('/notifications');
                    },
                  );
                }),
                Positioned(
                  bottom: -SizeConfig.blockHeight * 6,
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
            SizedBox(height: SizeConfig.blockHeight * 10),
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
              child: Column(
                children: [
                  GetBuilder<BadgeController>(
                    init: Get.isRegistered<BadgeController>()
                        ? Get.find<BadgeController>()
                        : Get.put(BadgeController(), permanent: true),
                    builder: (badgeController) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CustomCard(
                              icon: Icons.search,
                              text: "Find Donors",
                              onTap: () {
                                debugPrint("HomeScreenContent LOG: Find Donors tapped");
                                Get.toNamed('/donors');
                              },
                            ),
                            SizedBox(width: SizeConfig.blockWidth * 4),
                            Obx(() => CustomCard(
                              icon: Icons.water_drop,
                              text: "Request for blood",
                              badgeCount: badgeController.pendingRequestsCount,
                              onTap: () {
                                debugPrint("HomeScreenContent LOG: Request for blood tapped");
                                Get.toNamed('/request');
                              },
                            )),
                            SizedBox(width: SizeConfig.blockWidth * 4),
                            CustomCard(
                              icon: Icons.info,
                              text: "BloodInstructions",
                              onTap: () {
                                debugPrint("HomeScreenContent LOG: Blood Instructions tapped");
                                Get.toNamed('/bloodInstruction');
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Available Donors",
                        style: TextStyle(
                          fontSize: SizeConfig.blockWidth * 4.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          debugPrint("HomeScreenContent LOG: See all tapped");
                          Get.toNamed('/alldonors');
                        },
                        child: Text(
                          "See all",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: SizeConfig.blockWidth * 3.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 2),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('donors')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        debugPrint("HomeScreenContent ERROR: Stream error - ${snapshot.error}");
                        return const Center(child: Text('Error loading donors'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                      if (currentUserId == null) {
                        return const Center(child: Text("Login required"));
                      }

                      final List<DocumentSnapshot> filteredDonors = [];

                      for (var doc in snapshot.data!.docs) {
                        final data = doc.data() as Map<String, dynamic>;
                        final userId = data['userId'] as String?;
                        if (userId != null && userId != currentUserId) {
                          filteredDonors.add(doc);
                        }
                      }

                      if (filteredDonors.isEmpty) {
                        debugPrint("HomeScreenContent LOG: No other donors found");
                        return const Center(
                          child: Text(
                            "No other donors available",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredDonors.length > 5 ? 5 : filteredDonors.length,
                        itemBuilder: (context, index) {
                          final doc = filteredDonors[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final GeoPoint? location = data['location'] as GeoPoint?;

                          String distance = location != null
                              ? "${Get.find<RequestController>().calculateDistance(
                            Get.find<RequestController>().lat.value,
                            Get.find<RequestController>().lng.value,
                            location.latitude,
                            location.longitude,
                          ).toStringAsFixed(1)}km"
                              : "Unknown";

                          return CustomRequestTile(
                            name: data['name'] ?? "Unknown",
                            hospital: data['city'] ?? "Unknown",
                            distance: distance,
                            bloodType: data['bloodType'] ?? "",
                            imageUrl: data['photoUrl']?.isNotEmpty ?? false
                                ? data['photoUrl']
                                : "assets/user1.png",
                            isDonor: true,
                            donorId: doc.id,
                            onTap: () {
                              Get.toNamed('/need', arguments: {
                                'donorId': doc.id,
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
