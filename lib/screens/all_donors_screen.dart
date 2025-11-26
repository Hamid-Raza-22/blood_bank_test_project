import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/size_helper.dart';
import '../controller/request_controller.dart';
import '../widgets/custom_request_tile.dart';

class AllDonorsScreen extends StatelessWidget {
  const AllDonorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Donors"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.blockWidth * 4),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('donors')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                debugPrint("AllDonorsScreen ERROR: Stream error - ${snapshot.error}");
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
                return const Center(
                  child: Text(
                    "No other donors available",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredDonors.length,
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
                      Get.toNamed('/need', arguments: {'donorId': doc.id});
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}