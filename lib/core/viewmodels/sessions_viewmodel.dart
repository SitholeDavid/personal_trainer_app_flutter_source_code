import 'package:personal_trainer_app/core/models/purchase.dart';
import 'package:personal_trainer_app/core/models/session.dart';
import 'package:personal_trainer_app/core/models/trainer.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_app/core/services/cloud_messaging_service/cloud_messaging_service.dart';
import 'package:personal_trainer_app/core/services/cloud_messaging_service/cloud_messaging_service_interface.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_app/core/utils.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SessionsViewModel extends BaseViewModel {
  final DialogService _dialogService = locator<DialogService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();
  final AuthService _authService = locator<AuthServiceInterface>();
  final CloudMessagingService _messagingService =
      locator<CloudMessagingServiceInterface>();

  List<Session> sessions;
  List<DateTime> days;
  String trainerID;
  DateTime selectedDay;
  bool isUpdating = false;

  void setIsUpdating(bool status) {
    isUpdating = status;
    notifyListeners();
  }

  Future getSessions(String day) async {
    setBusy(true);
    generateDaysOfTheWeek();
    selectedDay = days[0];

    Trainer trainer = await _authService.getCurrentUser();
    trainerID = trainer?.id;

    sessions = await _firestoreService.getSessions(trainerID, 0);

    setBusy(false);
    notifyListeners();
  }

  Future changeDay(DateTime date) async {
    setBusy(true);

    int index = days.indexOf(date);
    selectedDay = days[index];

    sessions = await _firestoreService.getSessions(trainerID, index + 1);

    setBusy(false);
    notifyListeners();
  }

  Future updateSession(Session session) async {
    if (sessionHasPassed(session.startTime))
      return _snackbarService.showSnackbar(
          message: 'This session has already passed');

    var response = await _dialogService.showCustomDialog(
        variant: DialogType.updateBooking,
        additionalButtonTitle: session.client == 'Reserved'
            ? 'Make session available'
            : 'Make session unavailable',
        customData: dialogCustomData(session.client));

    Trainer trainer = await _authService.getCurrentUser();
    String trainerID = trainer?.id;

    bool sessionUpdated =
        response.responseData['selectedOption'] == null ? false : true;

    if (sessionUpdated) {
      setIsUpdating(true);

      String day = formatDay(session.startTime);
      String time = formatTime(DateTime.parse(session.startTime));

      cancelClientSession(
          clientID: session.clientID,
          clientToken: session.clientToken,
          day: day,
          time: time);

      switch (response.responseData['selectedOption'].toString().trim()) {
        case 'Reserve session':
          session.client = response.responseData['clientID'];
          session.clientToken = '';
          session.clientID = '';

          bool success = await _firestoreService.updateSession(
              trainerID, selectedDay.weekday, session);

          showResultSnackbar(success);
          break;

        case 'Cancel session':
          session.client = 'Available';
          session.clientToken = '';
          session.clientID = '';

          bool success = await _firestoreService.updateSession(
              trainerID, selectedDay.weekday, session);

          showResultSnackbar(success);
          break;

        case 'Make session unavailable':
          session.client = 'Reserved';
          session.clientToken = '';
          session.clientID = '';

          bool success = await _firestoreService.updateSession(
              trainerID, selectedDay.weekday, session);

          showResultSnackbar(success);
          break;
        case 'Make session available':
          session.client = 'Available';
          session.clientToken = '';
          session.clientID = '';

          bool success = await _firestoreService.updateSession(
              trainerID, selectedDay.weekday, session);

          showResultSnackbar(success);
          break;
      }

      setIsUpdating(false);
    }
  }

  bool sessionHasPassed(String time) {
    DateTime startTime = DateTime.parse(time);
    DateTime now = DateTime.now();
    return startTime.isBefore(now);
  }

  void cancelClientSession(
      {String clientToken,
      String clientID,
      String day,
      String time,
      bool reimburse = true}) async {
    if (clientID == null || clientID.isEmpty || clientToken.isEmpty) return;

    if (reimburse) {
      Purchase clientPackage =
          await _firestoreService.getClientPackage(trainerID, clientID);

      if (clientPackage != null) {
        clientPackage.sessionsCompleted = clientPackage.sessionsCompleted > 0
            ? clientPackage.sessionsCompleted - 1
            : 0;

        await _firestoreService.updateClientPackage(
            trainerID, clientID, clientPackage);
      }
    }

    await _messagingService.trainerCancelBookingAlert(
        clientToken: clientToken, day: day, time: time);
  }

  void showResultSnackbar(bool success) {
    _snackbarService.showSnackbar(
        message: success
            ? 'Session successfully updated'
            : 'Session could not be updated',
        duration: Duration(seconds: 2));
  }

  Future reserveSession(Session session) async {}

  Future clearSession(Session session) async {}

  Future bookSession(Session session) async {}

  void generateDaysOfTheWeek() {
    DateTime refPoint = DateTime.now();
    days = List<DateTime>();

    for (int i = 0; i < refPoint.weekday; i++)
      days.add(refPoint.subtract(Duration(days: i)));

    for (int i = 7 - refPoint.weekday; i > 0; i--)
      days.add(refPoint.add(Duration(days: i)));

    days.sort((a, b) {
      if (a.weekday > b.weekday) {
        return 1;
      } else if (a.weekday < b.weekday) {
        return -1;
      } else
        return 0;
    });
  }
}
