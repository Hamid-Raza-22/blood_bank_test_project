import '../../../core/utils/result.dart';
import '../../repositories/auth_repository.dart';
import '../base_usecase.dart';

/// Use case for user logout
class LogoutUseCase implements UseCaseNoParams<void> {
  final AuthRepository repository;

  const LogoutUseCase({required this.repository});

  @override
  Future<Result<void>> call() {
    return repository.signOut();
  }
}
