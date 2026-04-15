import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/CustomeAlertDialog.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../DeliveryBoyModel/GetStockTransferListModel.dart';
import '../ItemReceipt/CylItemList/CylItemListModel.dart';
import 'ImabalanceEmptyListModel.dart';
import 'ImbalnceTransactionHistory.dart';
class ImbalanceSheet extends StatefulWidget {
  @override
  _ImbalanceSheetState createState() => _ImbalanceSheetState();
}

class _ImbalanceSheetState extends State<ImbalanceSheet> {

  String selectedType = "D";
  CylItemListModel? _selectedItemModel;
  List<CylItemListModel> _items = [];
  String? _selectedItem;
  int? selectedItemId;
  final TextEditingController _totalImbalanceQty = TextEditingController();
  final TextEditingController _totalImbalanceQtyDMCustomer = TextEditingController();
  final TextEditingController _totalImbalanceQtyCustomer = TextEditingController();

  List<ImabalanceEmptyListModel> deliveryListFiltered = [];
  List<ImabalanceEmptyListModel> customerListFiltered = [];
  List<ImabalanceEmptyListModel> receiptList = [];
  ImabalanceEmptyListModel? selectedDeliveryModel;
  ImabalanceEmptyListModel? selectedCustomerModel;
  String? _selectedDeliveryMenName;
  int? selectedDeliveryMenId;
  String? _selectedCustomerName;
  int? selectedCustomerId;
  bool saveFlag = false;
  bool stockTransferFlag = false;
  List<GetStockTransferListModel> _stockTransferList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchItems();
    _fetchImbalanceData();
    fetchTransactionList();
    checkAndSaveDayEndData();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ DELIVERY LIST
    final deliveryList = getUniqueDelivery();

    if (!deliveryList.any((e) => e.dMId == selectedDeliveryMenId)) {
      selectedDeliveryMenId = null;
    }

    // ✅ CUSTOMER LIST
    final customerList = getUniqueCustomer();

    if (!customerList.any((e) => e.dMId == selectedCustomerId)) {
      selectedCustomerId = null;
    }
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 4,
        right: 4,
        top: 20,
      ),
      child: SingleChildScrollView(
        child:
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Update Imbalance Stock",
                    style: Styling.bodyTitleBigBoldDashGrey,
                    textScaler: TextScaler.noScaling,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(
                          context,
                          ImbalnceTransactionHistory
                              .screenName,
                          arguments: {

                      });

                    },
                    child:  Row(
                      children: [
                        Text(
                              'Show History',
                              style: TextStyle(fontSize: 14,color: Colors.lightBlue,fontWeight: FontWeight.normal),
                              textAlign:TextAlign.center
                          ),
                        Icon(Icons.arrow_forward_outlined,size: 16,color: Colors.black,),
                      ],
                    ),

                  ),
                ],
              ),
            ),

            SizedBox(height: 5),

            Row(
              children: [
                Expanded(child: textWidgetBlueColorWithStar("Select Item","*")),
                Flexible(
                  flex: 1,
                  child:
                  DropdownButtonFormField<CylItemListModel>(
                    decoration: buildInputBorderUpdateStatus(
                        "Select Item", context),
                    value: _selectedItemModel,
                    // Bind the value to the selected item model
                    items: _items.map((CylItemListModel item) {
                      return DropdownMenuItem<CylItemListModel>(
                        value: item,
                        child: Text(
                          item.itemName ?? 'Unknown',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.normal),
                        ),
                      );
                    }).toList(),
                    onChanged: (CylItemListModel? selectedItem) {
                      if (selectedItem != null) {
                        setState(() {
                          _selectedItem = selectedItem.itemName;
                          selectedItemId = selectedItem.itemId!.toInt();

                          // Update the selectedItemModel when the selection changes
                          _selectedItemModel = selectedItem;
                          selectedDeliveryModel = null;
                          selectedCustomerModel = null;
                          selectedDeliveryMenId = null;   // ✅ THIS is required
                          _selectedDeliveryMenName = null;
                          _selectedCustomerName = null;
                          selectedCustomerId = null;
                          _totalImbalanceQtyDMCustomer.clear();
                          _totalImbalanceQty.clear();

                          print(
                              'Selected Item: ${_selectedItem}, ID: ${selectedItemId}');

                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 5),
            Row(
              children: [
                Expanded(child: textWidgetBlueColorWithStar("Total Sale","*")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _totalImbalanceQty,
                    decoration: buildInputBorderUpdateStatus(
                        "Enter Total Sale", context),
                    style: Styling.textFormText,
                    keyboardType: TextInputType.number,
                    // Set keyboard type to numeric
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                      // Allow only digits
                    ],
                    onChanged: (value) {
                      setState(() {
                        // Get the current value of the filled quantity
                        int filledQty = int.tryParse(value) ?? 0;

                      }
                      );
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 5),
            /// 🔘 RADIO: Delivery Man
            Row(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero, // ✅ remove extra padding
                    dense: true,
                    value: "D",
                    groupValue: selectedType,
                    title: Text("Delivery Men"),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
                        selectedDeliveryModel = null;
                        selectedCustomerModel = null;
                        selectedDeliveryMenId = null;   // ✅ THIS is required
                        _selectedDeliveryMenName = null;
                        _selectedCustomerName = null;
                        selectedCustomerId = null;
                        _totalImbalanceQtyDMCustomer.clear();
                      });
                    },
                  ),
                ),
                /// 🔘 RADIO: Customer
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero, // ✅ remove extra padding
                    dense: true,
                    value: "C",
                    groupValue: selectedType,
                    title: Text("Customer"),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
                        selectedDeliveryModel = null;
                        selectedCustomerModel = null;
                        selectedDeliveryMenId = null;   // ✅ THIS is required
                        _selectedDeliveryMenName = null;
                        _selectedCustomerName = null;
                        selectedCustomerId = null;
                        _totalImbalanceQtyDMCustomer.clear();

                      });
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 5),

                /// 👨‍✈️ DELIVERY UI
                if (selectedType == "D") ...[

                  Row(
                    children: [
                      Expanded(child: textWidgetBlueColorWithStar("Select Delivery Men","*")),

                      Flexible(
                        flex: 1,
                        child:
                        DropdownButtonFormField<int>(
                          value: selectedDeliveryMenId,
                          isExpanded: true,
                          items: deliveryList.map((e) {
                            return DropdownMenuItem<int>(
                              value:e.dMId!.toInt(),
                              child: Text(e.staffName.toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {

                              selectedDeliveryMenId = value;

                              final selectedObj = deliveryList
                                  .firstWhere((e) => e.dMId == value);

                              _selectedDeliveryMenName = selectedObj.staffName;

                              _setQtyForSelection(
                                type: "D",
                                id: value,
                              );
                            });
                          },
                        ),
                        // DropdownButtonFormField<ImabalanceEmptyListModel>(
                        //   decoration: buildInputBorderUpdateStatus(
                        //       "Delivery Men", context),
                        //   value: selectedDeliveryModel,
                        //   isExpanded: true,
                        //   // hint: Text("Select Delivery Men"),
                        //   items: getUniqueDelivery().map((e) {
                        //     return DropdownMenuItem(
                        //       value: e,
                        //       child: Text(e.staffName.toString()),
                        //     );
                        //   }).toList(),
                        //   onChanged: (value) {
                        //     setState(() {
                        //       selectedDeliveryModel = value;
                        //       _selectedDeliveryMenName = value?.staffName;
                        //       selectedDeliveryMenId = value?.dMId?.toInt();
                        //       _setQtyForSelection(
                        //         type: "D",
                        //         id: value?.dMId,
                        //       );
                        //     });
                        //   },
                        // ),
                      ),
                    ],
                  ),


                ],

                /// 👤 CUSTOMER UI
                if (selectedType == "C") ...[
                  Row(
                    children: [
                      Expanded(child: textWidgetBlueColorWithStar("Select Customer","*")),
                      Flexible(
                        flex: 1,
                        child:
                        DropdownButtonFormField<int>(
                          value: selectedCustomerId,
                          isExpanded: true,
                          items: customerList.map((e) {
                            return DropdownMenuItem<int>(
                              value: e.dMId!.toInt(),
                              child: Text(e.customerName.toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCustomerId = value;

                              final selectedObj = customerList
                                  .firstWhere((e) => e.dMId == value);

                              _selectedCustomerName = selectedObj.customerName;

                              _setQtyForSelection(
                                type: "C",
                                id: value,
                              );
                            });
                          },
                        ),
                        // DropdownButtonFormField<ImabalanceEmptyListModel>(
                        //   decoration: buildInputBorderUpdateStatus(
                        //       "Customer Name", context),
                        //   value: selectedCustomerModel,
                        //   isExpanded: true,
                        //   // hint: Text("Select Customer"),
                        //   items: getUniqueCustomer().map((e) {
                        //     return DropdownMenuItem(
                        //       value: e,
                        //       child: Text(e.customerName.toString()),
                        //     );
                        //   }).toList(),
                        //   onChanged: (value) {
                        //     setState(() {
                        //       selectedCustomerModel = value;
                        //       _selectedCustomerName = value?.customerName;
                        //       selectedCustomerId = value?.custId?.toInt();
                        //       _setQtyForSelection(
                        //         type: "C",
                        //         id: value?.custId,
                        //       );
                        //     });
                        //   },
                        // ),
                      ),
                    ],
                  ),
                  //
                  // SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Expanded(child: textWidgetBlueColorWithStar("Total Imbalance","*")),
                  //     Flexible(
                  //       flex: 1,
                  //       child: TextField(
                  //         controller: _totalImbalanceQtyCustomer,
                  //         decoration: buildInputBorderUpdateStatus(
                  //             "10", context),
                  //         style: Styling.textFormText,
                  //         keyboardType: TextInputType.number,
                  //         // Set keyboard type to numeric
                  //         inputFormatters: <TextInputFormatter>[
                  //           FilteringTextInputFormatter.digitsOnly,
                  //           LengthLimitingTextInputFormatter(3),
                  //           // Allow only digits
                  //         ],
                  //         onChanged: (value) {
                  //           setState(() {
                  //             // Get the current value of the filled quantity
                  //             int filledQty = int.tryParse(value) ?? 0;
                  //
                  //
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],

                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(child: textWidgetBlueColorWithStar("DM Total Imbalance","*")),
                    Flexible(
                      flex: 1,
                      child: TextField(
                        controller: _totalImbalanceQtyDMCustomer,
                        decoration: buildInputBorderUpdateStatus(
                            "0", context),
                        style: Styling.textFormText,
                        keyboardType: TextInputType.number,
                        enabled: false,
                        // Set keyboard type to numeric
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                          // Allow only digits
                        ],
                        onChanged: (value) {
                          setState(() {
                            // Get the current value of the filled quantity
                            int filledQty = int.tryParse(value) ?? 0;


                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 5),

              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    SizedBox(
                      height: 40, // Button Height
                      width: 90, // Button Width
                      child:
                      ElevatedButton(
                        onPressed: () {
                         Navigator.pop(context);
                        },
                        style: ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          Color(0xFFFFFFFFF),
                          // Button Color
                          // backgroundColor: Color(0xFFfbe9e9),   // Button Color
                          foregroundColor:
                          Colors.black,
                          // Text Color (simple way)
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(20),
                          ),
                          padding: EdgeInsets.zero,

                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    SizedBox(
                      height: 40, // Button Height
                      width: 90, // Button Width
                      child:
                      ElevatedButton(
                        onPressed: () {
                          if (saveFlag) {
                            showFlushBar(
                                context,
                                Constants
                                    .dayEndCompleted);
                          } else {
                            if(stockTransferFlag){
                              addItemImbalanceQty();
                            }else{
                              CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
                            }
                          }
                        },
                        style: ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          Color(0xFFfbe9e9),
                          // Button Color
                          // backgroundColor: Color(0xFFfbe9e9),   // Button Color
                          foregroundColor:
                          Colors.black,
                          // Text Color (simple way)
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(20),
                          ),
                          padding: EdgeInsets.zero,

                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Customer/Delivery Men Wise List",
                    style: Styling.bodyTitleBigBoldDashGrey,
                    textScaler: TextScaler.noScaling,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    // ✅ Header (fixed height)
                    Container(
                      color: Color(0xFFfcf2f1),
                      padding: const EdgeInsets.only(
                          bottom: 10.0, top: 10),
                      child: Row(
                        children: [
                          Expanded( flex:1,child: Text('Cylinder', style: Styling
                              .itemBlackTest,
                            textAlign: TextAlign.left,
                            textScaler: TextScaler.noScaling,)),
                          Expanded( flex:2,child: Text('Consumer/Delivery Men',    style: Styling
                              .itemBlackTest,
                            textAlign: TextAlign.left,
                            textScaler: TextScaler.noScaling,)),
                          Expanded( flex:1,child: Text('Imbalance Qty.',    style: Styling
                              .itemBlackTest,
                            textAlign: TextAlign.center,
                            textScaler: TextScaler.noScaling,)),
                        ],
                      ),
                    ),

                    // ✅ Scrollable List
                    // Expanded(
                    //   child: receiptList.isNotEmpty
                    //       ? ListView.builder(
                    //     itemCount: receiptList.length,
                    //     itemBuilder: (context, index) {
                    //       final items = receiptList[index];
                    //
                    //       return Padding(
                    //         padding: const EdgeInsets.only(top: 10.0,bottom: 10),
                    //         child: Row(
                    //           children: [
                    //
                    //             Expanded(
                    //               flex:1,
                    //               child: Text(
                    //                 items.itemName.toString(),
                    //                 textAlign: TextAlign.center,
                    //               ),
                    //             ),
                    //             Expanded(
                    //               flex:2,
                    //               child: Text(
                    //                 items.staffName == null ? items.customerName.toString():items.staffName.toString(),
                    //                 textAlign: TextAlign.center,
                    //               ),
                    //             ),
                    //             Expanded(
                    //               flex:1,
                    //               child: Text(
                    //                 items.balImbQty.toString(),
                    //                 textAlign: TextAlign.center,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       );
                    //     },
                    //   )
                    //       : Center(child: Text("No Data Available")),
                    // ),
                    Expanded(
                      child: (deliveryListFiltered.isNotEmpty || customerListFiltered.isNotEmpty)
                          ? ListView.builder(
                        // Combine both lists for display
                        itemCount: deliveryListFiltered.length + customerListFiltered.length,
                        itemBuilder: (context, index) {
                          // Logic to pick the item from the correct list
                          final items = index < deliveryListFiltered.length
                              ? deliveryListFiltered[index]
                              : customerListFiltered[index - deliveryListFiltered.length];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    items.itemName ?? "-",
                                      style: Styling
                                          .itemBlackTest,
                                      textAlign: TextAlign.left,
                                      textScaler: TextScaler.noScaling,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    // Uses the correct name based on available data
                                    (items.staffName ?? items.customerName ?? "-").toString(),
                                    style: Styling
                                        .itemBlackTest,
                                    textAlign: TextAlign.left,
                                    textScaler: TextScaler.noScaling,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    // This now shows the grouped sum
                                    items.balImbQty.toString(),
                                    style: Styling
                                        .itemBlackTest,
                                    textAlign: TextAlign.center,
                                    textScaler: TextScaler.noScaling,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                          : const Center(child: Text("No Data Available")),
                    ),

                    SizedBox(height: 10),
                  ],
                ),
              ),

            ),

          ],
        ),
      ),
    );
  }

  Widget cell(String text, {bool isHeader = false}) {
    return Container(
      padding: EdgeInsets.all(8),
      color: isHeader ? Colors.grey[300] : Colors.white,
      child: Text(
        text,
        style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  Future<void> fetchItems() async {
    // EasyLoading.instance
    //   ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
    //   ..loadingStyle = EasyLoadingStyle.light
    //   ..dismissOnTap = false // Disable dismissing the loader by tapping
    //   ..userInteractions = false;
    // EasyLoading.show(status: 'Loading...');

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
          Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
          headers: {
            'Authorization': 'Bearer $bearerToken', // Add Bearer token here
          },
        );
        debugPrint("GetItemMasterList" +
            '${AppUrl.GetItemMasterList}/$distributorId/1/C');
        debugPrint("GetItemMasterList" + response.body);
        if (response.statusCode == 200) {
          // Parse the response
          List<dynamic> data = json.decode(response.body);
          setState(() {
            _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
            _items = _items
                .where(
                    (item) => !item.itemName!.toLowerCase().contains('regulator'))
                .toList();


          });
        } else {

          throw Exception('Failed To Load Items');
        }
      }catch(e){
        debugPrint("GetItemMasterList" + e.toString());
      }
    } else {

      showFlushBar(
          context,Constants.connectionMessage);
    }


  }

  Future<void> _fetchImbalanceData() async {
    // EasyLoading.instance
    //   ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
    //   ..loadingStyle = EasyLoadingStyle.light
    //   ..dismissOnTap = false // Disable dismissing the loader by tapping
    //   ..userInteractions = false;
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token
      int dId = int.parse(distributorId!);

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.ItemImbalanceList}/$dId/0/ALL'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
          },
        );
        print("Total ImbQty for delManId response ${response.body}");
        print("Total ImbQty for delManId request ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            receiptList = data
                .map((json) => ImabalanceEmptyListModel.fromJson(json))
                .toList();

            // ✅ FILTER DELIVERY
            deliveryListFiltered = receiptList.where((e) =>
            e.dMId != null &&
                e.dMId != 0 &&
                e.staffName != null &&
                e.entryType == "D"
            ).toList();

            // ✅ FILTER CUSTOMER
            customerListFiltered = receiptList.where((e) =>
            e.dMId != null &&
                e.dMId != 0 &&
                e.customerName != null &&
                e.entryType == "C"
            ).toList();
          });

          // 1. Filter Delivery Men
          var rawDelivery = receiptList.where((e) =>
          e.dMId != null && e.dMId != 0 && e.staffName != null && e.entryType == "D"
          ).toList();
          // 2. Group and Sum Delivery Men
          deliveryListFiltered = groupAndSum(rawDelivery);

          var rawCustomer = receiptList.where((e) =>
          e.dMId != null && e.dMId != 0 && e.customerName != null && e.entryType == "C"
          ).toList();
          customerListFiltered = groupAndSum(rawCustomer);

          deliveryListFiltered = groupAndSum(receiptList.where((e) => e.entryType == "D").toList());
          customerListFiltered = groupAndSum(receiptList.where((e) => e.entryType == "C").toList());

          // 2. Sort Delivery List (by staffName)
          deliveryListFiltered.sort((a, b) {
            String nameA = (a.staffName ?? "").toString().toLowerCase();
            String nameB = (b.staffName ?? "").toString().toLowerCase();
            return nameA.compareTo(nameB);
          });

          // 3. Sort Customer List (by customerName)
          customerListFiltered.sort((a, b) {
            String nameA = (a.customerName ?? "").toString().toLowerCase();
            String nameB = (b.customerName ?? "").toString().toLowerCase();
            return nameA.compareTo(nameB);
          });

        } else {
          // Handle non-200 responses
          setState(() {
            // EasyLoading.dismiss();
            showFlushBar(context, Constants.listGettingFail);
          });

        }
      } catch (e) {
        setState(() {
          // EasyLoading.dismiss();
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        showFlushBar(context,  Constants.listGettingFail);
      }
    } else {
      // EasyLoading.dismiss();
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }
  // List<ImabalanceEmptyListModel> getUniqueDelivery() {
  //   final map = <num, ImabalanceEmptyListModel>{};
  //
  //   for (var item in deliveryListFiltered) {
  //     map[item.dMId!] = item;
  //   }
  //
  //   return map.values.toList();
  // }
  //
  // List<ImabalanceEmptyListModel> getUniqueCustomer() {
  //   final map = <num, ImabalanceEmptyListModel>{};
  //
  //   for (var item in customerListFiltered) {
  //     map[item.custId!] = item;
  //   }
  //
  //   return map.values.toList();
  // }

  // void _setQtyForSelection({required String type, num? id}) {
  //   print("item $type id $id");
  //   if (_selectedItemModel == null || id == null) return;
  //
  //   final matched = receiptList.firstWhere(
  //         (e) {
  //       if (type == "D") {
  //         return e.dMId == id &&
  //             e.itemId == _selectedItemModel!.itemId;
  //       } else {
  //         return e.custId == id &&
  //             e.itemId == _selectedItemModel!.itemId;
  //       }
  //     },
  //     orElse: () => ImabalanceEmptyListModel(),
  //   );
  //
  //   // ✅ Only set if item exists
  //   if (matched.balImbQty != null) {
  //     _totalImbalanceQtyDMCustomer.text = matched.balImbQty.toString();
  //   } else {
  //     _totalImbalanceQtyDMCustomer.clear();
  //   }
  // }

  List<ImabalanceEmptyListModel> getUniqueDelivery() {
    final Map<int, ImabalanceEmptyListModel> map = {};

    for (var item in deliveryListFiltered) {
      if (item.dMId != null) {
        map[item.dMId!.toInt()] = item;
      }
    }

    return map.values.toList();
  }
  List<ImabalanceEmptyListModel> getUniqueCustomer() {
    final Map<int, ImabalanceEmptyListModel> map = {};

    for (var item in customerListFiltered) {
      if (item.dMId != null) {
        map[item.dMId!.toInt()] = item;
      }
    }

    return map.values.toList();
  }
  void _setQtyForSelection({required String type, num? id}) {
    print("item $type id $id");

    if (_selectedItemModel == null || id == null) return;

    final filteredList = receiptList.where((e) {
      if (type == "D") {
        return e.dMId == id &&
            e.itemId == _selectedItemModel!.itemId;
      } else {
        return e.dMId == id &&
            e.itemId == _selectedItemModel!.itemId;
      }
    }).toList();

    /// ✅ SUM all BalImbQty
    int totalQty = 0;

    for (var item in filteredList) {
      totalQty += (item.balImbQty ?? 0).toInt();
    }

    /// ✅ SET VALUE
    if (totalQty > 0) {
      _totalImbalanceQtyDMCustomer.text = totalQty.toString();
    } else {
      _totalImbalanceQtyDMCustomer.clear();
    }
  }

  Future<void> checkAndSaveDayEndData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? StaffId = prefs.getString('StaffId');
    int? staffIds = int.parse(StaffId!);
    int? distributorIds = int.parse(distributorId!);
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
          // Pass bearer token in headers
        },
      );
      debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
      debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
      if (response.statusCode == 200) {
        // Parse the API response
        List<dynamic> apiResponse = json.decode(response.body);

        // Check if the response list is empty
        if (apiResponse.isEmpty) {
          // If the list is empty, do not save
          saveFlag = false;
          print("The list is empty, no data to save.");
        } else {
          saveFlag = true;
          // If there is data in the response, process it and save
          var dayEndData = apiResponse[
          0]; // Access the first item in the list (assuming it's an object)

          // You can validate the fields in the response as needed
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;

          // Check if all required fields are saved
          // if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
          //   saveFlag = true;
          //   // If the conditions are met, set the flag and save the data
          //   print("Data is valid, proceeding to save.");
          // } else {
          //   // If any condition is not met, print a message
          //   print("Data is incomplete. Cannot proceed to save.");
          // }
        }
      } else {

        // Handle API error
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      // Exception handling
      print("Exception: $e");
    }
  }

  Future<void> fetchTransactionList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? bearerToken =
      prefs.getString('token'); // Assuming the token is stored here
      int dId = int.parse(distributorId!);
      int gId = int.parse(godownId!);
      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }
      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
          headers: {
            'Authorization': 'Bearer $bearerToken', // Add Bearer token here
          },
        );

        debugPrint("GetStockTransferDtls" +
            '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
        debugPrint("GetStockTransferDtls" + response.body);
        if (response.statusCode == 200) {
          // Parse the response
          List<dynamic> data = json.decode(response.body);
          setState(() {
            _stockTransferList = data
                .map((json) => GetStockTransferListModel.fromJson(json))
                .toList();
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

        } else {
          setState(() {

            showFlushBar(context, Constants.listGettingFail);
          });
        }
      } catch (e) {
        debugPrint("GetStockTransferDtls" + e.toString());
      }
    } else {

      showFlushBar(context, Constants.connectionMessage);
    }
  }
  Future<void> addItemImbalanceQty() async {
    // Construct the request payload
    EasyLoading.show(status: 'Sending Data...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token'); // This is your bearer token
    int dId = int.parse(distributorId!);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    int? selectedDM;
    int? selectedCust;
    String selectedTypes;
  selectedTypes = selectedType.toString();
    if( _selectedItem == null ||  _selectedItem == "null"){
      showFlushBar(context,
          Constants.selectValidItemReceipt);
      EasyLoading.dismiss();
      return;
    }
    if(selectedType == "D"){
      if(_selectedDeliveryMenName == null){
        showFlushBar(context,
            "Select Delivery Boy");
        EasyLoading.dismiss();
        return;
      }else{
        selectedDM = selectedDeliveryMenId?.toInt();
        selectedCust = selectedDeliveryMenId?.toInt();
      }
    }else{
      if(_selectedCustomerName == null){
        showFlushBar(context,
            "Select Customer");
        EasyLoading.dismiss();
        return;
      }else{
        selectedCust = selectedCustomerId?.toInt();
        selectedDM = selectedCustomerId?.toInt();
      }
    }

    int availableQty = int.tryParse(_totalImbalanceQtyDMCustomer.text) ?? 0;

    // Parse the available quantity
    int enteredQty = int.tryParse(_totalImbalanceQty.text) ?? 0;
    // Check if entered quantity exceeds available
    if(enteredQty > 0){
      if (enteredQty > availableQty) {
        // Show message
        showFlushBar(context,
            Constants.validCountEnter);
        EasyLoading.dismiss();
        return; // Stop further processing
      }
    }else{
      showFlushBar(context,
          Constants.validCountEnter);
      EasyLoading.dismiss();
      return;
    }

    Map<String, dynamic> requestBody = {
    "ImbId": 0,
    "DistributorId": distributorId,
    "GodownId": godownId,
    "ImbDate": formattedDate,
    "ItemId": selectedItemId,
    "EntryType": selectedTypes ?? '',
    "ConsDMId": selectedCust,
    "ImbRecQty": enteredQty,
    "AddedBy": addedBy,
    "Action": "ADD"
    };

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.DailySaleByGKImbSettleAdd}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody), // Encode the request body as JSON
      );

      // Print the raw response for debugging
      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");
      print("API Response request: ${response.request} ${requestBody}");

      if (response.statusCode == 200) {
        // Handle success
        print("Imbalance quantity added successfully!");
        EasyLoading.showToast("Data Sent Successfully..",
            duration: const Duration(milliseconds: 3000));
        setState(() {
          _fetchImbalanceData();
          selectedDeliveryModel = null;
          selectedCustomerModel = null;
          selectedDeliveryMenId = null;   // ✅ THIS is required
          _selectedDeliveryMenName = null;
          _selectedCustomerName = null;
          selectedCustomerId = null;
          _totalImbalanceQtyDMCustomer.clear();
          _totalImbalanceQty.clear();
          _selectedItemModel = null;
          _selectedItem = null;
          selectedItemId = null;
        });

        EasyLoading.dismiss();
      } else {
        // Handle error response
        print("Failed to add imbalance quantity: ${response.statusCode}");
        EasyLoading.dismiss();
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred: $e");
      EasyLoading.dismiss();
    }
  }

  List<ImabalanceEmptyListModel> groupAndSum(List<ImabalanceEmptyListModel> list) {
    Map<String, ImabalanceEmptyListModel> groupedMap = {};

    for (var item in list) {
      String displayName = item.staffName ?? item.customerName ?? "Unknown";
      String itemName = item.itemName ?? "Unknown Item";
      String key = "$displayName-$itemName";

      if (groupedMap.containsKey(key)) {
        // 1. Calculate the new total
        double existingQty = double.tryParse(groupedMap[key]!.balImbQty.toString()) ?? 0;
        double newQty = double.tryParse(item.balImbQty.toString()) ?? 0;
        double totalQty = existingQty + newQty;

        // 2. Replace the object in the map with a new instance containing the sum
        // Note: If your model has a .copyWith() method, use that instead.
        groupedMap[key] = ImabalanceEmptyListModel(
          itemName: item.itemName,
          staffName: item.staffName,
          customerName: item.customerName,
          balImbQty: totalQty, // Assign new sum here
          entryType: item.entryType,
          dMId: item.dMId,
          // Include any other fields your model requires
        );
      } else {
        groupedMap[key] = item;
      }
    }
    return groupedMap.values.toList();
  }

}
