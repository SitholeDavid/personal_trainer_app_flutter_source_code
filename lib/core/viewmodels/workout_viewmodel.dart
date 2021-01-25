import 'package:personal_trainer_app/core/models/workout.dart';
import 'package:personal_trainer_app/core/services/database_service/database_service.dart';
import 'package:personal_trainer_app/core/services/database_service/database_service_interface.dart';
import 'package:personal_trainer_app/core/utils.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class WorkoutViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseServiceInterface>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final DialogService _dialogService = locator<DialogService>();

  var workout = Workout(title: '', description: '');
  var viewTitle;
  var viewSubTitle;
  var buttonTitle;
  bool newWorkout = true;

  void initialise(Workout existingWorkout) {
    if (existingWorkout != null) {
      workout = existingWorkout;
      newWorkout = false;
    }

    viewTitle = newWorkout ? 'Create new workout' : 'Workout details';
    viewSubTitle = newWorkout
        ? 'Please enter the title and description of the workout below'
        : 'View and update ${workout.title} workout details below';
    buttonTitle = newWorkout ? 'Create workout' : 'Update workout';
  }

  void updateTitle() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Title',
        customData: dialogCustomData(workout.title));

    workout.title = response.responseData?.toString();
    notifyListeners();
  }

  void updateDescription() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Description',
        customData: dialogCustomData(workout.description));

    workout.description = response.responseData?.toString();
    notifyListeners();
  }

  Future saveWorkout() async {
    if (workout.title.isEmpty)
      showEmptyFieldSnackbar('Title');
    else if (workout.description.isEmpty)
      showEmptyFieldSnackbar('Description');
    else {
      bool success = await (newWorkout
          ? _databaseService.addWorkout(workout)
          : _databaseService.updateWorkout(workout));
      if (success) {
        _snackbarService.showSnackbar(
            message: newWorkout
                ? 'Workout successfully created'
                : 'Workout successfully updated',
            duration: Duration(seconds: 2));

        await Future.delayed(
            Duration(seconds: 2), () => {_navigationService.popRepeated(1)});
      } else {
        _snackbarService.showSnackbar(
            message: newWorkout
                ? 'Could not create workout'
                : 'Could not update workout',
            duration: Duration(seconds: 2));
      }
    }
  }

  void deleteWorkout() async {
    bool success = await _databaseService.deleteWorkout(workout.workoutID);
    if (success) {
      _snackbarService.showSnackbar(
          message: 'Workout successfully deleted',
          duration: Duration(seconds: 2));

      Future.delayed(
          Duration(seconds: 2), () => _navigationService.popRepeated(1));
    } else {
      _snackbarService.showSnackbar(
          message: 'Could not delete workout', duration: Duration(seconds: 2));
    }
  }

  void navigateToPrevView() {
    _navigationService.popRepeated(1);
  }

  void showEmptyFieldSnackbar(String fieldTitle) {
    _snackbarService.showSnackbar(
        message: '$fieldTitle can not be empty',
        duration: Duration(seconds: 2));
  }
}
