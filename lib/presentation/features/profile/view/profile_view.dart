import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../viewmodel/profile_viewmodel.dart';

/// Profile View - Pure UI, no business logic
/// Shows user profile and donor settings
class ProfileView extends GetView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (controller.isLoading && controller.currentUser == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  _buildDonorSection(),
                  const SizedBox(height: 16),
                  _buildSettingsSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      expandedHeight: 120,
      pinned: true,
      flexibleSpace: const FlexibleSpaceBar(
        title: Text('My Profile'),
        centerTitle: true,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _showEditProfileSheet(),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Obx(() => CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: controller.currentUser?.photoUrl != null
                    ? NetworkImage(controller.currentUser!.photoUrl!)
                    : null,
                child: controller.currentUser?.photoUrl == null
                    ? Text(
                        controller.currentUser?.name?.isNotEmpty == true
                            ? controller.currentUser!.name![0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              )),
          const SizedBox(height: 16),
          // Name
          Obx(() => Text(
                controller.currentUser?.name ?? 'User',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
          const SizedBox(height: 4),
          // Email
          Obx(() => Text(
                controller.currentUser?.email ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              )),
          const SizedBox(height: 16),
          // Blood type badge
          Obx(() => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Blood Type: ${controller.selectedBloodType}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDonorSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.volunteer_activism,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Donor Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (!controller.isDonor) {
                return Column(
                  children: [
                    const Text(
                      'You are not registered as a donor yet. Register to help save lives!',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.registerAsDonor,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Register as Donor'),
                      ),
                    ),
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Availability',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.isAvailable
                            ? 'You are available to donate'
                            : 'You are not available',
                        style: TextStyle(
                          color: controller.isAvailable
                              ? Colors.green
                              : Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: controller.isAvailable,
                    onChanged: (_) => controller.toggleAvailability(),
                    activeColor: AppColors.primary,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
            _buildSettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () => Get.toNamed('/notifications'),
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.history,
              title: 'Donation History',
              onTap: () => Get.snackbar('Coming Soon', 'This feature is coming soon'),
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () => Get.snackbar('Coming Soon', 'This feature is coming soon'),
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: 'About Blood Bank',
              onTap: () => Get.toNamed('/bloodInstruction'),
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.logout,
              title: 'Sign Out',
              textColor: Colors.red,
              onTap: _showSignOutDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: textColor ?? Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 56, color: Colors.grey[200]);
  }

  void _showEditProfileSheet() {
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
                'Edit Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              const Text('Blood Type'),
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.updateProfile();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showSignOutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
