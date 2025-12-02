import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../viewmodel/donor_viewmodel.dart';

/// Donor View - Blood type selection screen
/// Allows user to select blood type to find donors
class DonorView extends GetView<DonorViewModel> {
  const DonorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Find Donors'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildBloodTypeGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const Column(
        children: [
          Icon(Icons.bloodtype, size: 60, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Select Blood Type',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Choose the blood type you need',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodTypeGrid() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.bloodTypes.length - 1, // Exclude 'All'
          itemBuilder: (context, index) {
            final bloodType = controller.bloodTypes[index + 1]; // Skip 'All'
            return _buildBloodTypeCard(bloodType);
          },
        ),
      ),
    );
  }

  Widget _buildBloodTypeCard(String bloodType) {
    final color = controller.getBloodTypeColor(bloodType);

    return InkWell(
      onTap: () {
        controller.filterByBloodType(bloodType);
        Get.toNamed('/alldonors');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  bloodType,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Type $bloodType',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
