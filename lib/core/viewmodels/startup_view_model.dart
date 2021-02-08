import 'dart:developer';

import 'package:personal_trainer_app/core/models/trainer.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_app/core/services/cloud_messaging_service/cloud_messaging_service_interface.dart';
import 'package:personal_trainer_app/core/services/database_service/database_service.dart';
import 'package:personal_trainer_app/core/services/database_service/database_service_interface.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseServiceInterface>();
  final AuthService _authService = locator<AuthServiceInterface>();
  final _messagingService = locator<CloudMessagingServiceInterface>();
  final _firestoreService = locator<FirestoreServiceInterface>();

  Future startupLogic() async {
    await _databaseService.initialise();
    var loggedIn = await _authService.isUserLoggedIn();
    log('Logged In: $loggedIn');
    if (loggedIn) {
      String token = await _messagingService.getFCMToken();
      Trainer myAccount = await _authService.getCurrentUser();

      if (myAccount.myFCMToken.isEmpty || myAccount.myFCMToken != token) {
        myAccount.myFCMToken = token;
        _firestoreService.updateTrainer(myAccount);
      }

      _navigationService.replaceWith(DashboardViewRoute);
    } else
      _navigationService.replaceWith(SignInViewRoute);
  }
}
