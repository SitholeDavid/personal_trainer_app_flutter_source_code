import 'package:flutter/material.dart';
import 'package:personal_trainer_app/core/models/package.dart';
import 'package:personal_trainer_app/core/viewmodels/packages_viewmodel.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';
import 'package:personal_trainer_app/ui/constants/text_sizes.dart';
import 'package:personal_trainer_app/ui/widgets/loading_indicator.dart';
import 'package:stacked/stacked.dart';

class PackagesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PackagesViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: backgroundColor,
              elevation: 0,
              title: Text(
                'Packages',
                style:
                    largeTextFont.copyWith(fontSize: 20, color: primaryColor),
              ),
              leading: IconButton(
                onPressed: model.navigateBackToPrevView,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: primaryColor,
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: model.navigateToCreatePackage,
              child: Icon(
                Icons.add,
                size: 40,
              ),
              backgroundColor: primaryColor,
            ),
            body: model.isBusy
                ? loadingIndicatorLight(loadingText: 'loading packages')
                : model.packages.length == 0
                    ? Center(
                        child: Text(
                          'No packages found',
                          style: mediumTextFont,
                        ),
                      )
                    : ListView.builder(
                        itemCount: model.packages.length,
                        itemBuilder: (context, index) {
                          return packageTile(model.packages[index],
                              model.navigateToPackageDetail);
                        })),
        viewModelBuilder: () => PackagesViewModel(),
        onModelReady: (model) => model.getPackages());
  }
}

Widget packageTile(Package package, Function onTapCallback) {
  return GestureDetector(
    onTap: () => onTapCallback(package),
    child: ListTile(
      title: Text(
        package.title,
        style: largeTextFont.copyWith(fontSize: 18),
      ),
      subtitle: Text(
        package.description,
        style: mediumTextFont,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: primaryColor,
      ),
    ),
  );
}
