import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';
import '../controller/bottom_nav_controller.dart';
import '../controller/public_need_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_drop_down.dart';
import '../widgets/custom_text_field.dart';

class PublicNeedScreen extends StatefulWidget {
  const PublicNeedScreen({super.key});

  @override
  State<PublicNeedScreen> createState() => _PublicNeedScreenState();
}

class _PublicNeedScreenState extends State<PublicNeedScreen> {
  late final PublicNeedController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PublicNeedController());
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<NavController>().currentIndex.value = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Blood Needs", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: () => controller.fetchPublicNeeds(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('public_needs')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading requests'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filter and sort client-side
          final needs = snapshot.data?.docs
              .where((doc) => doc['requesterId'] != currentUserId)
              .toList() ?? [];
          
          needs.sort((a, b) {
            final aTime = (a.data() as Map)['createdAt'] as Timestamp?;
            final bTime = (b.data() as Map)['createdAt'] as Timestamp?;
            if (aTime == null || bTime == null) return 0;
            return bTime.compareTo(aTime);
          });

          if (needs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bloodtype_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "No blood requests yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap + to post a blood request",
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: needs.length,
            itemBuilder: (context, index) {
              final data = needs[index].data() as Map<String, dynamic>;
              final needId = needs[index].id;
              return _buildNeedCard(needId, data);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNeedFormBottomSheet(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildNeedCard(String needId, Map<String, dynamic> data) {
    final createdAt = data['createdAt'] as Timestamp?;
    final timeAgo = createdAt != null
        ? _getTimeAgo(createdAt.toDate())
        : 'Just now';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with user info and blood type
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: data['requesterPhoto']?.isNotEmpty == true
                      ? NetworkImage(data['requesterPhoto'])
                      : null,
                  child: data['requesterPhoto']?.isEmpty != false
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['requesterName'] ?? 'Anonymous',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data['bloodType'] ?? 'N/A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body with details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow(Icons.person, 'Patient', data['patientName'] ?? 'N/A'),
                _buildDetailRow(Icons.local_hospital, 'Hospital', data['hospital'] ?? 'N/A'),
                _buildDetailRow(Icons.location_on, 'Location', data['location'] ?? 'N/A'),
                _buildDetailRow(Icons.water_drop, 'Units Needed', '${data['units'] ?? 1} unit(s)'),
                if (data['date']?.isNotEmpty == true)
                  _buildDetailRow(Icons.calendar_today, 'Date Needed', data['date']),
                if (data['disease']?.isNotEmpty == true)
                  _buildDetailRow(Icons.medical_services, 'Condition', data['disease']),
              ],
            ),
          ),
          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showContactInfo(data),
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Contact'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmAccept(needId, data),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Accept & Help'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showContactInfo(Map<String, dynamic> data) {
    Get.dialog(
      AlertDialog(
        title: const Text('Contact Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${data['requesterName'] ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text('Phone: ${data['contact'] ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text('Hospital: ${data['hospital'] ?? 'N/A'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmAccept(String needId, Map<String, dynamic> data) {
    Get.dialog(
      AlertDialog(
        title: const Text('Accept Blood Request?'),
        content: Text(
          'You are about to accept the blood request for ${data['bloodType']} from ${data['requesterName']}.\n\nThis will allow you to chat with the requester.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.acceptNeed(needId, data);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Accept', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showNeedFormBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Post Blood Request',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Form
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CustomTextField(
                        label: "Patient Name *",
                        hint: "Enter patient name",
                        controller: controller.patientNameController,
                        icon: FontAwesomeIcons.person,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: "Age",
                              hint: "Age",
                              controller: controller.ageController,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Obx(() => CustomDropdown<int>(
                              label: "Units *",
                              value: controller.units.value == 0 ? null : controller.units.value,
                              onChanged: (value) {
                                if (value != null) controller.setUnits(value);
                              },
                              items: const [1, 2, 3, 4, 5],
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Obx(() => CustomDropdown<String>(
                        label: "Blood Group *",
                        value: controller.selectedBloodType.value.isEmpty
                            ? null
                            : controller.selectedBloodType.value,
                        items: const ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'],
                        onChanged: (value) {
                          if (value != null) controller.setBloodType(value);
                        },
                      )),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: "Hospital *",
                        hint: "Enter hospital name",
                        controller: controller.hospitalController,
                        icon: Icons.local_hospital,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: "Location",
                        hint: "Enter location",
                        controller: controller.locationController,
                        icon: FontAwesomeIcons.locationDot,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: "Contact Number *",
                        hint: "Enter contact number",
                        controller: controller.contactController,
                        icon: Icons.phone,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: "Disease/Condition",
                        hint: "Enter disease or condition",
                        controller: controller.diseaseController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: "Date Needed",
                        hint: "YYYY-MM-DD",
                        controller: controller.dateController,
                        icon: Icons.calendar_today,
                      ),
                      const SizedBox(height: 24),
                      Obx(() => CustomButton(
                        text: controller.isLoading.value ? "Posting..." : "Post Request",
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.submitPublicNeed(),
                      )),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
