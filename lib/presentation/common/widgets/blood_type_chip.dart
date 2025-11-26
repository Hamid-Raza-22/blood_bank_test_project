import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Blood Type Chip Widget
class BloodTypeChip extends StatelessWidget {
  final String bloodType;
  final bool isSelected;
  final VoidCallback? onTap;
  final double? size;

  const BloodTypeChip({
    super.key,
    required this.bloodType,
    this.isSelected = false,
    this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size ?? 50,
        height: size ?? 50,
        decoration: BoxDecoration(
          color: isSelected ? _getBloodTypeColor() : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBloodTypeColor(),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _getBloodTypeColor().withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            bloodType,
            style: TextStyle(
              color: isSelected ? Colors.white : _getBloodTypeColor(),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Color _getBloodTypeColor() {
    switch (bloodType) {
      case 'A+':
      case 'A-':
        return AppColors.bloodA;
      case 'B+':
      case 'B-':
        return AppColors.bloodB;
      case 'AB+':
      case 'AB-':
        return AppColors.bloodAB;
      case 'O+':
      case 'O-':
        return AppColors.bloodO;
      default:
        return AppColors.primary;
    }
  }
}

/// Blood Type Selector Grid
class BloodTypeSelector extends StatelessWidget {
  final String? selectedType;
  final Function(String) onSelected;
  final List<String> bloodTypes;

  const BloodTypeSelector({
    super.key,
    this.selectedType,
    required this.onSelected,
    this.bloodTypes = const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: bloodTypes.map((type) {
        return BloodTypeChip(
          bloodType: type,
          isSelected: selectedType == type,
          onTap: () => onSelected(type),
        );
      }).toList(),
    );
  }
}
