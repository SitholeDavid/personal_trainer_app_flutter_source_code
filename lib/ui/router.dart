import 'package:flutter/material.dart';
import 'package:personal_trainer_app/ui/constants/routes.dart';
import 'package:personal_trainer_app/ui/views/dashboard_view.dart';
import 'package:personal_trainer_app/ui/views/forgot_password_view.dart';
import 'package:personal_trainer_app/ui/views/select_working_days_view.dart';
import 'package:personal_trainer_app/ui/views/setup_view.dart';
import 'package:personal_trainer_app/ui/views/sign_in_view.dart';
import 'package:personal_trainer_app/ui/views/sign_up_view.dart';

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
    default:
      return null;
  }
}
