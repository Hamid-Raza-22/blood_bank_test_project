import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/donor_entity.dart';
import '../viewmodel/donor_viewmodel.dart';

/// All Donors View - Shows list of donors with filters
class AllDonorsView extends GetView<DonorViewModel> {
  const AllDonorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Obx(() => Text(
              controller.selectedBloodType != null
                  ? '${controller.selectedBloodType} Donors'
                  : 'All Donors',
            )),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildBloodTypeChips(),
          Expanded(child: _buildDonorList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search donors by name or city...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: controller.searchDonors,
      ),
    );
  }

  Widget _buildBloodTypeChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.bloodTypes.length,
        itemBuilder: (context, index) {
          final bloodType = controller.bloodTypes[index];
          return Obx(() {
            final isSelected = (bloodType == 'All' &&
                    controller.selectedBloodType == null) ||
                bloodType == controller.selectedBloodType;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(bloodType),
                selected: isSelected,
                onSelected: (_) => controller.filterByBloodType(bloodType),
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildDonorList() {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.donors.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No donors found',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: controller.clearFilters,
                child: const Text('Clear filters'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          if (controller.selectedBloodType != null) {
            await controller.loadDonorsByBloodType(controller.selectedBloodType!);
          }
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.donors.length,
          itemBuilder: (context, index) {
            final donor = controller.donors[index];
            return _buildDonorCard(donor);
          },
        ),
      );
    });
  }

  Widget _buildDonorCard(DonorEntity donor) {
    final color = controller.getBloodTypeColor(donor.bloodType);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showDonorDetails(donor),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.1),
                backgroundImage:
                    donor.photoUrl != null ? NetworkImage(donor.photoUrl!) : null,
                child: donor.photoUrl == null
                    ? Text(
                        donor.name.isNotEmpty ? donor.name[0].toUpperCase() : 'D',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          donor.city,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Blood type badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  donor.bloodType,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Donors',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text('Blood Type'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.bloodTypes.map((type) {
                return Obx(() {
                  final isSelected =
                      (type == 'All' && controller.selectedBloodType == null) ||
                          type == controller.selectedBloodType;
                  return ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (_) {
                      controller.filterByBloodType(type);
                      Get.back();
                    },
                  );
                });
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showDonorDetails(DonorEntity donor) {
    final color = controller.getBloodTypeColor(donor.bloodType);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: color.withOpacity(0.1),
              backgroundImage:
                  donor.photoUrl != null ? NetworkImage(donor.photoUrl!) : null,
              child: donor.photoUrl == null
                  ? Text(
                      donor.name.isNotEmpty ? donor.name[0].toUpperCase() : 'D',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              donor.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Blood Type: ${donor.bloodType}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  donor.city,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.toNamed('/chat');
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.toNamed('/request');
                    },
                    icon: const Icon(Icons.bloodtype),
                    label: const Text('Request'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
