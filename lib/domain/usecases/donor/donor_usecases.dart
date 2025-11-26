import '../../../core/utils/result.dart';
import '../../entities/donor_entity.dart';
import '../../repositories/donor_repository.dart';
import '../base_usecase.dart';

/// Get Donors by Blood Type Use Case
class GetDonorsByBloodTypeUseCase implements UseCase<List<DonorEntity>, String> {
  final DonorRepository repository;

  GetDonorsByBloodTypeUseCase({required this.repository});

  @override
  Future<Result<List<DonorEntity>>> call(String bloodType) {
    return repository.getDonorsByBloodType(bloodType);
  }
}

/// Get Donors by City Use Case
class GetDonorsByCityUseCase implements UseCase<List<DonorEntity>, String> {
  final DonorRepository repository;

  GetDonorsByCityUseCase({required this.repository});

  @override
  Future<Result<List<DonorEntity>>> call(String city) {
    return repository.getDonorsByCity(city);
  }
}

/// Register as Donor Use Case
class RegisterDonorUseCase implements UseCase<void, DonorEntity> {
  final DonorRepository repository;

  RegisterDonorUseCase({required this.repository});

  @override
  Future<Result<void>> call(DonorEntity donor) {
    return repository.registerDonor(donor);
  }
}

/// Update Donor Availability Use Case
class UpdateDonorAvailabilityUseCase implements UseCase<void, UpdateAvailabilityParams> {
  final DonorRepository repository;

  UpdateDonorAvailabilityUseCase({required this.repository});

  @override
  Future<Result<void>> call(UpdateAvailabilityParams params) {
    return repository.updateDonorAvailability(
      donorId: params.donorId,
      isAvailable: params.isAvailable,
    );
  }
}

class UpdateAvailabilityParams {
  final String donorId;
  final bool isAvailable;
  UpdateAvailabilityParams({required this.donorId, required this.isAvailable});
}

/// Watch Available Donors Stream Use Case
class WatchAvailableDonorsUseCase implements StreamUseCaseNoParams<List<DonorEntity>> {
  final DonorRepository repository;

  WatchAvailableDonorsUseCase({required this.repository});

  @override
  Stream<List<DonorEntity>> call() {
    return repository.watchAvailableDonors();
  }
}
