import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg, bool location) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: Colors.grey,
    toastLength: Toast.LENGTH_SHORT,
    gravity: (location ? ToastGravity.BOTTOM_RIGHT : ToastGravity.TOP),
    textColor: Colors.black,
  );
}