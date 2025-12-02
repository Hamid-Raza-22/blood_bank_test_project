import 'package:get/get.dart';
import '../../domain/repositories/donor_repository.dart';
import '../features/donors/viewmodel/donor_viewmodel.dart';

/// Donor Binding - Injects dependencies for Donor feature
/// 
/// Provides DonorViewModel with required repositories.
class DonorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonorViewModel>(
      () => DonorViewModel(
        donorRepository: Get.find<DonorRepository>(),
      ),
    );
  }
}
