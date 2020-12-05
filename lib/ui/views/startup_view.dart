import 'package:flutter/material.dart';
import 'package:personal_trainer_app/core/viewmodels/startup_view_model.dart';
import 'package:stacked/stacked.dart';

class StartupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Text('Startup'),
      ),
      viewModelBuilder: () => StartupViewModel(),
      onModelReady: (model) async => await model.startupLogic(),
    );
  }
}
