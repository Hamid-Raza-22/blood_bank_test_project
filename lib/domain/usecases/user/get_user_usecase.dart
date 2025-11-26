import '../../../core/utils/result.dart';
import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';
import '../base_usecase.dart';

/// Get User by ID Use Case
class GetUserUseCase implements UseCase<UserEntity, String> {
  final UserRepository repository;

  GetUserUseCase({required this.repository});

  @override
  Future<Result<UserEntity>> call(String userId) {
    return repository.getUserById(userId);
  }
}

/// Update User Profile Use Case
class UpdateUserProfileUseCase implements UseCase<void, UpdateUserParams> {
  final UserRepository repository;

  UpdateUserProfileUseCase({required this.repository});

  @override
  Future<Result<void>> call(UpdateUserParams params) {
    return repository.updateUser(params.user);
  }
}

class UpdateUserParams {
  final UserEntity user;
  UpdateUserParams({required this.user});
}
