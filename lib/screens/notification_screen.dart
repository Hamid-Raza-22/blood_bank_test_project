import 'package:flutter/material.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/size_helper.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final Color primaryRed = const Color(0xFF8B0000);

    // Sample notifications with more items
    final List<Map<String, String>> todayNotifications = [
      {
        "image": "assets/user1.png",
        "name": "Ali Khan",
        "message": "Requested A+ blood urgently",
        "time": "10:15 AM"
      },
      {
        "image": "assets/user2.png",
        "name": "Sara Ahmed",
        "message": "B+ blood donation available",
        "time": "11:30 AM"
      },
      {
        "image": "assets/user5.png",
        "name": "Ahmed Raza",
        "message": "O- blood needed at City Hospital",
        "time": "1:20 PM"
      },
      {
        "image": "assets/user6.png",
        "name": "Zara Khan",
        "message": "AB+ blood donation confirmed",
        "time": "2:45 PM"
      },
    ];

    final List<Map<String, String>> yesterdayNotifications = [
      {
        "image": "assets/user3.png",
        "name": "Usman Ali",
        "message": "O+ blood needed at City Hospital",
        "time": "3:20 PM"
      },
      {
        "image": "assets/user4.png",
        "name": "Hina Malik",
        "message": "AB+ blood donation done",
        "time": "5:45 PM"
      },
      {
        "image": "assets/user7.png",
        "name": "Bilal Shah",
        "message": "B- blood requested urgently",
        "time": "6:30 PM"
      },
      {
        "image": "assets/user8.png",
        "name": "Ayesha Iqbal",
        "message": "A+ blood available for donation",
        "time": "7:15 PM"
      },
    ];

    // Reusable notification section widget with reduced header height
    Widget notificationSection(
        String title, List<Map<String, String>> notifications) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            width: double.infinity,
            color: primaryRed,
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockHeight * 1, // reduced height
                horizontal: SizeConfig.blockWidth * 4),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.blockWidth * 4.5,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          // Notifications list
          ...notifications.map((notif) => Container(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockHeight * 1.5,
                horizontal: SizeConfig.blockWidth * 3),
            margin:
            EdgeInsets.symmetric(vertical: SizeConfig.blockHeight * 0.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left image
                CircleAvatar(
                  radius: SizeConfig.blockWidth * 6,
                  backgroundImage: AssetImage(notif["image"]!),
                ),
                SizedBox(width: SizeConfig.blockWidth * 3),
                // Name & message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif["name"]!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockWidth * 4,
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockHeight * 0.5),
                      Text(
                        notif["message"]!,
                        style: TextStyle(
                          fontSize: SizeConfig.blockWidth * 3.8,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                // Time
                Text(
                  notif["time"]!,
                  style: TextStyle(
                    fontSize: SizeConfig.blockWidth * 3.5,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ))
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Notifications"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.blockWidth * 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            notificationSection("Today", todayNotifications),
            SizedBox(height: SizeConfig.blockHeight * 2),
            notificationSection("Yesterday", yesterdayNotifications),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: primaryRed,
        onPressed: () {
          // FAB action
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
