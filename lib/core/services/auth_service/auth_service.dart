import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_trainer_app/core/models/trainer.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_app/locator.dart';

class AuthService extends AuthServiceInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = locator<FirestoreServiceInterface>();

  @override
  Future<Trainer> getCurrentUser() async {
    var user = await _auth.currentUser();
    if (user == null) return null;
    return await _firestore.getTrainer(user.uid);
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      var authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return authResult.user != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    if (await isUserLoggedIn()) {
      await _auth.signOut();
    }
  }

  @override
  Future<bool> signUpWithEmail(String email, String password, name) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (authResult == null) throw Error();

      var trainer = Trainer(id: authResult.user.uid, email: email, name: name);
      await _firestore.createTrainer(trainer);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    var user = await getCurrentUser();
    return user != null;
  }
}
