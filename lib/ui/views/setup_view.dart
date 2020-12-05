import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:personal_trainer_app/core/viewmodels/setup_viewmodel.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';
import 'package:personal_trainer_app/ui/constants/margins.dart';
import 'package:personal_trainer_app/ui/constants/text_sizes.dart';
import 'package:personal_trainer_app/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_app/ui/widgets/arrow_button.dart';
import 'package:stacked/stacked.dart';

class SetupView extends StatelessWidget {
  final Map<int, bool> selectedDays;
  SetupView({this.selectedDays});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SetupViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: pageHorizontalMargin, vertical: pageVerticalMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              largeSpace,
              Text(
                'Select working hours for',
                style: largeTextFont,
              ),
              Text(
                model.currentDay.title,
                style: largeTextFont.copyWith(color: primaryColorDark),
              ),
              mediumSpace,
              Text(
                'Select the start time, end time and duration of each session on ${model.currentDay.title}',
                style: mediumTextFont,
              ),
              largeSpace,
              Text(
                'Start time',
                style: smallTextFont,
              ),
              smallSpace,
              displayTime(model.showStartTimeDialog,
                  '${model.currentDay.startTime.hour.toString().padLeft(2, '0')} : ${model.currentDay.startTime.minute.toString().padLeft(2, '0')}'),
              mediumSpace,
              Text('End time', style: smallTextFont),
              smallSpace,
              displayTime(model.showEndTimeDialog,
                  '${model.currentDay.endTime.hour.toString().padLeft(2, '0')} : ${model.currentDay.endTime.minute.toString().padLeft(2, '0')}'),
              mediumSpace,
              Text(
                'Session duration',
                style: smallTextFont,
              ),
              smallSpace,
              displayTime(model.showDurationDialog,
                  '${model.currentDay.duration.hour.toString().padLeft(2, '0')} : ${model.currentDay.duration.minute.toString().padLeft(2, '0')}'),
              Expanded(child: Text('')),
              Row(
                children: [
                  model.dayIndex != 0
                      ? backwardArrowButton(model.goToPrevDay)
                      : Container(),
                  Expanded(child: Text('')),
                  forwardArrowButton(model.goToNextDay)
                ],
              ),
              smallSpace
            ],
          ),
        ),
      ),
      viewModelBuilder: () => SetupViewModel(),
      onModelReady: (model) => model.setupWorkingDays(selectedDays),
    );
  }
}

Widget displayTime(Function onTapCallback, String time) {
  return Row(
    children: [
      TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => primaryColorLight.withOpacity(0.03)),
              side: MaterialStateProperty.resolveWith(
                  (states) => BorderSide(color: primaryColor))),
          onPressed: onTapCallback,
          child: Container(
            width: 200,
            child: Row(
              children: [
                Text(
                  time,
                  style: mediumTextFont.copyWith(
                      fontSize: 25, color: primaryColorDark),
                  textAlign: TextAlign.left,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 25,
                    ),
                  ),
                )
              ],
            ),
          )),
    ],
  );
}
