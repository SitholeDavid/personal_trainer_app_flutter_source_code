import 'package:stacked/stacked.dart';

class ChooseExpiryPeriodViewModel extends BaseViewModel {
  int periodCount = 1;
  String period = 'days';
  var periodOptions = <String>['days', 'weeks', 'months'];

  void updatePeriodCount(int newPeriod) {
    periodCount = newPeriod;
    notifyListeners();
  }

  void updatePeriod(String newPeriod) {
    period = newPeriod;
    notifyListeners();
  }
}
