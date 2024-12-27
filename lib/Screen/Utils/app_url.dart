class AppUrl {
  static const String baseUrl = 'https://192.168.2.27:502'; // Local
  // static const String baseUrl = 'https://20.193.149.194/lpgniyojanapi'; // UAT

  ///Log in
  // static const String login = '$baseUrl/Login/LoginUser';
  static const String login = '$baseUrl/Login/GetLoginDetails';
  static const String forgotPassword = '$baseUrl/Login/ForgotPassword';
  static const String GetItemMasterList = '$baseUrl/Masters/GetItemMasterList';
  static const String GetItemReceiptList = '$baseUrl/GodownKeeper/GetItemReceiptList/';
  static const String ItemReceiptAddEdit = '$baseUrl/GodownKeeper/ItemReceiptAddEdit';
  static const String ItemReturnAddEdit = '$baseUrl/GodownKeeper/ItemReturnAddEdit';
  static const String GetStaffDetailsList = '$baseUrl/Masters/GetStaffDetailsList';
  static const String GetVehicleDetailsByStaffId = '$baseUrl/Masters/GetVehicleDetailsByStaffId';
  static const String UpdateDailyRefillSale = '$baseUrl/GodownKeeper/UpdateDailyRefillSale';
  static const String UpdateDailyRefillSaleList = '$baseUrl/GodownKeeper/UpdateDailyRefillSaleList';
  static const String DailySaleByGK_StatusUpdate = '$baseUrl/GodownKeeper/DailySaleByGK_StatusUpdate';


}