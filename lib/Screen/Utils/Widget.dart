import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/Utils/size_config.dart';

import 'Styling.dart';

Widget verticalDividerSmall() {
  return  Container(
    width: 1.0, // Width of the vertical line
    height: 50.0, // Height of the vertical line
    color: Colors.black, // Color of the line
  );
}
Widget verticalDividerVerySmall() {
  return  Container(
    width: 1.0, // Width of the vertical line
    height: 40.0, // Height of the vertical line
    color: Colors.black, // Color of the line
  );
}
Widget verticalDividerBig() {
  return  Container(
    width: 1.0, // Width of the vertical line
    height: 50.0, // Height of the vertical line
    color: Colors.black, // Color of the line
  );
}
Widget myElevButton(BuildContext context, String title, VoidCallback callback) {
  return ElevatedButton(
    onPressed: callback,
    style: ButtonStyle(
      backgroundColor:
      MaterialStateProperty.all<Color>(const Color(0xff1280b3)),
    ),
    child: Text(title, style: Styling.buttonText),
  );
}

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon),
    hintText: hintText,
    hintStyle: Styling.hintText,
    contentPadding: EdgeInsets.symmetric(
        vertical: 1.15 * SizeConfig.heightMultiplier!,
        horizontal: 4.86 * SizeConfig.widthMultiplier!),
    /*enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade100, width: 0.0)),*/
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}

Widget bodyTitleBlue(String title) {
  return Container(
    padding: const EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: const Color(0xff1280b3)),
        ),
        //titleText(title, 18, Colors.black),
      ],
    ),
  );
}

Widget textWidgetBlueColorWithStar(String title,String star) {
  return Container(
    margin: const EdgeInsets.only(left: 4),
    child: Row(
      children: [
        Text(title, style: Styling.blueClrText,),
        Text(star, style: Styling.redStar,),
      ],
    ),

  );
}
