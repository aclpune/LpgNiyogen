import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/Utils/size_config.dart';

class Styling {
  Styling._();

  static const Color appBackgroundColor = Color(0xFFFFF7EC);
  static const Color topBarBackgroundColor = Color(0xFFFFD974);
  static const Color selectedTabBackgroundColor = Color(0xFFFFC442);
  static const Color unSelectedTabBackgroundColor = Color(0xFFFFFFFC);
  static const Color subTitleTextColor = Color(0xFF9F988F);

  /*static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppTheme.appBackgroundColor,
    brightness: Brightness.light,
    textTheme: lightTextTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    textTheme: darkTextTheme,
  );

  static final TextTheme lightTextTheme = TextTheme(
    title: _titleLight,
    subtitle: _subTitleLight,
    button: _buttonLight,
    display1: _greetingLight,
    display2: _searchLight,
    body1: _selectedTabLight,
    body2: _unSelectedTabLight,
  );

  static final TextTheme darkTextTheme = TextTheme(
    title: _titleDark,
    subtitle: _subTitleDark,
    button: _buttonDark,
    display1: _greetingDark,
    display2: _searchDark,
    body1: _selectedTabDark,
    body2: _unSelectedTabDark,
  );*/

  // At first we took screen size by using "SizeConfig" class by which we got
  // ScreenWidth: 4.114285714285715 and ScreenHeight: 8.662857142857144
  // Using this we will make text size now...

  // static TextStyle itemBlueTextWithUnderline = const TextStyle(
  //   fontSize: 14,  // You can adjust the font size as needed
  //   color: Colors.blue, // Set color to blue to make it look like a link
  //   decoration: TextDecoration.underline, // Add underline decoration
  // );
  static final TextStyle appBarTitle = TextStyle(
    color: Colors.white,
    fontSize: 2.9 * SizeConfig.textMultiplier!,
  );

  static final TextStyle appBarDesc = TextStyle(
    fontFamily: 'OpenSans',
    color: Colors.white,
    fontSize: 1.6 * SizeConfig.textMultiplier!, // Size = 12-- [12/8.66] = 1.38
  );

  static final TextStyle bodyTitle = TextStyle(
      fontSize:
          2.07 * SizeConfig.textMultiplier!, // Size = 18-- [18/8.66] = 2.07
      fontFamily: 'OpenSans',
      color: Colors.black);

  static final TextStyle bodyTitleBig = TextStyle(
      fontSize:
      2.15 * SizeConfig.textMultiplier!, // Size = 18-- [18/8.66] = 2.07
      fontWeight: FontWeight.normal,
      color: Colors.black);

  static final TextStyle bodyTitleBigBold = TextStyle(
      fontSize:
      2.15 * SizeConfig.textMultiplier!, // Size = 18-- [18/8.66] = 2.07
      fontWeight: FontWeight.bold,
      color: Colors.black);

  static final TextStyle redStar = TextStyle(
      fontSize:
      1.50 * SizeConfig.textMultiplier!, // Size = 18-- [18/8.66] = 2.07
      fontFamily: 'OpenSans',
      color: Colors.red);

  static final TextStyle bodyTitleWithBlue = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:
          2.07 * SizeConfig.textMultiplier!, // Size = 18-- [18/8.66] = 2.07
      fontFamily: 'OpenSans',
      color: Colors.blue);

  static final TextStyle bodyTitleWithBlueHight = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:
          3.07 * SizeConfig.textMultiplier!, // Size = 18-- [18/8.66] = 2.07
      fontFamily: 'OpenSans',
      color: Colors.blue);

  static final TextStyle bodyTitleWithBlueHightSmall = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:
      2.2* SizeConfig.textMultiplier!, // Size = 18-- [18/8.66] = 2.07
      fontFamily: 'OpenSans',
      color: Colors.blue);

  static final TextStyle bodyTitleWithBlueHightSmallWithoutBold = TextStyle(
      fontSize:
      2.4* SizeConfig.textMultiplier!, // Size = 18-- [18/8.66] = 2.07
      fontFamily: 'OpenSans',
      color: Colors.blue);

  static final TextStyle countNumber = TextStyle(
      fontSize:
          2.4 * SizeConfig.textMultiplier!, // Size = 18-- [18/8.66] = 2.07
      fontFamily: 'OpenSans',
      color: Colors.black,
        );

  static final TextStyle countNumberReds = TextStyle(
      fontSize:
      2.07 * SizeConfig.textMultiplier!, // Size = 18-- [18/8.66] = 2.07
      fontFamily: 'OpenSans',
      color: Colors.black);

  static final TextStyle countNumberGreen = TextStyle(
      fontSize:
      2.07 * SizeConfig.textMultiplier!, // Size = 18-- [18/8.66] = 2.07
      fontFamily: 'OpenSans',
      color: Colors.blueGrey);

  static final TextStyle countText = TextStyle(
      fontSize:
          2.07 * SizeConfig.textMultiplier!, // Size = 18-- [18/8.66] = 2.07
      fontFamily: 'OpenSans',
      color: Colors.black);

  static final TextStyle badgeCount = TextStyle(
      fontSize: 1.8 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
      fontFamily: 'OpenSans',
      color: Colors.white,
      fontWeight: FontWeight.bold);

  static final TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontFamily: 'OpenSans',
    fontSize: 1.6 * SizeConfig.textMultiplier!, // Size = 14-- [14/8.66] = 1.6
  );

  static final TextStyle textFormText = TextStyle(
    color: Colors.black,
    fontFamily: 'OpenSans',
    fontSize: 1.8 * SizeConfig.textMultiplier!, // Size = 16-- [14/8.66] = 1.8
  );

  static final TextStyle textFormTextSmall = TextStyle(
    color: Colors.black,
    fontFamily: 'OpenSans',
    fontSize: 2 * SizeConfig.textMultiplier!, // Size = 16-- [14/8.66] = 1.8
  );

  static final TextStyle textFormTextWithUnderline = TextStyle(
    color: Colors.black,
    fontFamily: 'OpenSans',
    decoration:
    TextDecoration.underline,
    decorationColor: Colors.blue,
    fontSize: 1.8 * SizeConfig.textMultiplier!, // Size = 16-- [14/8.66] = 1.8
  );

  static final TextStyle buttonTextBlack = TextStyle(
    color: Colors.black,
    fontFamily: 'OpenSans',
    fontSize: 1.6 * SizeConfig.textMultiplier!, // Size = 14-- [14/8.66] = 1.6
  );

  static final TextStyle buttonTextBlack12 = TextStyle(
    color: Colors.black,
    fontFamily: 'OpenSans',
    fontSize: 1.38 * SizeConfig.textMultiplier!, // Size = 12-- [14/8.66] = 1.6
  );

  static final TextStyle itemTitle = TextStyle(
    color: const Color(0xff1280b3),
    fontFamily: 'OpenSans',
    fontSize: 2.07 * SizeConfig.textMultiplier!, // Size = 18-- [18/8.66] = 2.07
  );

  static final TextStyle hintText = TextStyle(
      fontSize:
          1.8 * SizeConfig.textMultiplier!, // Size = 16-- [18/8.66] = 2.07
      fontFamily: 'OpenSans');

  static final TextStyle hintTextSmall = TextStyle(
      fontSize:
      1.4 * SizeConfig.textMultiplier!, // Size = 16-- [18/8.66] = 2.07
      fontFamily: 'OpenSans');

  static final TextStyle itemGreyText = TextStyle(
      fontSize: 1.8 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
      fontFamily: 'OpenSans',
      color: const Color(0xff666666));

  static final TextStyle itemBlackTest = TextStyle(
      fontSize: 1.8 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
      fontFamily: 'OpenSans',
      color: Colors.black,);

  static final TextStyle itemBlackTestBold = TextStyle(
    fontSize: 1.8 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.bold,
    color: Colors.black,);

  static final TextStyle itemRedText = TextStyle(
    fontFamily: 'OpenSans',
    color: Colors.red,
    fontWeight: FontWeight.normal,
    fontSize: 1.8 * SizeConfig.textMultiplier!,
  );


  static final TextStyle itemGreenText = TextStyle(
    fontFamily: 'OpenSans',
    color: Colors.green,
    fontWeight: FontWeight.normal,
    fontSize: 1.8 * SizeConfig.textMultiplier!,
  );

  static final TextStyle actionsShowMoreText = TextStyle(
      fontSize: 1.8 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
      fontFamily: 'OpenSans',
      color: Colors.blue);

  static final TextStyle blueClrText = TextStyle(
    color: const Color(0xff1280b3),
    fontFamily: 'OpenSans',
    fontSize: 1.8 * SizeConfig.textMultiplier!, // Size = 16-- [18/8.66] = 1.0
  );

  static final TextStyle blueClrTextWithUnderline = TextStyle(
    color: const Color(0xff1280b3),
    fontFamily: 'OpenSans',
    decoration:
    TextDecoration.underline,
    decorationColor: Colors.blue,
    fontSize: 1.8 * SizeConfig.textMultiplier!, // Size = 16-- [18/8.66] = 1.0
  );

  static final TextStyle blueClrTextWithUnderlineGrey = TextStyle(
    color:  Colors.grey,
    fontFamily: 'OpenSans',
    decoration:
    TextDecoration.underline,
    decorationColor: Colors.grey,
    fontSize: 1.8 * SizeConfig.textMultiplier!, // Size = 16-- [18/8.66] = 1.0
  );

  static final TextStyle blueClrTextSmall = TextStyle(
    color: const Color(0xff1280b3),
    fontFamily: 'OpenSans',
    fontSize: 1.4 * SizeConfig.textMultiplier!, // Size = 16-- [18/8.66] = 1.0
  );

  static final TextStyle itemGreyTextSmall = TextStyle(
      fontSize: 1.6 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
      fontFamily: 'OpenSans',
      color: const Color(0xff666666));

  static final TextStyle itemGreyTextSmallReport = TextStyle(
      fontSize: 1.8 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
      fontFamily: 'OpenSans',
      color: const Color(0xff666666));

  static final TextStyle itemBlackTestSmall = TextStyle(
    fontSize: 1.6 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
    fontFamily: 'OpenSans',
    color: Colors.black,);

  static final TextStyle itemGreyTextVerySmall = TextStyle(
      fontSize: 1.4 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
      fontFamily: 'OpenSans',
      color: const Color(0xff666666));

  static final TextStyle itemBlackTestVerySmall = TextStyle(
    fontSize: 1.4 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
    fontFamily: 'OpenSans',
    color: Colors.black,);

  static final TextStyle itemBlackTestVerySmallReport = TextStyle(
    fontSize: 1.4 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
    fontFamily: 'OpenSans',
    color: Colors.black,);

  static final TextStyle itemBlackTestSmallReport = TextStyle(
    fontSize: 1.8 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
    fontFamily: 'OpenSans',
    color: Colors.black,);

  static final TextStyle itemBlackTestSmallReportBold = TextStyle(
    fontSize: 1.8 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
    fontFamily: 'OpenSans',
    fontWeight: FontWeight.bold,
    color: Colors.black,);

  static final TextStyle itemGreyTextBig = TextStyle(
      fontSize: 2 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
      fontFamily: 'OpenSans',
      color: Colors.grey[700]);

  static final TextStyle itemBlackTestBigs = TextStyle(
    fontSize: 2 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
    fontFamily: 'OpenSans',
    color: Colors.black,);

  static final TextStyle itemBlackTestMore = TextStyle(
    fontSize: 2.2 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
    fontFamily: 'OpenSans',
    color: Colors.black,);

  static final TextStyle itemGreyTextBigMore = TextStyle(
      fontSize: 2.5 * SizeConfig.textMultiplier!, // Size = 16-- [16/8.66] = 1.8
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.bold,
      color: Colors.grey[700]);

  /* static final TextStyle selectedTabLight = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 2 * SizeConfig.textMultiplier!,
  );

  static final TextStyle unSelectedTabLight = TextStyle(
    color: Colors.grey,
    fontSize: 2 * SizeConfig.textMultiplier!,
  );*/

  static final TextStyle countNumberRed =
      countNumber.copyWith(color: Colors.red);

  /*static final TextStyle _titleDark = _titleLight.copyWith(color: Colors.white);

  static final TextStyle _subTitleDark = _subTitleLight.copyWith(color: Colors.white70);

  static final TextStyle _buttonDark = _buttonLight.copyWith(color: Colors.black);

  static final TextStyle _greetingDark = _greetingLight.copyWith(color: Colors.black);

  static final TextStyle _searchDark = _searchDark.copyWith(color: Colors.black);

  static final TextStyle _selectedTabDark = _selectedTabDark.copyWith(color: Colors.white);

  static final TextStyle _unSelectedTabDark = _selectedTabDark.copyWith(color: Colors.white70);*/
}
