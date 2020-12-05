import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:personal_trainer_app/core/viewmodels/sign_in_viewmodel.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';
import 'package:personal_trainer_app/ui/constants/margins.dart';
import 'package:personal_trainer_app/ui/constants/text_sizes.dart';
import 'package:personal_trainer_app/ui/constants/ui_helpers.dart';
import 'package:stacked/stacked.dart';

class SignInView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignInViewModel>.reactive(
      viewModelBuilder: () => SignInViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          margin: EdgeInsets.symmetric(
              vertical: pageVerticalMargin, horizontal: pageHorizontalMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              extraLargeSpace,
              Text(
                'The Personal Trainer App',
                style: largeTextFont,
              ),
              mediumSpace,
              Text(
                'We are excited to see you here',
                style: mediumTextFont,
              ),
              extraLargeSpace,
              Text(
                'Email address',
                style: smallTextFont,
              ),
              smallSpace,
              TextFormField(
                controller: emailController,
                validator:
                    EmailValidator(errorText: 'Enter a valid email address'),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp("[ ]"))
                ],
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
                    hintText: 'personal@trainer.com',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.black87),
                        gapPadding: 0)),
              ),
              mediumSpace,
              Text(
                'Password',
                style: smallTextFont,
              ),
              smallSpace,
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
                    hintText: 'password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.black87),
                        gapPadding: 0)),
              ),
              mediumSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: Text('')),
                  InkWell(
                    onTap: () => model.navigateToForgotPassword(),
                    child: Text(
                      'Forgot Password?',
                      textAlign: TextAlign.end,
                      style: mediumTextFont.copyWith(
                          color: primaryColor,
                          backgroundColor: Colors.transparent),
                    ),
                  )
                ],
              ),
              largeSpace,
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async => await model.login(
                          emailController.text, passwordController.text),
                      child: Text(
                        'Sign In',
                        style: mediumTextFont.copyWith(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => primaryColorDark),
                          padding: MaterialStateProperty.resolveWith((states) =>
                              EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10)),
                          shape: MaterialStateProperty.resolveWith((states) =>
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: primaryColorDark)))),
                    ),
                  )
                ],
              ),
              Expanded(child: Text('')),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () => model.navigateToSignUp(),
                      child: Text(
                        'Create new account',
                        style: mediumTextFont.copyWith(color: primaryColorDark),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
