import 'package:personal_trainer_app/core/models/package.dart';
import 'package:personal_trainer_app/core/models/trainer.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service.dart';
import 'package:personal_trainer_app/core/services/auth_service/auth_service_interface.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service.dart';
import 'package:personal_trainer_app/core/services/firestore_service/firestore_service_interface.dart';
import 'package:personal_trainer_app/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';

class PackagesViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthServiceInterface>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();

  var packages = List<Package>();

  Future getPackages() async {
    setBusy(true);
    Trainer trainer = await _authService.getCurrentUser();
    String uid = trainer?.id;
    packages = await _firestoreService.getPackages(uid);
    setBusy(false);
  }

  void navigateToPackageDetail(Package selectedPackage) async {
    await _navigationService.navigateTo(PackageViewRoute,
        arguments: selectedPackage);
    await getPackages();
  }

  void navigateBackToPrevView() {
    _navigationService.popRepeated(1);
  }

  void navigateToCreatePackage() async {
    await _navigationService.navigateTo(PackageViewRoute);
    await getPackages();
  }
}
