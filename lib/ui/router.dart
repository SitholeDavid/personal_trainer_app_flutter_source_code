import 'package:flutter/material.dart';
import 'package:personal_trainer_app/core/models/client.dart';
import 'package:personal_trainer_app/core/models/package.dart';
import 'package:personal_trainer_app/core/models/workout.dart';
import 'package:personal_trainer_app/ui/constants/routes.dart';
import 'package:personal_trainer_app/ui/views/client_view.dart';
import 'package:personal_trainer_app/ui/views/clients_view.dart';
import 'package:personal_trainer_app/ui/views/package_view.dart';
import 'package:personal_trainer_app/ui/views/workout_view.dart';
import 'package:personal_trainer_app/ui/views/dashboard_view.dart';
import 'package:personal_trainer_app/ui/views/forgot_password_view.dart';
import 'package:personal_trainer_app/ui/views/packages_view.dart';
import 'package:personal_trainer_app/ui/views/payments_view.dart';
import 'package:personal_trainer_app/ui/views/select_working_days_view.dart';
import 'package:personal_trainer_app/ui/views/sessions_view.dart';
import 'package:personal_trainer_app/ui/views/setup_view.dart';
import 'package:personal_trainer_app/ui/views/sign_in_view.dart';
import 'package:personal_trainer_app/ui/views/sign_up_view.dart';
import 'package:personal_trainer_app/ui/views/workouts_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SignUpViewRoute:
      return MaterialPageRoute(builder: (_) => SignUpView());
    case DashboardViewRoute:
      return MaterialPageRoute(builder: (_) => DashboardView());
    case ForgotPasswordViewRoute:
      return MaterialPageRoute(builder: (_) => ForgotPasswordView());
    case SignInViewRoute:
      return MaterialPageRoute(builder: (_) => SignInView());
    case SelectWorkingDaysViewRoute:
      return MaterialPageRoute(builder: (_) => SelectWorkingDaysView());
    case SetupViewRoute:
      var selectedDays = settings.arguments as Map<int, bool>;
      return MaterialPageRoute(
          builder: (_) => SetupView(
                selectedDays: selectedDays,
              ));
    case SessionsViewRoute:
      return MaterialPageRoute(builder: (_) => SessionsView());
    case PaymentsViewRoute:
      return MaterialPageRoute(builder: (_) => PaymentsView());
    case ClientsViewRoute:
      return MaterialPageRoute(builder: (_) => ClientsView());
    case WorkoutsViewRoute:
      return MaterialPageRoute(builder: (_) => WorkoutsView());
    case PackagesViewRoute:
      return MaterialPageRoute(builder: (_) => PackagesView());
    case WorkoutViewRoute:
      Workout existingWorkout = settings.arguments as Workout;
      return MaterialPageRoute(
          builder: (_) => WorkoutView(
                existingWorkout: existingWorkout,
              ));
    case PackageViewRoute:
      Package existingPackage = settings.arguments as Package;
      return MaterialPageRoute(
          builder: (_) => PackageView(
                existingPackage: existingPackage,
              ));
    case ClientViewRoute:
      Client existingClient = settings.arguments as Client;
      return MaterialPageRoute(
          builder: (_) => ClientView(existingClient: existingClient));
    default:
      return null;
  }
}
