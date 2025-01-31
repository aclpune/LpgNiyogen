class Constants {
  /*UserName	Password
superadmin	cnf@1234
BranchAdminAI	cnf@1234
Operator	cnf@1234
Supervisor	cnf@1234
Picker	cnf@1234
Bill Drawer	cnf@1234
GateSupervisor	cnf@1234
BranchAdminAH	cnf@1234*/

  //font Size
  static double fontSize = 15;
  static String updateMessageForIos =
      "The new version of the apk is available..So Please update the new version..";
  static String appleUrl =
      "https://apps.apple.com/in/app/tirupati-c-f/id1673694668";
  //Firebase
  //Indian Rupee sign
  static String rupee = "\u{20B9}";
  static String fcmToken = "fcmToken";
  static String strAll = "ALL";
  static String strY = "Y";
  static String strN = "N";
  static String grantTypePassword = "password";
  static String grantTypeRefreshToken = "refresh_token";
  static int success = 200;
  static int internalServer = 500;
  static String exists = "Exists";
  static int tokenExpireAuth = 401;
  static String isBoxScanned = "1";
  static bool isNetworkAvailable = false;
  static String connectionTitle = 'No Internet';
  static String loginFailedTitle = 'Login Failed';
  static String connectionMessage =
      'No Internet connection please try again later';
  static String loginFailedMessage = 'Authentication failed';
  static String titleSuccess = 'Success';
  static String titleContent = 'New password is sent to your email id.';
  static String failed = 'Failed';
  static String emailFailedMessage =
      'This email id is not registered with us.. check again';
  static String forgetPassFailedMessage = 'Forget Password failed';
  static String responseFailedMessage = 'Something went wrong..try again';
  static String flag = 'Y';
  static String appName = "LPG Niyojan";
  // static String androidPlayStoreAppUrl =
  //     "https://play.google.com/store/apps/details?id=com.aipl.flutter.cnf.flutter_cnf";
  static String androidPlayStoreAppUrl =
      '';

  ///TODO: Replace below URL with Apple App Store URL
  static String appleAppStoreAppUrl =
      "";

  static String pickerRoleName = 'Picker';
  static String billDrawerRoleName = 'Bill Drawer';
  static String gateSupervisorRoleName = 'Gate Supervisor';
  static String typeGatePass = 'Gatepass';
  static String typeQRSticker = 'Sticker';
  static String roleIdBillDrawer = "6";
  static String roleIdGodown = "3";
  static String roleIdGateSupervisor = "7";
  static String roleIdExpirySupervisor = "8";
  static String roleIdInwardSupervisor = "9";
  static String roleIdOwner = "11";

  static String local = "1";
  static String otherCity = "2";
  static String byHand = "3";

// picklist status
  static int statusAllottedPickList = 3;
  static int statusReAllottedPickList = 6;
  static int statusAcceptedPickList = 4;
  static int statusRejectedPickList = 2;
  static int statusCompletedPickList = 8; // picked
  static int statusRaiseConcernCompletedPickList = 9; // picker concern
  static int statusVerifiedPickList = 1; //
  static int statusCompletedVerifiedPickList = 10;

  static int statusAllottedRejectPickList = 5; //
  static int statusReAllottedRejectPickList = 7; //
  static int statusRaiseConcernVerifyPickList = 11; //

  //Invoice status
  static int statusCreatedInvoice = 0;
  static int statusAcceptedInvoice = 1;
  static int statusDrawnInvoice = 2;
  static int statusCompletedInvoice = 3;
  static int statusPackageConcernInvoice = 4;
  static int statusReadyToDispatchInvoice = 5;

  //Expiry supervisor
  static int statusRaiseConcernFirstPhyCheck = 1;

  //Gatepass Supervisor
  static int statusGatePassGenerated = 7;

  //TextSizes
  static double size20 = 20;
  static double size18 = 18;
  static double size16 = 16;
  static double size14 = 14;

  /*
  //Picklist -
0	Created	PL
1	Verified	PL
2	Rejected	PL
3	Alloted	PL
7	Reallotment - Rejected	PL
4	Accepted	PL
2	Accepted	INV
5	Allotment-Rajected	PL
8	Picked	PL
9	Picker Concern	PL

//Invoice -
1	Accepted
0	Created
2	Invoice Drawn
3	Packed
5	Ready To Dispatch
7	Getpass Generated
8	Dispatched
9	LR Updated
4	Packing Concern
6	Dispatch Concern
20	Cancel  */

/* UserName	Password
superadmin	cnf@1234
BranchAdminAI	cnf@1234
Operator	cnf@1234
Supervisor	cnf@1234
Picker	cnf@1234
Bill Drawer	cnf@1234
GateSupervisor	cnf@1234
BranchAdminAH	cnf@1234*/

/*Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => super.widget));*/
}
