import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../constant/colors.dart';

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList notifications = RxList([]);

  @override
  void onInit() {
    super.onInit();
    _listenNotifications();
    _setupFcm();
  }

  void _listenNotifications() {
    String? uid = Get.find<AuthController>().firebaseUser.value?.uid;
    if (uid != null) {
      _firestore
          .collection('notifications')
          .where('userId', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
            notifications.value = snapshot.docs;
          });
    }
  }

  void _setupFcm() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Get.snackbar(
        message.notification?.title ?? 'Notification',
        message.notification?.body ?? '',
        backgroundColor: AppColors.primary,
        colorText: AppColors.white,
      );
    });
  }

  Future<void> markAsRead(String notifId) async {
    await _firestore.collection('notifications').doc(notifId).update({
      'read': true,
    });
  }
}
