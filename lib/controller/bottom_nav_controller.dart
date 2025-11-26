import 'package:get/get.dart';

class NavController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
    print("NavController LOG: Changing tab to index: $index");
    switch (index) {
      case 0:
        Get.offAllNamed('/home'); // Use offAllNamed to reset stack
        break;
      case 1:
        Get.offAllNamed('/donors');
        break;
      case 2:
        Get.offAllNamed('/need');
        break;
      case 3:
        Get.offAllNamed('/profile');
        break;
    }
  }
}
