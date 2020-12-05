import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectWorkingDaysViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  Set<int> selectedDays;

  Map<int, bool> dayIsChecked = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
    6: false,
    7: false
  };

  void daySelected(bool selected, int day) {
    dayIsChecked[day] = selected;
    notifyListeners();
  }

  void navigateToSetupView() {
    _navigationService.navigateTo(SetupViewRoute, arguments: dayIsChecked);
  }
}
