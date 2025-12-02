# Blood Bank App - Clean Architecture Guide

## Architecture Overview

This application follows **Clean Architecture** with **GetX MVVM** pattern, implementing:
- **Repository Pattern**
- **Domain-Driven Design (DDD)**
- **SOLID Principles**
- **DRY (Don't Repeat Yourself)**

## Folder Structure

```
lib/
├── core/                          # Core utilities and shared components
│   ├── constants/                 # App-wide constants
│   │   ├── app_constants.dart     # App configuration constants
│   │   ├── api_constants.dart     # API endpoints
│   │   └── storage_keys.dart      # SharedPreferences/Secure storage keys
│   ├── di/                        # Dependency Injection
│   │   └── injection_container.dart
│   ├── errors/                    # Error handling
│   │   ├── exceptions.dart        # Custom exceptions
│   │   ├── failures.dart          # Failure classes
│   │   └── error_handler.dart     # Global error handler
│   ├── network/                   # Network utilities
│   │   └── network_info.dart      # Network connectivity checker
│   ├── theme/                     # App theming
│   │   ├── app_theme.dart         # Theme data
│   │   ├── app_colors.dart        # Color palette
│   │   └── app_text_styles.dart   # Typography
│   ├── utils/                     # Utility classes
│   │   ├── extensions/            # Dart extensions
│   │   ├── validators.dart        # Input validators
│   │   ├── formatters.dart        # Data formatters
│   │   └── helpers.dart           # Helper functions
│   └── core.dart                  # Core barrel export
│
├── data/                          # Data Layer
│   ├── datasources/               # Data sources
│   │   ├── local/                 # Local data sources (Cache, DB)
│   │   │   └── user_local_datasource.dart
│   │   └── remote/                # Remote data sources (API, Firebase)
│   │       ├── auth_remote_datasource.dart
│   │       ├── user_remote_datasource.dart
│   │       ├── chat_remote_datasource.dart
│   │       ├── donor_remote_datasource.dart
│   │       ├── notification_remote_datasource.dart
│   │       └── public_need_remote_datasource.dart
│   ├── models/                    # Data Transfer Objects (DTOs)
│   │   ├── user_model.dart
│   │   ├── chat_room_model.dart
│   │   ├── message_model.dart
│   │   ├── donor_model.dart
│   │   ├── notification_model.dart
│   │   └── public_need_model.dart
│   ├── repositories/              # Repository implementations
│   │   ├── auth_repository_impl.dart
│   │   ├── user_repository_impl.dart
│   │   ├── chat_repository_impl.dart
│   │   ├── donor_repository_impl.dart
│   │   ├── notification_repository_impl.dart
│   │   └── public_need_repository_impl.dart
│   └── data.dart                  # Data barrel export
│
├── domain/                        # Domain Layer (Business Logic)
│   ├── entities/                  # Business entities (pure Dart)
│   │   ├── user_entity.dart
│   │   ├── chat_room_entity.dart
│   │   ├── message_entity.dart
│   │   ├── donor_entity.dart
│   │   ├── notification_entity.dart
│   │   └── public_need_entity.dart
│   ├── repositories/              # Repository interfaces (contracts)
│   │   ├── auth_repository.dart
│   │   ├── user_repository.dart
│   │   ├── chat_repository.dart
│   │   ├── donor_repository.dart
│   │   ├── notification_repository.dart
│   │   └── public_need_repository.dart
│   ├── usecases/                  # Use cases (application services)
│   │   ├── base_usecase.dart      # Base use case template
│   │   ├── auth/
│   │   │   ├── login_usecase.dart
│   │   │   ├── signup_usecase.dart
│   │   │   ├── google_signin_usecase.dart
│   │   │   └── logout_usecase.dart
│   │   ├── user/
│   │   │   ├── get_user_usecase.dart
│   │   │   └── update_profile_usecase.dart
│   │   ├── chat/
│   │   │   └── chat_usecases.dart
│   │   ├── donor/
│   │   │   └── donor_usecases.dart
│   │   ├── notification/
│   │   │   └── notification_usecases.dart
│   │   └── public_need/
│   │       └── public_need_usecases.dart
│   ├── value_objects/             # Value objects (immutable)
│   │   ├── email.dart
│   │   ├── password.dart
│   │   └── blood_type.dart
│   └── domain.dart                # Domain barrel export
│
├── presentation/                  # Presentation Layer
│   ├── bindings/                  # GetX bindings
│   │   ├── app_binding.dart       # Global app binding
│   │   ├── auth_binding.dart
│   │   ├── home_binding.dart
│   │   ├── chat_binding.dart
│   │   ├── donor_binding.dart
│   │   ├── notification_binding.dart
│   │   ├── profile_binding.dart
│   │   └── public_need_binding.dart
│   ├── common/                    # Shared UI components
│   │   ├── widgets/               # Reusable widgets
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── loading_widget.dart
│   │   │   ├── error_widget.dart
│   │   │   └── empty_state_widget.dart
│   │   ├── dialogs/               # Common dialogs
│   │   │   └── confirmation_dialog.dart
│   │   └── base/                  # Base classes
│   │       ├── base_view.dart
│   │       └── base_viewmodel.dart
│   ├── features/                  # Feature modules
│   │   ├── splash/
│   │   │   ├── view/
│   │   │   │   └── splash_view.dart
│   │   │   └── viewmodel/
│   │   │       └── splash_viewmodel.dart
│   │   ├── auth/
│   │   │   ├── view/
│   │   │   │   ├── login_view.dart
│   │   │   │   ├── signup_view.dart
│   │   │   │   ├── forgot_password_view.dart
│   │   │   │   └── verify_otp_view.dart
│   │   │   └── viewmodel/
│   │   │       └── auth_viewmodel.dart
│   │   ├── home/
│   │   │   ├── view/
│   │   │   │   ├── home_view.dart
│   │   │   │   └── main_navigation_view.dart
│   │   │   └── viewmodel/
│   │   │       └── home_viewmodel.dart
│   │   ├── chat/
│   │   │   ├── view/
│   │   │   │   ├── chat_view.dart
│   │   │   │   └── chat_list_view.dart
│   │   │   └── viewmodel/
│   │   │       └── chat_viewmodel.dart
│   │   ├── donors/
│   │   │   ├── view/
│   │   │   │   ├── donor_view.dart
│   │   │   │   └── all_donors_view.dart
│   │   │   └── viewmodel/
│   │   │       └── donor_viewmodel.dart
│   │   ├── notifications/
│   │   │   ├── view/
│   │   │   │   └── notification_view.dart
│   │   │   └── viewmodel/
│   │   │       └── notification_viewmodel.dart
│   │   ├── profile/
│   │   │   ├── view/
│   │   │   │   └── profile_view.dart
│   │   │   └── viewmodel/
│   │   │       └── profile_viewmodel.dart
│   │   └── public_needs/
│   │       ├── view/
│   │       │   └── public_need_view.dart
│   │       └── viewmodel/
│   │           └── public_need_viewmodel.dart
│   ├── routes/                    # Routing
│   │   ├── app_routes.dart        # Route names
│   │   └── app_pages.dart         # Route configurations
│   └── presentation.dart          # Presentation barrel export
│
└── main.dart                      # App entry point
```

## Layer Responsibilities

### 1. Domain Layer (Inner Circle)
- **Pure Dart** - No Flutter or external dependencies
- **Entities**: Core business objects
- **Value Objects**: Immutable objects with validation
- **Use Cases**: Single-purpose business operations
- **Repository Interfaces**: Contracts for data access

### 2. Data Layer (Outer Circle)
- **Models (DTOs)**: Data transfer objects with serialization
- **Data Sources**: Raw data access (Firebase, API, local DB)
- **Repository Implementations**: Implement domain contracts

### 3. Presentation Layer (Outer Circle)
- **Views**: Pure UI widgets (NO business logic)
- **ViewModels**: State management + UI logic (GetxController)
- **Bindings**: Dependency injection per route
- **Routes**: Navigation configuration

## Clean Architecture Rules

### Rule 1: Dependency Direction
```
Presentation → Domain ← Data
```
- Outer layers depend on inner layers
- Domain layer has ZERO external dependencies

### Rule 2: Single Responsibility
- Each class has ONE reason to change
- Each file contains ONE class

### Rule 3: Interface Segregation
- Repository interfaces in Domain layer
- Implementations in Data layer

### Rule 4: Separation of Concerns
- **Views**: ONLY widgets and UI rendering
- **ViewModels**: State, UI logic, navigation
- **UseCases**: Business rules
- **Repositories**: Data access

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Entity | `{Name}Entity` | `UserEntity` |
| Model | `{Name}Model` | `UserModel` |
| Repository (Interface) | `{Name}Repository` | `UserRepository` |
| Repository (Impl) | `{Name}RepositoryImpl` | `UserRepositoryImpl` |
| DataSource | `{Name}{Type}DataSource` | `UserRemoteDataSource` |
| UseCase | `{Action}{Entity}UseCase` | `LoginUserUseCase` |
| ViewModel | `{Feature}ViewModel` | `AuthViewModel` |
| View | `{Name}View` | `LoginView` |
| Binding | `{Feature}Binding` | `AuthBinding` |

## Code Templates

### Entity Template
```dart
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
  });

  @override
  List<Object?> get props => [id, email, name];

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}
```

### Model Template (DTO)
```dart
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
    );
  }
}
```

### Repository Interface Template
```dart
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> getUserById(String id);
  Future<void> updateUser(UserEntity user);
  Stream<UserEntity?> watchUser(String id);
}
```

### Repository Implementation Template
```dart
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity?> getUserById(String id) {
    return remoteDataSource.getUserById(id);
  }

  @override
  Future<void> updateUser(UserEntity user) {
    return remoteDataSource.updateUser(user);
  }

  @override
  Stream<UserEntity?> watchUser(String id) {
    return remoteDataSource.watchUser(id);
  }
}
```

### UseCase Template
```dart
import '../base_usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserUseCase implements UseCase<UserEntity?, String> {
  final UserRepository repository;

  GetUserUseCase({required this.repository});

  @override
  Future<UserEntity?> call(String userId) {
    return repository.getUserById(userId);
  }
}
```

### ViewModel Template
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/user/get_user_usecase.dart';

class ProfileViewModel extends GetxController {
  final GetUserUseCase _getUserUseCase;

  ProfileViewModel({required GetUserUseCase getUserUseCase})
      : _getUserUseCase = getUserUseCase;

  // === Observable State ===
  final _user = Rxn<UserEntity>();
  final _isLoading = false.obs;
  final _error = Rxn<String>();

  // === Getters ===
  UserEntity? get user => _user.value;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  // === Lifecycle ===
  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  // === Actions ===
  Future<void> loadUser() async {
    _isLoading.value = true;
    _error.value = null;
    try {
      final result = await _getUserUseCase('currentUserId');
      _user.value = result;
    } catch (e) {
      _error.value = e.toString();
      debugPrint('ProfileViewModel Error: $e');
    } finally {
      _isLoading.value = false;
    }
  }
}
```

### View Template
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../../../common/widgets/loading_widget.dart';
import '../../../common/widgets/error_widget.dart';

class ProfileView extends GetView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        if (controller.isLoading) {
          return const LoadingWidget();
        }
        if (controller.error != null) {
          return AppErrorWidget(
            message: controller.error!,
            onRetry: controller.loadUser,
          );
        }
        return _buildContent();
      }),
    );
  }

  Widget _buildContent() {
    final user = controller.user;
    if (user == null) {
      return const Center(child: Text('No user data'));
    }
    return ListView(
      children: [
        ListTile(title: Text(user.name)),
        ListTile(subtitle: Text(user.email)),
      ],
    );
  }
}
```

### Binding Template
```dart
import 'package:get/get.dart';
import '../../../domain/usecases/user/get_user_usecase.dart';
import '../viewmodel/profile_viewmodel.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileViewModel>(
      () => ProfileViewModel(
        getUserUseCase: Get.find<GetUserUseCase>(),
      ),
    );
  }
}
```

## Navigation with GetX

### Route Definition
```dart
// routes/app_routes.dart
abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
}

// routes/app_pages.dart
class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
```

### Navigation Examples
```dart
// Simple navigation
Get.toNamed(AppRoutes.profile);

// With arguments
Get.toNamed(AppRoutes.chat, arguments: {'userId': userId});

// Replace current route
Get.offNamed(AppRoutes.home);

// Clear stack and navigate
Get.offAllNamed(AppRoutes.login);

// Go back
Get.back();

// Get arguments in ViewModel
final userId = Get.arguments['userId'] as String;
```

## Best Practices

1. **Never put business logic in Views**
2. **Use UseCases for complex business operations**
3. **Keep ViewModels focused on UI state**
4. **Use Repository pattern for all data access**
5. **Entities are immutable - use copyWith**
6. **One class per file**
7. **Use barrel exports for cleaner imports**
8. **Handle errors in ViewModels, not Views**
9. **Use Rx types for reactive state**
10. **Keep dependencies minimal in Domain layer**

## Testing Structure

```
test/
├── domain/
│   ├── usecases/
│   │   └── login_usecase_test.dart
│   └── entities/
│       └── user_entity_test.dart
├── data/
│   └── repositories/
│       └── auth_repository_impl_test.dart
└── presentation/
    └── viewmodels/
        └── auth_viewmodel_test.dart
```
