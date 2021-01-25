import 'package:personal_trainer_app/core/constants/working_days.dart';
import 'package:personal_trainer_app/core/models/session.dart';
import 'package:personal_trainer_app/core/models/trainer.dart';
import 'package:personal_trainer_app/core/models/working_day.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_app/core/utils.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/enums.dart';
import 'package:personal_trainer_app/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SetupViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();
  final AuthService _authService = locator<AuthServiceInterface>();

  var days = List<WorkingDay>();
  var offDays = List<WorkingDay>();
  int dayIndex = 0;
  get currentDay => days[dayIndex];

  void setupWorkingDays(Map<int, bool> selectedDays) async {
    selectedDays.forEach((key, isSelected) {
      if (isSelected) {
        var workingDay =
            WorkingDay(title: workingDays[key], key: key, working: true);
        days.add(workingDay);
      } else {
        var offDay = WorkingDay(title: workingDays[key], working: false);
        offDays.add(offDay);
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

  void goToNextDay() async {
    if (days[dayIndex].endTime.hour < days[dayIndex].startTime.hour) {
      _snackbarService.showSnackbar(
          message: 'End time can not be before start time');

      return;
    } else if (days[dayIndex].endTime.hour <= days[dayIndex].startTime.hour &&
        days[dayIndex].endTime.minute < days[dayIndex].startTime.minute) {
      _snackbarService.showSnackbar(
          message: 'End time can not be before start time');

      return;
    }

    if (dayIndex + 1 == days.length) {
      bool success = await createNewSessions();

      if (success) {
        _snackbarService.showSnackbar(
            message: 'Workings hours have been successfully updated',
            duration: Duration(seconds: 2));

        Future.delayed(Duration(seconds: 2), navigateToDashboard);
      } else {
        _snackbarService.showSnackbar(
            message: 'Failed to set working hours. Please try again later');
      }
    } else {
      dayIndex++;
      notifyListeners();
    }
  }

  Future<bool> createNewSessions() async {
    setBusy(true);
    try {
      Trainer trainer = await _authService.getCurrentUser();
      String uid = trainer?.id;

      const daysList = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];

      for (String day in daysList) {
        await _firestoreService.deleteSessions(uid, day);
      }

      for (WorkingDay workingDay in days) {
        var sessions = workingDay.working
            ? createSessions(workingDay.title, workingDay.startTime,
                workingDay.endTime, workingDay.duration)
            : <Session>[];

        bool success = await _firestoreService.createNewSessions(
            uid, workingDay.title, sessions);

        if (!success) return false;
      }

      setBusy(false);
      return true;
    } catch (e) {
      setBusy(false);
      return false;
    }
  }

  void goToPrevDay() {
    if (dayIndex != 0) dayIndex--;
    notifyListeners();
  }

  void navigateToDashboard() =>
      _navigationService.navigateTo(DashboardViewRoute);
}
