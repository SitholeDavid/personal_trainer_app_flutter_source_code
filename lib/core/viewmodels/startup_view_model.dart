import 'dart:developer';

import 'package:personal_trainer_app/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthServiceInterface>();

  Future startupLogic() async {
    var loggedIn = await _authService.isUserLoggedIn();
    log('Logged In: $loggedIn');
    if (loggedIn)
      _navigationService.navigateTo(DashboardViewRoute);
    else
      _navigationService.navigateTo(SignInViewRoute);
  }
}
