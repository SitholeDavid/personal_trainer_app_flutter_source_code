import 'package:personal_trainer_app/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignUpViewModel extends BaseViewModel {
  AuthService _authService = locator<AuthServiceInterface>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  NavigationService _navigationService = locator<NavigationService>();

  Future<void> signUp(String email, String password, String name) async {
    var success = await _authService.signUpWithEmail(email, password, name);
    if (success) {
      _snackbarService.showSnackbar(
          message: 'Sign up successful', duration: Duration(seconds: 2));

      Future.delayed(Duration(seconds: 2),
          () => _navigationService.navigateTo(DashboardViewRoute));
    } else {
      _snackbarService.showSnackbar(
          message: 'Sign up failed. Please check your details and try again',
          duration: Duration(seconds: 2));
    }
  }
}
