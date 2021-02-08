import 'package:get_it/get_it.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_app/core/services/cloud_storage_service/cloud_storage_service.dart';
import 'package:personal_trainer_app/core/services/cloud_storage_service/cloud_storage_service_interface.dart';
import 'package:personal_trainer_app/core/services/database_service/database_service.dart';
import 'package:personal_trainer_app/core/services/database_service/database_service_interface.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_app/core/services/image_selection_service.dart/image_selection_service.dart';
import 'package:personal_trainer_app/core/services/image_selection_service.dart/image_selection_service_interface.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';
import 'package:stacked_services/stacked_services.dart';

import 'core/services/cloud_messaging_service/cloud_messaging_service.dart';
import 'core/services/cloud_messaging_service/cloud_messaging_service_interface.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AuthServiceInterface>(() => AuthService());
  locator.registerLazySingleton<FirestoreServiceInterface>(
      () => FirestoreService());

  locator
      .registerLazySingleton<DatabaseServiceInterface>(() => DatabaseService());
  locator.registerLazySingleton<ImageSelectionServiceInterface>(
      () => ImageSelectionService());
  locator.registerLazySingleton<CloudMessagingServiceInterface>(
      () => CloudMessagingService());
  locator.registerLazySingleton<CloudStorageServiceInterface>(
      () => CloudStorageService());

  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => DatabaseMigrationService());
}
