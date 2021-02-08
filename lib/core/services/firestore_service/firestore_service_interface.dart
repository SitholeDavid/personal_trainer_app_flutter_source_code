import 'package:personal_trainer_app/core/models/client.dart';
import 'package:personal_trainer_app/core/models/package.dart';
import 'package:personal_trainer_app/core/models/purchase.dart';
import 'package:personal_trainer_app/core/models/session.dart';
import 'package:personal_trainer_app/core/models/trainer.dart';
import 'package:personal_trainer_app/core/models/working_day.dart';

abstract class FirestoreServiceInterface {
  Future<bool> createTrainer(Trainer trainer);
  Future<Trainer> getTrainer(String trainerID);
  Future<bool> updateTrainer(Trainer trainer);

  Future<List<Package>> getPackages(String trainerID);
  Future<bool> createPackage(String trainerID, Package package);
  Future<bool> deletePackage(String trainerID, String packageID);
  Future<bool> updatePackage(String trainerID, Package package);

  Future<List<WorkingDay>> getWorkingDays(String trainerID);
  Future<bool> updateWorkingDays(
      String trainerID, List<WorkingDay> workingDays);

  Future<List<Session>> getSessions(String trainerID, int weekday);
  Future<bool> createNewSessions(
      String trainerID, String day, List<Session> sessions);
  Future<bool> updateSession(String trainerID, int weekday, Session session);

  Future<String> createClient(String trainerID, Client client);
  Future<Client> getClient(String trainerID, String clientID);
  Future<bool> updateClient(String trainerID, Client updatedClient);
  Future<bool> deleteClient(String trainerID, String clientID);
  Future<Purchase> getClientPackage(String trainerID, String clientID);
  Future<bool> updateClientPackage(
      String trainerID, String clientID, Purchase purchase);
  Future<List<Client>> getClients(String trainerID);
}
