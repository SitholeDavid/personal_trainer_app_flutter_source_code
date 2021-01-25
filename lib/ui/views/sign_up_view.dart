import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:personal_trainer_app/core/viewmodels/sign_up_viewmodel.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';
import 'package:personal_trainer_app/ui/constants/margins.dart';
import 'package:personal_trainer_app/ui/constants/text_sizes.dart';
import 'package:personal_trainer_app/ui/constants/ui_helpers.dart';
import 'package:personal_trainer_app/ui/shared/custom_text_button.dart';
import 'package:stacked/stacked.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'email is required'),
    EmailValidator(errorText: 'please enter a valid email address')
  ]);

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Name and surname are required'),
    MinLengthValidator(3,
        errorText: 'Name and surname must be at least 3 characters long')
  ]);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundColor,
              body: Container(
                margin: EdgeInsets.symmetric(
                    vertical: pageVerticalMargin,
                    horizontal: pageHorizontalMargin),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      extraLargeSpace,
                      Text(
                        'Create new account',
                        style: largeTextFont,
                      ),
                      mediumSpace,
                      Text(
                        'Welcome! Please enter your details below',
                        style: mediumTextFont,
                      ),
                      largeSpace,
                      Text(
                        'Email address',
                        style: smallTextFont,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: emailValidator,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp("[ ]"))
                        ],
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7.5),
                            hintText: 'personal@trainer.com',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black87),
                                gapPadding: 0)),
                      ),
                      mediumSpace,
                      Text(
                        'Name and surname',
                        style: smallTextFont,
                      ),
                      smallSpace,
                      TextFormField(
                        controller: _nameController,
                        validator: nameValidator,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7.5),
                            hintText: 'John Snow',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                        controller: _passwordController,
                        validator: passwordValidator,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp("[ ]"))
                        ],
                        obscureText: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7.5),
                            hintText: 'password',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black87),
                                gapPadding: 0)),
                      ),
                      mediumSpace,
                      Text(
                        'Confirm password',
                        style: smallTextFont,
                      ),
                      smallSpace,
                      TextFormField(
                        controller: _confirmPasswordController,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp("[ ]"))
                        ],
                        validator: (val) =>
                            MatchValidator(errorText: 'passwords do not match')
                                .validateMatch(val, _passwordController.text),
                        obscureText: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7.5),
                            hintText: 'Confirm password',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black87),
                                gapPadding: 0)),
                      ),
                      Expanded(child: Text('')),
                      customTextButton(
                          buttonText: 'Create account',
                          onTapCallback: () async {
                            // await model.signUp('sitholedavid003@gmail.com',
                            //     'sithole7', 'David Sithole');
                            if (_formKey.currentState.validate()) {
                              await model.signUp(
                                  _emailController.text,
                                  _passwordController.text,
                                  _nameController.text);
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => SignUpViewModel());
  }
}
