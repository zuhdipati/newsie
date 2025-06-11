import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void error(String message) {
    show(message, backgroundColor: Colors.red);
  }

  static void success(String message) {
    show(message, backgroundColor: Colors.green);
  }

  static void show(String message, {Color backgroundColor = Colors.black}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: backgroundColor,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
    );
  }
}
