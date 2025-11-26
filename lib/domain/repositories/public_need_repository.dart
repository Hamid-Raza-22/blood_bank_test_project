import '../../core/utils/result.dart';
import '../entities/public_need_entity.dart';

/// Public Need repository interface - defines the contract for blood request operations
abstract class PublicNeedRepository {
  /// Get all public needs
  Future<Result<List<PublicNeedEntity>>> getAllPublicNeeds();

  /// Get pending public needs
  Future<Result<List<PublicNeedEntity>>> getPendingNeeds();

  /// Get public needs by blood type
  Future<Result<List<PublicNeedEntity>>> getNeedsByBloodType(String bloodType);

  /// Get public needs by user
  Future<Result<List<PublicNeedEntity>>> getNeedsByUser(String userId);

  /// Get public need by ID
  Future<Result<PublicNeedEntity>> getNeedById(String needId);

  /// Create public need
  Future<Result<PublicNeedEntity>> createNeed(PublicNeedEntity need);

  /// Accept public need
  Future<Result<void>> acceptNeed({
    required String needId,
    required String acceptorId,
    required String chatRoomId,
  });

  /// Cancel public need
  Future<Result<void>> cancelNeed(String needId);

  /// Complete public need
  Future<Result<void>> completeNeed(String needId);

  /// Stream public needs
  Stream<List<PublicNeedEntity>> watchPublicNeeds();

  /// Stream pending needs
  Stream<List<PublicNeedEntity>> watchPendingNeeds();
}
