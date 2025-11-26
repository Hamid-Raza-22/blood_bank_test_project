import '../../core/utils/result.dart';

/// Base class for use cases with parameters
abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

/// Base class for use cases without parameters
abstract class UseCaseNoParams<Type> {
  Future<Result<Type>> call();
}

/// Base class for stream use cases with parameters
abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

/// Base class for stream use cases without parameters
abstract class StreamUseCaseNoParams<Type> {
  Stream<Type> call();
}

/// Empty params class for use cases that don't need parameters
class NoParams {
  const NoParams();
}
