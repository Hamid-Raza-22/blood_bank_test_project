import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/Get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/size_helper.dart';
import '../widgets/blood_request_card.dart';

class BloodRequestScreen extends StatelessWidget {
  const BloodRequestScreen({super.key});

  void _updateRequestStatus(String requestId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .update({'status': status});

      Get.snackbar(
        status == 'accepted' ? 'Accepted' : 'Declined',
        status == 'accepted'
            ? 'You have accepted the blood request.'
            : 'You have declined the request.',
        backgroundColor: status == 'accepted' ? Colors.green : Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to update: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Blood Requests"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: user == null
            ? const Center(child: Text('Please log in to view requests'))
            : StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('requests')
              .where('requestToUid',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid) // صرف یہی
              .where('status', isEqualTo: 'pending')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading requests'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final requests = snapshot.data?.docs ?? [];

            if (requests.isEmpty) {
              return const Center(
                child: Text(
                  "No pending blood requests",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final data = requests[index].data() as Map<String, dynamic>;
                final requestId = requests[index].id;

                return BloodRequestCard(
                  bloodType: data['bloodType'] ?? 'N/A',
                  title: data['patientName'] ?? 'Unknown Patient',
                  hospital: data['hospital'] ?? 'Unknown Hospital',
                  date: data['date'] ?? 'N/A',
                  onAccept: () => _updateRequestStatus(requestId, 'accepted'),
                  onDecline: () => _updateRequestStatus(requestId, 'declined'),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
