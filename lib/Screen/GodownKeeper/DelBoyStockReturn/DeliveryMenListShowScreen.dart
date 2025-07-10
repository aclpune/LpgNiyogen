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
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/shared_preference.dart';
import '../BottomNavigationForGodownKeeper.dart';
import '../DashboardScreen.dart';
import '../DeliveryBoyModel/DeliveryBoyInfoModel.dart';
import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
import 'DeliveryMenListShowScreenItemUI.dart';
import 'package:http/http.dart' as http;
class DeliveryMenListShowScreen extends StatefulWidget {
  static const screenName = '/deliveryMenListShowScreen';
  const DeliveryMenListShowScreen({super.key});

  @override
  State<DeliveryMenListShowScreen> createState() => _DeliveryMenListShowScreenState();
}

class _DeliveryMenListShowScreenState extends State<DeliveryMenListShowScreen> {
  List<DeliveryMenSaleListModel> _delBoyInfo = [];
  bool isLoading = true;
  String? mobileNo;
  List<DeliveryMenSaleListModel> _filteredDelBoyInfo = [];
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDeliveryBoyInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Trigger fetching of data whenever the screen is visited again
    fetchDeliveryBoyInfo();
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName,
              arguments: "onBack");
          return false;
        } else {
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName);
          return false;
        } // In case `null` is returned, return `false`
      },
        child:
      Scaffold(
        // appBar: CustomAppBar(
        //   title: 'Daily Sale', // Title or hint text for the text field
        // ),
        body:
        isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(  // Add SingleChildScrollView to make entire body scrollable
          child:
          Padding(
            padding: const EdgeInsets.only(left: 2.0,right: 2,top: 0),
            child:
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              margin: const EdgeInsets.only(left: 2, right: 2),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(height: 40,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) => filterSearchResults(value),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey ,
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(  // Explicitly align to the left
                            alignment: Alignment.centerLeft,  // Align to the left side
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Delivery Men',
                                style: Styling.itemGreyText,
                                textAlign: TextAlign.start,  // Align the text to the left within the container
                              ),
                            ),
                          ),
                        ),
                        verticalDividerVerySmall(),
                        Container(
                          width: 100,
                          child: Column(
                            children: [
                              Text(
                                'Total Sale',
                                style: Styling.itemGreyText,
                                textAlign: TextAlign.center,  // Center-align text in this container
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color(0xff1280B3),
                    height: 1.5,
                    width: MediaQuery.of(context).size.width,
                  ),
                  _filteredDelBoyInfo.isNotEmpty
                      ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _filteredDelBoyInfo.length,
                    itemBuilder: (context, index) {
                      return DeliveryMenListShowScreenItemUI(
                          _filteredDelBoyInfo[index]);
                    },
                  )
                      : Container(
                    child: Text(
                      "No Data Found..!",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  void filterSearchResults(String query) {
    setState(() {
      _filteredDelBoyInfo = _delBoyInfo
          .where((item) => item.staffName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

    Future<void> fetchDeliveryBoyInfo() async {
      Constants.isNetworkAvailable =
      await InternetConnectionChecker().hasConnection;
      if (Constants.isNetworkAvailable) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken =
        prefs.getString('token'); // Assuming the token is stored here

        if (bearerToken == null) {
          throw Exception('Bearer token is missing');
        }
          try{
        final response = await http.get(
          Uri.parse('${AppUrl.GetDeliveryBoyListForMob}/$distributorId/1/2'),
          headers: {
            'Authorization': 'Bearer $bearerToken', // Add Bearer token here
          },
        );
        debugPrint(
            "_delBoyInfo" + '${AppUrl.GetDeliveryBoyListForMob}/$distributorId/1/2');
        debugPrint("_delBoyInfo" + response.body);
        if (response.statusCode == 200) {
          // Parse the response
          List<dynamic> data = json.decode(response.body);
          setState(() {
            _delBoyInfo =
                data.map((json) => DeliveryMenSaleListModel.fromJson(json)).toList();
            _delBoyInfo.sort((a, b) => a.staffName!.toLowerCase().compareTo(b.staffName!.toLowerCase()));
            _filteredDelBoyInfo = List.from(_delBoyInfo); // Initialize the filtered list with all data

          });
          isLoading = false;
        } else {
          refreshTokens();
          isLoading = false;
          throw Exception(Constants.listGettingFail);
        }
          }catch(e){
            debugPrint("_delBoyInfo" + e.toString());
          }
      } else {
        isLoading = false;
        showFlushBar(
            context, Constants.connectionMessage);
      }
    }

  Future<void> refreshTokens() async {
    LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      mobileNo = preferences.getString('MobileNo').toString();

      final Future<Map<String, dynamic>> respose =
      auth.refreshToken(mobileNo!, context);

      try {
        respose.then((response) {
          EasyLoading.dismiss();
          if (response['status']) {
            debugPrint('RefreshTokenStatus - True');
            fetchDeliveryBoyInfo();
          } else if (response['message'] == "UnSuccessful") {
            debugPrint('RefreshTokenExc401 - true');

            showDialogToExpireSession(context);
          } else {
            debugPrint('RefreshTokenStatus - false');
          }
        }).catchError((error) {
          EasyLoading.dismiss();
          debugPrint('RefreshTokenError1: $error');
        });
      } on HttpException catch (error) {
        EasyLoading.dismiss();
        debugPrint('RefreshTokenHttpExc: $error');
      } catch (error) {
        EasyLoading.dismiss();
        debugPrint('RefreshTokenError2: $error');
      }
    } catch (error) {
      EasyLoading.dismiss();
      debugPrint('RefreshTokenError3: $error');
    }
  }

  showDialogToExpireSession(BuildContext context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "Expired";
        String message = "Your Session Is Expire. Click Ok To Login Again.";
        String btnLabel = "Ok";
        return Platform.isIOS
            ? WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: CupertinoAlertDialog(
            title: Text(
              title,
              style: Styling.bodyTitle,
            ),
            content: Text(
              message,
              style: Styling.bodyTitle,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  btnLabel,
                  style: Styling.blueClrText,
                ),
                onPressed: () {},
              ),
            ],
          ),
        )
            : WillPopScope(
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(btnLabel),
                onPressed: () => logoutUser(context),
              ),
            ],
          ),
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
        );
      },
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    ///Save data before logout logic
    EasyLoading.show(status: 'Loading...');

    try {
      SharedPref().removeUser();

      // try {
      //   if (Platform.isAndroid) {
      //     await FirebaseMessaging.instance
      //         .deleteToken()
      //         .whenComplete(() => debugPrint("Android FCM Token Deleted"));
      //   } else if (Platform.isIOS) {
      //     await FirebaseMessaging.instance
      //         .deleteToken()
      //         .whenComplete(() => debugPrint("iOS FCM Token Deleted"));
      //   }
      // } on PlatformException {
      //   debugPrint('###PlatformExc');
      // }

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
