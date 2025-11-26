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

// Use Cases - Auth
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/signup_usecase.dart';
import '../../domain/usecases/auth/google_signin_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';

// Use Cases - User
import '../../domain/usecases/user/get_user_usecase.dart';

// Use Cases - Donor
import '../../domain/usecases/donor/donor_usecases.dart';

// Use Cases - Chat
import '../../domain/usecases/chat/chat_usecases.dart';

// Use Cases - Notification
import '../../domain/usecases/notification/notification_usecases.dart';

// Use Cases - Public Need
import '../../domain/usecases/public_need/public_need_usecases.dart';

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

    // User Use Cases
    Get.lazyPut<GetUserUseCase>(
      () => GetUserUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<UpdateUserProfileUseCase>(
      () => UpdateUserProfileUseCase(repository: Get.find()),
      fenix: true,
    );

    // Donor Use Cases
    Get.lazyPut<GetDonorsByBloodTypeUseCase>(
      () => GetDonorsByBloodTypeUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<GetDonorsByCityUseCase>(
      () => GetDonorsByCityUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<RegisterDonorUseCase>(
      () => RegisterDonorUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<UpdateDonorAvailabilityUseCase>(
      () => UpdateDonorAvailabilityUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<WatchAvailableDonorsUseCase>(
      () => WatchAvailableDonorsUseCase(repository: Get.find()),
      fenix: true,
    );

    // Chat Use Cases
    Get.lazyPut<GetOrCreateChatRoomUseCase>(
      () => GetOrCreateChatRoomUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<SendMessageUseCase>(
      () => SendMessageUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<WatchChatRoomsUseCase>(
      () => WatchChatRoomsUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<WatchMessagesUseCase>(
      () => WatchMessagesUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<MarkMessagesAsReadUseCase>(
      () => MarkMessagesAsReadUseCase(repository: Get.find()),
      fenix: true,
    );

    // Notification Use Cases
    Get.lazyPut<WatchNotificationsUseCase>(
      () => WatchNotificationsUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<WatchUnreadCountUseCase>(
      () => WatchUnreadCountUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<MarkNotificationAsReadUseCase>(
      () => MarkNotificationAsReadUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<MarkAllNotificationsAsReadUseCase>(
      () => MarkAllNotificationsAsReadUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<SendPushNotificationUseCase>(
      () => SendPushNotificationUseCase(repository: Get.find()),
      fenix: true,
    );

    // Public Need Use Cases
    Get.lazyPut<CreatePublicNeedUseCase>(
      () => CreatePublicNeedUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<AcceptPublicNeedUseCase>(
      () => AcceptPublicNeedUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<CancelPublicNeedUseCase>(
      () => CancelPublicNeedUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<WatchPendingNeedsUseCase>(
      () => WatchPendingNeedsUseCase(repository: Get.find()),
      fenix: true,
    );

    Get.lazyPut<GetNeedsByBloodTypeUseCase>(
      () => GetNeedsByBloodTypeUseCase(repository: Get.find()),
      fenix: true,
    );
  }
}

/// Global injection container instance
final sl = InjectionContainer();
