import 'dart:developer';

import 'package:personal_trainer_app/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_app/core/services/database_service/database_service.dart';
import 'package:personal_trainer_app/core/services/database_service/database_service_interface.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseServiceInterface>();
  final AuthService _authService = locator<AuthServiceInterface>();

  Future startupLogic() async {
    await _databaseService.initialise();
    var loggedIn = await _authService.isUserLoggedIn();
    log('Logged In: $loggedIn');
    if (loggedIn)
      // _navigationService.navigateTo(SelectWorkingDaysViewRoute);
      _navigationService.replaceWith(DashboardViewRoute);
    else
      _navigationService.replaceWith(SignInViewRoute);
  }
}
