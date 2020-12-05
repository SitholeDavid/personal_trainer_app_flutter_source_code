import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_trainer_app/core/models/trainer.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service_interface.dart';

class FirestoreService extends FirestoreServiceInterface {
  CollectionReference _trainersRef = Firestore.instance.collection('trainers');

  @override
  Future<bool> createTrainer(Trainer trainer) async {
    try {
      await _trainersRef.document(trainer.id).setData(trainer.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Trainer> getTrainer(String trainerID) async {
    try {
      var trainerJson = await _trainersRef.document(trainerID).get();
      var trainer = Trainer.fromMap(trainerJson.data);
      return trainer;
    } catch (e) {
      return null;
    }
  }
}
