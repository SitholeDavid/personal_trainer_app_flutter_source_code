import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:personal_trainer_app/core/constants/working_days.dart';
import 'package:personal_trainer_app/core/models/client.dart';
import 'package:personal_trainer_app/core/models/purchase.dart';
import 'package:personal_trainer_app/core/models/session.dart';
import 'package:personal_trainer_app/core/models/package.dart';
import 'package:personal_trainer_app/core/models/trainer.dart';
import 'package:personal_trainer_app/core/models/working_day.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service_interface.dart';

class FirestoreService extends FirestoreServiceInterface {
  CollectionReference _trainersRef = Firestore.instance.collection('trainers');
  CollectionReference _workingDaysRef =
      Firestore.instance.collection('working-days');
  CollectionReference _packagesRef = Firestore.instance.collection('packages');
  CollectionReference _clientsRef = Firestore.instance.collection('clients');
  CollectionReference _sessionsRef = Firestore.instance.collection('sessions');
  CollectionReference _purchasesRef =
      Firestore.instance.collection('purchases');

  HttpsCallable createClientProfile =
      CloudFunctions.instance.getHttpsCallable(functionName: 'createClient');

  @override
  Future<bool> createTrainer(Trainer trainer) async {
    try {
      await _trainersRef.document(trainer.id).setData(trainer.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Trainer> getTrainer(String trainerID) async {
    try {
      var trainerJson = await _trainersRef.document(trainerID).get();
      var trainer = Trainer.fromMap(trainerJson.data, trainerID);
      return trainer;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> createClient(String trainerID, Client client) async {
    client.trainers.add(trainerID);

    try {
      var result = await getClient(trainerID, client.clientID);
      bool clientExists = result != null;
      String uid = '';

      if (!clientExists) {
        var result = await createClientProfile
            .call({"email": client.email, "password": 'temp123!'});
        uid = result.data as String;

        if (uid == null) return '';
        client.clientID = uid;

        await _clientsRef.document(uid).setData(client.toJson());
      } else {
        await updateClient(trainerID, client);
      }

      return uid;
    } catch (e) {
      return '';
    }
  }

  @override
  Future<bool> createPackage(String trainerID, Package package) async {
    try {
      await _packagesRef
          .document(trainerID)
          .collection('my-packages')
          .add(package.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteClient(String trainerID, String clientID) async {
    try {
      await _clientsRef.document(clientID).delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deletePackage(String trainerID, String packageID) async {
    try {
      await _packagesRef
          .document(trainerID)
          .collection('my-packages')
          .document(packageID)
          .delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Client> getClient(String trainerID, String clientID) async {
    try {
      var clientJson = await _clientsRef.document(clientID).get();

      if (clientJson == null) return null;

      return Client.fromMap(clientJson.data, clientJson.documentID);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Client>> getClients(String trainerID) async {
    try {
      var clientsQuery =
          _clientsRef.where('trainers', arrayContainsAny: [trainerID]);

      var clientsJson = await clientsQuery.getDocuments();

      if (clientsJson == null || clientsJson.documents.isEmpty)
        return <Client>[];

      return clientsJson.documents
          .map((snapshot) => Client.fromMap(snapshot.data, snapshot.documentID))
          .toList();
    } catch (e) {
      return <Client>[Client(name: '${e.toString()}')];
    }
  }

  @override
  Future<List<Package>> getPackages(String trainerID) async {
    try {
      var packagesJson = await _packagesRef
          .document(trainerID)
          .collection('my-packages')
          .getDocuments();

      if (packagesJson == null) return <Package>[];

      return packagesJson.documents
          .map(
              (snapshot) => Package.fromMap(snapshot.data, snapshot.documentID))
          .toList();
    } catch (e) {
      return <Package>[];
    }
  }

  @override
  Future<List<Session>> getSessions(String trainerID, int weekday) async {
    try {
      var sessionCollectionID = workingDays[weekday];
      var sessionsJson = await _sessionsRef
          .document(trainerID)
          .collection(sessionCollectionID)
          .getDocuments();

      if (sessionsJson == null) return <Session>[];

      var sessions = sessionsJson.documents
          .map(
              (snapshot) => Session.fromMap(snapshot.data, snapshot.documentID))
          .toList();

      var sortedSessions = sortSessions(sessions);
      return sortedSessions;
    } catch (e) {
      return <Session>[];
    }
  }

  @override
  Future<List<WorkingDay>> getWorkingDays(String trainerID) async {
    try {
      var workingDaysJson = await _workingDaysRef.document(trainerID).get();
      var workingDays = workingDaysJson.data['days'];
      if (workingDays == null) return <WorkingDay>[];

      return workingDays.map((day) => WorkingDay.fromString(day)).toList();
    } catch (e) {
      return <WorkingDay>[];
    }
  }

  @override
  Future<bool> updateClient(String trainerID, Client updatedClient) async {
    try {
      await _clientsRef
          .document(updatedClient.clientID)
          .updateData(updatedClient.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updatePackage(String trainerID, Package package) async {
    try {
      await _packagesRef
          .document(trainerID)
          .collection('my-packages')
          .document(package.packageID)
          .updateData(package.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateSession(
      String trainerID, int weekday, Session session) async {
    try {
      var sessionCollectionID = workingDays[weekday];
      await _sessionsRef
          .document(trainerID)
          .collection(sessionCollectionID)
          .document(session.sessionID)
          .updateData(session.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateTrainer(Trainer trainer) async {
    try {
      await _trainersRef.document(trainer.id).updateData(trainer.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateWorkingDays(
      String trainerID, List<WorkingDay> workingDays) async {
    try {
      var workingDaysList = <String>[];
      workingDays.forEach((day) => workingDaysList.add(day.toString()));
      await _workingDaysRef
          .document(trainerID)
          .setData({'days': workingDaysList});

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> createNewSessions(
      String trainerID, String day, List<Session> sessions) async {
    for (Session session in sessions) {
      await _sessionsRef
          .document(trainerID)
          .collection(day)
          .add(session.toJson());
    }

    return true;
  }

  List<Session> sortSessions(List<Session> sessions) {
    sessions.sort((a, b) {
      var aStartTime = DateTime.parse(a.startTime);
      var bStartTime = DateTime.parse(b.startTime);

      if (aStartTime.isBefore(bStartTime)) {
        return -1;
      } else {
        return 1;
      }
    });

    return sessions;
  }

  Future deleteSessions(String trainerID, String day) async {
    try {
      var documentSnapshots =
          await _sessionsRef.document(trainerID).collection(day).getDocuments();

      for (var snapshot in documentSnapshots.documents) {
        await snapshot.reference.delete();
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Purchase> getClientPackage(String trainerID, String clientID) async {
    try {
      var jsonData = await _purchasesRef
          .document(trainerID)
          .collection('client-purchases')
          .document(clientID)
          .get();

      Purchase purchase = Purchase.fromMap(jsonData.data, jsonData.documentID);
      return purchase;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateClientPackage(
      String trainerID, String clientID, Purchase purchase) async {
    try {
      await _purchasesRef
          .document(trainerID)
          .collection('client-purchases')
          .document(clientID)
          .updateData(purchase.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }
}
