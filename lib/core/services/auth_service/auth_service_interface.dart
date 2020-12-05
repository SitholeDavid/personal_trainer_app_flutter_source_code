import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_trainer_app/core/models/trainer.dart';

abstract class AuthServiceInterface {
  Future<Trainer> getCurrentUser();
  Future<bool> signInWithEmail(String email, String password);
  Future<bool> signUpWithEmail(String email, String password, name);
  Future<bool> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Future<bool> isUserLoggedIn();
}
