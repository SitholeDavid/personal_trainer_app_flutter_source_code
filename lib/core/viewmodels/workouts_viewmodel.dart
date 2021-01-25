import 'package:personal_trainer_app/core/models/workout.dart';
import 'package:personal_trainer_app/core/services/database_service/database_service.dart';
import 'package:personal_trainer_app/core/services/database_service/database_service_interface.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class WorkoutsViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseServiceInterface>();
  var workouts = List<Workout>();

  Future getWorkouts() async {
    workouts = await _databaseService.getWorkouts();
    notifyListeners();
  }

  void navigateToWorkoutDetail(Workout selectedWorkout) {
    _navigationService.navigateTo(WorkoutViewRoute, arguments: selectedWorkout);
  }

  void navigateBackToPrevView() {
    _navigationService.popRepeated(1);
  }

  void navigateToCreateWorkout() {
    _navigationService.navigateTo(WorkoutViewRoute);
  }
}
