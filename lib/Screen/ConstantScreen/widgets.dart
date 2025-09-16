import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';

import '../utils/constants.dart';

void showFlushBar(BuildContext context,  String message) {
  Flushbar(
    message: message,
    duration: const Duration(seconds: 2),
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

Widget countTextWidgetText(
    BuildContext context, String count, String title) {
  return Container(
    padding: const EdgeInsets.only(right: 5, left: 5),
    child: Row(
      children: <Widget>[
        SizedBox(width: 100,
          child: Text(count.toString(),
              style: Styling.itemGreyText),
        ),
         Text(
            ": $title",
            // style:Styling.itemBlackTest,
            style:Styling.textFormText,
          ),

      ],
    ),
  );
}

Widget countTextWidgetTextOnAccount(
    BuildContext context, String count, String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Text(
      "$count: $title",
      style: Styling.itemGreyText,
      softWrap: true,
    ),
  );
}


Widget countTextWidgetTextWithoutHeading(
    BuildContext context, String title) {
  return Container(
    padding: const EdgeInsets.only(right: 5, left: 5),
    child: Row(
      children: <Widget>[
        Text(
          title,
          // style:Styling.itemBlackTest,
          style:Styling.blueClrText,
        ),

      ],
    ),
  );
}
Widget countTextWidgetTextcash(
    BuildContext context, String title) {
  return Container(
    padding: const EdgeInsets.only(right: 5, left: 5),
    child: Row(
      children: <Widget>[
        Text(
          "$title",
          // style:Styling.itemBlackTest,
          style:Styling.itemGreyText,
        ),

      ],
    ),
  );
}
Widget countTextWidgetRemark(
    BuildContext context, String count, String title) {
  return Container(
    padding: const EdgeInsets.only(right: 5, left: 5),
    child: Row(
      children: <Widget>[
        SizedBox(width: 100,
          child: Text(count.toString(),
              style: Styling.itemGreyText),
        ),
        Text(
          ": $title",
          // style:Styling.itemBlackTest,
          style:Styling.textFormText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

      ],
    ),
  );
}

Widget countTextWidgetTextStar(BuildContext context, String label, {bool showAsterisk = false}) {

  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: label,
          style:Styling.itemGreyText,
        ),
        if (showAsterisk)
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red, // Asterisk in red
              fontSize: 16,
            ),
          ),
      ],
    ),
  );
}
Widget countTextWidgetTextStarWithBlue(BuildContext context, String label, {bool showAsterisk = false}) {

  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: label,
          style:Styling.blueClrText,
        ),
        if (showAsterisk)
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red, // Asterisk in red
              fontSize: 16,
            ),
          ),
      ],
    ),
  );
}
Widget countTextWidgetTextWithoutHeadingGrey(
    BuildContext context, String title) {
  return Container(
    padding: const EdgeInsets.only(right: 5, left: 5),
    child: Row(
      children: <Widget>[
        Text(
          title,
          // style:Styling.itemBlackTest,
          style:Styling.itemGreyText,
          textScaler:
          TextScaler.noScaling,
        ),

      ],
    ),
  );
}


