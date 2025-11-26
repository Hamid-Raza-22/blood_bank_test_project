import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/public_need_entity.dart';
import 'blood_type_chip.dart';

/// Public Need Card Widget
class NeedCard extends StatelessWidget {
  final PublicNeedEntity need;
  final bool isOwner;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final VoidCallback? onTap;

  const NeedCard({
    super.key,
    required this.need,
    this.isOwner = false,
    this.onAccept,
    this.onCancel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        side: BorderSide(
          color: _getUrgencyColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: need.requesterPhoto != null
                        ? NetworkImage(need.requesterPhoto!)
                        : null,
                    child: need.requesterPhoto == null
                        ? Text(
                            need.requesterName.isNotEmpty
                                ? need.requesterName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          need.requesterName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSizes.fontM,
                          ),
                        ),
                        Text(
                          DateFormatter.timeAgo(need.createdAt),
                          style: const TextStyle(
                            fontSize: AppSizes.fontS,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildUrgencyBadge(),
                ],
              ),
              const Divider(height: 24),
              // Blood Info Row
              Row(
                children: [
                  BloodTypeChip(
                    bloodType: need.bloodType,
                    isSelected: true,
                    size: 50,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          Icons.local_hospital,
                          need.hospital ?? 'Hospital not specified',
                        ),
                        const SizedBox(height: 4),
                        _buildInfoRow(
                          Icons.location_on,
                          need.city ?? 'City not specified',
                        ),
                        const SizedBox(height: 4),
                        _buildInfoRow(
                          Icons.water_drop,
                          '${need.unitsNeeded} ${need.unitsNeeded == 1 ? 'unit' : 'units'} needed',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Notes
              if (need.notes != null && need.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.greyLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    need.notes!,
                    style: const TextStyle(
                      fontSize: AppSizes.fontS,
                      color: AppColors.greyDark,
                    ),
                  ),
                ),
              ],
              // Actions
              if (need.isPending) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (isOwner && onCancel != null)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onCancel,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                          ),
                          child: const Text('Cancel'),
                        ),
                      )
                    else if (!isOwner && onAccept != null)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onAccept,
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
              // Status for non-pending
              if (!need.isPending)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    need.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: AppSizes.fontS,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUrgencyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getUrgencyColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        need.urgency.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: AppSizes.fontS,
              color: AppColors.greyDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getUrgencyColor() {
    switch (need.urgency) {
      case 'critical':
        return AppColors.error;
      case 'urgent':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  Color _getStatusColor() {
    switch (need.status) {
      case 'accepted':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'completed':
        return AppColors.info;
      default:
        return AppColors.grey;
    }
  }
}
