import 'package:flutter/material.dart';
import 'package:personal_trainer_app/core/constants/working_days.dart';
import 'package:personal_trainer_app/core/viewmodels/select_working_days_viewmodel.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';
import 'package:personal_trainer_app/ui/constants/margins.dart';
import 'package:personal_trainer_app/ui/constants/text_sizes.dart';
import 'package:personal_trainer_app/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_app/ui/widgets/arrow_button.dart';
import 'package:stacked/stacked.dart';

class SelectWorkingDaysView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectWorkingDaysViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundColor,
              body: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: pageHorizontalMargin,
                    vertical: pageVerticalMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    largeSpace,
                    Text(
                      'Working days',
                      style: largeTextFont.copyWith(color: primaryColor),
                    ),
                    largeSpace,
                    Text(
                      'Select your working days below. Your clients will be able to schedule sessions on these days.',
                      style: mediumTextFont,
                    ),
                    largeSpace,
                    Column(
                      children: workingDays.entries
                          .map((e) => dayCheckbox(e.value, e.key,
                              model.dayIsChecked[e.key], model.daySelected))
                          .toList(),
                    ),
                    Expanded(child: Text('')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [forwardArrowButton(model.navigateToSetupView)],
                    ),
                    mediumSpace
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => SelectWorkingDaysViewModel());
  }
}

Widget dayCheckbox(
    String day, int key, bool isChecked, Function onChangeCallback) {
  return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.all(0),
      value: isChecked,
      title: Text(
        day,
        style: mediumTextFont,
      ),
      activeColor: primaryColor,
      checkColor: Colors.white,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (value) => onChangeCallback(value, key));
}
