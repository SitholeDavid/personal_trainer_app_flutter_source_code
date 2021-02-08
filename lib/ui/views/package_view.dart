import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:personal_trainer_app/core/models/package.dart';
import 'package:personal_trainer_app/core/viewmodels/package_viewmodel.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';
import 'package:personal_trainer_app/ui/constants/margins.dart';
import 'package:personal_trainer_app/ui/constants/text_sizes.dart';
import 'package:personal_trainer_app/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_app/ui/shared/custom_text_button.dart';
import 'package:personal_trainer_app/ui/shared/display_input_field.dart';
import 'package:personal_trainer_app/ui/widgets/loading_indicator.dart';
import 'package:stacked/stacked.dart';

class PackageView extends StatelessWidget {
  final Package existingPackage;
  PackageView({this.existingPackage});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PackageViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundColor,
              body: Stack(
                children: [
                  Container(
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
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: primaryColor,
                                ),
                                onPressed: model.navigateToPrevView),
                            Text(
                              model.viewTitle,
                              style: largeTextFont.copyWith(
                                  fontSize: 22, color: primaryColor),
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
                            displayInputField('Title', model.package.title,
                                model.updateTitle),
                            displayInputField(
                                'Description',
                                model.package.description,
                                model.updateDescription),
                            displayInputField('Price', model.package.price,
                                model.updatePrice),
                            displayInputField(
                                'Number of sessions',
                                model.package.noSessions,
                                model.updateNoSessions),
                            displayInputField(
                                'Expiry date',
                                model.package.expiryDate,
                                model.updateExpiryDate),
                            mediumSpace,
                            model.newPackage
                                ? Text('')
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            bottom: 20, right: 10),
                                        child: IconButton(
                                            icon: Icon(
                                              FontAwesome5.trash_alt,
                                              color: primaryColorDark,
                                              size: 40,
                                            ),
                                            onPressed: model.deletePackage),
                                      ),
                                    ],
                                  ),
                            customTextButton(
                                buttonText: model.buttonTitle,
                                onTapCallback: model.savePackage)
                          ],
                        )),
                      ],
                    ),
                  ),
                  model.isBusy
                      ? loadingIndicator(loadingText: model.loadingText)
                      : SizedBox(
                          height: 0,
                        )
                ],
              ),
            ),
        viewModelBuilder: () => PackageViewModel(),
        onModelReady: (model) => model.initialise(existingPackage));
  }
}
