import 'package:blood_bank_test_project/screens/blood_instruction_screen.dart';
import 'package:flutter/material.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/size_helper.dart';
import '../widgets/blood_request_card.dart';
import 'notification_screen.dart';

class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen({super.key});

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {

  void _onItemTapped(int index) {
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // Initialize SizeConfig

    final List<Map<String, String>> requests = [
      {
        "bloodType": "A+",
        "title": "Emergency A+ Blood Needed",
        "hospital": "Better Life Hospital",
        "date": "12 Sep 2024"
      },
      {
        "bloodType": "B+",
        "title": "Emergency B+ Blood Needed",
        "hospital": "Better Life Hospital",
        "date": "12 Sep 2024"
      },
      {
        "bloodType": "AB+",
        "title": "Emergency AB+ Blood Needed",
        "hospital": "Better Life Hospital",
        "date": "12 Sep 2024"
      },
      {
        "bloodType": "O+",
        "title": "Emergency O+ Blood Needed",
        "hospital": "Better Life Hospital",
        "date": "12 Sep 2024"
      },
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Blood Request"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen()));},
          )
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
        child: ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.blockHeight * 1),
              child: BloodRequestCard(
                bloodType: request["bloodType"]!,
                title: request["title"]!,
                hospital: request["hospital"]!,
                date: request["date"]!,
                onAccept: () {},
                onDecline: () {},
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: _onItemTapped,
        // Connect with your controller
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: const Color(0xFF8B0000),
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: SizeConfig.blockWidth * 8,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}