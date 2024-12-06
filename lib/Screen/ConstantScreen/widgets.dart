import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../utils/constants.dart';



void showFlushBar(BuildContext context, String title, String message) {
  Flushbar(
    title: title,
    message: message,
    duration: const Duration(seconds: 3),
  ).show(context);
}

void showDialogBox(
    BuildContext context, Function function, String title, String content) {
  Widget onPositiveButton = TextButton(
    onPressed: function(),
    child: const Text(
      'Okay',
      style: TextStyle(color: Colors.black),
    ),
  );

  AlertDialog dialog = AlertDialog(
    actions: [onPositiveButton],
    title: Text(title),
    content: Text(content),
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      });
}

void configEasyLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..progressColor = Colors.black54
    ..backgroundColor = Colors.white70
    ..indicatorColor = Colors.black54
    ..textColor = Colors.black54
    ..userInteractions = false;
}

Widget countTextWidget(
    BuildContext context, int count, Color color, String title) {
  return Container(
    padding: const EdgeInsets.only(right: 5, left: 5, top: 8, bottom: 8),
    child: Column(
      children: <Widget>[
        Text(count.toString(),
            style: TextStyle(
                fontSize: 18,
                color: color,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.normal)),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    ),
  );
}

