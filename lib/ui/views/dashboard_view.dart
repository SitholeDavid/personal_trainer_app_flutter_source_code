import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:personal_trainer_app/core/models/session.dart';
import 'package:personal_trainer_app/core/viewmodels/dashboard_viewmodel.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';
import 'package:personal_trainer_app/ui/constants/margins.dart';
import 'package:personal_trainer_app/ui/constants/text_sizes.dart';
import 'package:personal_trainer_app/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_app/ui/shared/background_gradient.dart';
import 'package:personal_trainer_app/ui/widgets/loading_indicator.dart';
import 'package:stacked/stacked.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  model.sessions.length == 0
                      ? topDashboard(
                          "Done for the day!", "- - -", 0, model.openDrawer)
                      : topDashboard(
                          model.upcomingSession.client,
                          '${DateTime.parse(model.upcomingSession.startTime).hour.toString().padLeft(2, '0')} : ${DateTime.parse(model.upcomingSession.startTime).minute.toString().padLeft(2, '0')}',
                          model.sessionsLeft,
                          model.openDrawer),
                  nextThreeSessions(model.nextThreeSessions,
                      MediaQuery.of(context).size.width),
                  mediumSpace,
                  Flexible(
                    child: GridView.count(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      crossAxisSpacing: 0,
                      childAspectRatio: 120 / 100,
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,
                      children: [
                        navigationOption('Sessions', Icons.schedule,
                            model.navigateToSessions),
                        navigationOption('Clients', Icons.supervisor_account,
                            model.navigateToClients),
                        navigationOption('Workouts', Icons.directions_run,
                            model.navigateToWorkouts),
                        navigationOption(
                            'Packages',
                            MaterialCommunityIcons.sale,
                            model.navigateToPackages),
                        navigationOption(
                            'Settings', Octicons.settings, model.openDrawer)
                      ],
                    ),
                  )
                ],
              ),
            ),
            model.isBusy
                ? loadingIndicator(loadingText: 'Loading dashboard')
                : SizedBox(
                    height: 0,
                  )
          ],
        ),
      ),
      viewModelBuilder: () => DashboardViewModel(),
      onModelReady: (model) async => await model.fetchSessions(),
    );
  }
}

Widget navigationOption(String title, IconData icon, Function onTapCallback) {
  return Container(
    margin: EdgeInsets.only(top: 0, bottom: 15, left: 10, right: 10),
    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: primaryColor, width: 1)),
    width: 80,
    child: InkWell(
      onTap: onTapCallback,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: Icon(
                icon,
                color: Colors.white,
                size: 70,
              ),
            ),
            mediumSpace,
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: mediumTextFont.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget timeDisplay(String time, bool showLeftBorder, double screenWidth) {
  double boxWidth = screenWidth / 3 - pageHorizontalMargin;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
    width: boxWidth,
    decoration: BoxDecoration(
        border: Border(
            left: BorderSide(
                color: showLeftBorder ? Colors.black54 : Colors.white,
                width: 0.5))),
    child: TextButton(
        onPressed: () => null,
        style: ButtonStyle(
            padding: MaterialStateProperty.resolveWith(
                (states) => EdgeInsets.all(0))),
        child: Text(
          time == '-'
              ? time
              : '${DateTime.parse(time).hour.toString().padLeft(2, '0')} : ${DateTime.parse(time).minute.toString().padLeft(2, '0')}',
          style: mediumTextFont.copyWith(fontSize: 15),
        )),
  );
}

Widget nextThreeSessions(List<Session> nextSessions, double screenWidth) {
  return nextSessions.every((session) => session.startTime.toString() == '-')
      ? SizedBox(
          height: 5,
        )
      : Container(
          width: screenWidth,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                    offset: Offset(2.0, 2.0))
              ]),
          margin: EdgeInsets.symmetric(
              vertical: 10, horizontal: pageHorizontalMargin),
          child: Row(children: [
            timeDisplay(
                nextSessions[0].startTime.toString(), false, screenWidth),
            timeDisplay(
                nextSessions[1].startTime.toString(), true, screenWidth),
            timeDisplay(nextSessions[2].startTime.toString(), true, screenWidth)
          ]),
        );
}

Widget topDashboard(String nextClient, String time, int remainingSessions,
    Function onOpenDialogCallback) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 10),
    decoration: BoxDecoration(
        gradient: backgroundGradient, borderRadius: BorderRadius.circular(25)),
    child: Column(
      children: [
        mediumSpace,
        Text(
          nextClient,
          style: largeTextFont.copyWith(fontSize: 19, color: Colors.white),
        ),
        smallSpace,
        Text(
          time,
          style: mediumTextFont.copyWith(fontSize: 16, color: Colors.white),
        ),
        mediumSpace,
        Text(
          'You have $remainingSessions upcoming sessions',
          style: mediumTextFont.copyWith(color: Colors.white),
        ),
        mediumSpace
      ],
    ),
  );
}
