import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Data Sources
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/user_remote_datasource.dart';
import '../../data/datasources/remote/donor_remote_datasource.dart';
import '../../data/datasources/remote/chat_remote_datasource.dart';
import '../../data/datasources/remote/notification_remote_datasource.dart';
import '../../data/datasources/remote/public_need_remote_datasource.dart';

// Repositories
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/repositories/donor_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/repositories/public_need_repository_impl.dart';

// Domain Repositories (interfaces)
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/donor_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/public_need_repository.dart';

// Use Cases
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/signup_usecase.dart';
import '../../domain/usecases/auth/google_signin_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';

/// Dependency Injection Container
class InjectionContainer {
  static final InjectionContainer _instance = InjectionContainer._internal();
  factory InjectionContainer() => _instance;
  InjectionContainer._internal();

  /// Initialize all dependencies
  Future<void> init() async {
    // External Dependencies
    await _initExternalDependencies();

    // Data Sources
    _initDataSources();

    // Repositories
    _initRepositories();

    // Use Cases
    _initUseCases();
  }

  Future<void> _initExternalDependencies() async {
    // Firebase instances
    Get.lazyPut<FirebaseAuth>(() => FirebaseAuth.instance, fenix: true);
    Get.lazyPut<FirebaseFirestore>(() => FirebaseFirestore.instance, fenix: true);
    Get.lazyPut<FirebaseMessaging>(() => FirebaseMessaging.instance, fenix: true);

    // SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut<SharedPreferences>(() => sharedPreferences, fenix: true);
  }

  void _initDataSources() {
    // Remote Data Sources
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: Get.find(),
        firestore: Get.find(),
        messaging: Get.find(),
      ),
      fenix: true,
    );

    Get.lazyPut<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(
        firestore: Get.find(),
      ),
      fenix: true,
    );

    Get.lazyPut<DonorRemoteDataSource>(
      () => DonorRemoteDataSourceImpl(
        firestore: Get.find(),
      ),
      fenix: true,
    );

    Get.lazyPut<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(
        firestore: Get.find(),
      ),
      fenix: true,
    );

    Get.lazyPut<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(
        firestore: Get.find(),
        messaging: Get.find(),
      ),
      fenix: true,
    );

    Get.lazyPut<PublicNeedRemoteDataSource>(
      () => PublicNeedRemoteDataSourceImpl(
        firestore: Get.find(),
      ),
      fenix: true,
    );
  }

  void _initRepositories() {
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );

    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );

    Get.lazyPut<DonorRepository>(
      () => DonorRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );

    Get.lazyPut<ChatRepository>(
      () => ChatRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );

    Get.lazyPut<NotificationRepository>(
      () => NotificationRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );

    Get.lazyPut<PublicNeedRepository>(
      () => PublicNeedRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );
  }

  void _initUseCases() {
    // Auth Use Cases
    Get.lazyPut<LoginUseCase>(
      () => LoginUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<SignupUseCase>(
      () => SignupUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<GoogleSignInUseCase>(
      () => GoogleSignInUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<LogoutUseCase>(
      () => LogoutUseCase(repository: Get.find()),
      fenix: true,
    );
  }
}

/// Global injection container instance
final sl = InjectionContainer();
