import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:lpgsalesandinventory/Screen/Utils/size_config.dart';

void main() {
  group('Styling', () {
    setUpAll(() {
      SizeConfig().init(const BoxConstraints(maxWidth: 400, maxHeight: 800), Orientation.portrait);
    });

    test('static colors are defined', () {
      expect(Styling.appBackgroundColor, isA<Color>());
      expect(Styling.topBarBackgroundColor, isA<Color>());
      expect(Styling.selectedTabBackgroundColor, isA<Color>());
    });

    test('appBarTitle style is available', () {
      expect(Styling.appBarTitle, isA<TextStyle>());
      expect(Styling.appBarTitle.fontSize, isNotNull);
    });

    test('appBarDesc style is available', () {
      expect(Styling.appBarDesc, isA<TextStyle>());
      expect(Styling.appBarDesc.fontSize, isNotNull);
    });

    test('bodyTitle style is available', () {
      expect(Styling.bodyTitle, isA<TextStyle>());
      expect(Styling.bodyTitle.color, Colors.black);
    });

    test('redStar style is red', () {
      expect(Styling.redStar.color, Colors.red);
    });
  });
}

