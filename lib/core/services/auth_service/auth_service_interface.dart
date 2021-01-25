import 'package:personal_trainer_app/core/models/trainer.dart';

abstract class AuthServiceInterface {
  Future<Trainer> getCurrentUser();
  Future<bool> signInWithEmail(String email, String password);
  Future<bool> signUpWithEmail(String email, String password, String name);
  Future<String> signUpClientWithEmail(String email, String password);
  Future<bool> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Future<bool> isUserLoggedIn();
}
