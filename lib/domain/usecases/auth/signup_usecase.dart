import '../../../core/utils/result.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';
import '../base_usecase.dart';

/// Signup use case parameters
class SignupParams {
  final String email;
  final String password;

  const SignupParams({
    required this.email,
    required this.password,
  });
}

/// Use case for user signup with email and password
class SignupUseCase implements UseCase<UserEntity, SignupParams> {
  final AuthRepository repository;

  const SignupUseCase({required this.repository});

  @override
  Future<Result<UserEntity>> call(SignupParams params) {
    return repository.signUpWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}
