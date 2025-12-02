import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/public_need_entity.dart';
import '../viewmodel/public_need_viewmodel.dart';

/// Public Need View - Pure UI, no business logic
/// Shows list of blood requests and allows creating new ones
class PublicNeedView extends GetView<PublicNeedViewModel> {
  const PublicNeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Blood Requests'),
        elevation: 0,
      ),
      body: _buildNeedsList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateRequestSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Post Request'),
      ),
    );
  }

  Widget _buildNeedsList() {
    return Obx(() {
      if (controller.isLoading && controller.publicNeeds.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.publicNeeds.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bloodtype_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No blood requests yet',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Be the first to post a request',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {},
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.pendingNeeds.length,
          itemBuilder: (context, index) {
            final need = controller.pendingNeeds[index];
            return _buildNeedCard(need);
          },
        ),
      );
    });
  }

  Widget _buildNeedCard(PublicNeedEntity need) {
    final urgencyColor = controller.getUrgencyColor(need.urgency);
    final isMyRequest = controller.isMyRequest(need);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: urgencyColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      need.bloodType,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${need.unitsNeeded} unit${need.unitsNeeded > 1 ? 's' : ''} needed',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By ${need.requesterName}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: urgencyColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    need.urgency.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(Icons.local_hospital, need.hospital ?? 'Unknown Hospital'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.location_on, need.city ?? 'Unknown City'),
                if (need.notes != null && need.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.note, need.notes!),
                ],
                const SizedBox(height: 16),
                // Action buttons
                Row(
                  children: [
                    if (isMyRequest)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showCancelDialog(need),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Cancel Request'),
                        ),
                      )
                    else
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => controller.acceptRequest(need),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('I Can Help'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[700]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showCreateRequestSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Post Blood Request',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Blood Type
              const Text('Blood Type Needed'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.bloodTypes.map((type) {
                  return Obx(() => ChoiceChip(
                        label: Text(type),
                        selected: controller.selectedBloodType == type,
                        onSelected: (_) => controller.setBloodType(type),
                        selectedColor: AppColors.primary.withOpacity(0.2),
                      ));
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Urgency
              const Text('Urgency'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: controller.urgencyOptions.map((urgency) {
                  return Obx(() => ChoiceChip(
                        label: Text(urgency.toUpperCase()),
                        selected: controller.selectedUrgency == urgency,
                        onSelected: (_) => controller.setUrgency(urgency),
                        selectedColor:
                            controller.getUrgencyColor(urgency).withOpacity(0.2),
                      ));
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Hospital
              TextField(
                controller: controller.hospitalController,
                decoration: InputDecoration(
                  labelText: 'Hospital Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // City
              TextField(
                controller: controller.cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Units
              TextField(
                controller: controller.unitsController,
                decoration: InputDecoration(
                  labelText: 'Units Needed',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              // Notes
              TextField(
                controller: controller.notesController,
                decoration: InputDecoration(
                  labelText: 'Additional Notes (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              // Submit button
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                      onPressed:
                          controller.isLoading ? null : controller.createRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Post Request'),
                    )),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showCancelDialog(PublicNeedEntity need) {
    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Request'),
        content: const Text('Are you sure you want to cancel this blood request?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.cancelRequest(need.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
