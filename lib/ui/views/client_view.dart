import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:personal_trainer_app/core/models/client.dart';
import 'package:personal_trainer_app/core/viewmodels/client_viewmodel.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';
import 'package:personal_trainer_app/ui/constants/margins.dart';
import 'package:personal_trainer_app/ui/constants/text_sizes.dart';
import 'package:personal_trainer_app/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_app/ui/shared/custom_text_button.dart';
import 'package:personal_trainer_app/ui/shared/display_input_field.dart';
import 'package:stacked/stacked.dart';

class ClientView extends StatelessWidget {
  final Client existingClient;
  ClientView({this.existingClient});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ClientViewModel>.reactive(
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
                    displayProfilePicture(model.client.pictureUrl,
                        model.localImage, model.updateProfilePicture),
                    Flexible(
                        child: ListView(
                      children: [
                        displayInputField(
                            'Name', model.client.name, model.updateName),
                        displayInputField('Surname', model.client.surname,
                            model.updateSurname),
                        displayInputField(
                            'Email', model.client.email, model.updateEmail),
                        displayInputField(
                            'Weight', model.currentWeight, model.updateWeight),
                        displayInputField(
                            'Height', model.client.height, model.updateHeight),
                        displayInputField(
                            'Health conditions',
                            model.client.healthConditions,
                            model.updateHealthConditions),
                        displayInputField('Phone number', model.client.phoneNo,
                            model.updatePhoneNo),
                        mediumSpace,
                        model.newClient
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
                                        onPressed: model.deleteClient),
                                  ),
                                ],
                              ),
                        customTextButton(
                            buttonText: model.buttonTitle,
                            onTapCallback: model.saveClient)
                      ],
                    ))
                  ]))),
      viewModelBuilder: () => ClientViewModel(),
      onModelReady: (model) => model.initialise(existingClient),
    );
  }
}

Widget displayProfilePicture(
    String profilePicUrl, File localImage, Function onTapCallback) {
  const double imageHeight = 130;

  Image chosenImage = localImage == null
      ? Image.asset(
          'assets/images/default_profile_picture.jpg',
          height: imageHeight,
        )
      : Image.file(
          localImage,
          height: imageHeight,
        );

  return FlatButton(
      onPressed: onTapCallback,
      child: Container(
        alignment: Alignment.center,
        child: profilePicUrl == ''
            ? chosenImage
            : Image.network(
                profilePicUrl,
                height: imageHeight,
              ),
      ));
}
