import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/Get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_request_tile.dart';
import '../widgets/header_with_profie.dart';
import '../widgets/horizantal_card_view.dart';
import '../constant/size_helper.dart';
import '../controller/bottom_nav_controller.dart';
import '../controller/home_controller.dart';
import '../controller/request_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final NavController navController = Get.find();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navController.currentIndex.value = 0;
    });
    Get.put(HomeController());
    Get.put(RequestController());
    print("HomeScreen LOG: initState - Set nav index to 0 (Home)");
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    Location location = Location();
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          print("HomeScreen LOG: Location services disabled");
          return;
        }
      }
      PermissionStatus permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission != PermissionStatus.granted) {
          print("HomeScreen LOG: Location permission denied");
          return;
        }
      }
      LocationData loc = await location.getLocation();
      Get.find<RequestController>().setCoordinates(loc.latitude!, loc.longitude!);
      print("HomeScreen LOG: User location set - Lat: ${loc.latitude}, Lng: ${loc.longitude}");
    } catch (e) {
      print("HomeScreen LOG: Failed to get location: $e");
      Get.find<RequestController>().setCoordinates(31.5204, 74.3587);
    }
  }

  void _onCenterTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Center button tapped")),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print("HomeScreen LOG: build - SizeConfig initialized");

    final User? user = FirebaseAuth.instance.currentUser;
    print("HomeScreen LOG: build - User is ${user != null ? 'not null' : 'null'}, UID: ${user?.uid}");
    if (user == null) {
      print("HomeScreen LOG: User is null, redirecting to login");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("HomeScreen LOG: Executing redirect to /login");
        Get.offAllNamed('/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    print(
        "HomeScreen LOG: Building home UI with email: ${user.email ?? 'null'}, displayName: ${user.displayName ?? 'null'}, photoURL: ${user.photoURL ?? 'null'}");

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
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
                        print("HomeScreen LOG: Messenger button tapped");
                        Get.toNamed('/chatList');
                      },
                      onNotificationTap: () {
                        print("HomeScreen LOG: Notification button tapped");
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CustomCard(
                            icon: Icons.search,
                            text: "Find Donors",
                            onTap: () {
                              print("HomeScreen LOG: Find Donors tapped");
                              Get.toNamed('/donors');
                            },
                          ),
                          SizedBox(width: SizeConfig.blockWidth * 4),
                          CustomCard(
                            icon: Icons.water_drop,
                            text: "Request for blood",
                            onTap: () {
                              print("HomeScreen LOG: Request for blood tapped");
                              Get.toNamed('/request');
                            },
                          ),
                          SizedBox(width: SizeConfig.blockWidth * 4),
                          CustomCard(
                            icon: Icons.info,
                            text: "BloodInstructions",
                            onTap: () {
                              print("HomeScreen LOG: Blood Instructions tapped");
                              Get.toNamed('/bloodInstruction');
                            },
                          ),
                        ],
                      ),
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
                            print("HomeScreen LOG: See all tapped");
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
                          print("HomeScreen ERROR: Stream error - ${snapshot.error}");
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

                        // SIRF DOOSRE USERS KE DONORS
                        for (var doc in snapshot.data!.docs) {
                          final data = doc.data() as Map<String, dynamic>;
                          final userId = data['userId'] as String?;
                          if (userId != null && userId != currentUserId) {
                            filteredDonors.add(doc);
                          }
                        }

                        if (filteredDonors.isEmpty) {
                          print("HomeScreen LOG: No other donors found");
                          return const Center(
                            child: Text(
                              "No other donors available",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }

                        print("HomeScreen LOG: Showing ${filteredDonors.length} other donors");

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

                            print("HomeScreen LOG: Donor ${doc.id} - name: ${data['name']}, city: ${data['city']}, bloodType: ${data['bloodType']}");

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
                                }

                              // onTap: () {
                              //
                                // final data = doc.data() as Map<String, dynamic>;
                                // Get.toNamed('/request', arguments: {
                                //   'donorId': doc.id,
                                //   'donorUserId': data['userId'],  // Yeh field donors collection mein hona chahiye!
                                // });
                              // },
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
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
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
