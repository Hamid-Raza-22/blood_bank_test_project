import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/public_need_entity.dart';
import '../../../../domain/repositories/public_need_repository.dart';
import '../../../../domain/repositories/chat_repository.dart';
import '../../../../domain/repositories/notification_repository.dart';

/// Public Need ViewModel - handles blood request state and logic
class PublicNeedViewModel extends GetxController {
  final PublicNeedRepository _publicNeedRepository;
  final ChatRepository _chatRepository;
  final NotificationRepository _notificationRepository;
  final String currentUserId;
  final String currentUserName;

  PublicNeedViewModel({
    required PublicNeedRepository publicNeedRepository,
    required ChatRepository chatRepository,
    required NotificationRepository notificationRepository,
    required this.currentUserId,
    required this.currentUserName,
  })  : _publicNeedRepository = publicNeedRepository,
        _chatRepository = chatRepository,
        _notificationRepository = notificationRepository;

  // Observable states
  final _publicNeeds = <PublicNeedEntity>[].obs;
  final _isLoading = false.obs;
  final _selectedBloodType = 'A+'.obs;
  final _selectedUrgency = 'normal'.obs;

  // Form controllers
  final hospitalController = TextEditingController();
  final cityController = TextEditingController();
  final notesController = TextEditingController();
  final unitsController = TextEditingController(text: '1');

  // Getters
  List<PublicNeedEntity> get publicNeeds => _publicNeeds;
  List<PublicNeedEntity> get pendingNeeds => 
      _publicNeeds.where((n) => n.isPending).toList();
  bool get isLoading => _isLoading.value;
  String get selectedBloodType => _selectedBloodType.value;
  String get selectedUrgency => _selectedUrgency.value;

  // Blood type options
  final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final urgencyOptions = ['normal', 'urgent', 'critical'];

  @override
  void onInit() {
    super.onInit();
    _watchPublicNeeds();
  }

  @override
  void onClose() {
    hospitalController.dispose();
    cityController.dispose();
    notesController.dispose();
    unitsController.dispose();
    super.onClose();
  }

  void _watchPublicNeeds() {
    _publicNeedRepository.watchPendingNeeds().listen((needs) {
      _publicNeeds.value = needs;
    });
  }

  void setBloodType(String type) {
    _selectedBloodType.value = type;
  }

  void setUrgency(String urgency) {
    _selectedUrgency.value = urgency;
  }

  /// Create a new blood request
  Future<bool> createRequest() async {
    _isLoading.value = true;

    final need = PublicNeedEntity(
      id: '',
      requesterId: currentUserId,
      requesterName: currentUserName,
      bloodType: _selectedBloodType.value,
      unitsNeeded: int.tryParse(unitsController.text) ?? 1,
      urgency: _selectedUrgency.value,
      hospital: hospitalController.text.trim(),
      city: cityController.text.trim(),
      notes: notesController.text.trim(),
    );

    final result = await _publicNeedRepository.createNeed(need);

    _isLoading.value = false;

    return result.fold(
      onSuccess: (createdNeed) {
        _clearForm();
        Get.back();
        Get.snackbar(
          'Success',
          'Blood request posted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Send notifications to all users (in real app, filter by blood type/location)
        _sendNewNeedNotification(createdNeed);
        
        return true;
      },
      onFailure: (failure) {
        Get.snackbar(
          'Error',
          failure.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      },
    );
  }

  /// Accept a blood request
  Future<bool> acceptRequest(PublicNeedEntity need) async {
    if (need.requesterId == currentUserId) {
      Get.snackbar(
        'Error',
        'You cannot accept your own request',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    _isLoading.value = true;

    // Create chat room
    final chatResult = await _chatRepository.getOrCreateChatRoom(
      userId1: currentUserId,
      userId2: need.requesterId,
      needId: need.id,
    );

    final chatRoomId = chatResult.fold(
      onSuccess: (room) => room.id,
      onFailure: (_) => null,
    );

    if (chatRoomId == null) {
      _isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to create chat room',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    // Accept the need
    final result = await _publicNeedRepository.acceptNeed(
      needId: need.id,
      acceptorId: currentUserId,
      chatRoomId: chatRoomId,
    );

    _isLoading.value = false;

    return result.fold(
      onSuccess: (_) {
        // Send acceptance notification
        _sendAcceptanceNotification(need, chatRoomId);

        // Navigate to chat
        Get.toNamed('/chat', arguments: {
          'chatRoomId': chatRoomId,
          'otherUserId': need.requesterId,
          'otherUserName': need.requesterName,
          'otherUserPhoto': need.requesterPhoto ?? '',
        });

        return true;
      },
      onFailure: (failure) {
        Get.snackbar(
          'Error',
          failure.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      },
    );
  }

  /// Cancel own request
  Future<bool> cancelRequest(String needId) async {
    _isLoading.value = true;

    final result = await _publicNeedRepository.cancelNeed(needId);

    _isLoading.value = false;

    return result.fold(
      onSuccess: (_) {
        Get.snackbar(
          'Success',
          'Request cancelled',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      },
      onFailure: (failure) {
        Get.snackbar(
          'Error',
          failure.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      },
    );
  }

  void _sendNewNeedNotification(PublicNeedEntity need) async {
    // In real app, this would send to relevant users
    debugPrint('Sending new need notification for ${need.bloodType}');
  }

  void _sendAcceptanceNotification(PublicNeedEntity need, String chatRoomId) async {
    await _notificationRepository.sendPushNotification(
      receiverId: need.requesterId,
      title: 'Request Accepted!',
      body: '$currentUserName has accepted your ${need.bloodType} blood request',
      type: 'need_accepted',
      data: {
        'chatRoomId': chatRoomId,
        'senderId': currentUserId,
        'senderName': currentUserName,
      },
    );
  }

  void _clearForm() {
    hospitalController.clear();
    cityController.clear();
    notesController.clear();
    unitsController.text = '1';
    _selectedBloodType.value = 'A+';
    _selectedUrgency.value = 'normal';
  }

  /// Get urgency color
  Color getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'critical':
        return Colors.red;
      case 'urgent':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  /// Check if need belongs to current user
  bool isMyRequest(PublicNeedEntity need) {
    return need.requesterId == currentUserId;
  }
}
