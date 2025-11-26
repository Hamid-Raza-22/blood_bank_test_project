import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/public_need_entity.dart';
import '../../domain/repositories/public_need_repository.dart';
import '../datasources/remote/public_need_remote_datasource.dart';

/// Public Need repository implementation
class PublicNeedRepositoryImpl implements PublicNeedRepository {
  final PublicNeedRemoteDataSource remoteDataSource;

  PublicNeedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<PublicNeedEntity>>> getAllPublicNeeds() async {
    try {
      final needs = await remoteDataSource.getAllPublicNeeds();
      return Result.success(needs);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<PublicNeedEntity>>> getPendingNeeds() async {
    try {
      final needs = await remoteDataSource.getPendingNeeds();
      return Result.success(needs);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<PublicNeedEntity>>> getNeedsByBloodType(String bloodType) async {
    try {
      final needs = await remoteDataSource.getNeedsByBloodType(bloodType);
      return Result.success(needs);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<PublicNeedEntity>>> getNeedsByUser(String userId) async {
    try {
      final needs = await remoteDataSource.getNeedsByUser(userId);
      return Result.success(needs);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<PublicNeedEntity>> getNeedById(String needId) async {
    try {
      final need = await remoteDataSource.getNeedById(needId);
      return Result.success(need);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<PublicNeedEntity>> createNeed(PublicNeedEntity need) async {
    try {
      final created = await remoteDataSource.createNeed(need);
      return Result.success(created);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> acceptNeed({
    required String needId,
    required String acceptorId,
    required String chatRoomId,
  }) async {
    try {
      await remoteDataSource.acceptNeed(needId, acceptorId, chatRoomId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> cancelNeed(String needId) async {
    try {
      await remoteDataSource.cancelNeed(needId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> completeNeed(String needId) async {
    try {
      await remoteDataSource.completeNeed(needId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<PublicNeedEntity>> watchPublicNeeds() {
    return remoteDataSource.watchPublicNeeds();
  }

  @override
  Stream<List<PublicNeedEntity>> watchPendingNeeds() {
    return remoteDataSource.watchPendingNeeds();
  }
}
