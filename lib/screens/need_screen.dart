import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/Get.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/size_helper.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_drop_down.dart';
import '../widgets/custom_text_field.dart';
import '../controller/blood_needed_controller.dart';

class BloodNeededScreen extends StatelessWidget {
  const BloodNeededScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? donorId = Get.arguments?['donorId']; // donorId from arguments
    SizeConfig().init(context);
    final controller = Get.put(BloodNeededController());

    debugPrint("BloodNeededScreen LOG: Initialized with donorId: $donorId");

    if (donorId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'No donor selected', backgroundColor: Colors.red, colorText: Colors.white);
        Get.back();
      });
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Request Blood"),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: "Patient Name",
                hint: "Enter patient name",
                controller: controller.patientNameController,
                icon: FontAwesomeIcons.person,
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              CustomTextField(
                label: "Age",
                hint: "Enter patient age",
                controller: controller.ageController,
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              CustomTextField(
                label: "Disease",
                hint: "Enter disease",
                controller: controller.diseaseController,
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              CustomTextField(
                label: "Contact",
                hint: "Enter contact number",
                controller: controller.contactController,
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              CustomTextField(
                label: "Hospital",
                hint: "Enter hospital name",
                controller: controller.hospitalController,
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              CustomTextField(
                label: "Location",
                hint: "Enter location",
                controller: controller.locationController,
                icon: FontAwesomeIcons.locationDot,
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              Obx(
                    () => CustomDropdown<String>(
                  label: "Blood Group",
                  value: controller.selectedBloodType.value.isEmpty ? null : controller.selectedBloodType.value,
                  items: const ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'],
                  onChanged: (value) {
                    if (value != null) controller.setBloodType(value);
                  },
                ),
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              Obx(
                    () => CustomDropdown<int>(
                  label: "Units",
                  value: controller.units.value == 0 ? null : controller.units.value,
                  onChanged: (value) {
                    if (value != null) controller.setUnits(value);
                  },
                  items: [1, 2, 3, 4, 5],
                ),
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              CustomTextField(
                label: "Date Needed",
                hint: "YYYY-MM-DD",
                controller: controller.dateController,
                icon: Icons.calendar_today,
              ),
              SizedBox(height: SizeConfig.blockHeight * 3),
              CustomButton(
                text: "Submit Request",
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.submitRequest(), // Bas yeh line change kar do
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}