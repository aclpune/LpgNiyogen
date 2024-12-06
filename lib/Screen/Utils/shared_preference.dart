import 'package:shared_preferences/shared_preferences.dart';
import '../User/Login/model/LoginResponseModel.dart';
import 'constants.dart';

class SharedPref {
  // Save user information to SharedPreferences
  Future<bool> saveUser(UserInfo user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('displayName', user.displayName.toString()) &&
        await prefs.setString('mobileNo', user.mobileNo.toString()) &&
        await prefs.setString('customerId', user.customerId.toString()) &&
        await prefs.setString('customerCode', user.customerCode.toString()) &&
        await prefs.setString('customerName', user.customerName.toString()) &&
        await prefs.setString('refNo', user.refNo.toString()) &&
        await prefs.setString('userName', user.userName.toString()) &&
        await prefs.setString('userId', user.userId.toString()) &&
        await prefs.setString('roleId', user.roleId.toString()) &&
        await prefs.setString('roleName', user.roleName.toString()) &&
        await prefs.setString('activeStatus', user.activeStatus.toString()) &&
        await prefs.setString('lastUpdatedDate', user.lastUpdatedDate.toString()) &&
        await prefs.setString('customerAddress', user.customerAddress.toString()) &&
        await prefs.setString('gstno', user.gstno.toString()) &&
        await prefs.setString('email', user.email.toString()) &&
        await prefs.setString('source', user.source.toString()) &&
        await prefs.setString('godownId', user.godownId.toString()) &&
        await prefs.setString('godownKeeperId', user.godownKeeperId.toString()) &&
        await prefs.setString('distributorId', user.distributorId.toString());
  }

  // Get user information from SharedPreferences
  Future<UserInfo> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Read values from SharedPreferences with null checks and default values
    String displayName = prefs.getString("displayName") ?? '';
    String mobileNo = prefs.getString("mobileNo") ?? '';
    String customerId = prefs.getString("customerId") ?? '';
    String customerCode = prefs.getString("customerCode") ?? '';
    String customerName = prefs.getString("customerName") ?? '';
    String refNo = prefs.getString("refNo") ?? '';
    String userName = prefs.getString("userName") ?? '';
    int userId = int.tryParse(prefs.getString("userId") ?? '0') ?? 0; // Ensure it's an int
    int roleId = int.tryParse(prefs.getString("roleId") ?? '0') ?? 0; // Ensure it's an int
    String roleName = prefs.getString("roleName") ?? '';
    String activeStatus = prefs.getString("activeStatus") ?? '';
    String lastUpdatedDate = prefs.getString("lastUpdatedDate") ?? '';
    String customerAddress = prefs.getString("customerAddress") ?? '';
    String gstno = prefs.getString("gstno") ?? '';
    String email = prefs.getString("email") ?? '';
    String source = prefs.getString("source") ?? '';
    int godownId = (prefs.getString("godownId") ?? '') as int;
    int godownKeeperId = (prefs.getString("godownKeeperId") ?? '') as int;
    int distributorId = (prefs.getString("distributorId") ?? '') as int;

    return UserInfo(
      displayName: displayName,
      mobileNo: mobileNo,
      customerId: customerId,
      customerCode: customerCode,
      customerName: customerName,
      refNo: refNo,
      userName: userName,
      userId: userId,
      roleId: roleId,
      roleName: roleName,
      activeStatus: activeStatus,
      lastUpdatedDate: lastUpdatedDate,
      customerAddress: customerAddress,
      gstno: gstno,
      email: email,
      source: source,
      godownId:godownId,
      godownKeeperId:godownKeeperId,
      distributorId:distributorId,
    );
  }

  // Remove user data from SharedPreferences
  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('displayName');
    await prefs.remove('mobileNo');
    await prefs.remove('customerId');
    await prefs.remove('customerCode');
    await prefs.remove('customerName');
    await prefs.remove('refNo');
    await prefs.remove('userId');
    await prefs.remove('roleId');
    await prefs.remove('roleName');
    await prefs.remove('activeStatus');
    await prefs.remove('lastUpdatedDate');
    await prefs.remove('customerAddress');
    await prefs.remove('gstno');
    await prefs.remove('email');
    await prefs.remove('source');
    await prefs.remove('godownId');
    await prefs.remove('godownKeeperId');
    await prefs.remove('distributorId');
    await prefs.remove('encryptPass');
    await prefs.remove('password');

    // Clear all prefs data
    await prefs.clear();
  }

  // Save authentication token to SharedPreferences
  Future<bool> setAuthToken(AuthToken authToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('token', authToken.token.toString()) &&
        await prefs.setString('expiration', authToken.expiration.toString()) &&
        await prefs.setString('refresh_token', authToken.refreshToken.toString());
  }

  // Set Firebase Cloud Messaging (FCM) token
  void setFCMToken(String? fcmToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Constants.fcmToken, fcmToken.toString());
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



// import 'package:shared_preferences/shared_preferences.dart';
// import '../User/Login/model/LoginResponseModel.dart';
// import 'constants.dart';
//
// class SharedPref {
//   Future<bool> saveUser(UserInfo user) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('displayName', user.displayName.toString());
//     prefs.setString('mobileNo', user.mobileNo.toString());
//     prefs.setString('customerId', user.customerId.toString());
//     prefs.setString('customerCode', user.customerCode.toString());
//     prefs.setString('customerName', user.customerName.toString());
//     prefs.setString('refNo', user.refNo.toString());
//     prefs.setString('userName', user.userName.toString());
//     prefs.setString('userId', user.userId.toString());
//     prefs.setString('roleId', user.roleId.toString());
//     prefs.setString('roleName', user.roleName.toString());
//     prefs.setString('activeStatus', user.activeStatus.toString());
//     prefs.setString('lastUpdatedDate', user.lastUpdatedDate.toString());
//     prefs.setString('customerAddress', user.customerAddress.toString());
//     prefs.setString('gstno', user.gstno.toString());
//     prefs.setString('email', user.email.toString());
//     prefs.setString('source', user.source.toString());
//
//     //prefs.setString('refresh_token',user.refreshToken);
//
//     return prefs.commit();
//   }
//
//   Future<UserInfo> getUser() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String displayName = prefs.getString("displayName")!;
//     String mobileNo = prefs.getString("mobileNo")!;
//     String customerId = prefs.getString("customerId")!;
//     String customerCode = prefs.getString("customerCode")!;
//     String customerName = prefs.getString("customerName")!;
//     String refNo = prefs.getString("refNo")!;
//     String userName = prefs.getString("userName")!;
//     int userId = prefs.getString("userId")! as int;
//     int roleId = prefs.getString("roleId")! as int;
//     String roleName = prefs.getString("roleName")!;
//     String activeStatus = prefs.getString("activeStatus")!;
//     String lastUpdatedDate = prefs.getString("lastUpdatedDate")!;
//     String customerAddress = prefs.getString("customerAddress")!;
//     String gstno = prefs.getString("gstno")!;
//     String email = prefs.getString("email")!;
//     String source = prefs.getString("source")!;
//
//     return UserInfo(
//       displayName:displayName,
//       mobileNo:mobileNo,
//       customerId:customerId,
//       customerCode:customerCode,
//       customerName:customerName,
//       refNo:refNo,
//       userName:userName,
//       userId:userId,
//       roleId:roleId,
//       roleName:roleName,
//       activeStatus:activeStatus,
//       lastUpdatedDate:lastUpdatedDate,
//       customerAddress:customerAddress,
//       gstno:gstno,
//       email:email,
//       source:source,
//     );
//   }
//
//   void removeUser() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('displayName');
//     prefs.remove('mobileNo');
//     prefs.remove('customerId');
//     prefs.remove('customerCode');
//     prefs.remove('customerName');
//     prefs.remove('refNo');
//     prefs.remove('userName');
//     prefs.remove('userId');
//     prefs.remove('roleId');
//     prefs.remove('roleName');
//     prefs.remove('activeStatus');
//     prefs.remove('lastUpdatedDate');
//     prefs.remove('customerAddress');
//     prefs.remove('gstno');
//     prefs.remove('email');
//     prefs.remove('source');
//
//     await prefs.clear();
//   }
//
//   Future<bool> setAuthToken(AuthToken authToken) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('token', authToken.token.toString());
//     prefs.setString('expiration', authToken.expiration.toString());
//     prefs.setString('refresh_token', authToken.refreshToken.toString());
//
//     return prefs.commit();
//   }
//
//   void setFCMToken(String? fcmToken) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString(Constants.fcmToken, fcmToken.toString());
//
//     prefs.commit();
//   }
//
//   Future<AuthToken> getAuthToken() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String token = prefs.getString("token")!;
//     String expiryToken = prefs.getString("expiration")!;
//     String refreshToken = prefs.getString("refresh_token")!;
//
//     return AuthToken(
//         token: token, expiration: expiryToken, refreshToken: refreshToken);
//   }
//
//
//
//
//
//
// }
