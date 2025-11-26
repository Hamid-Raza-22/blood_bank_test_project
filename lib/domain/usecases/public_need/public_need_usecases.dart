import '../../../core/utils/result.dart';
import '../../entities/public_need_entity.dart';
import '../../repositories/public_need_repository.dart';
import '../base_usecase.dart';

/// Create Public Need Use Case
class CreatePublicNeedUseCase implements UseCase<PublicNeedEntity, PublicNeedEntity> {
  final PublicNeedRepository repository;

  CreatePublicNeedUseCase({required this.repository});

  @override
  Future<Result<PublicNeedEntity>> call(PublicNeedEntity need) {
    return repository.createNeed(need);
  }
}

/// Accept Public Need Use Case
class AcceptPublicNeedUseCase implements UseCase<void, AcceptNeedParams> {
  final PublicNeedRepository repository;

  AcceptPublicNeedUseCase({required this.repository});

  @override
  Future<Result<void>> call(AcceptNeedParams params) {
    return repository.acceptNeed(
      needId: params.needId,
      acceptorId: params.acceptorId,
      chatRoomId: params.chatRoomId,
    );
  }
}

class AcceptNeedParams {
  final String needId;
  final String acceptorId;
  final String chatRoomId;
  AcceptNeedParams({
    required this.needId,
    required this.acceptorId,
    required this.chatRoomId,
  });
}

/// Cancel Public Need Use Case
class CancelPublicNeedUseCase implements UseCase<void, String> {
  final PublicNeedRepository repository;

  CancelPublicNeedUseCase({required this.repository});

  @override
  Future<Result<void>> call(String needId) {
    return repository.cancelNeed(needId);
  }
}

/// Watch Pending Needs Stream Use Case
class WatchPendingNeedsUseCase implements StreamUseCaseNoParams<List<PublicNeedEntity>> {
  final PublicNeedRepository repository;

  WatchPendingNeedsUseCase({required this.repository});

  @override
  Stream<List<PublicNeedEntity>> call() {
    return repository.watchPendingNeeds();
  }
}

/// Get Needs by Blood Type Use Case
class GetNeedsByBloodTypeUseCase implements UseCase<List<PublicNeedEntity>, String> {
  final PublicNeedRepository repository;

  GetNeedsByBloodTypeUseCase({required this.repository});

  @override
  Future<Result<List<PublicNeedEntity>>> call(String bloodType) {
    return repository.getNeedsByBloodType(bloodType);
  }
}
