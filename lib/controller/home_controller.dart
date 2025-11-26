import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<QueryDocumentSnapshot> requests = RxList([]);
  RxMap userData = RxMap({});

  @override
  void onInit() {
    super.onInit();
    _fetchUser();
    _fetchRequests();
  }

  void _fetchUser() {
    String? uid = Get.find<AuthController>().firebaseUser.value?.uid;
    if (uid != null) {
      _firestore.collection('users').doc(uid).snapshots().listen((doc) {
        if (doc.exists) {
          userData.value = doc.data()!;
        }
      }, onError: (e) => print("HomeController ERROR: $e"));
    }
  }

  void _fetchRequests() {
    _firestore
        .collection('requests')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .listen((snapshot) {
      requests.value = snapshot.docs;
      print("HomeController LOG: Fetched ${requests.length} requests");
    }, onError: (e) => print("HomeController ERROR: $e"));
  }
}