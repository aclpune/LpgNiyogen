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
Widget verticalDividerSmallest() {
  return  Container(
    width: 1.0, // Width of the vertical line
    height: 20.0, // Height of the vertical line
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
      MaterialStateProperty.all<Color>(Colors.blue),
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
Widget textWidgetBlueColorWithoutStar(String title) {
  return Container(
    margin: const EdgeInsets.only(left: 4),
    child: Row(
      children: [
        Text(title, style: Styling.blueClrText,),
      ],
    ),

  );
}

Widget itemSubLine(String greyText, String blackText) {
  return Container(
    padding: EdgeInsets.only(
        left: 2.4 * SizeConfig.widthMultiplier!,
        right: 2.4 * SizeConfig.widthMultiplier!),
    child: Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Text(
            greyText,
            style: Styling.itemGreyText,
          ),
        ),
        Text(
          " :  ",
          style: Styling.itemGreyText,
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Text(
            blackText,
            style: Styling.itemBlackTest,
          ),
        ),
      ],
    ),
  );
}

Widget itemSubLineLeftBig(String greyText, String blackText) {
  return Container(
    padding: EdgeInsets.only(
        left: 2.8 * SizeConfig.widthMultiplier!,
        right: 2.4 * SizeConfig.widthMultiplier!),
    child: Row(
      children: <Widget>[
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Text(
            greyText,
            style: Styling.itemGreyText,
          ),
        ),
        Text(
          " :  ",
          style: Styling.itemGreyText,
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Text(
            blackText,
            style: Styling.itemBlackTest,
          ),
        ),
      ],
    ),
  );
}

Widget itemSubLineWithBlackAndBlue(String greyText, String blackText) {
  return Container(
    padding: EdgeInsets.only(
        left: 2.4 * SizeConfig.widthMultiplier!,
        right: 2.4 * SizeConfig.widthMultiplier!),
    child: Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Text(
            greyText,
            style: Styling.itemGreyText,
          ),
        ),
        Text(
          " :  ",
          style: Styling.itemGreyText,
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Text(
            blackText,
            style: Styling.bodyTitleWithBlue,
          ),
        ),
      ],
    ),
  );
}

Widget itemSubLineWithDD(String greyText, String blackText) {
  return
    Container(
    padding: EdgeInsets.only(
        left: 2.4 * SizeConfig.widthMultiplier!,
        right: 2.4 * SizeConfig.widthMultiplier!),
    child: Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Text(
            greyText,
            style: Styling.itemGreyText,
          ),
        ),
        Text(
          " :  ",
          style: Styling.itemGreyText,
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Text(
            blackText,
            style: Styling.itemBlackTest,
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child:Icon(Icons.arrow_drop_down)
        ),
      ],
    ),
  );
}

InputDecoration buildInputBorderUpdateStatus(
    String hintText, BuildContext context) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: Styling.hintTextSmall,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade100, width: 0.0)),
      contentPadding: EdgeInsets.all(1.2 * SizeConfig.heightMultiplier!),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)));
}


InputDecoration buildInputWithoutBorderUpdateStatus(
    BuildContext context) {
  return InputDecoration(
      enabledBorder: InputBorder.none,
      border: InputBorder.none);
}
InputDecoration buildInputWithSmallUnderline(BuildContext context) {
  return InputDecoration(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0), // Smaller underline
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 0.5), // Slightly thicker underline when focused
    ),
  );
}

Widget itemSubLineWithDDs(String greyText, bool isOutwardStockListViewVisible) {
  return
    Container(
      child:  Padding(
        padding: const EdgeInsets.all(10.0),
        child:
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              greyText,
              style: Styling.bodyTitleWithBlueHightSmallWithoutBold,
            ),
            Icon(
              isOutwardStockListViewVisible
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down,
              size: 30, // Bigger icon for a more clickable feel
              color:Color(0xff1280b3),
            ),
          ],
        ),
      ),
    );

}

Widget itemSubLineWithDDss(String greyText, bool isImbalanceStockListViewVisible) {
  return
    Container(
      child:    Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              greyText,
              style: Styling.bodyTitleBig,
            ),
            Icon(
              isImbalanceStockListViewVisible
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down,
              size: 30, // Bigger icon for a more clickable feel
              color:Color(0xff1280b3),
            ),
          ],
        ),
      ),
    );

}

Widget itemSubLineWithDDsss(String greyText,String textData, bool isImbalanceStockListViewVisible) {
  return
    Container(
      child:    Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.start,
              children: [
                Text(
                  greyText,
                  style: Styling.bodyTitleBig,
                ),
                Text(
                  textData,
                  style: Styling.textFormText,
                ),
              ],
            ),
            Icon(
              isImbalanceStockListViewVisible
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down,
              size: 30, // Bigger icon for a more clickable feel
              color:Color(0xff1280b3),
            ),
          ],
        ),
      ),
    );

}

Widget itemSubLineSubMenu(String greyText, bool isImbalanceStockListViewVisible) {
  return
    Container(
      child:    Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              greyText,
              style: Styling.bodyTitleBig,
            ),
            Icon(
              isImbalanceStockListViewVisible
                  ? Icons.keyboard_arrow_up_outlined
                  : Icons.keyboard_arrow_down_outlined,
              size: 24, // Bigger icon for a more clickable feel
              color:Color(0xff0d0e0e),
            ),
          ],
        ),
      ),
    );

}
