class AppUrl {
   // static const String baseUrl = 'https://192.168.2.27:502'; // Local
   // static const String baseUrl = 'https://192.168.2.64:502'; // Local new
  // static const String baseUrl = 'https://20.193.149.194/lpgniyojanapi'; // UAT Client
  //  static const String baseUrl = 'https://20.193.149.194/lpgniyojanuatapi'; // UAT New Development
  //  static const String baseUrl = 'https://aadyaminfotech.com/lpgniyojanuatapi'; // UAT New Development working
 static const String baseUrl = 'https://lpgniyojan.aadyaminfotech.com/lpgniyojanapi'; // Production New

  ///Log in
  // static const String login = '$baseUrl/Login/LoginUser';
  // static const String login = '$baseUrl/Login/GetLoginDetails';
  static const String login = '$baseUrl/Login/GetLoginDetails_V2';
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
  static const String DefectiveMasterAdd_Mob = '$baseUrl/GodownKeeper/DefectiveMasterAdd_Mob';
  static const String GetDefectiveList_Mob = '$baseUrl/GodownKeeper/GetDefectiveList_Mob';
  static const String GetDailySaleSVTVConsumerDtls_Mob = '$baseUrl/DailyStockCash/GetDailySaleSVTVConsumerDtls_Mob';
  static const String GetDailySaleSVTVConsumerDtls = '$baseUrl/DailyStockCash/GetDailySaleSVTVConsumerDtls';

  ///manager
  static const String GetDailySaleSummaryListDMWiseForMob = '$baseUrl/DailyStockCash/GetDailySaleSummaryListDMWiseForMob';
  static const String GetDailySaleDetailsByStaffIdForMob = '$baseUrl/DailyStockCash/GetDailySaleDetailsByStaffIdForMob';
  static const String GetDailySaleCollReceiptNo = '$baseUrl/DailyStockCash/GetDailySaleCollReceiptNo';
  static const String GetRSPDetailsList = '$baseUrl/Masters/GetRSPDetailsList';
  static const String GetCustomerList = '$baseUrl/Masters/GetCustomerList';
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
  static const String DailySaleCheckCashLessConsumerDtls = '$baseUrl/DailyStockCash/DailySaleCheckCashLessConsumerDtls';
  static const String GetCustDiscountList = '$baseUrl/Masters/GetCustDiscountList';
  static const String GetCustItemCurrDiscount = '$baseUrl/Masters/GetCustItemCurrDiscount';
  static const String GetDailySaleCollByMgrDataByIdForMob = '$baseUrl/DailyStockCash/GetDailySaleCollByMgrDataByIdForMob';
  static const String GetBalanceByStaffId = '$baseUrl/DailyStockCash/GetBalanceByStaffId';
  static const String GetLastUploadedTimeDiff = '$baseUrl/AutoExport/GetLastUploadedTimeDiff';
  static const String DepositCashAddEdit = '$baseUrl/DailyStockCash/DepositCashAddEdit';
  static const String CustDiscDetailsAddEdit = '$baseUrl/Masters/CustDiscDetailsAddEdit';

  ///DSR Click API
  static const String GetCashflowpopupList_Mob = '$baseUrl/Reports/GetCashflowpopupList_Mob';
   static const String GetexpensepopupList_Mob =  '$baseUrl/Reports/GetexpensepopupList_Mob';
   static const String GetCashInHandpopupList_Mob = '$baseUrl/Reports/GetCashInHandpopupList_Mob';
   static const String GetUnsettledAmountList_Mob = '$baseUrl/Reports/GetUnsettledAmountList_Mob';
   static const String GetexpensepopupListOnAccount_Mob = '$baseUrl/Reports/GetexpensepopupListOnAccount_Mob';

   ///Dashboard Click API
  static const String GetDashboardSettlementCtnList = '$baseUrl/Dashboard/GetDashboardSettlementCtnList';
  static const String GetDashboardNiyojanPunchCtnLstForMob = '$baseUrl/Dashboard/GetDashboardNiyojanPunchCtnLstForMob';
  static const String GetDashboardPostpaidVarifiPendCntLstForMob = '$baseUrl/Dashboard/GetDashboardPostpaidVarifiPendCntLstForMob';
  static const String GetDashboardSVStockPendCtnListForMob = '$baseUrl/Dashboard/GetDashboardSVStockPendCtnListForMob';
  static const String GetDashboardTVStockPendCtnListForMob = '$baseUrl/Dashboard/GetDashboardTVStockPendCtnListForMob';
  static const String GetBankMappingDetailsList = '$baseUrl/Masters/GetBankMappingDetailsList';
  static const String GetDashboardOnAccAmtCtnListMob_V1 = '$baseUrl/Dashboard/GetDashboardOnAccAmtCtnListMob_V1';
  static const String GetDashboardUnsettledAmtListMob_V1 = '$baseUrl/Dashboard/GetDashboardUnsettledAmtListMob_V1';
  static const String GetDashboardImbalanceDtlsListMob_V1 = '$baseUrl/Dashboard/GetDashboardImbalanceDtlsListMob_V1';

  ///Cash Handover API
   static const String GetStaffDetailsListUserIsMade = '$baseUrl/Masters/GetStaffDetailsListUserIsMade';
   // static const String GetBankMappingDetailsList = '$baseUrl/Masters/GetBankMappingDetailsList';
    static const String GetCashHandOverDtls = '$baseUrl/DailyStockCash/GetCashHandOverDtls';
    //static const String GetCashDenominationItemList = '$baseUrl/Masters/GetCashDenominationItemList';

//sv
  static const String PendingSVAddEdit_Mob = '$baseUrl/DailyStockCash/PendingSVAddEdit_Mob';
  static const String GetDistStampDuty = '$baseUrl/DailyStockCash/GetDistStampDuty';
  static const String GetArbCurrentStockList = '$baseUrl/Reports/GetArbCurrentStockList';
  static const String GetARBItemMasterList = '$baseUrl/Masters/GetARBItemMasterList';
  static const String GetPendingSVList_Mob = '$baseUrl/DailyStockCash/GetPendingSVList_Mob';
  static const String GetPendingSVCashDenoDtlsById_Mob = '$baseUrl/DailyStockCash/GetPendingSVCashDenoDtlsById_Mob';

  ///update Payments
  static const String GetVoucherNoForExpense = '$baseUrl/DailyStockCash/GetVoucherNoForExpense';
  static const String GetVendorMasterList = '$baseUrl/Masters/GetVendorMasterList';
  //static const String GetExpenseHeaderList = '$baseUrl/Masters/GetExpenseHeaderList';
  static const String SaveVendorMaster = '$baseUrl/Masters/SaveVendorMaster';
  //static const String GetBalanceByStaffId = '$baseUrl/DailyStockCash/GetBalanceByStaffId';
  //static const String GetBalanceByStaffId = '$baseUrl/DailyStockCash/GetBalanceByStaffId';
  static const String PaymentDetailAddEdit = '$baseUrl/DailyStockCash/PaymentDetailAddEdit';
  static const String GetPaymentDetailList = '$baseUrl/DailyStockCash/GetPaymentDetailList';
  static const String GetPaymentdetailCashDenominationDtl = '$baseUrl/DailyStockCash/GetPaymentdetailCashDenominationDtl';

  ///payment Receipt
  static const String GetReceiptNoForBank = '$baseUrl/DailyStockCash/GetReceiptNoForBank';
  //static const String GetCustomerList = '$baseUrl/Masters/GetCustomerList';
  static const String GetCustTypeList = '$baseUrl/Masters/GetCustTypeList';
  static const String AddEditCustomer = '$baseUrl/Masters/AddEditCustomer';
  static const String GetBankcashReceiptList = '$baseUrl/DailyStockCash/GetBankcashReceiptList';
  static const String BankCashReceiptAddEdit = '$baseUrl/DailyStockCash/BankCashReceiptAddEdit';
  static const String GetReceiptCashDenominationDtl = '$baseUrl/DailyStockCash/GetReceiptCashDenominationDtl';

  ///Salary Payments
  static const String GetSalaryIncentiveEntryList = '$baseUrl/DailyStockCash/GetSalaryIncentiveEntryList';
  //static const String GetStaffDetailsList = '$baseUrl/DailyStockCash/GetStaffDetailsList';
  static const String SalaryIncentiveEntryAddEdit = '$baseUrl/DailyStockCash/SalaryIncentiveEntryAddEdit';
  static const String GetCashDenominationDtlsById = '$baseUrl/DailyStockCash/GetCashDenominationDtlsById';

  ///TV

  static const String TVDtlsAddEdit = '$baseUrl/DailyStockCash/TVDtlsAddEdit_V2';
  static const String GetTVDetails = '$baseUrl/DailyStockCash/GetTVDetails_V2';
  static const String GetTVEntryCashDenominationDtl = '$baseUrl/DailyStockCash/GetTVEntryCashDenominationDtl_V2';

  ///cash denomination
  static const String GetPageActionPermissionDtls = '$baseUrl/Masters/GetPageActionPermissionDtls';

  ///ARB Purchase Return
  static const String AddEditARBItemPurchase = '$baseUrl/InventoryStock/AddEditARBItemPurchase';
  static const String GetARBItemPurList = '$baseUrl/InventoryStock/GetARBItemPurList';
  static const String PaymentDetailsAdd = '$baseUrl/InventoryStock/PaymentDetailsAdd';
  static const String GetPaymentDetlARBPurLst = '$baseUrl/InventoryStock/GetPaymentDetlARBPurLst';
  static const String GetARBItemPurCashDenoDtlsById = '$baseUrl/InventoryStock/GetARBItemPurCashDenoDtlsById';
  //static const String GetARBItemPurList = '$baseUrl/InventoryStock/GetARBItemPurList';
  ///InventoryStock/GetARBItemPurList/8118

  ///ARB
  static const String AddEditARBItemReturn = '$baseUrl/InventoryStock/AddEditARBItemReturn';
  static const String GetARBItemRetList = '$baseUrl/InventoryStock/GetARBItemRetList';
  static const String AddCreditNoteDetails = '$baseUrl/InventoryStock/AddCreditNoteDetails';

 ///ARB Sale
 ///InventoryStock/ARBSalesAddEdit
 static const String ARBSalesAddEdit = '$baseUrl/InventoryStock/ARBSalesAddEdit_V2';
 static const String GetARBSalesList = '$baseUrl/InventoryStock/GetARBSalesList_V2';
 static const String GetARBSalesCashDenoDtlsById = '$baseUrl/InventoryStock/GetARBSalesCashDenoDtlsById_V2';
}




