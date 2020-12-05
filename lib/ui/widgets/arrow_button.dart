import 'package:flutter/material.dart';
import 'package:personal_trainer_app/ui/constants/colors.dart';

Widget forwardArrowButton(Function onTapCallback) {
  return Container(
    decoration: BoxDecoration(
        color: primaryColorDark, borderRadius: BorderRadius.circular(5)),
    padding: EdgeInsets.all(6),
    child: IconButton(
        icon: Icon(
          Icons.arrow_forward,
          color: backgroundColor,
          size: 25,
        ),
        onPressed: onTapCallback),
  );
}

Widget backwardArrowButton(Function onTapCallback) {
  return Container(
    decoration: BoxDecoration(
        color: primaryColorDark, borderRadius: BorderRadius.circular(5)),
    padding: EdgeInsets.all(6),
    child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: backgroundColor,
          size: 25,
        ),
        onPressed: onTapCallback),
  );
}
