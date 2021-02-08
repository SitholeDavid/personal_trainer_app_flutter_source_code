import 'package:personal_trainer_app/core/models/session.dart';
import 'package:personal_trainer_app/core/models/trainer.dart';
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

class DashboardViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();
  final AuthService _authService = locator<AuthServiceInterface>();

  var sessions = List<Session>();
  Session upcomingSession;
  var nextThreeSessions = List<Session>();
  int sessionsLeft;

  Future fetchSessions() async {
    setBusy(true);
    notifyListeners();

    Trainer trainer = await _authService.getCurrentUser();
    String trainerID = trainer?.id;
    int weekday = DateTime.now().weekday;

    sessions = await _firestoreService.getSessions(trainerID, weekday);
    sessions = getBookedSessions();
    nextThreeSessions = <Session>[];

    if (sessions.length < 3) {
      if (sessions.length != 0) {
        nextThreeSessions = sessions.sublist(0, sessions.length);
      }

      for (var i = 0; i < 3 - sessions.length; i++) {
        nextThreeSessions.add(Session(
            sessionID: 'null',
            startTime: '-',
            clientID: '',
            client: '-',
            clientToken: ''));
      }
    } else {
      nextThreeSessions = sessions.sublist(0, 3);
    }

    sessionsLeft = countRemainingSessions();
    upcomingSession = nextThreeSessions[0];

    setBusy(false);
    notifyListeners();
  }

  List<Session> getBookedSessions() {
    var bookedSessions = <Session>[];
    for (Session session in sessions) {
      if (session.client != 'Available' && session.client != 'Reserved')
        bookedSessions.add(session);
    }

    return bookedSessions;
  }

  int countRemainingSessions() {
    var bookedSessions = getBookedSessions();
    var currentTime = DateTime.now();
    int count = 0;

    for (Session session in bookedSessions) {
      var sessionStartTime = DateTime.parse(session.startTime);
      if (timeComesBefore(currentTime, sessionStartTime) ||
          timesAreEqual(currentTime, sessionStartTime)) count++;
    }

    return count;
  }

  void openDrawer() async {
    Trainer trainer = await _authService.getCurrentUser();
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.drawer, title: trainer.name);

    if (response != null) {
      switch (response.responseData) {
        case 'setup':
          navigateToSetup();
          break;
        case 'logout':
          logout();
          break;
      }
    }
  }

  void logout() async {
    await _authService.signOut();
    _navigationService.clearStackAndShow(SignInViewRoute);
  }

  void navigateToSetup() {
    _navigationService.navigateTo(SelectWorkingDaysViewRoute);
  }

  void navigateToSessions() {
    _navigationService.navigateTo(SessionsViewRoute);
  }

  void navigateToClients() {
    _navigationService.navigateTo(ClientsViewRoute);
  }

  void navigateToPayments() {
    _navigationService.navigateTo(PaymentsViewRoute);
  }

  void navigateToWorkouts() {
    _navigationService.navigateTo(WorkoutsViewRoute);
  }

  void navigateToPackages() {
    _navigationService.navigateTo(PackagesViewRoute);
  }
}
