import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:personal_trainer_app/core/viewmodels/choose_expiry_period_viewmodel.dart';
import 'package:personal_trainer_app/core/viewmodels/update_booking_viewmodel.dart';
import 'package:personal_trainer_app/locator.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';
import 'package:personal_trainer_app/ui/constants/enums.dart';
import 'package:personal_trainer_app/ui/constants/margins.dart';
import 'package:personal_trainer_app/ui/constants/text_sizes.dart';
import 'package:personal_trainer_app/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_app/ui/shared/background_gradient.dart';
import 'package:personal_trainer_app/ui/shared/custom_text_button.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final builders = {
    DialogType.timePicker: (context, sheetRequest, completer) =>
        _TimePickerDialog(
          completer: completer,
          request: sheetRequest,
        ),
    DialogType.editInputField: (context, sheetRequest, completer) =>
        _EditInputDialog(completer: completer, request: sheetRequest),
    DialogType.choosePeriod: (context, sheetRequest, completer) =>
        _ChooseExpiryPeriodDialog(
          completer: completer,
          request: sheetRequest,
        ),
    DialogType.updateBooking: (context, sheetRequest, completer) =>
        _UpdateTimeSlotDialog(
          completer: completer,
          request: sheetRequest,
        ),
    DialogType.drawer: (context, sheetRequest, completer) => _DrawerDialog(
          completer: completer,
          request: sheetRequest,
        )
  };

  dialogService.registerCustomDialogBuilders(builders);
}

class _DrawerDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  _DrawerDialog({Key key, this.request, this.completer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54.withOpacity(0.5),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.only(right: 80),
        color: backgroundColor,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(gradient: backgroundGradient),
              child: Container(
                padding: EdgeInsets.all(20),
                height: 120,
                child: Row(
                  children: [
                    Text(
                      request.title,
                      style: largeTextFont.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            largeSpace,
            drawerListTile('Setup working days', 'setup'),
            smallSpace,
            drawerListTile('Help', 'help'),
            smallSpace,
            drawerListTile('Logout', 'logout')
          ],
        ),
      ),
    );
  }

  Widget drawerListTile(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: mediumTextFont.copyWith(fontSize: 20),
      ),
      onTap: () => completer(DialogResponse(responseData: value)),
    );
  }
}

class _UpdateTimeSlotDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  TextEditingController inputController;
  _UpdateTimeSlotDialog({Key key, this.request, this.completer})
      : super(key: key) {
    inputController =
        TextEditingController(text: request.customData['value'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateBookingViewModel>.reactive(
      onModelReady: (model) => model.initialise(),
      viewModelBuilder: () => UpdateBookingViewModel(),
      builder: (context, model, builder) => Container(
        margin: EdgeInsets.symmetric(
            horizontal: dialogHorizontalMargin - 30,
            vertical: dialogVerticalMargin - 70),
        padding: EdgeInsets.symmetric(
            horizontal: dialogHorizontalMargin, vertical: 20),
        color: backgroundColor,
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                mediumSpace,
                Text(
                  'Update booking',
                  style: largeTextFont.copyWith(
                      color: primaryColorDark, fontSize: 20),
                ),
                mediumSpace,
                Column(
                  children: model.updateOptions
                      .map((option) => checkboxRadioButton(
                          option,
                          option == model.selectedOption,
                          model.updateSelectedOption))
                      .toList(),
                ),
                largeSpace,
                TextFormField(
                  controller: inputController,
                  enabled: !model.disableKeyboard,
                ),
                largeSpace,
                customTextButton(
                    buttonText: 'Update booking',
                    onTapCallback: () => completer(DialogResponse(
                            responseData: {
                              'selectedOption': model.selectedOption,
                              'clientID': inputController.text
                            })))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget checkboxRadioButton(
      String value, bool isChecked, Function onTapCallback) {
    return CheckboxListTile(
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      value: isChecked,
      onChanged: (_) => onTapCallback(value),
      title: Text(
        value,
        style: mediumTextFont,
      ),
    );
  }
}

class _ChooseExpiryPeriodDialog extends StatelessWidget {
  final DialogRequest request;
  var periodCount = 1;
  final Function(DialogResponse) completer;
  var period = 'days';
  _ChooseExpiryPeriodDialog({Key key, this.request, this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChooseExpiryPeriodViewModel>.reactive(
      viewModelBuilder: () => ChooseExpiryPeriodViewModel(),
      builder: (context, model, child) => Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(
            horizontal: dialogHorizontalMargin, vertical: dialogVerticalMargin),
        color: backgroundColor,
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: Column(
              children: [
                mediumSpace,
                Text(
                  'Expires after',
                  style: largeTextFont.copyWith(
                      fontSize: 20, color: primaryColorDark),
                  textAlign: TextAlign.center,
                ),
                mediumSpace,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 30,
                        child: NumberPicker.integer(
                          initialValue: model.periodCount,
                          minValue: 1,
                          maxValue: 100,
                          onChanged: (newPeriod) =>
                              model.updatePeriodCount(newPeriod),
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                        width: 100,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: model.period,
                            onChanged: (newPeriod) =>
                                model.updatePeriod(newPeriod),
                            items: model.periodOptions
                                .map((period) => DropdownMenuItem(
                                    value: period,
                                    child: Text(
                                      period,
                                      style:
                                          mediumTextFont.copyWith(fontSize: 18),
                                    )))
                                .toList(),
                          ),
                        ))
                  ],
                ),
                Expanded(child: Text('')),
                customTextButton(
                    buttonText: 'Set period',
                    onTapCallback: () => completer(DialogResponse(
                        responseData: '${model.periodCount} ${model.period}')))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditInputDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  var inputController;
  _EditInputDialog({Key key, this.request, this.completer}) : super(key: key) {
    inputController =
        TextEditingController(text: request.customData['value'].toString());
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: pageHorizontalMargin, vertical: pageVerticalMargin),
      color: backgroundColor,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mediumSpace,
            IconButton(
              padding: EdgeInsets.all(0),
              alignment: Alignment.topLeft,
              icon: Icon(
                Entypo.cross,
                color: Colors.black87,
              ),
              onPressed: null,
            ),
            extraLargeSpace,
            largeSpace,
            Text(
              request.title,
              style:
                  smallTextFont.copyWith(color: Colors.black87, fontSize: 14),
            ),
            TextFormField(
              keyboardType:
                  request.customData['inputType'] ?? TextInputType.text,
              controller: inputController,
              autofocus: true,
            ),
            Expanded(child: Text('')),
            customTextButton(
                buttonText: 'Update ${request.title}',
                onTapCallback: () => completer(
                    DialogResponse(responseData: inputController.text))),
            mediumSpace
          ],
        ),
      ),
    );
  }
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
