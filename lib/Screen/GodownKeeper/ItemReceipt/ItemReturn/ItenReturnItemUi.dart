import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ConstantScreen/widgets.dart';
import '../../../User/Login/provider/LoginProvider.dart';
import '../../../User/splashscreen/page/splash_screen.dart';
import '../../../Utils/CustomeAlertDialog.dart';
import '../../../Utils/Styling.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/shared_preference.dart';
import '../../DashboardScreen.dart';
import '../../DeliveryBoyModel/GetStockTransferListModel.dart';
import '../AddItem/ItemReceiptScreen.dart';
import '../CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
import '../EditItem/Model/GetItemReceiptListModel.dart';
import 'package:http/http.dart' as http;

class ItemReturnScreenListItem extends StatefulWidget {
  GetItemReceiptListModel _listModel;


  ItemReturnScreenListItem(this._listModel,{Key? key}) : super(key: key);

  @override
  State<ItemReturnScreenListItem> createState() => _ItemReturnScreenListItemState();
}

class _ItemReturnScreenListItemState extends State<ItemReturnScreenListItem> {
  bool isListViewVisible = false; // Tracks if ListView is visible
  List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
  bool isLoading = true;
  bool saveFlag = false;
  bool stockTransferFlag = false;
  List<GetStockTransferListModel> _stockTransferList = [];
  String? mobileNo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCurrentStock();
    checkAndSaveDayEndData();
    fetchTransactionList();
  }

  @override
  Widget build(BuildContext context) {
    var value = widget._listModel;
    return
    value != null && value != ""?
      Card(
        elevation: 5,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      child:
      SingleChildScrollView(  // Make the Column scrollable
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Set min to shrink-wrap the Column
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8,top: 0),
                    child:
                    Text("Vehicle No. - "+value.vehicleNo.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text( value.receiptDate != null
                        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(value.receiptDate!))
                        : '', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                  ),
                  // value.returnOn =="0001-01-01T00:00:00"?
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: saveFlag ? Colors.grey:stockTransferFlag?Colors.blue:Colors.grey,
                  //     padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  //     foregroundColor: Colors.white,
                  //     textStyle: const TextStyle(
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     if(saveFlag){
                  //     }
                  //     else{
                  //       if(stockTransferFlag){
                  //         var itemsToShow = value.itemDetails?.where(
                  //               (item) => item.filledQty != 0,
                  //         ).toList();
                  //         if (itemsToShow != null && itemsToShow.isNotEmpty) {
                  //           // List to store names of items where filledQty > current stock
                  //           List<String> invalidItems = [];
                  //           // Loop through items and check if filledQty is greater than stock
                  //           for (var item in itemsToShow) {
                  //             final stockInfo = getCurrentStcOfGodownKeeper.firstWhere(
                  //                   (stock) => stock.itemId == item.itemId,
                  //               orElse: () => GetCurrentStcOfGodownKeeperModel(), // Default if not found
                  //             );
                  //             if (item.filledQty! > (stockInfo.currentStkEmpty ?? 0)) {
                  //               invalidItems.add(item.itemName ?? "Unknown Item");
                  //             }
                  //           }
                  //           if (invalidItems.isNotEmpty) {
                  //             // Show AlertDialog if there are items with invalid quantity
                  //             showDialog(
                  //               context: context,
                  //               builder: (BuildContext context) {
                  //                 return AlertDialog(
                  //                   title: Text("Invalid Quantity"),
                  //                   content: Text(
                  //                     "The following items have a filled quantity greater than the available stock:\n\n" +
                  //                         invalidItems.join("\n"),
                  //                   ),
                  //                   actions: [
                  //                     TextButton(
                  //                       onPressed: () {
                  //                         Navigator.pop(context); // Close the dialog
                  //                       },
                  //                       child: Text("OK"),
                  //                     ),
                  //                   ],
                  //                 );
                  //               },
                  //             );
                  //           } else {
                  //             // Proceed with showing details dialog if no invalid qty
                  //             var receiptId = value.receiptId;
                  //             showDetailsDialog(context, itemsToShow, receiptId);
                  //           }
                  //         } else {
                  //           showFlushBar(context, Constants.nodataFound);
                  //         }
                  //       }else{
                  //         CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
                  //       }
                  //     }
                  //   },
                  //   child: Text("Out"),
                  // ) :
                  //     Text(""),
                  // value.returnOn =="0001-01-01T00:00:00"?
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: saveFlag ? Colors.grey:stockTransferFlag?Colors.blue:Colors.grey,
                  //     padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  //     foregroundColor: Colors.white,
                  //     textStyle: const TextStyle(
                  //       fontSize: 15,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     if(saveFlag){
                  //
                  //     }else {
                  //       if (stockTransferFlag) {
                  //         var itemsToShow = value.itemDetails?.toList();
                  //         var receiptId = value.receiptId;
                  //         var vehicleNo = value.vehicleNo.toString();
                  //         var receiptDate = value.receiptDate.toString();
                  //         if (itemsToShow != null && itemsToShow.isNotEmpty) {
                  //           // Navigate to the target screen and pass the data
                  //           Navigator.pushNamed(
                  //             context,
                  //             ItemReceiptScreen.screenName,
                  //             arguments: {
                  //               'vehicleNo': vehicleNo,
                  //               'receiptDate': receiptDate,
                  //               'itemsToShow': itemsToShow,
                  //               'modeChange': "Edit",
                  //               'receiptID': receiptId
                  //             },
                  //           );
                  //         } else {
                  //           showFlushBar(context,Constants.nodataFound);
                  //         }
                  //       } else {
                  //         CustomAlertDialog.showCustomAlert(context,
                  //             Constants.stockNotAccepted);
                  //       }
                  //     }
                  //
                  //   },
                  //   child: Text("Edit"),
                  // ):
                  // Text(""),
                ],
              ),
            ),
            // Use Flexible instead of Expanded
            Flexible(
              fit: FlexFit.loose,  // Allow ListView to take only as much space as it needs
              child: Visibility(
                visible: isListViewVisible,
                child:
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,  // Shrink-wrap ListView to fit within available space
                  itemCount: value.itemDetails?.length,
                  itemBuilder: (context, index) {
                    final item = value.itemDetails![index];
                    // Find the matching stock info from getCurrentStcOfGodownKeeper list
                    final stockInfo = getCurrentStcOfGodownKeeper.firstWhere(
                          (stock) => stock.itemId == item.itemId,
                      orElse: () => GetCurrentStcOfGodownKeeperModel(), // Default value if not found
                    );
                    return value.returnOn == "0001-01-01T00:00:00"
                        ? Container(
                      margin: EdgeInsets.all(2.0),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Item name: ${item.itemName}",style: TextStyle(fontWeight:FontWeight.bold)),
                              Text("Current stock: ${stockInfo.currentStkEmpty ?? 0}",style: TextStyle(fontWeight:FontWeight.bold)),
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Filled Qty'),
                                  Text('EMR Qty'),
                                  Text('Invoice Qty'),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${item.filledQty}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    Text('${item.eMRQty}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                                    Text('${item.invoiceQty}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                                  ],
                                ),
                              )
                              // Text('Filled Qty: ${item.filledQty}'),
                              // Text('EMR Qty: ${item.eMRQty}'),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Text('Invoice Qty: ${item.invoiceQty}'),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : Container(
                      margin: EdgeInsets.all(2.0),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Item name: ${item.itemName}",style: TextStyle(fontWeight:FontWeight.bold)),
                              Text("Current stock: ${stockInfo.currentStkEmpty}",style: TextStyle(fontWeight:FontWeight.bold)),
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Empty Return Qty'),
                                  Text('Defective Return Qty'),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${item.emptyReturnQty}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                    Text('${item.defectiveReturnQty}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(isListViewVisible ? "View Less" :"View More",style: Styling.actionsShowMoreText),
                      IconButton(
                        icon: Icon(
                          isListViewVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          size: 24,
                          color:Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            isListViewVisible = !isListViewVisible; // Toggle ListView visibility
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      value.returnOn =="0001-01-01T00:00:00"?
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: saveFlag ? Colors.grey:stockTransferFlag?Colors.blue:Colors.grey,
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          if(saveFlag){
                            showFlushBar(context,
                                Constants.dayEndCompleted);
                          }
                          else{
                            if(stockTransferFlag){
                              var itemsToShow = value.itemDetails?.where(
                                    (item) => item.filledQty != 0,
                              ).toList();
                              if (itemsToShow != null && itemsToShow.isNotEmpty) {
                                // List to store names of items where filledQty > current stock
                                List<String> invalidItems = [];
                                // Loop through items and check if filledQty is greater than stock
                                for (var item in itemsToShow) {
                                  final stockInfo = getCurrentStcOfGodownKeeper.firstWhere(
                                        (stock) => stock.itemId == item.itemId,
                                    orElse: () => GetCurrentStcOfGodownKeeperModel(), // Default if not found
                                  );
                                  if (item.filledQty! > (stockInfo.currentStkEmpty ?? 0)) {
                                    invalidItems.add(item.itemName ?? "Unknown Item");
                                  }
                                }
                                if (invalidItems.isNotEmpty) {
                                  // Show AlertDialog if there are items with invalid quantity
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return
                                        AlertDialog(
                                        title: Text(""),
                                        content: Text(
                                          "The following items have a quantity greater than the available stock:\n\n" +
                                              invalidItems.join("\n"),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context); // Close the dialog
                                            },
                                            child: Text("OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // Proceed with showing details dialog if no invalid qty
                                  var receiptId = value.receiptId;
                                  showDetailsDialog(context, itemsToShow, receiptId);
                                }
                              } else {
                                showFlushBar(context, Constants.nodataFound);
                              }
                            }else{
                              CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
                            }
                          }
                        },
                        child: Text("Out"),
                      ) :
                      Text(""),
                      SizedBox(width: 10,),
                      value.returnOn =="0001-01-01T00:00:00"?
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: saveFlag ? Colors.grey:stockTransferFlag?Colors.blue:Colors.grey,
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          if(saveFlag){
                            showFlushBar(context,
                                Constants.dayEndCompleted);
                          }else {
                            if (stockTransferFlag) {
                              var itemsToShow = value.itemDetails?.toList();
                              var receiptId = value.receiptId;
                              var vehicleNo = value.vehicleNo.toString();
                              var receiptDate = value.receiptDate.toString();
                              if (itemsToShow != null && itemsToShow.isNotEmpty) {
                                // Navigate to the target screen and pass the data
                                Navigator.pushNamed(
                                  context,
                                  ItemReceiptScreen.screenName,
                                  arguments: {
                                    'vehicleNo': vehicleNo,
                                    'receiptDate': receiptDate,
                                    'itemsToShow': itemsToShow,
                                    'modeChange': "Edit",
                                    'receiptID': receiptId
                                  },
                                );
                              } else {
                                showFlushBar(context,Constants.nodataFound);
                              }
                            } else {
                              CustomAlertDialog.showCustomAlert(context,
                                  Constants.stockNotAccepted);
                            }
                          }

                        },
                        child: Text("Edit"),
                      ):
                      Text(""),
                    ],
                  )
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

  void showDetailsDialog(BuildContext context, List<ItemDetails> items, num? receiptId) {
    // Controllers to track changes in text fields
    List<TextEditingController> returnQtyControllers = [];
    List<TextEditingController> defectiveQtyControllers = [];


    // Initialize controllers for each item
    for (var item in items) {
      returnQtyControllers.add(TextEditingController(text: item.filledQty.toString()));
      defectiveQtyControllers.add(TextEditingController(text: "0"));

    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Details for Items Return'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items.asMap().map((index, item) {
                return MapEntry(
                  index,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item Name (Non-editable)
                      Text("Item Name: ${item.itemName}"),
                      // Editable Return Qty
                      TextFormField(
                        controller: returnQtyControllers[index],
                        decoration: InputDecoration(labelText: 'Return Qty'),
                        keyboardType: TextInputType.number,
                        enabled: false,
                      ),
                      // Editable Defective Qty
                      // Editable Defective Qty
                      // Editable Defective Qty
                      TextFormField(
                        controller: defectiveQtyControllers[index],
                        decoration: InputDecoration(labelText: 'Defective'),
                        keyboardType: TextInputType.number,
                        onChanged: (newValue) {
                          // Get the current value of return quantity and filled quantity
                          num? filledQty = items[index].filledQty;
                          int defectiveQty = int.tryParse(newValue) ?? 0;
                          int returnQty = int.tryParse(returnQtyControllers[index].text) ?? 0;

                          if (newValue.isEmpty) {
                            // If the defective quantity is cleared, reset return quantity to filled quantity
                            returnQtyControllers[index].text = filledQty.toString();
                          } else if (defectiveQty > 0) {
                            int? f = filledQty?.toInt();
                            if(defectiveQty>filledQty!){
                              showFlushBar(context, Constants.defectiveQtyItemReturn);
                            }else{
                              // If defective quantity is a valid number, subtract it from the filled quantity
                              int remainingReturnQty = f! - defectiveQty;
                              returnQtyControllers[index].text = remainingReturnQty.toString();
                            }

                          } else {
                            // Handle invalid inputs, revert to filled quantity if input is invalid
                            returnQtyControllers[index].text = filledQty.toString();
                          }

                          // Update the defective quantity controller
                          defectiveQtyControllers[index].text = defectiveQty.toString();
                        },
                      ),


                      Divider(),
                    ],
                  ),
                );
              }).values.toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Close",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 14),),
            ),

            ElevatedButton(
              onPressed: () async {
                // Gather the updated item details, including ItemId, EmptyReturnQty, and DefectiveQty
                List<Map<String, dynamic>> updatedItemDetails = [];
                bool isValid = true;
                String errorMessage = "";

                for (int i = 0; i < items.length; i++) {
                  int returnQty = int.tryParse(returnQtyControllers[i].text) ?? 0;
                  int defectiveQty = int.tryParse(defectiveQtyControllers[i].text) ?? 0;
                  num? filledQty = items[i].filledQty;

                  // Check if the sum of returnQty and defectiveQty exceeds the filledQty
                  if (returnQty + defectiveQty > filledQty!) {
                    isValid = false;
                    errorMessage = "Return quantity and defective quantity cannot exceed the filled quantity for ${items[i].filledQty}.";
                    break; // Stop the loop if validation fails
                  }
                    if(returnQty < defectiveQty){
                      isValid = false;
                      errorMessage = "Defective quantity cannot exceed the Return quantity for ${items[i].filledQty}.";
                      break;
                    }
                  updatedItemDetails.add({
                    "ItemId": items[i].itemId,
                    "EmptyReturnQty": returnQty,
                    "DefectiveQty": defectiveQty,
                  });
                }

                // If validation fails, show an error message
                if (!isValid) {
                  // Display the error message as a SnackBar
                  showFlushBar(context, Constants.defectiveQtyItemReturn);
                } else {
                  // Send the data to the API if validation is successful
                  await sendItemDetailsToApi(updatedItemDetails, receiptId);

                  // Close the dialog
                  Navigator.of(context).pop();
                }
              },
              child: Text("Out",style: TextStyle(color: Colors.white,fontSize: 14,),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button expands to fill available width// Text color of the button
                shape: RoundedRectangleBorder( // Optional: Set rounded corners
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendItemDetailsToApi(List<Map<String, dynamic>> itemDetails, num? receiptId) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if(Constants.isNetworkAvailable){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String distributorId = preferences.getString('DistributorId') ?? '';
      String? addedBy = preferences.getString('StaffId');
      String? token = preferences.getString('token');

      // Construct the request body
      final requestBody = json.encode({
        "ReceiptId": receiptId,
        "DistributorId": distributorId,
        "AddedBy":addedBy,
        "ItemDetails": itemDetails, // This now contains ItemId, ReturnQty, and DefectiveQty
      });

      // Send the HTTP POST request
      final response = await http.post(
        Uri.parse(AppUrl.ItemReturnAddEdit),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print("Request requestBody: ${requestBody}");
      if (response.statusCode == 200) {
        // Handle successful response
        // Navigator.pushReplacementNamed(context, DashboardScreen.screenName);
        // Navigator.pushReplacementNamed(context, '/godownDashboard');
        Future.delayed(Duration(milliseconds: 300), () {
          Navigator.pushReplacementNamed(context, DashboardScreen.screenName);
        });
        print("Request successful: ${response.body}");
      } else {
        // Handle failure response
        print("Request failed: ${response.statusCode}");
      }
    }else{
      showFlushBar(context,
          Constants.connectionMessage);
    }
  }

  Future<void> fetchCurrentStock() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if(Constants.isNetworkAvailable){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request URL ItemCurrentStkList: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print("API Response Status ItemCurrentStkList: ${response.statusCode}");
        print("API Response ItemCurrentStkList: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getCurrentStcOfGodownKeeper = data.map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json)).toList();
            isLoading = false;
          });
        } else {
          // Handle non-200 responses
          setState(() {
            isLoading = false;
          });
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        showFlushBar(context,  Constants.listGettingFail);
      }
    }else{
      showFlushBar(context,
          Constants.connectionMessage);
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
          "Authorization": "Bearer $bearerToken", // Pass bearer token in headers
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
          // If there is data in the response, process it and save
          var dayEndData = apiResponse[0]; // Access the first item in the list (assuming it's an object)

          // You can validate the fields in the response as needed
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;

          // Check if all required fields are saved
          if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
            saveFlag = true;
            // If the conditions are met, set the flag and save the data
            print("Data is valid, proceeding to save.");
          } else {
            // If any condition is not met, print a message
            print("Data is incomplete. Cannot proceed to save.");
          }
        }
      } else {
        // Handle API error
        print("Error: ${response.statusCode}");
      }
    }
    catch (e) {
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
      } else {
        refreshTokens();
        isLoading = false;
        throw Exception(Constants.listGettingFail);
      }
    } else {
      refreshTokens();
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
            fetchCurrentStock();
            checkAndSaveDayEndData();
            fetchTransactionList();
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
        String message = "Your session is expire. Click ok to login again.";
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
