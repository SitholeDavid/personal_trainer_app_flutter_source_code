import 'package:flutter/cupertino.dart';
import 'package:personal_trainer_app/core/models/package.dart';
import 'package:personal_trainer_app/core/models/trainer.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_app/core/services/database_service/database_service.dart';
import 'package:personal_trainer_app/core/services/database_service/database_service_interface.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_app/core/utils.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PackageViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseServiceInterface>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final DialogService _dialogService = locator<DialogService>();
  final AuthService _authService = locator<AuthServiceInterface>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();

  var package = Package(title: '', description: '');
  var viewTitle;
  var viewSubTitle;
  var buttonTitle;
  String loadingText;
  bool newPackage = true;

  void initialise(Package existingPackage) {
    if (existingPackage != null) {
      package = existingPackage;
      newPackage = false;
    }

    viewTitle = newPackage ? 'Create new package' : 'Package details';
    viewSubTitle = newPackage
        ? 'Please enter the title and description of the package below'
        : 'View and update ${package.title} package details below';
    buttonTitle = newPackage ? 'Create package' : 'Update package';
  }

  void updateTitle() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Title',
        customData: dialogCustomData(package.title));

    package.title = response?.responseData?.toString();
    notifyListeners();
  }

  void updateDescription() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Description',
        customData: dialogCustomData(package.description));

    package.description = response?.responseData?.toString();
    notifyListeners();
  }

  void updatePrice() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Price',
        customData:
            dialogCustomData(package.price, inputType: TextInputType.number));

    package.price = response?.responseData == null
        ? 0.0
        : double.tryParse(response.responseData);

    notifyListeners();
  }

  void updateNoSessions() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.editInputField,
        title: 'Number of sessions',
        customData: dialogCustomData(package.noSessions));

    package.noSessions = response?.responseData == null
        ? 0
        : int.tryParse(response.responseData);
    notifyListeners();
  }

  void updateExpiryDate() async {
    var response = await _dialogService.showCustomDialog(
        variant: DialogType.choosePeriod,
        title: 'Expires after',
        customData: dialogCustomData(package.expiryDate));

    package.expiryDate = response?.responseData ?? 1;
    notifyListeners();
  }

  Future savePackage() async {
    if (package.title.isEmpty)
      showEmptyFieldSnackbar('Title');
    else if (package.description.isEmpty)
      showEmptyFieldSnackbar('Description');
    else {
      loadingText = 'Saving package..';
      setBusy(true);

      Trainer trainer = await _authService.getCurrentUser();
      String uid = trainer?.id;

      //Attempt to update package on firebase first
      bool cloudUpdated = await (newPackage
          ? _firestoreService.createPackage(uid, package)
          : _firestoreService.updatePackage(uid, package));

      //if firebase update fails, cancel operation
      if (!cloudUpdated) {
        _snackbarService.showSnackbar(
            message: newPackage
                ? 'Could not create package'
                : 'Could not update package',
            duration: Duration(seconds: 2));

        setBusy(false);
        return;
      }

      bool success = await (newPackage
          ? _databaseService.addPackage(package)
          : _databaseService.updatePackage(package));

      if (success) {
        _snackbarService.showSnackbar(
            message: newPackage
                ? 'Package successfully created'
                : 'Package successfully updated',
            duration: Duration(seconds: 2));

        await Future.delayed(
            Duration(seconds: 2), () => {_navigationService.popRepeated(1)});
      } else {
        _snackbarService.showSnackbar(
            message: newPackage
                ? 'Could not create package'
                : 'Could not update package',
            duration: Duration(seconds: 2));
      }

      setBusy(false);
    }
  }

  void deletePackage() async {
    loadingText = 'Deleting package..';
    setBusy(true);

    Trainer trainer = await _authService.getCurrentUser();
    String uid = trainer?.id;

    bool cloudDeleted =
        await _firestoreService.deletePackage(uid, package.packageID);

    if (!cloudDeleted) {
      _snackbarService.showSnackbar(
          message: 'Could not delete package', duration: Duration(seconds: 2));

      setBusy(false);
      return;
    }

    bool success = await _databaseService.deletePackage(package.id);
    if (success) {
      _snackbarService.showSnackbar(
          message: 'Package successfully deleted',
          duration: Duration(seconds: 2));

      Future.delayed(
          Duration(seconds: 2), () => _navigationService.popRepeated(1));
    } else {
      _snackbarService.showSnackbar(
          message: 'Could not delete package', duration: Duration(seconds: 2));
    }

    setBusy(false);
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
