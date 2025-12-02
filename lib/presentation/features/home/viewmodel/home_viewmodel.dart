import 'package:get/get.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/repositories/notification_repository.dart';
import '../../../../domain/repositories/public_need_repository.dart';
import '../../../../domain/entities/public_need_entity.dart';

/// Home ViewModel - handles home screen state and logic
class HomeViewModel extends GetxController {
  final AuthRepository _authRepository;
  final NotificationRepository _notificationRepository;
  final PublicNeedRepository _publicNeedRepository;

  HomeViewModel({
    required AuthRepository authRepository,
    required NotificationRepository notificationRepository,
    required PublicNeedRepository publicNeedRepository,
  })  : _authRepository = authRepository,
        _notificationRepository = notificationRepository,
        _publicNeedRepository = publicNeedRepository;

  // Observable states
  final _unreadNotificationCount = 0.obs;
  final _recentNeeds = <PublicNeedEntity>[].obs;
  final _currentIndex = 0.obs;
  final _currentUserName = Rxn<String>();
  final _currentUserPhoto = Rxn<String>();

  // Getters
  int get unreadNotificationCount => _unreadNotificationCount.value;
  List<PublicNeedEntity> get recentNeeds => _recentNeeds;
  int get currentIndex => _currentIndex.value;
  String? get currentUserName => _currentUserName.value;
  String? get currentUserPhoto => _currentUserPhoto.value;
  
  String? get currentUserId => _authRepository.currentUser?.id;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
    _initStreams();
  }

  void _loadUserInfo() {
    final user = _authRepository.currentUser;
    _currentUserName.value = user?.name;
    _currentUserPhoto.value = user?.photoUrl;
  }

  void _initStreams() {
    final userId = currentUserId;
    if (userId != null) {
      // Watch unread notifications
      _notificationRepository.watchUnreadCount(userId).listen((count) {
        _unreadNotificationCount.value = count;
      });

      // Watch recent needs
      _publicNeedRepository.watchPendingNeeds().listen((needs) {
        _recentNeeds.value = needs.take(5).toList();
      });
    }
  }

  /// Change bottom navigation index
  void changeIndex(int index) {
    _currentIndex.value = index;
  }

  /// Navigate to notifications screen
  void goToNotifications() {
    Get.toNamed('/notifications');
  }

  /// Navigate to chat list
  void goToChats() {
    Get.toNamed('/chatList');
  }

  /// Navigate to public needs
  void goToPublicNeeds() {
    Get.toNamed('/publicNeed');
  }

  /// Navigate to donors
  void goToDonors() {
    Get.toNamed('/donors');
  }

  /// Navigate to profile
  void goToProfile() {
    Get.toNamed('/profile');
  }

  /// Sign out
  Future<void> signOut() async {
    final result = await _authRepository.signOut();
    result.fold(
      onSuccess: (_) => Get.offAllNamed('/login'),
      onFailure: (failure) => Get.snackbar('Error', failure.message),
    );
  }

  /// Refresh data
  void refreshData() {
    _initStreams();
  }
}
