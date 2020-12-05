import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';
import 'package:personal_trainer_app/ui/constants/enums.dart';
import 'package:personal_trainer_app/ui/constants/margins.dart';
import 'package:personal_trainer_app/ui/constants/text_sizes.dart';
import 'package:personal_trainer_app/ui/constants/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final builders = {
    DialogType.timePicker: (context, sheetRequest, completer) =>
        _TimePickerDialog(
          completer: completer,
          request: sheetRequest,
        )
  };

  dialogService.registerCustomDialogBuilders(builders);
}

class _TimePickerDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  var selectedTime = DateTime.now();
  _TimePickerDialog({Key key, this.request, this.completer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: dialogHorizontalMargin, vertical: dialogVerticalMargin),
      color: backgroundColor,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hr     :     Min',
                style: largeTextFont.copyWith(
                    fontSize: 20, color: primaryColorDark),
                textAlign: TextAlign.center,
              ),
              smallSpace,
              timePicker(),
              smallSpace,
              TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => primaryColorDark),
                      padding: MaterialStateProperty.resolveWith((states) =>
                          EdgeInsets.symmetric(vertical: 12, horizontal: 30)),
                      shape: MaterialStateProperty.resolveWith((states) =>
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: primaryColorDark)))),
                  onPressed: () =>
                      completer(DialogResponse(responseData: selectedTime)),
                  child: Text(
                    'Set time',
                    style: mediumTextFont.copyWith(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget timePicker() {
    return TimePickerSpinner(
      alignment: Alignment.center,
      is24HourMode: true,
      normalTextStyle: mediumTextFont.copyWith(fontSize: 20),
      highlightedTextStyle:
          mediumTextFont.copyWith(fontSize: 20, color: primaryColor),
      spacing: 50,
      itemHeight: 60,
      isForce2Digits: true,
      onTimeChange: (time) => selectedTime = time,
    );
  }
}
