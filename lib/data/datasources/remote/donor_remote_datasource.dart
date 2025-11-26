import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/donor_model.dart';

/// Donor remote data source interface
abstract class DonorRemoteDataSource {
  Future<List<DonorModel>> getAllDonors();
  Future<List<DonorModel>> getDonorsByBloodType(String bloodType);
  Future<List<DonorModel>> getDonorsByCity(String city);
  Future<DonorModel> getDonorById(String donorId);
  Future<DonorModel> registerDonor(DonorModel donor);
  Future<void> updateDonorAvailability(String donorId, bool isAvailable);
  Future<void> updateDonor(DonorModel donor);
  Future<void> deleteDonor(String donorId);
  Stream<List<DonorModel>> watchDonors();
  Stream<List<DonorModel>> watchAvailableDonors();
}

/// Donor remote data source implementation
class DonorRemoteDataSourceImpl implements DonorRemoteDataSource {
  final FirebaseFirestore firestore;

  DonorRemoteDataSourceImpl({required this.firestore});

  CollectionReference get _donorsCollection => firestore.collection('donors');

  @override
  Future<List<DonorModel>> getAllDonors() async {
    try {
      final query = await _donorsCollection.get();
      return query.docs.map((doc) => DonorModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<DonorModel>> getDonorsByBloodType(String bloodType) async {
    try {
      final query = await _donorsCollection
          .where('bloodType', isEqualTo: bloodType)
          .where('isAvailable', isEqualTo: true)
          .get();
      return query.docs.map((doc) => DonorModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<DonorModel>> getDonorsByCity(String city) async {
    try {
      final query = await _donorsCollection
          .where('city', isEqualTo: city)
          .where('isAvailable', isEqualTo: true)
          .get();
      return query.docs.map((doc) => DonorModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<DonorModel> getDonorById(String donorId) async {
    try {
      final doc = await _donorsCollection.doc(donorId).get();
      if (!doc.exists) {
        throw const NotFoundException(message: 'Donor not found');
      }
      return DonorModel.fromFirestore(doc);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<DonorModel> registerDonor(DonorModel donor) async {
    try {
      final docRef = await _donorsCollection.add(donor.toMap());
      final doc = await docRef.get();
      return DonorModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateDonorAvailability(String donorId, bool isAvailable) async {
    try {
      await _donorsCollection.doc(donorId).update({'isAvailable': isAvailable});
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateDonor(DonorModel donor) async {
    try {
      await _donorsCollection.doc(donor.id).update(donor.toMap());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteDonor(String donorId) async {
    try {
      await _donorsCollection.doc(donorId).delete();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<List<DonorModel>> watchDonors() {
    return _donorsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => DonorModel.fromFirestore(doc)).toList();
    });
  }

  @override
  Stream<List<DonorModel>> watchAvailableDonors() {
    return _donorsCollection
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => DonorModel.fromFirestore(doc)).toList();
    });
  }
}
