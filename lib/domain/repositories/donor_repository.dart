import '../../core/utils/result.dart';
import '../entities/donor_entity.dart';

/// Donor repository interface - defines the contract for donor operations
abstract class DonorRepository {
  /// Get all donors
  Future<Result<List<DonorEntity>>> getAllDonors();

  /// Get donors by blood type
  Future<Result<List<DonorEntity>>> getDonorsByBloodType(String bloodType);

  /// Get donors by city
  Future<Result<List<DonorEntity>>> getDonorsByCity(String city);

  /// Get donor by ID
  Future<Result<DonorEntity>> getDonorById(String donorId);

  /// Register as donor
  Future<Result<DonorEntity>> registerDonor(DonorEntity donor);

  /// Update donor availability
  Future<Result<void>> updateDonorAvailability({
    required String donorId,
    required bool isAvailable,
  });

  /// Update donor profile
  Future<Result<void>> updateDonor(DonorEntity donor);

  /// Delete donor registration
  Future<Result<void>> deleteDonor(String donorId);

  /// Stream donors
  Stream<List<DonorEntity>> watchDonors();

  /// Stream available donors
  Stream<List<DonorEntity>> watchAvailableDonors();
}
