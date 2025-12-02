import 'package:equatable/equatable.dart';

/// Blood type value object with validation and compatibility logic
class BloodType extends Equatable {
  final String value;

  const BloodType._(this.value);

  // === Valid Blood Types ===
  static const String aPositive = 'A+';
  static const String aNegative = 'A-';
  static const String bPositive = 'B+';
  static const String bNegative = 'B-';
  static const String abPositive = 'AB+';
  static const String abNegative = 'AB-';
  static const String oPositive = 'O+';
  static const String oNegative = 'O-';

  static const List<String> validTypes = [
    aPositive,
    aNegative,
    bPositive,
    bNegative,
    abPositive,
    abNegative,
    oPositive,
    oNegative,
  ];

  /// Factory constructor with validation
  factory BloodType(String input) {
    final normalized = _normalize(input);
    if (!validTypes.contains(normalized)) {
      throw BloodTypeValidationException('Invalid blood type: $input');
    }
    return BloodType._(normalized);
  }

  /// Try to create BloodType, returns null if invalid
  static BloodType? tryParse(String input) {
    try {
      return BloodType(input);
    } catch (_) {
      return null;
    }
  }

  /// Normalize blood type string
  static String _normalize(String input) {
    return input.trim().toUpperCase().replaceAll(' ', '');
  }

  /// Check if blood type is valid
  static bool isValid(String input) {
    return validTypes.contains(_normalize(input));
  }

  /// Get blood types that can donate to this blood type
  List<BloodType> get compatibleDonors {
    switch (value) {
      case aPositive:
        return [BloodType(aPositive), BloodType(aNegative), BloodType(oPositive), BloodType(oNegative)];
      case aNegative:
        return [BloodType(aNegative), BloodType(oNegative)];
      case bPositive:
        return [BloodType(bPositive), BloodType(bNegative), BloodType(oPositive), BloodType(oNegative)];
      case bNegative:
        return [BloodType(bNegative), BloodType(oNegative)];
      case abPositive:
        return validTypes.map((t) => BloodType(t)).toList();
      case abNegative:
        return [BloodType(aNegative), BloodType(bNegative), BloodType(abNegative), BloodType(oNegative)];
      case oPositive:
        return [BloodType(oPositive), BloodType(oNegative)];
      case oNegative:
        return [BloodType(oNegative)];
      default:
        return [];
    }
  }

  /// Get blood types this blood type can donate to
  List<BloodType> get canDonateTo {
    switch (value) {
      case aPositive:
        return [BloodType(aPositive), BloodType(abPositive)];
      case aNegative:
        return [BloodType(aPositive), BloodType(aNegative), BloodType(abPositive), BloodType(abNegative)];
      case bPositive:
        return [BloodType(bPositive), BloodType(abPositive)];
      case bNegative:
        return [BloodType(bPositive), BloodType(bNegative), BloodType(abPositive), BloodType(abNegative)];
      case abPositive:
        return [BloodType(abPositive)];
      case abNegative:
        return [BloodType(abPositive), BloodType(abNegative)];
      case oPositive:
        return [BloodType(aPositive), BloodType(bPositive), BloodType(abPositive), BloodType(oPositive)];
      case oNegative:
        return validTypes.map((t) => BloodType(t)).toList(); // Universal donor
      default:
        return [];
    }
  }

  /// Check if this blood type can donate to another
  bool canDonateToo(BloodType recipient) {
    return canDonateTo.contains(recipient);
  }

  /// Check if this blood type can receive from another
  bool canReceiveFrom(BloodType donor) {
    return compatibleDonors.contains(donor);
  }

  /// Is universal donor (O-)
  bool get isUniversalDonor => value == oNegative;

  /// Is universal recipient (AB+)
  bool get isUniversalRecipient => value == abPositive;

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}

class BloodTypeValidationException implements Exception {
  final String message;
  const BloodTypeValidationException(this.message);

  @override
  String toString() => message;
}
