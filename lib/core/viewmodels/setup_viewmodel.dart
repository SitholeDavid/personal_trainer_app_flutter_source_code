import 'dart:developer';

import 'package:personal_trainer_app/core/constants/working_days.dart';
import 'package:personal_trainer_app/core/models/working_day.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/enums.dart';
import 'package:personal_trainer_app/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SetupViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  var days = List<WorkingDay>();
  int dayIndex = 0;
  get currentDay => days[dayIndex];

  void setupWorkingDays(Map<int, bool> selectedDays) {
    selectedDays.forEach((key, isSelected) {
      if (isSelected) {
        var workingDay = WorkingDay(title: workingDays[key], key: key);
        days.add(workingDay);
      }
    });

    notifyListeners();
  }

  void showStartTimeDialog() async {
    var response =
        await _dialogService.showCustomDialog(variant: DialogType.timePicker);
    days[dayIndex].startTime = response.responseData as DateTime;
    notifyListeners();
  }

  void showEndTimeDialog() async {
    var response =
        await _dialogService.showCustomDialog(variant: DialogType.timePicker);
    days[dayIndex].endTime = response.responseData as DateTime;
    notifyListeners();
  }

  void showDurationDialog() async {
    var response =
        await _dialogService.showCustomDialog(variant: DialogType.timePicker);
    days[dayIndex].duration = response.responseData as DateTime;
    notifyListeners();
  }

  void goToNextDay() {
    if (dayIndex + 1 == days.length)
      navigateToDashboard();
    else {
      dayIndex++;
      notifyListeners();
    }
  }

  void goToPrevDay() {
    if (dayIndex != 0) dayIndex--;
    notifyListeners();
  }

  void navigateToDashboard() =>
      _navigationService.navigateTo(DashboardViewRoute);
}
