// screens/donor_screen.dart
import 'package:blood_bank_test_project/screens/blood_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:get/Get.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/size_helper.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_drop_down.dart';
import '../widgets/custom_text_field.dart' show CustomTextField;
import '../widgets/select_group_grid.dart';
import '../controller/request_controller.dart';
import '../controller/auth_controller.dart';
import '../controller/bottom_nav_controller.dart';

class DonorScreen extends StatefulWidget {
  const DonorScreen({super.key});

  @override
  State<DonorScreen> createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController();
    
    // Set nav index to 1 (Donors)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<NavController>().currentIndex.value = 1;
    });
    
    final controller = Get.find<RequestController>();
    _updateCityText(controller.city.value);
    ever(controller.city, (String city) => _updateCityText(city));
    ever<bool>(controller.isDonorAdded, (isAdded) {
      if (isAdded) {
        Future.delayed(const Duration(milliseconds: 800), () {
          controller.resetDonorForm();
          Get.offAllNamed('/home');
        });
      }
    });
  }

  void _updateCityText(String city) {
    _cityController.text = city.isEmpty ? "Auto-detected" : city;
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(title: "Find Donor", onTap: () => Get.toNamed('/notifications')),
        body: Obx(() {
          final controller = Get.find<RequestController>();

          if (controller.isDonorAdded.value) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),
                  SizedBox(height: 16),
                  Text("Donor Registered!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  crossAxisSpacing: SizeConfig.blockWidth * 2,
                  mainAxisSpacing: SizeConfig.blockHeight * 2,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.8,
                  children: [
                    _buildGridItem("A+", controller),
                    _buildGridItem("B+", controller),
                    _buildGridItem("O+", controller),
                    _buildGridItem("AB+", controller),
                    _buildGridItem("A-", controller),
                    _buildGridItem("B-", controller),
                    _buildGridItem("O-", controller),
                    _buildGridItem("AB-", controller),
                  ],
                )),

                SizedBox(height: SizeConfig.blockHeight * 2),

                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Available Blood units", style: TextStyle(fontWeight: FontWeight.w600, fontSize: SizeConfig.blockWidth * 4)),
                    SizedBox(
                      width: SizeConfig.blockWidth * 13,
                      child: CustomDropdown(
                        value: controller.units.value,
                        onChanged: (val) => controller.setUnits(val ?? 1),
                        label: '',
                        items: const [1, 2, 3, 4, 5],
                      ),
                    ),
                  ],
                )),

                SizedBox(height: SizeConfig.blockHeight * 2),
                CustomTextField(label: "Your Location", hint: "Auto-detected", controller: _cityController),
                SizedBox(height: SizeConfig.blockHeight * 3),

                CustomButton(text: "Submit Donor", onPressed: _submitDonor),
              ],
            ),
          );
        }),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }

  Widget _buildGridItem(String type, RequestController controller) {
    return GridItem(
      icon: FontAwesomeIcons.droplet,
      text: "Blood $type",
      isSelected: controller.selectedBloodType.value == type,
      onTap: () => controller.setBloodType(type),
    );
  }

  Future<void> _submitDonor() async {
    final controller = Get.find<RequestController>();
    final authController = Get.find<AuthController>();

    if (controller.selectedBloodType.value.isEmpty) {
      Get.snackbar('Error', 'Please select a blood type', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (controller.units.value <= 0) {
      Get.snackbar('Error', 'Please select valid units', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final userId = authController.firebaseUser.value?.uid;
    if (userId == null) {
      Get.snackbar('Error', 'User not logged in', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      Location location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) throw Exception("Service disabled");
      }
      PermissionStatus permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission != PermissionStatus.granted) throw Exception("Permission denied");
      }
      LocationData loc = await location.getLocation();
      if (loc.latitude == null || loc.longitude == null) throw Exception("Invalid location");

      List<Placemark> placemarks = await placemarkFromCoordinates(loc.latitude!, loc.longitude!);
      String city = placemarks.isNotEmpty
          ? (placemarks.first.locality ?? placemarks.first.administrativeArea ?? 'Unknown')
          : 'Unknown';

      await controller.addDonor(
        userId: userId,
        name: authController.firebaseUser.value?.displayName ?? 'Unknown',
        bloodType: controller.selectedBloodType.value,
        units: controller.units.value,
        location: GeoPoint(loc.latitude!, loc.longitude!),
        city: city,
        photoUrl: authController.firebaseUser.value?.photoURL ?? 'assets/user1.png',
      );

      Get.snackbar('Success', 'Donor registered in $city!', backgroundColor: Colors.green, colorText: Colors.white,
          duration: const Duration(seconds: 2));
      
      // Navigation handled by Obx
    } on Exception catch (e) {
      String msg = e.toString().replaceFirst('Exception: ', '');
      if (msg.contains('Already registered')) {
        Get.snackbar('Already Donor', 'You are already registered!', backgroundColor: Colors.orange, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Failed: $msg', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to register donor.', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}