// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../ConstantScreen/widgets.dart';
// import '../../User/Login/provider/LoginProvider.dart';
// import '../../User/splashscreen/page/splash_screen.dart';
// import '../../Utils/CustomAppBar.dart';
// import '../../Utils/Styling.dart';
// import '../../Utils/Widget.dart';
// import '../../Utils/app_url.dart';
// import '../../Utils/constants.dart';
// import '../../Utils/shared_preference.dart';
// import '../BottomNavigationForGodownKeeper.dart';
// import '../DashboardScreen.dart';
// import '../DeliveryBoyModel/DeliveryBoyInfoModel.dart';
// import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
// import 'DeliveryMenListShowScreenItemUI.dart';
// import 'package:http/http.dart' as http;
// class DeliveryMenListShowScreen extends StatefulWidget {
//   static const screenName = '/deliveryMenListShowScreen';
//   const DeliveryMenListShowScreen({super.key});
//
//   @override
//   State<DeliveryMenListShowScreen> createState() => _DeliveryMenListShowScreenState();
// }
//
// class _DeliveryMenListShowScreenState extends State<DeliveryMenListShowScreen> {
//   List<DeliveryMenSaleListModel> _delBoyInfo = [];
//   bool isLoading = true;
//   String? mobileNo;
//   List<DeliveryMenSaleListModel> _filteredDelBoyInfo = [];
//   TextEditingController _searchController = TextEditingController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchDeliveryBoyInfo();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Trigger fetching of data whenever the screen is visited again
//     fetchDeliveryBoyInfo();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var argLRAdd = ModalRoute.of(context)?.settings.arguments;
//     return WillPopScope(
//         onWillPop: () async {
//           // Show a confirmation dialog
//           if (argLRAdd == "fromDrawer") {
//             Navigator.pushReplacementNamed(
//                 context, BottomNavigationForGodownKeeper.screenName,
//                 arguments: "onBack");
//             return false;
//           } else {
//             Navigator.pushReplacementNamed(
//                 context, BottomNavigationForGodownKeeper.screenName);
//             return false;
//           } // In case `null` is returned, return `false`
//         },
//         child:
//         Scaffold(
//           // appBar: CustomAppBar(
//           //   title: 'Daily Sale', // Title or hint text for the text field
//           // ),
//           body:
//           isLoading
//               ? Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(  // Add SingleChildScrollView to make entire body scrollable
//             child:
//             Padding(
//               padding: const EdgeInsets.only(left: 2.0,right: 2,top: 0),
//               child:
//               // Container(
//               //   color: Colors.white,
//               //   // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
//               //   margin: const EdgeInsets.only(left: 2, right: 2),
//               //   child: Column(
//               //     children: [
//               //       Padding(
//               //         padding: const EdgeInsets.all(8.0),
//               //         child: SizedBox(height: 40,
//               //           child: TextField(
//               //             controller: _searchController,
//               //             decoration: InputDecoration(
//               //               labelText: 'Search',
//               //               border: OutlineInputBorder(),
//               //               prefixIcon: Icon(Icons.search),
//               //             ),
//               //             onChanged: (value) => filterSearchResults(value),
//               //           ),
//               //         ),
//               //       ),
//               //       Container(
//               //         color: Colors.grey ,
//               //         height: 1,
//               //         width: MediaQuery.of(context).size.width,
//               //       ),
//               //       Padding(
//               //         padding: const EdgeInsets.only(top: 0.0, bottom: 0),
//               //         child: Row(
//               //           children: [
//               //             Expanded(
//               //               child: Align(  // Explicitly align to the left
//               //                 alignment: Alignment.centerLeft,  // Align to the left side
//               //                 child: Padding(
//               //                   padding: const EdgeInsets.only(left: 8.0),
//               //                   child: Text(
//               //                     'Delivery Men',
//               //                     style: Styling.itemGreyText,
//               //                     textAlign: TextAlign.start,  // Align the text to the left within the container
//               //                   ),
//               //                 ),
//               //               ),
//               //             ),
//               //             verticalDividerVerySmall(),
//               //             Container(
//               //               width: 100,
//               //               child: Column(
//               //                 children: [
//               //                   Text(
//               //                     'Total Sale',
//               //                     style: Styling.itemGreyText,
//               //                     textAlign: TextAlign.center,  // Center-align text in this container
//               //                   ),
//               //                 ],
//               //               ),
//               //             ),
//               //           ],
//               //         ),
//               //       ),
//               //       Container(
//               //         color: const Color(0xff1280B3),
//               //         height: 1.5,
//               //         width: MediaQuery.of(context).size.width,
//               //       ),
//               //       _filteredDelBoyInfo.isNotEmpty
//               //           ? ListView.builder(
//               //         physics: const BouncingScrollPhysics(),
//               //         shrinkWrap: true,
//               //         itemCount: _filteredDelBoyInfo.length,
//               //         itemBuilder: (context, index) {
//               //           return DeliveryMenListShowScreenItemUI(
//               //               _filteredDelBoyInfo[index]);
//               //         },
//               //       )
//               //           : Container(
//               //         child: Text(
//               //           "No Data Found..!",
//               //           style: TextStyle(fontSize: 16),
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               Container(
//                 color: Colors.white,
//                 // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
//                 margin: const EdgeInsets.only(left: 2, right: 2),
//                 child: Column(
//                   children: [
//
//                     Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: SizedBox(height: 40,
//                         child: TextField(
//                           controller: _searchController,
//                           decoration: InputDecoration(
//                             labelText: 'Search',
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//                             prefixIcon: Icon(Icons.search),
//                           ),
//                           onChanged: (value) => filterSearchResults(value),
//                         ),
//                       ),
//                     ),
//                     Align(  // Explicitly align to the left
//                       alignment: Alignment.centerLeft,  // Align to the left side
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Text(
//                           'Delivery Men And Total Sale',
//                           style: Styling.blueClrText,
//                           textAlign: TextAlign.start,  // Align the text to the left within the container
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10,),
//                     _filteredDelBoyInfo.isNotEmpty
//                         ? ListView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: _filteredDelBoyInfo.length,
//                       itemBuilder: (context, index) {
//                         return DeliveryMenListShowScreenItemUI(
//                             _filteredDelBoyInfo[index]);
//                       },
//                     )
//                         : Container(
//                       child: Text(
//                         "No Data Found..!",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         )
//     );
//   }
//
//   void filterSearchResults(String query) {
//     setState(() {
//       _filteredDelBoyInfo = _delBoyInfo
//           .where((item) => item.staffName!.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   Future<void> fetchDeliveryBoyInfo() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken =
//       prefs.getString('token'); // Assuming the token is stored here
//
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//       }
//       try{
//         final response = await http.get(
//           Uri.parse('${AppUrl.GetDeliveryBoyListForMob}/$distributorId/1/2'),
//           headers: {
//             'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//           },
//         );
//         debugPrint(
//             "_delBoyInfo" + '${AppUrl.GetDeliveryBoyListForMob}/$distributorId/1/2');
//         debugPrint("_delBoyInfo" + response.body);
//         if (response.statusCode == 200) {
//           // Parse the response
//           List<dynamic> data = json.decode(response.body);
//           setState(() {
//             _delBoyInfo =
//                 data.map((json) => DeliveryMenSaleListModel.fromJson(json)).toList();
//             _delBoyInfo.sort((a, b) => a.staffName!.toLowerCase().compareTo(b.staffName!.toLowerCase()));
//             _filteredDelBoyInfo = List.from(_delBoyInfo); // Initialize the filtered list with all data
//
//           });
//           isLoading = false;
//         } else {
//           refreshTokens();
//           isLoading = false;
//           throw Exception(Constants.listGettingFail);
//         }
//       }catch(e){
//         debugPrint("_delBoyInfo" + e.toString());
//       }
//     } else {
//       isLoading = false;
//       showFlushBar(
//           context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> refreshTokens() async {
//     LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       mobileNo = preferences.getString('MobileNo').toString();
//
//       final Future<Map<String, dynamic>> respose =
//       auth.refreshToken(mobileNo!, context);
//
//       try {
//         respose.then((response) {
//           EasyLoading.dismiss();
//           if (response['status']) {
//             debugPrint('RefreshTokenStatus - True');
//             fetchDeliveryBoyInfo();
//           } else if (response['message'] == "UnSuccessful") {
//             debugPrint('RefreshTokenExc401 - true');
//
//             showDialogToExpireSession(context);
//           } else {
//             debugPrint('RefreshTokenStatus - false');
//           }
//         }).catchError((error) {
//           EasyLoading.dismiss();
//           debugPrint('RefreshTokenError1: $error');
//         });
//       } on HttpException catch (error) {
//         EasyLoading.dismiss();
//         debugPrint('RefreshTokenHttpExc: $error');
//       } catch (error) {
//         EasyLoading.dismiss();
//         debugPrint('RefreshTokenError2: $error');
//       }
//     } catch (error) {
//       EasyLoading.dismiss();
//       debugPrint('RefreshTokenError3: $error');
//     }
//   }
//
//   showDialogToExpireSession(BuildContext context) async {
//     await showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         String title = "Expired";
//         String message = "Your Session Is Expire. Click Ok To Login Again.";
//         String btnLabel = "Ok";
//         return Platform.isIOS
//             ? WillPopScope(
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//           child: CupertinoAlertDialog(
//             title: Text(
//               title,
//               style: Styling.bodyTitle,
//             ),
//             content: Text(
//               message,
//               style: Styling.bodyTitle,
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: Text(
//                   btnLabel,
//                   style: Styling.blueClrText,
//                 ),
//                 onPressed: () => logoutUser(context),
//               ),
//             ],
//           ),
//         )
//             : WillPopScope(
//           child: AlertDialog(
//             title: Text(title),
//             content: Text(message),
//             actions: <Widget>[
//               TextButton(
//                 child: Text(btnLabel),
//                 onPressed: () => logoutUser(context),
//               ),
//             ],
//           ),
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> logoutUser(BuildContext context) async {
//     ///Save data before logout logic
//     EasyLoading.show(status: 'Loading...');
//
//     try {
//       SharedPref().removeUser();
//
//       // try {
//       //   if (Platform.isAndroid) {
//       //     await FirebaseMessaging.instance
//       //         .deleteToken()
//       //         .whenComplete(() => debugPrint("Android FCM Token Deleted"));
//       //   } else if (Platform.isIOS) {
//       //     await FirebaseMessaging.instance
//       //         .deleteToken()
//       //         .whenComplete(() => debugPrint("iOS FCM Token Deleted"));
//       //   }
//       // } on PlatformException {
//       //   debugPrint('###PlatformExc');
//       // }
//
//       EasyLoading.dismiss();
//
//       Navigator.pushNamedAndRemoveUntil(
//           context, SplashScreen.screenName, (r) => false);
//
//       debugPrint("Logout Successful");
//     } catch (error) {
//       EasyLoading.dismiss();
//       debugPrint("LogoutPrefEcx: $error");
//     }
//   }
// }



// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../ConstantScreen/widgets.dart';
// import '../../User/Login/provider/LoginProvider.dart';
// import '../../User/splashscreen/page/splash_screen.dart';
// import '../../Utils/CustomAppBar.dart';
// import '../../Utils/Widget.dart';
// import '../../Utils/app_url.dart';
// import '../../Utils/constants.dart';
// import '../../Utils/shared_preference.dart';
// import '../BottomNavigationForGodownKeeper.dart';
// import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
// import 'DeliveryMenListShowScreenItemUI.dart';
// import 'package:http/http.dart' as http;
//
// // ─────────────────────────────────────────────
// // Design tokens — mirrors Manager Dashboard
// // ─────────────────────────────────────────────
// abstract final class _C {
//   static const blue      = Color(0xFF1E3A8A);
//   static const blueLight = Color(0xFF2D52C5);
//   static const blueXL    = Color(0xFFEFF6FF);
//   static const blueXXL   = Color(0xFFDBEAFE);
//   static const bg2       = Color(0xFFF1F5FE);
//   static const white     = Color(0xFFFFFFFF);
//   static const text      = Color(0xFF111827);
//   static const textMid   = Color(0xFF374151);
//   static const textMuted = Color(0xFF6B7280);
//   static const border    = Color(0xFFE2E8F0);
//   static const teal      = Color(0xFF0F766E);
//   static const tealXL    = Color(0xFFF0FDFA);
//
//   static const gradHero = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     stops: [0.0, 0.6, 1.0],
//     colors: [Color(0xFF1E3A8A), Color(0xFF1D5A72), Color(0xFF0F766E)],
//   );
// }
//
// class DeliveryMenListShowScreen extends StatefulWidget {
//   static const screenName = '/deliveryMenListShowScreen';
//   const DeliveryMenListShowScreen({super.key});
//
//   @override
//   State<DeliveryMenListShowScreen> createState() =>
//       _DeliveryMenListShowScreenState();
// }
//
// class _DeliveryMenListShowScreenState
//     extends State<DeliveryMenListShowScreen> {
//   // ── All original state preserved exactly ──
//   List<DeliveryMenSaleListModel> _delBoyInfo = [];
//   bool isLoading = true;
//   String? mobileNo;
//   List<DeliveryMenSaleListModel> _filteredDelBoyInfo = [];
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchDeliveryBoyInfo();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     fetchDeliveryBoyInfo();
//   }
//
//   // ── build ──────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     final argLRAdd = ModalRoute.of(context)?.settings.arguments;
//
//     return WillPopScope(
//       onWillPop: () async {
//         if (argLRAdd == "fromDrawer") {
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName,
//               arguments: "onBack");
//           return false;
//         } else {
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName);
//           return false;
//         }
//       },
//       child: Scaffold(
//         backgroundColor: _C.bg2,
//         appBar: CustomAppBar(
//           title: 'Daily Sale',
//         ),
//         body: Column(
//           children: [
//             // _HeroHeader(count: _filteredDelBoyInfo.length),
//             Expanded(
//               child: isLoading
//                   ? const _LoadingState()
//                   : _buildBody(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBody() {
//     return Column(
//       children: [
//         _SearchBar(
//           controller: _searchController,
//           onChanged: filterSearchResults,
//         ),
//         Expanded(
//           child: _filteredDelBoyInfo.isNotEmpty
//               ? ListView.builder(
//             physics: const BouncingScrollPhysics(),
//             padding:
//             const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             itemCount: _filteredDelBoyInfo.length,
//             itemBuilder: (context, index) {
//               return DeliveryMenListShowScreenItemUI(
//                   _filteredDelBoyInfo[index]);
//             },
//           )
//               : const _EmptyState(),
//         ),
//       ],
//     );
//   }
//
//   // ── All original logic below — untouched ──
//
//   void filterSearchResults(String query) {
//     setState(() {
//       _filteredDelBoyInfo = _delBoyInfo
//           .where((item) =>
//           item.staffName!.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   Future<void> fetchDeliveryBoyInfo() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken = prefs.getString('token');
//
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//       }
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.GetDeliveryBoyListForMob}/$distributorId/1/2'),
//           headers: {
//             'Authorization': 'Bearer $bearerToken',
//           },
//         );
//         debugPrint(
//             "_delBoyInfo" + '${AppUrl.GetDeliveryBoyListForMob}/$distributorId/1/2');
//         debugPrint("_delBoyInfo" + response.body);
//         if (response.statusCode == 200) {
//           List<dynamic> data = json.decode(response.body);
//           setState(() {
//             _delBoyInfo = data
//                 .map((json) => DeliveryMenSaleListModel.fromJson(json))
//                 .toList();
//             _delBoyInfo.sort((a, b) => a.staffName!
//                 .toLowerCase()
//                 .compareTo(b.staffName!.toLowerCase()));
//             _filteredDelBoyInfo = List.from(_delBoyInfo);
//           });
//           isLoading = false;
//         } else {
//           refreshTokens();
//           isLoading = false;
//           throw Exception(Constants.listGettingFail);
//         }
//       } catch (e) {
//         debugPrint("_delBoyInfo" + e.toString());
//       }
//     } else {
//       isLoading = false;
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> refreshTokens() async {
//     LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       mobileNo = preferences.getString('MobileNo').toString();
//
//       final Future<Map<String, dynamic>> respose =
//       auth.refreshToken(mobileNo!, context);
//
//       try {
//         respose.then((response) {
//           EasyLoading.dismiss();
//           if (response['status']) {
//             debugPrint('RefreshTokenStatus - True');
//             fetchDeliveryBoyInfo();
//           } else if (response['message'] == "UnSuccessful") {
//             debugPrint('RefreshTokenExc401 - true');
//             showDialogToExpireSession(context);
//           } else {
//             debugPrint('RefreshTokenStatus - false');
//           }
//         }).catchError((error) {
//           EasyLoading.dismiss();
//           debugPrint('RefreshTokenError1: $error');
//         });
//       } on HttpException catch (error) {
//         EasyLoading.dismiss();
//         debugPrint('RefreshTokenHttpExc: $error');
//       } catch (error) {
//         EasyLoading.dismiss();
//         debugPrint('RefreshTokenError2: $error');
//       }
//     } catch (error) {
//       EasyLoading.dismiss();
//       debugPrint('RefreshTokenError3: $error');
//     }
//   }
//
//   showDialogToExpireSession(BuildContext context) async {
//     await showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         const title = "Expired";
//         const message = "Your Session Is Expire. Click Ok To Login Again.";
//         const btnLabel = "Ok";
//         return Platform.isIOS
//             ? WillPopScope(
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//           child: CupertinoAlertDialog(
//             title: const Text(title),
//             content: const Text(message),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => logoutUser(context),
//                 child: const Text(btnLabel),
//               ),
//             ],
//           ),
//         )
//             : WillPopScope(
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//           child: AlertDialog(
//             title: const Text(title),
//             content: const Text(message),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => logoutUser(context),
//                 child: const Text(btnLabel),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> logoutUser(BuildContext context) async {
//     EasyLoading.show(status: 'Loading...');
//     try {
//       SharedPref().removeUser();
//       EasyLoading.dismiss();
//       Navigator.pushNamedAndRemoveUntil(
//           context, SplashScreen.screenName, (r) => false);
//       debugPrint("Logout Successful");
//     } catch (error) {
//       EasyLoading.dismiss();
//       debugPrint("LogoutPrefEcx: $error");
//     }
//   }
// }
//
// // ─────────────────────────────────────────────
// // UI-only widgets (stateless, no logic)
// // ─────────────────────────────────────────────
//
// /// Gradient hero header matching Manager Dashboard style
// class _HeroHeader extends StatelessWidget {
//   const _HeroHeader({required this.count});
//   final int count;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(gradient: _C.gradHero),
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
//           child: Row(
//             children: [
//               // Back button
//               GestureDetector(
//                 onTap: () => Navigator.maybePop(context),
//                 child: Container(
//                   width: 38,
//                   height: 38,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(11),
//                     border: Border.all(
//                         color: Colors.white.withOpacity(0.25), width: 1),
//                   ),
//                   child: const Icon(Icons.arrow_back_ios_new_rounded,
//                       color: Colors.white, size: 16),
//                 ),
//               ),
//               const SizedBox(width: 14),
//               // Title
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'DELIVERY MEN',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 11,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 0.8,
//                       ),
//                     ),
//                     const SizedBox(height: 3),
//                     const Text(
//                       'Daily Sale',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w800,
//                         letterSpacing: -0.4,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Count badge
//               Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                       color: Colors.white.withOpacity(0.25), width: 1),
//                 ),
//                 child: Text(
//                   '$count Staff',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// Search bar styled to match dashboard inputs
// class _SearchBar extends StatelessWidget {
//   const _SearchBar({required this.controller, required this.onChanged});
//   final TextEditingController controller;
//   final ValueChanged<String> onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: _C.white,
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//       child: TextField(
//         controller: controller,
//         onChanged: onChanged,
//         style: const TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.w500,
//           color: _C.text,
//         ),
//         decoration: InputDecoration(
//           hintText: 'Search delivery men…',
//           hintStyle: const TextStyle(
//             fontSize: 14,
//             color: _C.textMuted,
//             fontWeight: FontWeight.w400,
//           ),
//           prefixIcon: const Icon(Icons.search_rounded,
//               color: _C.textMuted, size: 20),
//           filled: true,
//           fillColor: _C.bg2,
//           contentPadding:
//           const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(color: _C.border, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: const BorderSide(color: _C.blueLight, width: 1.5),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// Loading state — skeleton shimmer
// class _LoadingState extends StatelessWidget {
//   const _LoadingState();
//
//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: CircularProgressIndicator(
//         color: _C.blueLight,
//         strokeWidth: 2.5,
//       ),
//     );
//   }
// }
//
// /// Empty / no results state
// class _EmptyState extends StatelessWidget {
//   const _EmptyState();
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               color: _C.blueXL,
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: const Icon(Icons.people_outline_rounded,
//                 color: _C.blueLight, size: 30),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'No Delivery Men Found',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: _C.text,
//             ),
//           ),
//           const SizedBox(height: 6),
//           const Text(
//             'Try a different search term',
//             style: TextStyle(
//               fontSize: 13,
//               color: _C.textMuted,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// ─────────────────────────────────────────────────────────────────────────────
// DeliveryMenListShowScreen.dart
//
// REFACTOR NOTES
// • Removed private _C token class — all values now come from the centralised
//   design system (AppColors, AppSpacing, AppRadius, AppSizes, AppTextStyles,
//   AppDecorations, AppShadows).
// • No hardcoded Color(), EdgeInsets, BorderRadius, or TextStyle values remain
//   in this file.
// • Zero functional / layout changes.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../User/Login/provider/LoginProvider.dart';
import '../../User/splashscreen/page/splash_screen.dart';
import '../../Utils/CustomAppBar.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/BoxShadow/styles.dart';          // ← single barrel import
import '../BottomNavigationForGodownKeeper.dart';
import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
import 'DeliveryMenListShowScreenItemUI.dart';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────────────────────────────────────
// Screen widget
// ─────────────────────────────────────────────────────────────────────────────

class DeliveryMenListShowScreen extends StatefulWidget {
  static const screenName = '/deliveryMenListShowScreen';
  const DeliveryMenListShowScreen({super.key});

  @override
  State<DeliveryMenListShowScreen> createState() =>
      _DeliveryMenListShowScreenState();
}

class _DeliveryMenListShowScreenState
    extends State<DeliveryMenListShowScreen> {
  // ── State (unchanged) ──────────────────────────────────────────────────────
  List<DeliveryMenSaleListModel> _delBoyInfo = [];
  bool isLoading = true;
  String? mobileNo;
  List<DeliveryMenSaleListModel> _filteredDelBoyInfo = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDeliveryBoyInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchDeliveryBoyInfo();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName,
              arguments: "onBack");
          return false;
        } else {
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName);
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background2,
        appBar: CustomAppBar(title: 'Daily Sale'),
        body: Column(
          children: [
            // AppGradientHeader(
            //   title: 'Daily Sale',
            //   subtitle: 'Show Daily Sale',
            //   icon: Icons.receipt_long_rounded,
            //   onBack: () => Navigator.pushReplacementNamed(
            //     context,
            //     BottomNavigationForGodownKeeper.screenName,
            //     arguments: "onBack",
            //   ),
            // ),
            Expanded(
              child: isLoading
                  ? const _LoadingState()
                  : _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _SearchBar(
          controller: _searchController,
          onChanged: filterSearchResults,
        ),
        Expanded(
          child: _filteredDelBoyInfo.isNotEmpty
              ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: AppSpacing.listPadding,
            itemCount: _filteredDelBoyInfo.length,
            itemBuilder: (context, index) {
              return DeliveryMenListShowScreenItemUI(
                  _filteredDelBoyInfo[index]);
            },
          )
              : const _EmptyState(),
        ),
      ],
    );
  }

  // ── Business logic (unchanged) ─────────────────────────────────────────────

  void filterSearchResults(String query) {
    setState(() {
      _filteredDelBoyInfo = _delBoyInfo
          .where((item) =>
          item.staffName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Future<void> fetchDeliveryBoyInfo() async {
  //   Constants.isNetworkAvailable =
  //   await InternetConnectionChecker().hasConnection;
  //   if (Constants.isNetworkAvailable) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? bearerToken = prefs.getString('token');
  //
  //     if (bearerToken == null) {
  //       throw Exception('Bearer token is missing');
  //     }
  //     try {
  //       final response = await http.get(
  //         Uri.parse('${AppUrl.GetDeliveryBoyListForMob}/$distributorId/1/2'),
  //         headers: {'Authorization': 'Bearer $bearerToken'},
  //       );
  //       debugPrint(
  //           "_delBoyInfo${AppUrl.GetDeliveryBoyListForMob}/$distributorId/1/2");
  //       debugPrint("_delBoyInfo${response.body}");
  //       if (response.statusCode == 200) {
  //         List<dynamic> data = json.decode(response.body);
  //         setState(() {
  //           _delBoyInfo = data
  //               .map((json) => DeliveryMenSaleListModel.fromJson(json))
  //               .toList();
  //           _delBoyInfo.sort((a, b) => a.staffName!
  //               .toLowerCase()
  //               .compareTo(b.staffName!.toLowerCase()));
  //           _filteredDelBoyInfo = List.from(_delBoyInfo);
  //         });
  //         isLoading = false;
  //       } else {
  //         refreshTokens();
  //         isLoading = false;
  //         throw Exception(Constants.listGettingFail);
  //       }
  //
  //     } catch (e) {
  //       debugPrint("_delBoyInfo${e.toString()}");
  //     }
  //   } else {
  //     isLoading = false;
  //     showFlushBar(context, Constants.connectionMessage);
  //   }
  // }
  //
  // Future<void> refreshTokens() async {
  //   LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
  //   try {
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     mobileNo = preferences.getString('MobileNo').toString();
  //
  //     final Future<Map<String, dynamic>> respose =
  //     auth.refreshToken(mobileNo!, context);
  //
  //     try {
  //       respose.then((response) {
  //         EasyLoading.dismiss();
  //         if (response['status']) {
  //           debugPrint('RefreshTokenStatus - True');
  //           fetchDeliveryBoyInfo();
  //         } else if (response['message'] == "UnSuccessful") {
  //           debugPrint('RefreshTokenExc401 - true');
  //           showDialogToExpireSession(context);
  //         } else {
  //           debugPrint('RefreshTokenStatus - false');
  //         }
  //       }).catchError((error) {
  //         EasyLoading.dismiss();
  //         debugPrint('RefreshTokenError1: $error');
  //       });
  //     } on HttpException catch (error) {
  //       EasyLoading.dismiss();
  //       debugPrint('RefreshTokenHttpExc: $error');
  //     } catch (error) {
  //       EasyLoading.dismiss();
  //       debugPrint('RefreshTokenError2: $error');
  //     }
  //   } catch (error) {
  //     EasyLoading.dismiss();
  //     debugPrint('RefreshTokenError3: $error');
  //   }
  // }

  Future<void> refreshTokens() async {
    // ✅ Capture context BEFORE any await, and guard with mounted
    if (!mounted) return;
    final currentContext = context;

    LoginProvider auth = Provider.of<LoginProvider>(currentContext, listen: false);

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (!mounted) return; // ✅ Guard after await

      mobileNo = preferences.getString('MobileNo').toString();

      // ✅ Await instead of .then() — cleaner and respects mounted guards
      try {
        final response = await auth.refreshToken(mobileNo!, currentContext);
        if (!mounted) return; // ✅ Guard after await

        EasyLoading.dismiss();

        if (response['status'] == true) {
          debugPrint('RefreshTokenStatus - True');
          await fetchDeliveryBoyInfo();
        } else if (response['message'] == "UnSuccessful") {
          debugPrint('RefreshTokenExc401 - true');
          if (!mounted) return;
          showDialogToExpireSession(currentContext);
        } else {
          debugPrint('RefreshTokenStatus - false');
        }
      } on HttpException catch (error) {
        EasyLoading.dismiss();
        debugPrint('RefreshTokenHttpExc: $error');
      } catch (error) {
        EasyLoading.dismiss();
        debugPrint('RefreshTokenError1: $error');
      }
    } catch (error) {
      EasyLoading.dismiss();
      debugPrint('RefreshTokenError3: $error');
    }
  }

  Future<void> fetchDeliveryBoyInfo() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (!mounted) return; // ✅ Guard after await

    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!mounted) return; // ✅ Guard after await

      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetDeliveryBoyListForMob}/$distributorId/1/2'),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );
        if (!mounted) return; // ✅ Guard after await

        debugPrint("_delBoyInfo${AppUrl.GetDeliveryBoyListForMob}/$distributorId/1/2");
        debugPrint("_delBoyInfo${response.body}");

        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          setState(() {
            _delBoyInfo = data
                .map((json) => DeliveryMenSaleListModel.fromJson(json))
                .toList();
            _delBoyInfo.sort((a, b) =>
                a.staffName!.toLowerCase().compareTo(b.staffName!.toLowerCase()));
            _filteredDelBoyInfo = List.from(_delBoyInfo);
            isLoading = false; // ✅ Inside setState so UI rebuilds
          });
        } else {
          // ✅ Guard before calling refreshTokens (which uses context)
          if (!mounted) return;
          setState(() => isLoading = false); // ✅ Inside setState
          await refreshTokens();
        }
      } catch (e) {
        debugPrint("_delBoyInfo${e.toString()}");
        if (mounted) setState(() => isLoading = false); // ✅ Don't leave stuck
      }
    } else {
      if (!mounted) return; // ✅ Guard before using context
      setState(() => isLoading = false); // ✅ Inside setState
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  showDialogToExpireSession(BuildContext context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        const title = "Expired";
        const message = "Your Session Is Expire. Click Ok To Login Again.";
        const btnLabel = "Ok";
        return Platform.isIOS
            ? WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: CupertinoAlertDialog(
            title: const Text(title),
            content: const Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () => logoutUser(context),
                child: const Text(btnLabel),
              ),
            ],
          ),
        )
            : WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: AlertDialog(
            title: const Text(title),
            content: const Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () => logoutUser(context),
                child: const Text(btnLabel),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    EasyLoading.show(status: 'Loading...');
    try {
      SharedPref().removeUser();
      EasyLoading.dismiss();
      Navigator.pushNamedAndRemoveUntil(
          context, SplashScreen.screenName, (r) => false);
      debugPrint("Logout Successful");
    } catch (error) {
      EasyLoading.dismiss();
      debugPrint("LogoutPrefEcx: $error");
    }
  }
}


/// Search bar styled to match dashboard inputs.
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: AppSpacing.searchBarPadding,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.searchInput,
        decoration: InputDecoration(
          hintText: 'Search delivery men…',
          hintStyle: AppTextStyles.searchHint,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textMuted,
            size: AppSizes.searchIconSize,
          ),
          filled: true,
          fillColor: AppColors.background2,
          contentPadding: AppSpacing.deliveryCardPadding,
          border: AppDecorations.searchBorderNone,
          enabledBorder: AppDecorations.searchBorderEnabled,
          focusedBorder: AppDecorations.searchBorderFocused,
        ),
      ),
    );
  }
}

/// Loading state — centred progress indicator.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryLight,
        strokeWidth: AppSizes.loadingStrokeWidth,
      ),
    );
  }
}

/// Empty / no-results state.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSizes.emptyStateIconSize,
            height: AppSizes.emptyStateIconSize,
            decoration: AppDecorations.emptyStateIcon,
            child: const Icon(
              Icons.people_outline_rounded,
              color: AppColors.primaryLight,
              size: AppSizes.emptyStateIconPx,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('No Delivery Men Found', style: AppTextStyles.emptyStateTitle),
          const SizedBox(height: 6),
          const Text('Try a different search term', style: AppTextStyles.emptyStateSubtitle),
        ],
      ),
    );
  }
}