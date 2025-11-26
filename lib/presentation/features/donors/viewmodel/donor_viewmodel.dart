import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/donor_entity.dart';
import '../../../../domain/repositories/donor_repository.dart';

/// Donor ViewModel - handles donor state and logic
class DonorViewModel extends GetxController {
  final DonorRepository _donorRepository;

  DonorViewModel({required DonorRepository donorRepository})
      : _donorRepository = donorRepository;

  // Observable states
  final _donors = <DonorEntity>[].obs;
  final _filteredDonors = <DonorEntity>[].obs;
  final _isLoading = false.obs;
  final _selectedBloodType = RxnString();
  final _searchQuery = ''.obs;

  // Getters
  List<DonorEntity> get donors => _filteredDonors;
  List<DonorEntity> get allDonors => _donors;
  bool get isLoading => _isLoading.value;
  String? get selectedBloodType => _selectedBloodType.value;

  // Blood type options
  final bloodTypes = ['All', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void onInit() {
    super.onInit();
    _watchDonors();
  }

  void _watchDonors() {
    _donorRepository.watchAvailableDonors().listen((donorList) {
      _donors.value = donorList;
      _applyFilters();
    });
  }

  /// Filter donors by blood type
  void filterByBloodType(String? bloodType) {
    if (bloodType == 'All') {
      _selectedBloodType.value = null;
    } else {
      _selectedBloodType.value = bloodType;
    }
    _applyFilters();
  }

  /// Search donors
  void searchDonors(String query) {
    _searchQuery.value = query.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = _donors.toList();

    // Filter by blood type
    if (_selectedBloodType.value != null) {
      filtered = filtered
          .where((d) => d.bloodType == _selectedBloodType.value)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((d) {
        return d.name.toLowerCase().contains(_searchQuery.value) ||
            d.city.toLowerCase().contains(_searchQuery.value);
      }).toList();
    }

    _filteredDonors.value = filtered;
  }

  /// Load donors by blood type from server
  Future<void> loadDonorsByBloodType(String bloodType) async {
    _isLoading.value = true;

    final result = await _donorRepository.getDonorsByBloodType(bloodType);

    result.fold(
      onSuccess: (donorList) {
        _donors.value = donorList;
        _applyFilters();
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

    _isLoading.value = false;
  }

  /// Load donors by city
  Future<void> loadDonorsByCity(String city) async {
    _isLoading.value = true;

    final result = await _donorRepository.getDonorsByCity(city);

    result.fold(
      onSuccess: (donorList) {
        _donors.value = donorList;
        _applyFilters();
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

    _isLoading.value = false;
  }

  /// Register as donor
  Future<bool> registerAsDonor(DonorEntity donor) async {
    _isLoading.value = true;

    final result = await _donorRepository.registerDonor(donor);

    _isLoading.value = false;

    return result.fold(
      onSuccess: (_) {
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

  /// Update donor availability
  Future<void> updateAvailability(String donorId, bool isAvailable) async {
    final result = await _donorRepository.updateDonorAvailability(
      donorId: donorId,
      isAvailable: isAvailable,
    );

    result.fold(
      onSuccess: (_) {
        Get.snackbar(
          'Success',
          isAvailable ? 'You are now available' : 'You are now unavailable',
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

  /// Get blood type color
  Color getBloodTypeColor(String bloodType) {
    switch (bloodType) {
      case 'A+':
      case 'A-':
        return Colors.red;
      case 'B+':
      case 'B-':
        return Colors.blue;
      case 'AB+':
      case 'AB-':
        return Colors.purple;
      case 'O+':
      case 'O-':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void clearFilters() {
    _selectedBloodType.value = null;
    _searchQuery.value = '';
    _applyFilters();
  }
}
