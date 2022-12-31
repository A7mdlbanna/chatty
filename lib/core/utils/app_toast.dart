import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({
  required String msg,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: state.color,
      textColor: Colors.white,
      fontSize: 16.0,
    );

enum ToastStates{
  SUCCESS,
  WARNING,
  ERROR,
}

extension AppLanguageHelper on ToastStates {
  Color get color {
    switch (this) {
      case ToastStates.SUCCESS:
        return Colors.green;
      case ToastStates.WARNING:
        return Colors.orangeAccent;
      case ToastStates.ERROR:
        return Colors.red;
    }
  }
}
