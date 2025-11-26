import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/donor_entity.dart';
import '../../domain/repositories/donor_repository.dart';
import '../datasources/remote/donor_remote_datasource.dart';
import '../models/donor_model.dart';

/// Donor repository implementation
class DonorRepositoryImpl implements DonorRepository {
  final DonorRemoteDataSource remoteDataSource;

  DonorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<DonorEntity>>> getAllDonors() async {
    try {
      final donors = await remoteDataSource.getAllDonors();
      return Result.success(donors.map((d) => d.toEntity()).toList());
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<DonorEntity>>> getDonorsByBloodType(String bloodType) async {
    try {
      final donors = await remoteDataSource.getDonorsByBloodType(bloodType);
      return Result.success(donors.map((d) => d.toEntity()).toList());
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<DonorEntity>>> getDonorsByCity(String city) async {
    try {
      final donors = await remoteDataSource.getDonorsByCity(city);
      return Result.success(donors.map((d) => d.toEntity()).toList());
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<DonorEntity>> getDonorById(String donorId) async {
    try {
      final donor = await remoteDataSource.getDonorById(donorId);
      return Result.success(donor.toEntity());
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<DonorEntity>> registerDonor(DonorEntity donor) async {
    try {
      final model = DonorModel.fromEntity(donor);
      final result = await remoteDataSource.registerDonor(model);
      return Result.success(result.toEntity());
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> updateDonorAvailability({
    required String donorId,
    required bool isAvailable,
  }) async {
    try {
      await remoteDataSource.updateDonorAvailability(donorId, isAvailable);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> updateDonor(DonorEntity donor) async {
    try {
      final model = DonorModel.fromEntity(donor);
      await remoteDataSource.updateDonor(model);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteDonor(String donorId) async {
    try {
      await remoteDataSource.deleteDonor(donorId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<DonorEntity>> watchDonors() {
    return remoteDataSource.watchDonors().map(
      (donors) => donors.map((d) => d.toEntity()).toList(),
    );
  }

  @override
  Stream<List<DonorEntity>> watchAvailableDonors() {
    return remoteDataSource.watchAvailableDonors().map(
      (donors) => donors.map((d) => d.toEntity()).toList(),
    );
  }
}
