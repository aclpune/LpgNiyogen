import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/ItemReceipt/ItemReturnXMI/screen/ItemReturnXMIListItemUI.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/ItemReceipt/ItemReturnXMI/model/GetEXMIListModel.dart';

void main() {
  group('ItemReturnXMIListItemUI - basic checks', () {
    test('construct widget with minimal model does not throw', () {
      final model = GetExmiListModel(
        pkId: 1,
        returnId: 2,
        vehicleNo: 'V1',
      );

      // Constructing the widget instance should not throw synchronously.
      expect(() => ItemReturnXMIListItemUI(model), returnsNormally);
    });

    testWidgets(
        'pump ItemReturnXMIListItemUI (skipped - needs mocks)', (tester) async {
      // To run this widget test you must mock SharedPreferences and HTTP.
      // Provide SharedPreferences.setMockInitialValues and a MockClient for http.
      // After adding mocks remove skip:true.
    }, skip: true);
  });
}
