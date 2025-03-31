class AppUrl {
  // static const String baseUrl = 'https://192.168.2.27:502'; // Local
  // static const String baseUrl = 'https://20.193.149.194/lpgniyojanapi'; // UAT Client
  static const String baseUrl = 'https://20.193.149.194/lpgniyojanuatapi'; // UAT New Development
  // static const String baseUrl = 'https://lpgniyojan.aadyaminfotech.com/lpgniyojanapi'; // Production New

  ///Log in
  // static const String login = '$baseUrl/Login/LoginUser';
  static const String login = '$baseUrl/Login/GetLoginDetails';
  static const String forgotPassword = '$baseUrl/Login/ForgotPassword';

  ///GK
  static const String GetItemMasterList = '$baseUrl/Masters/GetItemMasterList';
  static const String GetItemReceiptList = '$baseUrl/GodownKeeper/GetItemReceiptList/';
  static const String ItemReceiptAddEdit = '$baseUrl/GodownKeeper/ItemReceiptAddEdit';
  static const String ItemReturnAddEdit = '$baseUrl/GodownKeeper/ItemReturnAddEdit';
  static const String GetStaffDetailsList = '$baseUrl/Masters/GetStaffDetailsList';
  static const String GetVehicleDetailsByStaffId = '$baseUrl/Masters/GetVehicleDetailsByStaffId';
  static const String UpdateDailyRefillSale = '$baseUrl/GodownKeeper/UpdateDailyRefillSale';
  static const String UpdateDailyRefillSaleList = '$baseUrl/GodownKeeper/UpdateDailyRefillSaleList';
  static const String DailySaleByGK_StatusUpdate = '$baseUrl/GodownKeeper/DailySaleByGK_StatusUpdate';
  static const String ItemImbalanceList = '$baseUrl/GodownKeeper/ItemImbalanceList';
  static const String ItemImbalanceQtyAddEdit = '$baseUrl/GodownKeeper/ItemImbalanceQtyAddEdit';
  static const String TodaysOpeningStkForGK = '$baseUrl/GodownKeeper/TodaysOpeningStkForGK';
  static const String ImbalanceAsOfDateStkForGK = '$baseUrl/GodownKeeper/ImbalanceAsOfDateStkForGK';
  static const String ItemCurrentStkList = '$baseUrl/GodownKeeper/ItemCurrentStkList';
  static const String GetDeliveryBoyListForMob = '$baseUrl/GodownKeeper/GetDeliveryBoyListForMob';
  static const String GetGodownMasterList = '$baseUrl/Masters/GetGodownMasterList';
  static const String SaveGodownStockTransferDtls = '$baseUrl/GodownKeeper/SaveGodownStockTransferDtls';
  static const String GetStockTransferDtls = '$baseUrl/GodownKeeper/GetStockTransferDtls';
  static const String ItemRetEXMIAddEdit = '$baseUrl/GodownKeeper/ItemRetEXMIAddEdit';
  static const String ItemReceiptEXMIAddEdit = '$baseUrl/GodownKeeper/ItemReceiptEXMIAddEdit';
  static const String GetItemEXMIDetailList = '$baseUrl/GodownKeeper/GetItemEXMIDetailList';

  ///maager
  static const String GetDailySaleSummaryListDMWiseForMob = '$baseUrl/DailyStockCash/GetDailySaleSummaryListDMWiseForMob';
  static const String GetDailySaleDetailsByStaffIdForMob = '$baseUrl/DailyStockCash/GetDailySaleDetailsByStaffIdForMob';
  static const String GetDailySaleCollReceiptNo = '$baseUrl/DailyStockCash/GetDailySaleCollReceiptNo';
  static const String GetRSPDetailsList = '$baseUrl/Masters/GetRSPDetailsList';
  static const String GetVendorMasterList = '$baseUrl/Masters/GetVendorMasterList';
  static const String GetExpenseHeaderList = '$baseUrl/Masters/GetExpenseHeaderList';
  static const String UpdateSaleAddEditForMob = '$baseUrl/DailyStockCash/UpdateSaleAddEditForMob';
  static const String ExpenseDetailsAddEdit = '$baseUrl/DailyStockCash/ExpenseDetailsAddEdit';
  static const String GetExpenseDetailsListByStaffId = '$baseUrl/DailyStockCash/GetExpenseDetailsListByStaffId';
  static const String GetCashDenominationItemList = '$baseUrl/Masters/GetCashDenominationItemList';
  static const String GetMobDashboardSummaryForMgr = '$baseUrl/Dashboard/GetMobDashboardSummaryForMgr';
  static const String InventoryCurrentStockDtlsForMobDash = '$baseUrl/Dashboard/InventoryCurrentStockDtlsForMobDash';
  static const String GetDsrIncomeReportListForMob = '$baseUrl/Reports/GetDsrIncomeReportListForMob';
  static const String GetDSRDataAgainstDateForMob = '$baseUrl/Reports/GetDSRDataAgainstDateForMob';
  static const String GetDsrExpenseReportListForMob = '$baseUrl/Reports/GetDsrExpenseReportListForMob';
  static const String GetCDCMsStockUpdateForMob = '$baseUrl/Reports/GetCDCMsStockUpdateForMob';
  static const String GetCashHandOverDSRDtlsForMob = '$baseUrl/Reports/GetCashHandOverDSRDtlsForMob';
  static const String GetCashDenomDSRRprtForMob = '$baseUrl/Reports/GetCashDenomDSRRprtForMob';
  static const String SavecDCMSDataFromMob = '$baseUrl/Reports/SavecDCMSDataFromMob';
  static const String SaveAllDSRDataFromMob = '$baseUrl/Reports/SaveAllDSRDataFromMob';
  static const String DSRCheckSavedornot = '$baseUrl/Reports/DSRCheckSavedornot';
  static const String CheckDayEndConfirmation = '$baseUrl/Masters/CheckDayEndConfirmation';
  static const String GetCashFlowSummaryDSRMob = '$baseUrl/Reports/GetCashFlowSummaryDSRMob';

}