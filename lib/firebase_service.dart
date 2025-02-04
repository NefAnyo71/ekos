import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> insertFeedback(Map<String, dynamic> data) async {
    await _firestore.collection('feedback').add(data);
  }

  Future<void> insertTournamentRegistration(Map<String, dynamic> data) async {
    await _firestore.collection('tournament_registrations').add(data);
  }
}
