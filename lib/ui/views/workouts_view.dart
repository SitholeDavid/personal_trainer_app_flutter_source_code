import 'package:flutter/material.dart';
import 'package:personal_trainer_app/core/models/workout.dart';
import 'package:personal_trainer_app/core/viewmodels/workouts_viewmodel.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';
import 'package:personal_trainer_app/ui/constants/text_sizes.dart';
import 'package:stacked/stacked.dart';

class WorkoutsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WorkoutsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Text(
            'Workouts',
            style:
                largeTextFont.copyWith(fontSize: 20, color: primaryColorDark),
          ),
          leading: IconButton(
            onPressed: model.navigateBackToPrevView,
            icon: Icon(
              Icons.arrow_back_ios,
              color: primaryColorDark,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: model.navigateToCreateWorkout,
          child: Icon(
            Icons.add,
            size: 40,
          ),
          backgroundColor: primaryColorDark,
        ),
        body: model.workouts.length == 0
            ? Center(
                child: Text(
                  'No workouts found',
                  style: mediumTextFont,
                ),
              )
            : ListView.builder(
                itemCount: model.workouts.length,
                itemBuilder: (context, index) {
                  return workoutTile(
                      model.workouts[index], model.navigateToWorkoutDetail);
                }),
      ),
      viewModelBuilder: () => WorkoutsViewModel(),
      onModelReady: (model) => model.getWorkouts(),
    );
  }
}

Widget workoutTile(Workout workout, Function onTapCallback) {
  return GestureDetector(
    onTap: () => onTapCallback(workout),
    child: ListTile(
      title: Text(
        workout.title,
        style: largeTextFont.copyWith(fontSize: 18),
      ),
      subtitle: Text(
        workout.description,
        style: mediumTextFont,
      ),
      trailing: Icon(Icons.arrow_forward_ios),
    ),
  );
}
