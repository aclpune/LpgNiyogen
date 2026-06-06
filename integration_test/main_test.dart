import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lpgsalesandinventory/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches and bottom navigation renders', (tester) async {

    SharedPreferences.setMockInitialValues({
      'roleId': '0',
      'userActive': 'Y',
      'DistributorId': '8118',
      'godownId': '1',
      'StaffId': '22',             // ← real StaffId from API response
      'UserId': '0',
      'godownKeeperId': '22',      // ← real GodownKeeperId from API response
      'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJTYWhlYnJhbyBKYW5nYWxlIiwianRpIjoiZTU1OWQ2OTAtMjg5Ni00ODAzLWJhMTYtNjk1Mjk0ZjZkMDhkIiwibmFtZWlkIjoiU2FoZWJyYW8gSmFuZ2FsZSIsInJvbGUiOiIwIiwiTG9nZ2VkT24iOiI1LzE5LzIwMjYgNToyNjoxOSBQTSIsIkRpc3BsYXlOYW1lIjoiU2FoZWJyYW8gSmFuZ2FsZSIsIm5iZiI6MTc3OTE5MTc3OSwiZXhwIjoxNzc5Mjk5Nzc5LCJpYXQiOjE3NzkxOTE3NzksImlzcyI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSIsImF1ZCI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSJ9.IJSs_b6kpyp5Zxh4L065jsRLs8eyw7Cxv9r5yweqqpk',
      'MobileNo': '9700097000',
      'StaffName': 'Sahebrao Jangale',
      'DistributorName': 'SHREE RENUKA GAS SUPPLY COMPANY',
      'IsAlreadyLogin': '1',
      'userActive': 'Y',
    });

    app.main();

    // Wait for splash (3s) + API calls to settle
    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(seconds: 3));

    // Verify bottom nav items
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Daily Sale'), findsOneWidget);
    expect(find.text("Today's Summary"), findsOneWidget);
    expect(find.text('More'), findsOneWidget);
  });
}