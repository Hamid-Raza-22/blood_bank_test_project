import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/entities/donor_entity.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../domain/repositories/donor_repository.dart';

/// Profile ViewModel - handles user profile state and logic
class ProfileViewModel extends GetxController {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final DonorRepository _donorRepository;

  ProfileViewModel({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required DonorRepository donorRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _donorRepository = donorRepository;

  // Observable states
  final _currentUser = Rxn<UserEntity>();
  final _donorProfile = Rxn<DonorEntity>();
  final _isLoading = false.obs;
  final _isDonor = false.obs;
  final _isAvailable = false.obs;

  // Form controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final _selectedBloodType = 'A+'.obs;

  // Getters
  UserEntity? get currentUser => _currentUser.value;
  DonorEntity? get donorProfile => _donorProfile.value;
  bool get isLoading => _isLoading.value;
  bool get isDonor => _isDonor.value;
  bool get isAvailable => _isAvailable.value;
  String get selectedBloodType => _selectedBloodType.value;

  // Blood type options
  final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> _loadProfile() async {
    _isLoading.value = true;

    // Get current user from auth
    final userId = _authRepository.currentUser?.id;
    if (userId != null) {
      // Get user data
      final userResult = await _userRepository.getUserById(userId);
      userResult.onSuccess((user) {
        _currentUser.value = user;
        nameController.text = user.name ?? '';
        phoneController.text = user.phoneNumber ?? '';
        _selectedBloodType.value = user.bloodType ?? 'A+';
      });

      // Check if user is a donor
      final donorResult = await _donorRepository.getDonorById(userId);
      donorResult.onSuccess((donor) {
        if (donor != null) {
          _donorProfile.value = donor;
          _isDonor.value = true;
          _isAvailable.value = donor.isAvailable;
        }
      });
    }

    _isLoading.value = false;
  }

  void setBloodType(String type) {
    _selectedBloodType.value = type;
  }

  /// Update user profile
  Future<bool> updateProfile() async {
    final userId = _authRepository.currentUser?.id;
    if (userId == null) return false;

    _isLoading.value = true;

    final currentEmail = _currentUser.value?.email ?? _authRepository.currentUser?.email ?? '';
    final updatedUser = (_currentUser.value ?? UserEntity(id: userId, email: currentEmail)).copyWith(
      name: nameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      bloodType: _selectedBloodType.value,
    );

    final result = await _userRepository.updateUser(updatedUser);

    _isLoading.value = false;

    return result.fold(
      onSuccess: (_) {
        _currentUser.value = updatedUser;
        Get.snackbar(
          'Success',
          'Profile updated successfully',
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

  /// Register as donor
  Future<bool> registerAsDonor() async {
    final userId = _authRepository.currentUser?.id;
    final user = _currentUser.value;
    if (userId == null || user == null) return false;

    _isLoading.value = true;

    final donor = DonorEntity(
      id: userId,
      userId: userId,
      name: user.name ?? '',
      phoneNumber: user.phoneNumber,
      bloodType: _selectedBloodType.value,
      city: user.city ?? '',
      isAvailable: true,
    );

    final result = await _donorRepository.registerDonor(donor);

    _isLoading.value = false;

    return result.fold(
      onSuccess: (_) {
        _donorProfile.value = donor;
        _isDonor.value = true;
        _isAvailable.value = true;
        Get.snackbar(
          'Success',
          'You are now registered as a donor',
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

  /// Toggle donor availability
  Future<void> toggleAvailability() async {
    final userId = _authRepository.currentUser?.id;
    if (userId == null || !_isDonor.value) return;

    final newAvailability = !_isAvailable.value;

    final result = await _donorRepository.updateDonorAvailability(
      donorId: userId,
      isAvailable: newAvailability,
    );

    result.fold(
      onSuccess: (_) {
        _isAvailable.value = newAvailability;
        Get.snackbar(
          'Success',
          newAvailability ? 'You are now available' : 'You are now unavailable',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
      onFailure: (failure) {
        Get.snackbar(
          'Error',
          failure.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  /// Sign out
  Future<void> signOut() async {
    final result = await _authRepository.signOut();
    result.fold(
      onSuccess: (_) => Get.offAllNamed('/login'),
      onFailure: (failure) => Get.snackbar('Error', failure.message),
    );
  }

  /// Refresh profile data
  void refreshProfile() {
    _loadProfile();
  }
}
