import 'package:personal_trainer_app/core/models/client.dart';
import 'package:personal_trainer_app/core/models/trainer.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ClientsViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthServiceInterface>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();

  var clients = List<Client>();

  Future getClients() async {
    Trainer trainer = await _authService.getCurrentUser();
    String uid = trainer?.id;
    clients = await _firestoreService.getClients(uid);
    locator<SnackbarService>()
        .showSnackbar(message: clients[0].name, duration: Duration(seconds: 5));
    notifyListeners();
  }

  void navigateBackToPrevView() {
    _navigationService.popRepeated(1);
  }

  void navigateToCreateClient() {
    _navigationService.navigateTo(ClientViewRoute);
  }

  void navigateToClientDetail(Client selectedClient) {
    _navigationService.navigateTo(ClientViewRoute, arguments: selectedClient);
  }
}
