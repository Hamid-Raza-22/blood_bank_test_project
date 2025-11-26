import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../domain/entities/donor_entity.dart';
import 'blood_type_chip.dart';

/// Donor Card Widget
class DonorCard extends StatelessWidget {
  final DonorEntity donor;
  final VoidCallback? onTap;
  final VoidCallback? onChatTap;

  const DonorCard({
    super.key,
    required this.donor,
    this.onTap,
    this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Row(
            children: [
              // Profile Photo
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: donor.photoUrl != null
                    ? NetworkImage(donor.photoUrl!)
                    : null,
                child: donor.photoUrl == null
                    ? Text(
                        donor.name.isNotEmpty ? donor.name[0].toUpperCase() : 'D',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AppSizes.paddingM),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            donor.name,
                            style: const TextStyle(
                              fontSize: AppSizes.fontL,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: donor.isAvailable
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            donor.isAvailable ? 'Available' : 'Unavailable',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: donor.isAvailable
                                  ? AppColors.success
                                  : AppColors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            donor.city,
                            style: const TextStyle(
                              fontSize: AppSizes.fontS,
                              color: AppColors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (donor.phoneNumber != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 14,
                            color: AppColors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            donor.phoneNumber!,
                            style: const TextStyle(
                              fontSize: AppSizes.fontS,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.paddingS),
              // Blood Type
              Column(
                children: [
                  BloodTypeChip(
                    bloodType: donor.bloodType,
                    isSelected: true,
                    size: 45,
                  ),
                  if (onChatTap != null) ...[
                    const SizedBox(height: 8),
                    IconButton(
                      onPressed: onChatTap,
                      icon: const Icon(Icons.chat_bubble_outline),
                      color: AppColors.primary,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
