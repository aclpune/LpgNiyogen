import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/CustomeAlertDialog.dart';
import '../../Utils/Widget.dart';
import '../../Utils/constants.dart';
import '../DeliveryBoyModel/DeliveryBoyInfoModel.dart';
import 'package:http/http.dart' as http;

import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
import '../DeliveryBoyModel/GetStockTransferListModel.dart';
import 'StockReturnFromDelBoy.dart';

class DeliveryMenListShowScreenItemUI extends StatefulWidget {
  DeliveryMenSaleListModel _listModel;

  DeliveryMenListShowScreenItemUI(this._listModel,{Key? key}) : super(key: key);

  @override
  State<DeliveryMenListShowScreenItemUI> createState() => _DeliveryMenListShowScreenItemUIState();
}

class _DeliveryMenListShowScreenItemUIState extends State<DeliveryMenListShowScreenItemUI> {
  bool isListViewVisible = false; // Tracks if ListView is visible
  bool isLoading = true;
  bool saveFlag = false;
  bool stockTransferFlag = false;
  List<GetStockTransferListModel> _stockTransferList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchTransactionList();
  }
  @override
  Widget build(BuildContext context) {
    var value = widget._listModel;
    return
      value != null && value != ""?
      SingleChildScrollView(  // Make the Column scrollable
        child:
        Card(
          margin: EdgeInsets.all(5),
          color: Color(0xFFEFFFFfff),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0))),
          child:
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0.0,bottom: 0),
                child: Column(
                  children: [
                    // Container(
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       Expanded(
                    //         flex: 1,
                    //         child:
                    //         CircleAvatar(
                    //           radius: 15,
                    //           backgroundColor: const Color(0xff1280B3),
                    //           child: Text(
                    //             value.staffName != null && value.staffName!.isNotEmpty
                    //                 ? value.staffName![0].toUpperCase()
                    //                 : "",
                    //             style: const TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 12,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         flex: 1,
                    //         child:
                    //         GestureDetector(
                    //           onTap: (){
                    //             // if(stockTransferFlag){
                    //             //   if(saveFlag){
                    //             //     showFlushBar(context,
                    //             //         Constants.dayEndCompleted);
                    //             //   }else{
                    //                 Navigator.pushNamed(
                    //                     context,
                    //                     DailyRefillSalePage
                    //                         .screenName,
                    //                     arguments: {
                    //                       "delBoyName": value.staffName,
                    //                       "delBoyID" : value.dMId,
                    //                       "vehicleNo" :value.vehicleNo,
                    //                     });
                    //               // }
                    //             // }else{
                    //             //   CustomAlertDialog.showCustomAlert(context,Constants.stockNotAccepted);
                    //             // }
                    //           },
                    //           child: Padding(
                    //             padding: const EdgeInsets.only(left: 8.0),
                    //             child: Text(
                    //               value.staffName.toString(),
                    //               textAlign: TextAlign.left,
                    //               style:Styling.blueClrTextWithUnderline,
                    //               textScaler: TextScaler.noScaling,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       verticalDividerVerySmall(),
                    //       Container(
                    //         width: 100,
                    //         child: Column(
                    //           children: [
                    //             Text(
                    //               value.filledSaleQty.toString(),
                    //               style:Styling.textFormText,
                    //               textAlign: TextAlign.center,
                    //               textScaler: TextScaler.noScaling,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(
                                context,
                                DailyRefillSalePage
                                    .screenName,
                                arguments: {
                                  "delBoyName": value.staffName,
                                  "delBoyID" : value.dMId,
                                  "vehicleNo" :value.vehicleNo,
                                });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: const Color(0xFFfbe9e9),
                                child: Text(
                                  value.staffName != null && value.staffName!.isNotEmpty
                                      ? value.staffName![0].toUpperCase()
                                      : "",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // GestureDetector(
                                    //   onTap: (){
                                    //     // if(stockTransferFlag){
                                    //     //   if(saveFlag){
                                    //     //     showFlushBar(context,
                                    //     //         Constants.dayEndCompleted);
                                    //     //   }else{
                                    //     Navigator.pushNamed(
                                    //         context,
                                    //         DailyRefillSalePage
                                    //             .screenName,
                                    //         arguments: {
                                    //           "delBoyName": value.staffName,
                                    //           "delBoyID" : value.dMId,
                                    //           "vehicleNo" :value.vehicleNo,
                                    //         });
                                    //     // }
                                    //     // }else{
                                    //     //   CustomAlertDialog.showCustomAlert(context,Constants.stockNotAccepted);
                                    //     // }
                                    //   },
                                    //
                                    //     child:
                                    Text(
                                      value.staffName.toString(),
                                      textAlign: TextAlign.left,
                                      style:Styling.itemTitle,
                                      textScaler: TextScaler.noScaling,
                                    ),

                                    // ),
                                    SizedBox(height: 2,),
                                    Row(mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total Sale : ",
                                          style:Styling.textFormText,
                                          textAlign: TextAlign.start,
                                          textScaler: TextScaler.noScaling,
                                        ),
                                        Text(
                                          value.filledSaleQty.toString(),
                                          style:Styling.itemBlackTestBold,
                                          textAlign: TextAlign.start,
                                          textScaler: TextScaler.noScaling,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Spacer(),
                              Icon(Icons.arrow_forward_ios_outlined,size: 15,),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),

      ):
      Container(
        child:  Text("No data found"),
      );
  }

  Future<void> fetchTransactionList() async {
    EasyLoading.show();
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
      int dId = int.parse(distributorId!);
      int gId = int.parse(godownId!);
      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );
      debugPrint(
          "GetStockTransferDtls" + '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
      debugPrint("GetStockTransferDtls" + response.body);
      if (response.statusCode == 200) {
        // Parse the response
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _stockTransferList = data.map((json) => GetStockTransferListModel.fromJson(json)).toList();
          bool hasZeroStkTrans = false;
          for (int i = 0; i < _stockTransferList.length; i++) {
            if (_stockTransferList[i].isStkTrans == 0) {
              hasZeroStkTrans = true;
              debugPrint("Found item with isStkTrans = 0");
              break; // No need to continue checking once we find an item with isStkTrans = 0
            }
          }
          if (hasZeroStkTrans) {
            stockTransferFlag = false; // Disable the button
            // showFlushBar(
            //     context, "Action Restricted", "Cannot perform the action as one or more items have isStkTrans = 0");
          } else {
            stockTransferFlag = true; // Enable the button
          }
        });
        isLoading = false;
        EasyLoading.dismiss();
      } else {
        isLoading = false;
        EasyLoading.dismiss();
        throw Exception('Failed To Load Items');
      }
    } else {
      isLoading = false;
      EasyLoading.dismiss();
      showFlushBar(
          context,Constants.connectionMessage);
    }
  }
}
