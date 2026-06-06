import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ConstantScreen/widgets.dart';
import 'package:lpgsalesandinventory/Screen/Utils/size_config.dart';

void main() {
  group('ConstantScreen widgets.dart', () {
    setUpAll(() {
      SizeConfig().init(const BoxConstraints(maxWidth: 400, maxHeight: 800), Orientation.portrait);
    });

    testWidgets('countTextWidget renders count and title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: countTextWidget(context, 5, Colors.red, 'Title'),
            ),
          ),
        ),
      );
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('countTextWidgetText renders label and title', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => Scaffold(body: countTextWidgetText(context, 'Count', 'Title')))));
      expect(find.text('Count'), findsOneWidget);
      expect(find.text(': Title'), findsOneWidget);
    });

    testWidgets('countTextWidgetTextOnAccount renders combined text', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => Scaffold(body: countTextWidgetTextOnAccount(context, '100', 'Pending')))));
      expect(find.text('100: Pending'), findsOneWidget);
    });

    testWidgets('countTextWidgetTextWithoutHeading renders title', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => Scaffold(body: countTextWidgetTextWithoutHeading(context, 'Heading')))));
      expect(find.text('Heading'), findsOneWidget);
    });

    testWidgets('countTextWidgetRemark renders truncated-capable row', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => Scaffold(body: countTextWidgetRemark(context, 'Remark', 'A long description')))));
      expect(find.text('Remark'), findsOneWidget);
      expect(find.text(': A long description'), findsOneWidget);
    });

    testWidgets('countTextWidgetTextStar renders label and star', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => Scaffold(body: countTextWidgetTextStar(context, 'Label', showAsterisk: true)))));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is RichText && widget.text.toPlainText().contains('Label') && widget.text.toPlainText().contains('*'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('countTextWidgetTextStarWithBlue renders label and star', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => Scaffold(body: countTextWidgetTextStarWithBlue(context, 'Blue Label', showAsterisk: true)))));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is RichText && widget.text.toPlainText().contains('Blue Label') && widget.text.toPlainText().contains('*'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('countTextWidgetTextWithoutHeadingGrey renders title', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => Scaffold(body: countTextWidgetTextWithoutHeadingGrey(context, 'Grey Title')))));
      expect(find.text('Grey Title'), findsOneWidget);
    });

    testWidgets('countTextWidgetOptSteps renders step and highlight', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) => Scaffold(body: countTextWidgetOptSteps(context, 'Step 1', 'Important')))));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is RichText && widget.text.toPlainText().contains('Step 1') && widget.text.toPlainText().contains('Important'),
        ),
        findsOneWidget,
      );
    });

    test('configEasyLoading sets custom loading style', () {
      configEasyLoading();
      expect(EasyLoading.instance.loadingStyle, EasyLoadingStyle.custom);
      expect(EasyLoading.instance.userInteractions, isFalse);
    });
  });
}
