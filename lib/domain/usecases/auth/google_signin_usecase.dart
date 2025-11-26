import '../../../core/utils/result.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';
import '../base_usecase.dart';

/// Use case for Google sign in
class GoogleSignInUseCase implements UseCaseNoParams<UserEntity> {
  final AuthRepository repository;

  const GoogleSignInUseCase({required this.repository});

  @override
  Future<Result<UserEntity>> call() {
    return repository.signInWithGoogle();
  }
}
