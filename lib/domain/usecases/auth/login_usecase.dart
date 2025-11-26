import '../../../core/utils/result.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';
import '../base_usecase.dart';

/// Login use case parameters
class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}

/// Use case for user login with email and password
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  const LoginUseCase({required this.repository});

  @override
  Future<Result<UserEntity>> call(LoginParams params) {
    return repository.signInWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}
