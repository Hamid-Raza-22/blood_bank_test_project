import 'package:blood_bank_test_project/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../constant/size_helper.dart';
import 'notification_screen.dart';

class BloodNeededScreen extends StatefulWidget {
  const BloodNeededScreen({super.key});

  @override
  State<BloodNeededScreen> createState() => _BloodNeededScreenState();
}

class _BloodNeededScreenState extends State<BloodNeededScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();
  final TextEditingController diseaseController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController unitsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  void _onItemTapped(int index) {
    // handle bottom nav tap
  }

  void _submitRequest() {
    // handle form submission
    print("Blood request submitted:");
    print("Name: ${nameController.text}");
    print("Blood Type: ${bloodTypeController.text}");
    print("Hospital: ${hospitalController.text}");
    print("City: ${diseaseController.text}");
    print("Contact: ${contactController.text}");
    print("Units: ${unitsController.text}");
    print("Date: ${dateController.text}");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: 'Needed Blood',
       onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));},

        ),


      body: Padding(
        padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                controller: nameController,
                label: 'Patient Name', hint: 'Enter Patient Name',
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              CustomTextField(
                controller: bloodTypeController,
                label: 'Blood Type', hint: 'select blood type',
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              CustomTextField(
                controller: hospitalController,
                 label: 'Age', hint: 'Enter patient age',
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              CustomTextField(
                controller: diseaseController,
                 label: 'Disease Name', hint: 'Enter disease name',
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              CustomTextField(
                controller: contactController,
                 label: '', hint: '',
              ),
              SizedBox(height: SizeConfig.blockHeight * 2),
              CustomTextField(
                controller: unitsController,
                label: 'Location', hint: 'location',
                suffixIcon:Icon(Icons.location_on_rounded),
              ),

              SizedBox(height: SizeConfig.blockHeight * 3),
              CustomButton(
                text: "Submit Request",
                onPressed: _submitRequest,
                color: const Color(0xFF8B0000),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: const Color(0xFF8B0000),
        onPressed: () {
          // handle FAB action
        },
        child: const Icon(Icons.add, color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: _onItemTapped,
      ),
    );
  }
}
