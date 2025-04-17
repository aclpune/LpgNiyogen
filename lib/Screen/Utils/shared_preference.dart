import 'package:shared_preferences/shared_preferences.dart';
import '../User/Login/model/LoginResponseModel.dart';
import 'constants.dart';

class SharedPref {
  // Save user information to SharedPreferences
  Future<bool> saveUser(AuthToken user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('StaffId', user.staffId.toString()) &&
        await prefs.setString('DistributorId', user.distributorId.toString()) &&
        await prefs.setString('StaffName', user.staffName.toString()) &&
        await prefs.setString('MobileNo', user.mobileNo.toString()) &&
        await prefs.setString('roleId', user.roleId.toString()) &&
        await prefs.setString('godownId', user.godownId.toString()) &&
        await prefs.setString(
            'godownKeeperId', user.godownKeeperId.toString()) &&
        await prefs.setString('OTP', user.otp.toString()) &&
        await prefs.setString(
            'DistributorCode', user.distributorCode.toString()) &&
        await prefs.setString('StaffStatus', user.staffStatus.toString()) &&
        await prefs.setString('Status', user.status.toString()) &&
        await prefs.setString('token', user.token.toString()) &&
        await prefs.setString('expiration', user.expiration.toString()) &&
        await prefs.setString('refresh_token', user.refreshToken.toString());
  }

  // Get user information from SharedPreferences
  Future<AuthToken> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Read values from SharedPreferences with null checks and default values
    int StaffId = (prefs.getString("StaffId") ?? '') as int;
    int DistributorId = (prefs.getString("DistributorId") ?? '') as int;
    String StaffName = prefs.getString("StaffName") ?? '';
    String MobileNo = prefs.getString("MobileNo") ?? '';
    int roleId = int.tryParse(prefs.getString("roleId") ?? '0') ??
        0; // Ensure it's an int
    int godownId = (prefs.getString("godownId") ?? '') as int;
    int godownKeeperId = (prefs.getString("godownKeeperId") ?? '') as int;
    String OTP = prefs.getString("OTP") ?? '';
    String DistributorCode = prefs.getString("DistributorCode") ?? '';
    int StaffStatus = (prefs.getString("StaffStatus") ?? '') as int;
    String Status = prefs.getString("Status") ?? '';
    String Token = prefs.getString("Token") ?? '';
    String expiration = prefs.getString("expiration") ?? '';
    String refresh_token = prefs.getString("refresh_token") ?? '';

    return AuthToken(
      staffId: StaffId,
      distributorId: DistributorId,
      staffName: StaffName,
      mobileNo: MobileNo,
      roleId: roleId,
      godownId: godownId,
      godownKeeperId: godownKeeperId,
      otp: OTP,
      distributorCode: DistributorCode,
      staffStatus: StaffStatus,
      status: Status,
      token: Token,
      expiration: expiration,
      refreshToken: refresh_token,
    );
  }

  // Remove user data from SharedPreferences
  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('StaffId');
    await prefs.remove('DistributorId');
    await prefs.remove('StaffName');
    await prefs.remove('MobileNo');
    await prefs.remove('roleId');
    await prefs.remove('godownId');
    await prefs.remove('godownKeeperId');
    await prefs.remove('OTP');
    await prefs.remove('DistributorCode');
    await prefs.remove('StaffStatus');
    await prefs.remove('Status');
    await prefs.remove('token');
    await prefs.remove('expiration');
    await prefs.remove('refresh_token');
    await prefs.remove('userActive');


    // Clear all prefs data
    await prefs.clear();
  }

  // Save authentication token to SharedPreferences
  // Future<bool> setAuthToken(AuthToken authToken) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return await prefs.setString('token', authToken.token.toString()) &&
  //       await prefs.setString('expiration', authToken.expiration.toString()) &&
  //       await prefs.setString(
  //           'refresh_token', authToken.refreshToken.toString());
  // }

  // Set Firebase Cloud Messaging (FCM) token
  void setFCMToken(String? fcmToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.fcmToken, fcmToken.toString());
  }
   Future<Future<bool>> setUserName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('userActive', value);
  }

   Future<String> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userActive') ?? '';
  }
  // Get authentication token from SharedPreferences
  Future<AuthToken> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token") ?? '';
    String expiryToken = prefs.getString("expiration") ?? '';
    String refreshToken = prefs.getString("refresh_token") ?? '';

    return AuthToken(
      token: token,
      expiration: expiryToken,
      refreshToken: refreshToken,
    );
  }



}
