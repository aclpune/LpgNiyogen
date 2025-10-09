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
      'No internet connection. Please try again later.';
  static String loginFailedMessage = 'Authentication failed';
  static String titleSuccess = 'Success';
  static String titleContent = 'New password is sent to your email id.';
  static String failed = 'Failed';
  static String emailFailedMessage =
      'This email id is not registered with us.. check again';
  static String forgetPassFailedMessage = 'Forget Password failed';
  static String responseFailedMessage = 'Something went wrong..try again';
  static String flag = 'Y';
  static String appName = "Niyojan";
  static String androidPlayStoreAppUrl =
      '';

  ///TODO: Replace below URL with Apple App Store URL
  static String appleAppStoreAppUrl = "";
  static String listGettingFail = "Unable to load data at this time. Please try again";
  static String recordAlreadyExist = "The entered item already exists for the selected delivery personnel.";
  static String countShouldNotBeGreater = "The total cylinder count must be greater than all other quantities.";
  static String svConsumerCountExceed = "Consumer details count should not exceed the SV cyl quantity.";
  static String tvConsumerCountExceed = "Consumer details count should not exceed the TV cyl quantity.";
  static String svConsumerCountExceedTwoLine = "Consumer details count should \n not exceed the SV cyl quantity.";
  static String tvConsumerCountExceedTwoLine = "Consumer details count should \n not exceed the tv cyl quantity.";
  static String consumerExist = "This consumer already exists.";
  static String recordExist = "This item already exists.";
  static String dataDeleted = "Data deleted successfully.";
  static String dataDeletedFail = "Failed to delete the record.";
  static String dataUpdated = "Data updated successfully.";
  static String nodataFound = "No data found.";
  static String validCountEnter = "Enter a valid count.";
  static String recordNotInserted = "Unsuccessful to send data.";
  static String imbalanceCountValidation = "Input quantity must be smaller than the empty quantity.";
  static String stockTransferValidation = "Stock transfer quantity entered should not exceed current stock.";
  static String selectValidItemReceipt = "Please select a valid item for each entry.";
  static String atLeastOneQtyRequired = "At least one quantity is required.";
  static String itemAddedSuccessfully = "Item added successfully.";
  static String vehicleValidation = "Please enter a valid vehicle number.";
  static String stockNotAccepted = "Kindly complete the stock transfer request for this godown before taking any further action.";
  static String vehicleNotReturn = "Item return action for this vehicle no. is pending, you need to first return this vehicle and then proceed to Item receipt for the same.";
  static String vehicleNotIn = "The vehicle no. being returned has not been received in the system, please use EXMI receipt menu to first receive it and then proceed to item return for the same vehicle no.";
  static String itemreceiptDataNotInserted = "Data not inserted/updated";
  static String failToInserRecord = "Something went wrong.";
  static String defectiveQtyItemReturn = "Defective quantity must be less than the return quantity.";
  static String gretaerItemQty = "The following items have a quantity greater than the available stock.";
  static String dayEndCompleted = "This action is not permitted as today's day end operation has already been completed.";
  static String totalSaleQtyDailySale = "Refill sale qty exceeds current filled stock for this item, kindly check the qty entered or add filled stock using item receipt menu.";
  static String defectiveSaleQtyDailySale = "Defective qty exceeds current defective stock for this item, kindly check the qty entered or add defective stock.";
  static String svTvConsumerSelectFromDD = "Please select valid consumer number from list.";

  ///manager
  static String expenseSendMgr = "Data saved successfully.";
  static String expenseExistMgr = "Record already exist.";
  static String cashHandOverDeno = "The Entered Cash Denomination Total Should Be Equal To Cash Handover/Deposit Amount.";
  static String cashDenominationIsMandatory = "Cash Denomination Is Mandatory.";
  ///update sale
  static String transactionDetails = "Please enter transaction details.";
  static String customerDetails = "Please enter customer details.";
  static String reticulatedCylinderQuantity = "The reticulated cylinder quantity must be equal to the customer cylinder quantity.";
  static String receivedAmount = "Please enter a valid total received amount.";
  static String addBalanceDelBoyAccount = "Please select the balance amount to be added to the delivery personnel’s account.";
  static String denominationAmount = "The total received amount must match the final total amount.";
  static String totalReceivedAmountLumpsum = "The total receivable amount cannot exceed the actual sale amount.";
  static String allDataEmpty = "Please review and enter the required details.";
  static String correctionRequestMethod = "Correction Request Processed Successfully.";
  static String acceptSale = "Accepted Successfully..";
  static String selectPaymentMode = "Please select payment mode.";
  static String selectConsumerMode = "Please select consumer.";
  static String selectConsumerTypeMode = "Please select consumer type.";
  static String creditQty = "The quantity cannot exceed the cylinder quantity.";
  static String cashAmount = "Please enter a valid cash amount.";
  static String discountExceedCashCollection = "Discount amount should not be greater than discount limit.";
  static String discountExceedCashCollectionRSP = "Discount amount should not be greater than RSP price.";

  static String roleIdGodown = "0";
  static String roleIdManager= "3";

  static String roleIdOwner = "5";

  ///
  static String reqfield = "Please enter all required fields";
  static String expenseSendMgr1 = "Data deleted successfully.";
  static String amountEqual = 'The Entered Payment Amount cannot exceed the total amount';

  static String TransMode = "Please select payment mode";
  static String selStaff = "Please select staff name";
  static String selCust = "Please select customer name";
  static String pedagainst = "Please select paid against value";
  static String salaryAmt = "Amount is required";
  static String bankname = "Bank Account No is required";
  static String transCode = "Transaction Code is required";
  static String expenseSendMgrEdit = "Data Updated successfully.";
  static String expenseSendMgrDelete = "Data deleted successfully.";
  static String failToDelete = "Failed to delete record.";
  static String arbSaleCashAmount = "Please enter valid cash amount.";
  static String arbSaleQrAmount = "Please enter valid QR amount.";
  static String arbSaleQrCashAmount = "Please enter valid QR and Cash amount.";
  //TextSizes
  static double size20 = 20;
  static double size18 = 18;
  static double size16 = 16;
  static double size14 = 14;
  static String AppBarTitle = "Niyojan";

  static String DSRMessage =
      "Warning: Once you confirm the DSR,\nApplication will close the day and save the closing entries for inventory (cyl and ARB), along with cash flow transactions.\nYou will not be allowed to make any changes to any transaction once you confirm, and today’s closing will be done.\nAre you sure you want to proceed?";
  static String OnAccErr = "Please select the specific staff for payment.";
  ///
  static String discountError = "The Entered Discount Should Not Be Greater Than Amt.";

  static String partialPayErr = "After partial payment or payment completion, the invoice cannot be deleted";
  static String partialPayErr1 = "After partial payment or payment completion, the invoice cannot be edited";
  static String creditPayErr = "After adding a credit note, you cannot edit the record.";
  static String creditPayErr1 = "After adding a credit note, you cannot delete the record.";
  static String creditCheck = "The Credit note amount is equal to the total amount.";
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
