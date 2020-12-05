import 'package:personal_trainer_app/core/models/trainer.dart';

abstract class FirestoreServiceInterface {
  Future<bool> createTrainer(Trainer trainer);
  Future<Trainer> getTrainer(String trainerID);
}
