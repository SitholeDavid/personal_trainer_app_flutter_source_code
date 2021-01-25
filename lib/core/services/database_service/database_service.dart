import 'package:personal_trainer_app/core/models/package.dart';
import 'package:personal_trainer_app/core/models/workout.dart';
import 'package:personal_trainer_app/core/services/database_service/database_service_interface.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';
import 'package:stacked_services/stacked_services.dart';

class DatabaseService extends DatabaseServiceInterface {
  static const String DB_NAME = 'personal_trainer_db.sqlite';
  static const String WorkoutsTable = 'workouts';
  static const String PackagesTable = 'packages';
  static const int DB_VERSION = 4;

  Database _database;

  final DatabaseMigrationService _migrationService =
      locator<DatabaseMigrationService>();

  Future initialise() async {
    _database = await openDatabase(DB_NAME, version: DB_VERSION);

    await _migrationService
        .runMigration(_database, migrationFiles: ['1_create_schema.sql']);
  }

  @override
  Future<bool> addWorkout(Workout newWorkout) async {
    try {
      var jsonData = newWorkout.toJson();
      await _database.insert(WorkoutsTable, jsonData);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Workout>> getWorkouts() async {
    try {
      List<Map> result = await _database.query(WorkoutsTable);
      return result.map((workout) => Workout.fromMap(workout)).toList();
    } catch (e) {
      return List<Workout>();
    }
  }

  @override
  Future<bool> updateWorkout(Workout updatedWorkout) async {
    try {
      await _database.update(WorkoutsTable, updatedWorkout.toJson(),
          where: 'id = ?', whereArgs: [updatedWorkout.workoutID]);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteWorkout(int workoutID) async {
    try {
      await _database
          .delete(WorkoutsTable, where: 'id = ?', whereArgs: [workoutID]);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> deleteAllWorkouts() async {
    try {
      await _database.delete(WorkoutsTable);
    } catch (e) {}
  }

  @override
  Future<bool> addPackage(Package newPackage) async {
    try {
      var jsonData = newPackage.toJson();
      await _database.insert(PackagesTable, jsonData);
      return true;
    } catch (e) {
      locator<SnackbarService>().showSnackbar(
          message: newPackage.toJson().toString(),
          duration: Duration(seconds: 5));
      return false;
    }
  }

  @override
  Future<void> deleteAllPackages() async {
    try {
      await _database.delete(PackagesTable);
    } catch (e) {}
  }

  @override
  Future<bool> deletePackage(int packageID) async {
    try {
      await _database
          .delete(PackagesTable, where: 'id = ?', whereArgs: [packageID]);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Package>> getPackages() async {
    try {
      var result = await _database.query(PackagesTable);
      return result.map((package) => Package.fromMap(package, '')).toList();
    } catch (e) {
      return List<Package>();
    }
  }

  @override
  Future<bool> updatePackage(Package updatedPackage) async {
    try {
      await _database.update(PackagesTable, updatedPackage.toJson(),
          where: 'id = ?', whereArgs: [updatedPackage.id]);
      return true;
    } catch (e) {
      return false;
    }
  }
}
