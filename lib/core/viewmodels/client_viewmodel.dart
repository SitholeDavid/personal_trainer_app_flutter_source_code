import 'package:flutter/cupertino.dart';
import 'package:personal_trainer_app/core/models/client.dart';
import 'package:personal_trainer_app/core/models/trainer.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_app/core/services/image_selection_service.dart/image_selection_service.dart';
import 'package:personal_trainer_app/core/services/image_selection_service.dart/image_selection_service_interface.dart';
import 'package:personal_trainer_app/core/utils.dart';
import 'package:personal_trainer_app/ui/constants/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../locator.dart';

class ClientViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final DialogService _dialogService = locator<DialogService>();

  final AuthService _authService = locator<AuthServiceInterface>();
  final ImageSelectionService _imageService =
      locator<ImageSelectionServiceInterface>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();

  var client = Client();
  var viewTitle;
  var viewSubTitle;
  var buttonTitle;
  var currentWeight;
  var localImage;
  bool newClient = true;

  void initialise(Client existingClient) {
    if (existingClient != null) {
      client = existingClient;
      newClient = false;
      currentWeight = 0;
      localImage = null;
    }

    currentWeight = client.weight.length == 0 ? 0.0 : client.weight.last;
    viewTitle = newClient ? 'Create new client' : 'Client details';
    viewSubTitle = newClient
        ? 'Please enter the client\'s details below'
        : 'View and update ${client.name} client details below';
    buttonTitle = newClient ? 'Create client' : 'Update client';
  }

  void updateProfilePicture() async {
    localImage = await _imageService.chooseImageFromStorage();
    notifyListeners();
  }

  void updateName() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Name',
        customData: dialogCustomData(client.name));

    client.name = response?.responseData?.toString();
    notifyListeners();
  }

  void updateSurname() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Surname',
        customData: dialogCustomData(client.surname));

    client.surname = response?.responseData?.toString();
    notifyListeners();
  }

  void updateEmail() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Email',
        customData: dialogCustomData(client.name,
            inputType: TextInputType.emailAddress));

    client.email = response?.responseData?.toString();
    notifyListeners();
  }

  void updateWeight() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Current weight',
        customData:
            dialogCustomData(currentWeight, inputType: TextInputType.number));

    currentWeight = response?.responseData == null
        ? 0.0
        : double.tryParse(response.responseData);

    notifyListeners();
  }

  void updateHeight() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Height',
        customData:
            dialogCustomData(client.height, inputType: TextInputType.number));

    client.height = response?.responseData == null
        ? 0.0
        : double.tryParse(response.responseData);

    notifyListeners();
  }

  void updateHealthConditions() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Health conditions',
        customData: dialogCustomData(client.healthConditions));

    client.healthConditions = response?.responseData?.toString();
    notifyListeners();
  }

  void updatePhoneNo() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Phone number',
        customData:
            dialogCustomData(client.phoneNo, inputType: TextInputType.phone));

    client.phoneNo = response?.responseData?.toString();
    notifyListeners();
  }

  void navigateToPrevView() {
    _navigationService.popRepeated(1);
  }

  void showEmptyFieldSnackbar(String fieldTitle) {
    _snackbarService.showSnackbar(
        message: '$fieldTitle can not be empty',
        duration: Duration(seconds: 2));
  }

  Future saveClient() async {
    client.weight.add(currentWeight);
    try {
      Trainer trainer = await _authService.getCurrentUser();
      String uid = trainer?.id;

      bool success = await (newClient
          ? _firestoreService.createClient(uid, client)
          : _firestoreService.updateClient(uid, client));

      if (!success) throw Error();

      _snackbarService.showSnackbar(
          message: newClient
              ? 'Client successfully created'
              : 'Client successfully updated');
    } catch (e) {
      _snackbarService.showSnackbar(
          message: newClient
              ? 'Client could not be created'
              : 'Client could not be updated');
    }
  }

  Future deleteClient() async {
    try {
      Trainer trainer = await _authService.getCurrentUser();
      String uid = trainer?.id;

      bool success = await _firestoreService.deleteClient(uid, client.clientID);

      if (!success) throw Error();

      _snackbarService.showSnackbar(
          message: 'Client successfully deleted',
          duration: Duration(seconds: 2));

      Future.delayed(
          Duration(seconds: 2), () => _navigationService.popRepeated(1));
    } catch (e) {
      _snackbarService.showSnackbar(
          message: 'Client could not be deleted',
          duration: Duration(seconds: 2));
    }
  }
}
