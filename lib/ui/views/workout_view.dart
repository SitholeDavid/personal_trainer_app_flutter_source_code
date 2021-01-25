import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:personal_trainer_app/core/models/workout.dart';
import 'package:personal_trainer_app/core/viewmodels/workout_viewmodel.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';
import 'package:personal_trainer_app/ui/constants/margins.dart';
import 'package:personal_trainer_app/ui/constants/text_sizes.dart';
import 'package:personal_trainer_app/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_app/ui/shared/custom_text_button.dart';
import 'package:personal_trainer_app/ui/shared/display_input_field.dart';
import 'package:stacked/stacked.dart';

class WorkoutView extends StatelessWidget {
  final Workout existingWorkout;
  WorkoutView({this.existingWorkout});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WorkoutViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundColor,
              body: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: pageHorizontalMargin,
                    vertical: pageVerticalMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mediumSpace,
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: model.navigateToPrevView),
                        Text(
                          model.viewTitle,
                          style: largeTextFont.copyWith(
                              fontSize: 22, color: primaryColorDark),
                        ),
                      ],
                    ),
                    mediumSpace,
                    Text(
                      model.viewSubTitle,
                      style: mediumTextFont,
                    ),
                    largeSpace,
                    Flexible(
                        child: ListView(
                      children: [
                        displayInputField(
                            'Title', model.workout.title, model.updateTitle),
                        displayInputField('Description',
                            model.workout.description, model.updateDescription),
                        mediumSpace,
                        model.newWorkout
                            ? Text('')
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: 20, right: 10),
                                    child: IconButton(
                                        icon: Icon(
                                          FontAwesome5.trash_alt,
                                          color: primaryColorDark,
                                          size: 40,
                                        ),
                                        onPressed: model.deleteWorkout),
                                  ),
                                ],
                              ),
                        customTextButton(
                            buttonText: model.buttonTitle,
                            onTapCallback: model.saveWorkout)
                      ],
                    )),
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => WorkoutViewModel(),
        onModelReady: (model) => model.initialise(existingWorkout));
  }
}
