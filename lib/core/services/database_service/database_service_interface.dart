import 'package:personal_trainer_app/core/models/package.dart';
import 'package:personal_trainer_app/core/models/workout.dart';

abstract class DatabaseServiceInterface {
  Future<List<Workout>> getWorkouts();
  Future<bool> updateWorkout(Workout updatedWorkout);
  Future<bool> addWorkout(Workout newWorkout);
  Future<bool> deleteWorkout(int workoutID);
  Future<void> deleteAllWorkouts();

  Future<List<Package>> getPackages();
  Future<bool> updatePackage(Package updatedPackage);
  Future<bool> addPackage(Package newPackage);
  Future<bool> deletePackage(int packageID);
  Future<void> deleteAllPackages();
}
