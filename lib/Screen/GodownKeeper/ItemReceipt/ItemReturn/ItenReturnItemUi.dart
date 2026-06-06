// import 'dart:convert';
// import 'dart:ffi';
// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../ConstantScreen/widgets.dart';
// import '../../../User/Login/provider/LoginProvider.dart';
// import '../../../User/splashscreen/page/splash_screen.dart';
// import '../../../Utils/CustomeAlertDialog.dart';
// import '../../../Utils/Styling.dart';
// import '../../../Utils/constants.dart';
// import '../../../Utils/shared_preference.dart';
// import '../../BottomNavigationForGodownKeeper.dart';
// import '../../DashboardScreen.dart';
// import '../../DeliveryBoyModel/GetStockTransferListModel.dart';
// import '../AddItem/ItemReceiptScreen.dart';
// import '../CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
// import '../EditItem/Model/GetItemReceiptListModel.dart';
// import 'package:http/http.dart' as http;
//
// class ItemReturnScreenListItem extends StatefulWidget {
//   GetItemReceiptListModel _listModel;
//
//
//   ItemReturnScreenListItem(this._listModel,{Key? key}) : super(key: key);
//
//   @override
//   State<ItemReturnScreenListItem> createState() => _ItemReturnScreenListItemState();
// }
//
// class _ItemReturnScreenListItemState extends State<ItemReturnScreenListItem> {
//   bool isListViewVisible = false; // Tracks if ListView is visible
//   List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
//   bool isLoading = true;
//   bool saveFlag = false;
//   bool stockTransferFlag = false;
//   List<GetStockTransferListModel> _stockTransferList = [];
//   String? mobileNo;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchCurrentStock();
//     checkAndSaveDayEndData();
//     fetchTransactionList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var value = widget._listModel;
//     return
//     value != null && value != ""?
//       Card(
//         elevation: 5,
//         margin: EdgeInsets.all(8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       child:
//       SingleChildScrollView(  // Make the Column scrollable
//         child: Column(
//           mainAxisSize: MainAxisSize.min,  // Set min to shrink-wrap the Column
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(2.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 8,top: 0),
//                     child:
//                     Text("Vehicle No. - "+value.vehicleNo.toString(),
//                       style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: Text( value.receiptDate != null
//                         ? DateFormat('yyyy-MM-dd').format(DateTime.parse(value.receiptDate!))
//                         : '', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
//                   ),
//                 ],
//               ),
//             ),
//             // Use Flexible instead of Expanded
//             Flexible(
//               fit: FlexFit.loose,  // Allow ListView to take only as much space as it needs
//               child: Visibility(
//                 visible: isListViewVisible,
//                 child:
//                 ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   shrinkWrap: true,  // Shrink-wrap ListView to fit within available space
//                   itemCount: value.itemDetails?.length,
//                   itemBuilder: (context, index) {
//                     final item = value.itemDetails![index];
//                     // Find the matching stock info from getCurrentStcOfGodownKeeper list
//                     final stockInfo = getCurrentStcOfGodownKeeper.firstWhere(
//                           (stock) => stock.itemId == item.itemId,
//                       orElse: () => GetCurrentStcOfGodownKeeperModel(), // Default value if not found
//                     );
//                     return value.returnOn == "0001-01-01T00:00:00"
//                         ?
//                     Container(
//                       margin: EdgeInsets.all(2.0),
//                       child: ListTile(
//                         title: Padding(
//                           padding: const EdgeInsets.all(5.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Item name: ${item.itemName}",style: TextStyle(fontWeight:FontWeight.bold)),
//                               Text("Current stock: ${stockInfo.currentStkEmpty ?? 0}",style: TextStyle(fontWeight:FontWeight.bold)),
//                             ],
//                           ),
//                         ),
//                         subtitle: Padding(
//                           padding: const EdgeInsets.all(5.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//
//                               const Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text('Filled Qty'),
//                                   Text('EMR Qty'),
//                                   Text('Invoice Qty'),
//                                 ],
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('${item.filledQty}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
//                                     Text('${item.eMRQty}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
//                                     Text('${item.invoiceQty}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
//                                   ],
//                                 ),
//                               )
//                               // Text('Filled Qty: ${item.filledQty}'),
//                               // Text('EMR Qty: ${item.eMRQty}'),
//                               // Row(
//                               //   mainAxisAlignment: MainAxisAlignment.center,
//                               //   children: [
//                               //     Text('Invoice Qty: ${item.invoiceQty}'),
//                               //   ],
//                               // ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                         : Container(
//                       margin: EdgeInsets.all(2.0),
//                       child: ListTile(
//                         title: Padding(
//                           padding: const EdgeInsets.all(5.0),
//                           child:
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Item name: ${item.itemName}",style: TextStyle(fontWeight:FontWeight.bold)),
//                               Text("Current stock: ${stockInfo.currentStkEmpty}",style: TextStyle(fontWeight:FontWeight.bold)),
//                             ],
//                           ),
//                         ),
//                         subtitle: Padding(
//                           padding: const EdgeInsets.all(5.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                                Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   // item.emptyReturnQty! > 0?
//                                   Text('Empty Return Qty'),
//                                   // Text('EMR Qty'),
//                                   Text('Defective Return Qty'),
//                                 ],
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     // item.emptyReturnQty! > 0?
//                                     Text('${item.emptyReturnQty}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
//                                     // Text('${item.eMRQty}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
//                                     Text('${item.defectiveReturnQty}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 5),
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       Row(
//             //         children: [
//             //           Text(isListViewVisible ? "View Less" :"View More",style: Styling.actionsShowMoreText),
//             //           IconButton(
//             //             icon: Icon(
//             //               isListViewVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
//             //               size: 24,
//             //               color:Colors.blue,
//             //             ),
//             //             onPressed: () {
//             //               setState(() {
//             //                 isListViewVisible = !isListViewVisible; // Toggle ListView visibility
//             //               });
//             //             },
//             //           ),
//             //         ],
//             //       ),
//             //       Row(
//             //         children: [
//             //           value.returnOn =="0001-01-01T00:00:00"?
//             //           ElevatedButton(
//             //             style: ElevatedButton.styleFrom(
//             //               backgroundColor: saveFlag ? Colors.grey:stockTransferFlag?Colors.blue:Colors.grey,
//             //               padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
//             //               foregroundColor: Colors.white,
//             //               textStyle: const TextStyle(
//             //                 fontSize: 15,
//             //                 fontWeight: FontWeight.bold,
//             //               ),
//             //             ),
//             //             onPressed: () {
//             //               if(saveFlag){
//             //                 showFlushBar(context,
//             //                     Constants.dayEndCompleted);
//             //               }
//             //               else{
//             //                 if(stockTransferFlag){
//             //                   var itemsToShow = value.itemDetails?.where(
//             //                         (item) => item.filledQty != 0,
//             //                   ).toList();
//             //                   var receiptId = value.receiptId;
//             //                   showDetailsDialog(context, itemsToShow!, receiptId);
//             //                   // if (itemsToShow != null && itemsToShow.isNotEmpty) {
//             //                   //   // List to store names of items where filledQty > current stock
//             //                   //   List<String> invalidItems = [];
//             //                   //   // Loop through items and check if filledQty is greater than stock
//             //                   //   for (var item in itemsToShow) {
//             //                   //     final stockInfo = getCurrentStcOfGodownKeeper.firstWhere(
//             //                   //           (stock) => stock.itemId == item.itemId,
//             //                   //       orElse: () => GetCurrentStcOfGodownKeeperModel(), // Default if not found
//             //                   //     );
//             //                   //     if (item.filledQty! > (stockInfo.currentStkEmpty ?? 0)) {
//             //                   //       invalidItems.add(item.itemName ?? "Unknown Item");
//             //                   //     }
//             //                   //   }
//             //                   //   if (invalidItems.isNotEmpty) {
//             //                   //     // Show AlertDialog if there are items with invalid quantity
//             //                   //     showDialog(
//             //                   //       context: context,
//             //                   //       builder: (BuildContext context) {
//             //                   //         return
//             //                   //           AlertDialog(
//             //                   //           title: Text(""),
//             //                   //           content: Text(
//             //                   //             "The following items have a quantity greater than the available stock:\n\n" +
//             //                   //                 invalidItems.join("\n"),
//             //                   //           ),
//             //                   //           actions: [
//             //                   //             TextButton(
//             //                   //               onPressed: () {
//             //                   //                 Navigator.pop(context); // Close the dialog
//             //                   //               },
//             //                   //               child: Text("OK"),
//             //                   //             ),
//             //                   //           ],
//             //                   //         );
//             //                   //       },
//             //                   //     );
//             //                   //   } else {
//             //                   //     // Proceed with showing details dialog if no invalid qty
//             //                   //     var receiptId = value.receiptId;
//             //                   //     showDetailsDialog(context, itemsToShow, receiptId);
//             //                   //   }
//             //                   // } else {
//             //                   //   showFlushBar(context, Constants.nodataFound);
//             //                   // }
//             //                 }else{
//             //                   CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
//             //                 }
//             //               }
//             //             },
//             //             child: Text("Out"),
//             //           ) :
//             //           Text(""),
//             //           SizedBox(width: 10,),
//             //           value.returnOn =="0001-01-01T00:00:00"?
//             //           ElevatedButton(
//             //             style: ElevatedButton.styleFrom(
//             //               backgroundColor: saveFlag ? Colors.grey:stockTransferFlag?Colors.blue:Colors.grey,
//             //               padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
//             //               foregroundColor: Colors.white,
//             //               textStyle: const TextStyle(
//             //                 fontSize: 15,
//             //                 fontWeight: FontWeight.bold,
//             //               ),
//             //             ),
//             //             onPressed: () {
//             //               if(saveFlag){
//             //                 showFlushBar(context,
//             //                     Constants.dayEndCompleted);
//             //               }else {
//             //                 if (stockTransferFlag) {
//             //                   var itemsToShow = value.itemDetails?.toList();
//             //                   var receiptId = value.receiptId;
//             //                   var vehicleNo = value.vehicleNo.toString();
//             //                   var receiptDate = value.receiptDate.toString();
//             //                   if (itemsToShow != null && itemsToShow.isNotEmpty) {
//             //                     // Navigate to the target screen and pass the data
//             //                     Navigator.pushNamed(
//             //                       context,
//             //                       ItemReceiptScreen.screenName,
//             //                       arguments: {
//             //                         'vehicleNo': vehicleNo,
//             //                         'receiptDate': receiptDate,
//             //                         'itemsToShow': itemsToShow,
//             //                         'modeChange': "Edit",
//             //                         'receiptID': receiptId
//             //                       },
//             //                     );
//             //                   } else {
//             //                     showFlushBar(context,Constants.nodataFound);
//             //                   }
//             //                 } else {
//             //                   CustomAlertDialog.showCustomAlert(context,
//             //                       Constants.stockNotAccepted);
//             //                 }
//             //               }
//             //
//             //             },
//             //             child: Text("Edit"),
//             //           ):
//             //           Text(""),
//             //         ],
//             //       )
//             //     ],
//             //   ),
//             // ),
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 5),
//               child:
//               Row(
//                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Left side: View More / View Less
//                   Row(
//                     children: [
//                       Text(
//                         isListViewVisible ? "View Less" : "View More",
//                         style: Styling.actionsShowMoreText,
//                       ),
//                       IconButton(
//                         icon: Icon(
//                           isListViewVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
//                           size: 24,
//                           color: Colors.blue,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             isListViewVisible = !isListViewVisible;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//
//                   Spacer(),
//
//                   // Right side: Out button
//                   (isListViewVisible && value.returnOn == "0001-01-01T00:00:00")
//                       ? ElevatedButton(
//                     // style: ElevatedButton.styleFrom(
//                     //   backgroundColor: saveFlag
//                     //       ? Colors.transparent
//                     //       : stockTransferFlag
//                     //       ? Colors.transparent
//                     //       // ? Color(0xFFF8C8C8)
//                     //       : Colors.transparent,
//                     //   padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
//                     //   foregroundColor: Colors.white,
//                     //   textStyle: const TextStyle(
//                     //     fontSize: 15,
//                     //     fontWeight: FontWeight.bold,
//                     //   ),
//                     // ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: saveFlag
//                           ? Colors.transparent
//                           : stockTransferFlag
//                           ? Colors.transparent
//                           : Colors.transparent,
//                       elevation: 0,
//                       shadowColor: Colors.transparent,
//                       surfaceTintColor: Colors.transparent,
//                       padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
//                       foregroundColor: Colors.white,
//                       textStyle: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     onPressed: () {
//                       if (saveFlag) {
//                         showFlushBar(context, Constants.dayEndCompleted);
//                       } else {
//                         if (stockTransferFlag) {
//                           var itemsToShow = value.itemDetails
//                               ?.where((item) => item.filledQty != 0)
//                               .toList();
//                           var receiptId = value.receiptId;
//                           showDetailsDialog(context, itemsToShow!, receiptId);
//                         } else {
//                           CustomAlertDialog.showCustomAlert(
//                               context, Constants.stockNotAccepted);
//                         }
//                       }
//                     },
//                     child:  Icon(
//                       Icons.local_shipping,
//                       color: Colors.blue,
//                       size: 20,
//                     ),
//                     // Text("Out"),
//                   )
//                       : SizedBox.shrink(),
//                   SizedBox(width: 2),
//                   // Edit Button (conditionally displayed)
//                   if (isListViewVisible && value.returnOn == "0001-01-01T00:00:00")
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         elevation: 0,
//                         shadowColor: Colors.transparent,
//                         surfaceTintColor: Colors.transparent,
//                         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                         textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                       ),
//                       onPressed: () {
//                         if (saveFlag) {
//                           showFlushBar(context, Constants.dayEndCompleted);
//                         } else {
//                           if (stockTransferFlag) {
//                             var itemsToShow = value.itemDetails?.toList();
//                             var receiptId = value.receiptId;
//                             var vehicleNo = value.vehicleNo.toString();
//                             var receiptDate = value.receiptDate.toString();
//                             if (itemsToShow != null && itemsToShow.isNotEmpty) {
//                               Navigator.pushNamed(
//                                 context,
//                                 ItemReceiptScreen.screenName,
//                                 arguments: {
//                                   'vehicleNo': vehicleNo,
//                                   'receiptDate': receiptDate,
//                                   'itemsToShow': itemsToShow,
//                                   'modeChange': "Edit",
//                                   'receiptID': receiptId
//                                 },
//                               );
//                             } else {
//                               showFlushBar(context, Constants.nodataFound);
//                             }
//                           } else {
//                             CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
//                           }
//                         }
//                       },
//                       child: Icon(
//                         Icons.edit,
//                         color: Colors.blue,
//                         size: 20,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//
//       ),
//     ):
//         Container(
//           child:  Text("No data found"),
//         );
//   }
//
//   void showDetailsDialog(BuildContext context, List<ItemDetails> items, num? receiptId) {
//     // Controllers to track changes in text fields
//     List<TextEditingController> returnQtyControllers = [];
//     List<TextEditingController> defectiveQtyControllers = [];
//
//     // Initialize controllers for each item
//     for (var item in items) {
//       returnQtyControllers.add(TextEditingController(text: item.filledQty.toString()));
//       defectiveQtyControllers.add(TextEditingController(text: "0"));
//     }
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Details for Items Return'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: items.asMap().map((index, item) {
//                 return MapEntry(
//                   index,
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Item Name (Non-editable)
//                       Text("Item Name: ${item.itemName}"),
//                       // Editable Return Qty
//                       TextFormField(
//                         controller: returnQtyControllers[index],
//                         decoration: InputDecoration(labelText: 'Return Qty'),
//                         keyboardType: TextInputType.number,
//                         enabled: false,
//                       ),
//                       // Editable Defective Qty
//                       // Editable Defective Qty
//                       // Editable Defective Qty
//                       TextFormField(
//                         controller: defectiveQtyControllers[index],
//                         decoration: InputDecoration(labelText: 'Defective'),
//                         keyboardType: TextInputType.number,
//                         onChanged: (newValue) {
//                           // Get the current value of return quantity and filled quantity
//                           num? filledQty = items[index].filledQty;
//                           int defectiveQty = int.tryParse(newValue) ?? 0;
//                           int returnQty = int.tryParse(returnQtyControllers[index].text) ?? 0;
//
//                           if (newValue.isEmpty) {
//                             // If the defective quantity is cleared, reset return quantity to filled quantity
//                             returnQtyControllers[index].text = filledQty.toString();
//                           } else if (defectiveQty > 0) {
//                             int? f = filledQty?.toInt();
//                             if(defectiveQty>filledQty!){
//                               debugPrint("def3");
//                               showFlushBar(context, Constants.defectiveQtyItemReturn);
//                             }else{
//                               // If defective quantity is a valid number, subtract it from the filled quantity
//                               int remainingReturnQty = f! - defectiveQty;
//                               returnQtyControllers[index].text = remainingReturnQty.toString();
//                             }
//
//                           } else {
//                             // Handle invalid inputs, revert to filled quantity if input is invalid
//                             returnQtyControllers[index].text = filledQty.toString();
//                           }
//                           // Update the defective quantity controller
//                           defectiveQtyControllers[index].text = defectiveQty.toString();
//                         },
//                       ),
//                       Divider(),
//                     ],
//                   ),
//                 );
//               }).values.toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text("Close",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 14),),
//             ),
//
//             ElevatedButton(
//               onPressed: () async {
//                 // Gather the updated item details, including ItemId, EmptyReturnQty, and DefectiveQty
//                 List<Map<String, dynamic>> updatedItemDetails = [];
//                 bool isValid = true;
//                 bool isValidDefStock =  true;
//                 bool isValidEmptyStock = true;
//                 String errorMessage = "";
//
//                 for (int i = 0; i < items.length; i++) {
//                   int returnQty = int.tryParse(returnQtyControllers[i].text) ?? 0;
//                   int defectiveQty = int.tryParse(defectiveQtyControllers[i].text) ?? 0;
//                   num? filledQty = items[i].filledQty;
//
//                   // Find the current stock for the item (using the itemId)
//                   GetCurrentStcOfGodownKeeperModel? currentStock = getCurrentStcOfGodownKeeper.firstWhere(
//                           (stock) => stock.itemId == items[i].itemId,
//                       orElse: () => GetCurrentStcOfGodownKeeperModel()
//                   );
//
//                   // Check if returnQty + emrQty exceeds the current stock (currentStkEmpty)
//                   num currentStkDef = currentStock.currentStkDefective ?? 0;
//                   num currentStkEmpty = currentStock.currentStkEmpty ?? 0;
//
//                   if(returnQty > currentStkEmpty){
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return
//                           AlertDialog(
//                             title: Text(""),
//                             content: Text(
//                               "The following items have a quantity greater than the available stock:\n\n" +
//                                   (items[i].itemName ?? ''),
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context); // Close the dialog
//                                 },
//                                 child: Text("OK"),
//                               ),
//                             ],
//                           );
//                       },
//                     );
//                     isValidEmptyStock = false;
//                     debugPrint("def2");
//                     errorMessage = "Return quantity and EMR quantity cannot exceed the current stock for ${items[i].itemName}.";
//                     debugPrint("errorMessage$errorMessage");
//                     return;
//                   }else{
//                     if (defectiveQty> currentStkDef) {
//                       debugPrint("def1");
//                       showFlushBar(context, Constants.defectiveSaleQtyDailySale);
//                       isValidDefStock = false;
//                       errorMessage = "Defective qty exceeds current defective stock for this item, kindly check the qty entered or add defective stock.";
//                       return;
//                     }
//
//                     // Check if the sum of returnQty and defectiveQty exceeds the filledQty
//                     if (returnQty + defectiveQty > filledQty!) {
//                       showFlushBar(context, Constants.defectiveQtyItemReturn);
//                       isValid = false;
//                       errorMessage = "Defective quantity must be less than the return quantity.";
//                       return; // Stop the loop if validation fails
//                     }
//                     // if(returnQty < defectiveQty){
//                     //   isValid = false;
//                     //   errorMessage = "Defective quantity cannot exceed the Return quantity for ${items[i].filledQty}.";
//                     //   break;
//                     // }
//
//                     updatedItemDetails.add({
//                       "ItemId": items[i].itemId,
//                       "EmptyReturnQty": returnQty,
//                       "DefectiveQty": defectiveQty,
//                     });
//                   }
//                   // if(!isValidDefStock){
//                   //   showFlushBar(context, Constants.defectiveSaleQtyDailySale);
//                   // }else{
//                   //   // If validation fails, show an error message
//                   //   if (!isValid) {
//                   //     // Display the error message as a SnackBar
//                   //     showFlushBar(context, Constants.defectiveQtyItemReturn);
//                   //   } else {
//                   //     // Send the data to the API if validation is successful
//                   //     await sendItemDetailsToApi(updatedItemDetails, receiptId);
//                   //     // Close the dialog
//                   //     Navigator.of(context).pop();
//                   //   }
//                   // }
//                   }
//
//                 if(!isValidDefStock){
//                   showFlushBar(context, Constants.defectiveSaleQtyDailySale);
//                 }else{
//                   // If validation fails, show an error message
//                   if (!isValid) {
//                     // Display the error message as a SnackBar
//                     showFlushBar(context, Constants.defectiveQtyItemReturn);
//                   } else {
//                     // Send the data to the API if validation is successful
//                     await sendItemDetailsToApi(updatedItemDetails, receiptId);
//                     // Close the dialog
//                     if (mounted) {
//                       Navigator.of(context).pop();
//                     }
//                   }
//                 }
//               },
//               child: Text("Out",style: TextStyle(color: Colors.white,fontSize: 14,),),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue, // Button expands to fill available width// Text color of the button
//                 shape: RoundedRectangleBorder( // Optional: Set rounded corners
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // void showDetailsDialog(BuildContext context, List<ItemDetails> items, num? receiptId) {
//   //   // Controllers to track changes in text fields
//   //   List<TextEditingController> returnQtyControllers = [];
//   //   List<TextEditingController> defectiveQtyControllers = [];
//   //
//   //
//   //   // Initialize controllers for each item
//   //   for (var item in items) {
//   //     returnQtyControllers.add(TextEditingController(text: item.filledQty.toString()));
//   //     defectiveQtyControllers.add(TextEditingController(text: "0"));
//   //
//   //   }
//   //
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) {
//   //       return AlertDialog(
//   //         title: Text('Details for Items Return'),
//   //         content: SingleChildScrollView(
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: items.asMap().map((index, item) {
//   //               return MapEntry(
//   //                 index,
//   //                 Column(
//   //                   crossAxisAlignment: CrossAxisAlignment.start,
//   //                   children: [
//   //                     // Item Name (Non-editable)
//   //                     Text("Item Name: ${item.itemName}"),
//   //                     // Editable Return Qty
//   //                     TextFormField(
//   //                       controller: returnQtyControllers[index],
//   //                       decoration: InputDecoration(labelText: 'Return Qty'),
//   //                       keyboardType: TextInputType.number,
//   //                       enabled: false,
//   //                     ),
//   //                     // Editable Defective Qty
//   //                     // Editable Defective Qty
//   //                     // Editable Defective Qty
//   //                     TextFormField(
//   //                       controller: defectiveQtyControllers[index],
//   //                       decoration: InputDecoration(labelText: 'Defective'),
//   //                       keyboardType: TextInputType.number,
//   //                       onChanged: (newValue) {
//   //                         // Get the current value of return quantity and filled quantity
//   //                         num? filledQty = items[index].filledQty;
//   //                         int defectiveQty = int.tryParse(newValue) ?? 0;
//   //                         int returnQty = int.tryParse(returnQtyControllers[index].text) ?? 0;
//   //
//   //                         if (newValue.isEmpty) {
//   //                           // If the defective quantity is cleared, reset return quantity to filled quantity
//   //                           returnQtyControllers[index].text = filledQty.toString();
//   //                         } else if (defectiveQty > 0) {
//   //                           int? f = filledQty?.toInt();
//   //                           if(defectiveQty>filledQty!){
//   //                             showFlushBar(context, Constants.defectiveQtyItemReturn);
//   //                           }else{
//   //                             // If defective quantity is a valid number, subtract it from the filled quantity
//   //                             int remainingReturnQty = f! - defectiveQty;
//   //                             returnQtyControllers[index].text = remainingReturnQty.toString();
//   //                           }
//   //
//   //                         } else {
//   //                           // Handle invalid inputs, revert to filled quantity if input is invalid
//   //                           returnQtyControllers[index].text = filledQty.toString();
//   //                         }
//   //
//   //                         // Update the defective quantity controller
//   //                         defectiveQtyControllers[index].text = defectiveQty.toString();
//   //                       },
//   //                     ),
//   //
//   //
//   //                     Divider(),
//   //                   ],
//   //                 ),
//   //               );
//   //             }).values.toList(),
//   //           ),
//   //         ),
//   //         actions: [
//   //           TextButton(
//   //             onPressed: () {
//   //               Navigator.of(context).pop(); // Close the dialog
//   //             },
//   //             child: Text("Close",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 14),),
//   //           ),
//   //
//   //           ElevatedButton(
//   //             onPressed: () async {
//   //               // Gather the updated item details, including ItemId, EmptyReturnQty, and DefectiveQty
//   //               List<Map<String, dynamic>> updatedItemDetails = [];
//   //               bool isValid = true;
//   //               bool isValidDefStock =  true;
//   //               String errorMessage = "";
//   //
//   //               for (int i = 0; i < items.length; i++) {
//   //                 int returnQty = int.tryParse(returnQtyControllers[i].text) ?? 0;
//   //                 int defectiveQty = int.tryParse(defectiveQtyControllers[i].text) ?? 0;
//   //                 num? filledQty = items[i].filledQty;
//   //
//   //                 // Find the current stock for the item (using the itemId)
//   //                 GetCurrentStcOfGodownKeeperModel? currentStock = getCurrentStcOfGodownKeeper.firstWhere(
//   //                         (stock) => stock.itemId == items[i].itemId,
//   //                     orElse: () => GetCurrentStcOfGodownKeeperModel()
//   //                 );
//   //
//   //                 // Check if returnQty + emrQty exceeds the current stock (currentStkEmpty)
//   //                 num currentStkDef = currentStock.currentStkDefective ?? 0;
//   //
//   //                 if (defectiveQty> currentStkDef) {
//   //                   isValidDefStock = false;
//   //                   errorMessage = "Return quantity and EMR quantity cannot exceed the current stock for ${items[i].itemName}.";
//   //                   break;
//   //                 }
//   //
//   //                 // Check if the sum of returnQty and defectiveQty exceeds the filledQty
//   //                 if (returnQty + defectiveQty > filledQty!) {
//   //                   isValid = false;
//   //                   errorMessage = "Return quantity and defective quantity cannot exceed the filled quantity for ${items[i].filledQty}.";
//   //                   break; // Stop the loop if validation fails
//   //                 }
//   //                 if(returnQty < defectiveQty){
//   //                   isValid = false;
//   //                   errorMessage = "Defective quantity cannot exceed the Return quantity for ${items[i].filledQty}.";
//   //                   break;
//   //                 }
//   //                 updatedItemDetails.add({
//   //                   "ItemId": items[i].itemId,
//   //                   "EmptyReturnQty": returnQty,
//   //                   "DefectiveQty": defectiveQty,
//   //                 });
//   //               }
//   //               if(!isValidDefStock){
//   //                 showFlushBar(context, Constants.defectiveSaleQtyDailySale);
//   //               }else{
//   //                 // If validation fails, show an error message
//   //                 if (!isValid) {
//   //                   // Display the error message as a SnackBar
//   //                   showFlushBar(context, Constants.defectiveQtyItemReturn);
//   //                 } else {
//   //                   // Send the data to the API if validation is successful
//   //                   await sendItemDetailsToApi(updatedItemDetails, receiptId);
//   //                   // Close the dialog
//   //                   Navigator.of(context).pop();
//   //                 }
//   //               }
//   //
//   //             },
//   //             child: Text("Out",style: TextStyle(color: Colors.white,fontSize: 14,),),
//   //             style: ElevatedButton.styleFrom(
//   //               backgroundColor: Colors.blue, // Button expands to fill available width// Text color of the button
//   //               shape: RoundedRectangleBorder( // Optional: Set rounded corners
//   //                 borderRadius: BorderRadius.circular(50),
//   //               ),
//   //             ),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//
//   Future<void> sendItemDetailsToApi(List<Map<String, dynamic>> itemDetails, num? receiptId) async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if(Constants.isNetworkAvailable){
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       String distributorId = preferences.getString('DistributorId') ?? '';
//       String? addedBy = preferences.getString('StaffId');
//       String? token = preferences.getString('token');
//
//       // Construct the request body
//       final requestBody = json.encode({
//         "ReceiptId": receiptId,
//         "DistributorId": distributorId,
//         "AddedBy":addedBy,
//         "ItemDetails": itemDetails, // This now contains ItemId, ReturnQty, and DefectiveQty
//       });
//
//       // Send the HTTP POST request
//       final response = await http.post(
//         Uri.parse(AppUrl.ItemReturnAddEdit),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: requestBody,
//       );
//
//       print("Request requestBodyItemReturnAddEdit: ${requestBody}");
//       if (response.statusCode == 200) {
//         // Handle successful response
//         // Navigator.pushReplacementNamed(context, DashboardScreen.screenName);
//         // Navigator.pushReplacementNamed(context, '/godownDashboard');
//         // Future.delayed(Duration(milliseconds: 300), () {
//         //   // Navigator.pushReplacementNamed(context, DashboardScreen.screenName);
//         //   Navigator.pushReplacementNamed(context, BottomNavigationForGodownKeeper.screenName);
//         //
//         // });
//
//         Future.delayed(Duration(milliseconds: 300), () {
//           if (!mounted) return; // Prevent accessing context if widget is disposed
//           Navigator.pushReplacementNamed(context, BottomNavigationForGodownKeeper.screenName);
//         });
//         print("Request successfulItemReturnAddEdit: ${response.body}");
//       } else {
//         // Handle failure response
//         print("Request failedItemReturnAddEdit: ${response.statusCode}");
//       }
//     }else{
//       showFlushBar(context,
//           Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchCurrentStock() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if(Constants.isNetworkAvailable){
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token'); // This is your bearer token
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
//           headers: {
//             'Authorization': 'Bearer $token',  // Add the Bearer token here
//             // Any other headers you need can go here
//           },
//         );
//         // Print the URL and the headers (including the Bearer token)
//         print("Request URL ItemCurrentStkList: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         // Print the raw response for debugging
//         print("API Response Status ItemCurrentStkList: ${response.statusCode}");
//         print("API Response ItemCurrentStkList: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getCurrentStcOfGodownKeeper = data.map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json)).toList();
//             isLoading = false;
//           });
//         } else {
//           // Handle non-200 responses
//           setState(() {
//             isLoading = false;
//           });
//           showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         setState(() {
//           isLoading = false;
//         });
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text('Error: $e')),
//         // );
//         showFlushBar(context,  Constants.listGettingFail);
//       }
//     }else{
//       showFlushBar(context,
//           Constants.connectionMessage);
//     }
//
//   }
//
//   Future<void> checkAndSaveDayEndData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     String? StaffId = prefs.getString('StaffId');
//     int? staffIds = int.parse(StaffId!);
//     int? distributorIds = int.parse(distributorId!);
//     try {
//       // Make the GET request
//       final response = await http.get(
//         Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $bearerToken", // Pass bearer token in headers
//         },
//       );
//       debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
//       debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
//       if (response.statusCode == 200) {
//         // Parse the API response
//         List<dynamic> apiResponse = json.decode(response.body);
//
//         // Check if the response list is empty
//         if (apiResponse.isEmpty) {
//           // If the list is empty, do not save
//           saveFlag = false;
//           print("The list is empty, no data to save.");
//         } else {
//           saveFlag = true;
//           // If there is data in the response, process it and save
//           var dayEndData = apiResponse[0]; // Access the first item in the list (assuming it's an object)
//
//           // You can validate the fields in the response as needed
//           int DSRSaved = dayEndData['DSRSaved'] ?? 0;
//           int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
//           int OpClSaved = dayEndData['OpClSaved'] ?? 0;
//
//           // Check if all required fields are saved
//           // if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
//           //   saveFlag = true;
//           //   // If the conditions are met, set the flag and save the data
//           //   print("Data is valid, proceeding to save.");
//           // } else {
//           //   // If any condition is not met, print a message
//           //   print("Data is incomplete. Cannot proceed to save.");
//           // }
//         }
//       } else {
//         // Handle API error
//         print("Error: ${response.statusCode}");
//       }
//     }
//     catch (e) {
//       // Exception handling
//       print("Exception: $e");
//     }
//   }
//
//   Future<void> fetchTransactionList() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
//       int dId = int.parse(distributorId!);
//       int gId = int.parse(godownId!);
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//         },
//       );
//       debugPrint(
//           "GetStockTransferDtls" + '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
//       debugPrint("GetStockTransferDtls" + response.body);
//       if (response.statusCode == 200) {
//         // Parse the response
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _stockTransferList = data.map((json) => GetStockTransferListModel.fromJson(json)).toList();
//           bool hasZeroStkTrans = false;
//           for (int i = 0; i < _stockTransferList.length; i++) {
//             if (_stockTransferList[i].isStkTrans == 0) {
//               hasZeroStkTrans = true;
//               debugPrint("Found item with isStkTrans = 0");
//               break; // No need to continue checking once we find an item with isStkTrans = 0
//             }
//           }
//           if (hasZeroStkTrans) {
//             stockTransferFlag = false; // Disable the button
//             // showFlushBar(
//             //     context, "Action Restricted", "Cannot perform the action as one or more items have isStkTrans = 0");
//           } else {
//             stockTransferFlag = true; // Enable the button
//           }
//         });
//         isLoading = false;
//       } else {
//         refreshTokens();
//         isLoading = false;
//         throw Exception(Constants.listGettingFail);
//       }
//     } else {
//       refreshTokens();
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
//             fetchCurrentStock();
//             checkAndSaveDayEndData();
//             fetchTransactionList();
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
//         String title = "Expired";
//         String message = "Your session is expire. Click ok to login again.";
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
//                 // onPressed: () {},
//                 onPressed: () => logoutUser(context),
//
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
//
// }



//
// import 'dart:convert';
// import 'dart:ffi';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../ConstantScreen/widgets.dart';
// import '../../../User/Login/provider/LoginProvider.dart';
// import '../../../User/splashscreen/page/splash_screen.dart';
// import '../../../Utils/CustomeAlertDialog.dart';
// import '../../../Utils/Styling.dart';
// import '../../../Utils/constants.dart';
// import '../../../Utils/shared_preference.dart';
// import '../../BottomNavigationForGodownKeeper.dart';
// import '../../DashboardScreen.dart';
// import '../../DeliveryBoyModel/GetStockTransferListModel.dart';
// import '../AddItem/ItemReceiptScreen.dart';
// import '../CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
// import '../EditItem/Model/GetItemReceiptListModel.dart';
// import 'package:http/http.dart' as http;
//
// class ItemReturnScreenListItem extends StatefulWidget {
//   GetItemReceiptListModel _listModel;
//
//   ItemReturnScreenListItem(this._listModel, {Key? key}) : super(key: key);
//
//   @override
//   State<ItemReturnScreenListItem> createState() =>
//       _ItemReturnScreenListItemState();
// }
//
// class _ItemReturnScreenListItemState extends State<ItemReturnScreenListItem> {
//   bool isListViewVisible = false;
//   List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
//   bool isLoading = true;
//   bool saveFlag = false;
//   bool stockTransferFlag = false;
//   List<GetStockTransferListModel> _stockTransferList = [];
//   String? mobileNo;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCurrentStock();
//     checkAndSaveDayEndData();
//     fetchTransactionList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     var value = widget._listModel;
//
//     if (value == null || value == "") {
//       return const SizedBox.shrink();
//     }
//
//     final bool isOut = value.returnOn != "0001-01-01T00:00:00";
//     final statusColor = isOut ? colorScheme.secondary : colorScheme.tertiary;
//     final statusBg = isOut
//         ? colorScheme.secondaryContainer
//         : colorScheme.tertiaryContainer ?? colorScheme.primaryContainer;
//     final statusLabel = isOut ? 'Out' : 'Pending';
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: colorScheme.surface,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: colorScheme.primary.withOpacity(0.06),
//             blurRadius: 12,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border(
//           left: BorderSide(
//             color: isOut ? colorScheme.secondary : colorScheme.tertiary,
//             width: 4,
//           ),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // ── Header row ──
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Vehicle icon
//                 Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: colorScheme.primaryContainer,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     Icons.local_shipping_rounded,
//                     color: colorScheme.primary,
//                     size: 22,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 // Vehicle info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Vehicle No.',
//                         style: TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w600,
//                           color: colorScheme.onSurfaceVariant,
//                           letterSpacing: 0.4,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         value.vehicleNo?.toString() ?? '—',
//                         style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w800,
//                           color: colorScheme.onSurface,
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 // Right: date + status badge
//                 // Column(
//                 //   crossAxisAlignment: CrossAxisAlignment.end,
//                 //   children: [
//                 //     // Status badge
//                 //     Container(
//                 //       padding: const EdgeInsets.symmetric(
//                 //           horizontal: 10, vertical: 4),
//                 //       decoration: BoxDecoration(
//                 //         color: statusBg,
//                 //         borderRadius: BorderRadius.circular(20),
//                 //       ),
//                 //       child: Text(
//                 //         statusLabel,
//                 //         style: TextStyle(
//                 //           fontSize: 11,
//                 //           fontWeight: FontWeight.w700,
//                 //           color: statusColor,
//                 //           letterSpacing: 0.2,
//                 //         ),
//                 //       ),
//                 //     ),
//                 //     const SizedBox(height: 5),
//                 //     // Date
//                 //     Text(
//                 //       value.receiptDate != null
//                 //           ? DateFormat('dd MMM yyyy')
//                 //           .format(DateTime.parse(value.receiptDate!))
//                 //           : '',
//                 //       style: TextStyle(
//                 //         fontSize: 12,
//                 //         fontWeight: FontWeight.w500,
//                 //         color: colorScheme.onSurfaceVariant,
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     // Date only
//                     Text(
//                       value.receiptDate != null
//                           ? DateFormat('dd MMM yyyy')
//                           .format(DateTime.parse(value.receiptDate!))
//                           : '',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: colorScheme.onSurfaceVariant,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // ── Expanded item list ──
//           if (isListViewVisible) ...[
//             Divider(height: 1, color: colorScheme.outline),
//             ListView.separated(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: value.itemDetails?.length ?? 0,
//               separatorBuilder: (_, __) =>
//                   Divider(height: 1, color: colorScheme.outline),
//               itemBuilder: (context, index) {
//                 final item = value.itemDetails![index];
//                 final stockInfo = getCurrentStcOfGodownKeeper.firstWhere(
//                       (stock) => stock.itemId == item.itemId,
//                   orElse: () => GetCurrentStcOfGodownKeeperModel(),
//                 );
//
//                 return Padding(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Item name + stock row
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               item.itemName ?? '—',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w700,
//                                 color: colorScheme.onSurface,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 3),
//                             decoration: BoxDecoration(
//                               color: colorScheme.primaryContainer,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               'Stock: ${stockInfo.currentStkEmpty ?? 0}',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w700,
//                                 color: colorScheme.primary,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//
//                       // Qty details — depends on returnOn state
//                       value.returnOn == "0001-01-01T00:00:00"
//                           ? _QtyRow(labels: const [
//                         'Filled Qty',
//                         'EMR Qty',
//                         'Invoice Qty'
//                       ], values: [
//                         item.filledQty?.toString() ?? '0',
//                         item.eMRQty?.toString() ?? '0',
//                         item.invoiceQty?.toString() ?? '0',
//                       ])
//                           : _QtyRow(labels: const [
//                         'Empty Return',
//                         'Defective Return',
//                       ], values: [
//                         item.emptyReturnQty?.toString() ?? '0',
//                         item.defectiveReturnQty?.toString() ?? '0',
//                       ]),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//
//           // ── Footer: toggle + action buttons ──
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
//             child: Row(
//               children: [
//                 // View More / Less toggle
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       isListViewVisible = !isListViewVisible;
//                     });
//                   },
//                   borderRadius: BorderRadius.circular(8),
//                   child: Padding(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           isListViewVisible ? 'View Less' : 'View More',
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: colorScheme.primary,
//                           ),
//                         ),
//                         const SizedBox(width: 2),
//                         Icon(
//                           isListViewVisible
//                               ? Icons.keyboard_arrow_up_rounded
//                               : Icons.keyboard_arrow_down_rounded,
//                           size: 20,
//                           color: colorScheme.primary,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const Spacer(),
//
//                 // Out button (ship icon) — only when list visible & not returned
//                 if (isListViewVisible &&
//                     value.returnOn == "0001-01-01T00:00:00") ...[
//                   _IconActionButton(
//                     icon: Icons.local_shipping_rounded,
//                     color: colorScheme.primary,
//                     bg: colorScheme.primaryContainer,
//                     onPressed: () {
//                       if (saveFlag) {
//                         showFlushBar(context, Constants.dayEndCompleted);
//                       } else {
//                         if (stockTransferFlag) {
//                           var itemsToShow = value.itemDetails
//                               ?.where((item) => item.filledQty != 0)
//                               .toList();
//                           var receiptId = value.receiptId;
//                           showDetailsDialog(context, itemsToShow!, receiptId);
//                         } else {
//                           CustomAlertDialog.showCustomAlert(
//                               context, Constants.stockNotAccepted);
//                         }
//                       }
//                     },
//                   ),
//                   const SizedBox(width: 8),
//                   _IconActionButton(
//                     icon: Icons.edit_rounded,
//                     color: colorScheme.secondary,
//                     bg: colorScheme.secondaryContainer,
//                     onPressed: () {
//                       if (saveFlag) {
//                         showFlushBar(context, Constants.dayEndCompleted);
//                       } else {
//                         if (stockTransferFlag) {
//                           var itemsToShow = value.itemDetails?.toList();
//                           var receiptId = value.receiptId;
//                           var vehicleNo = value.vehicleNo.toString();
//                           var receiptDate = value.receiptDate.toString();
//                           if (itemsToShow != null && itemsToShow.isNotEmpty) {
//                             Navigator.pushNamed(
//                               context,
//                               ItemReceiptScreen.screenName,
//                               arguments: {
//                                 'vehicleNo': vehicleNo,
//                                 'receiptDate': receiptDate,
//                                 'itemsToShow': itemsToShow,
//                                 'modeChange': "Edit",
//                                 'receiptID': receiptId
//                               },
//                             );
//                           } else {
//                             showFlushBar(context, Constants.nodataFound);
//                           }
//                         } else {
//                           CustomAlertDialog.showCustomAlert(
//                               context, Constants.stockNotAccepted);
//                         }
//                       }
//                     },
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void showDetailsDialog(
//       BuildContext context, List<ItemDetails> items, num? receiptId) {
//     List<TextEditingController> returnQtyControllers = [];
//     List<TextEditingController> defectiveQtyControllers = [];
//
//     for (var item in items) {
//       returnQtyControllers
//           .add(TextEditingController(text: item.filledQty.toString()));
//       defectiveQtyControllers.add(TextEditingController(text: "0"));
//     }
//
//     final colorScheme = Theme.of(context).colorScheme;
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: Row(
//             children: [
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   color: colorScheme.primaryContainer,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(Icons.swap_horiz_rounded,
//                     color: colorScheme.primary, size: 20),
//               ),
//               const SizedBox(width: 10),
//               const Expanded(
//                 child: Text(
//                   'Item Return Details',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ],
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: items.asMap().map((index, item) {
//                 return MapEntry(
//                   index,
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Item name chip
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: colorScheme.primaryContainer,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           item.itemName ?? '—',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: colorScheme.primary,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       // Return Qty field (disabled)
//                       TextFormField(
//                         controller: returnQtyControllers[index],
//                         decoration: InputDecoration(
//                           labelText: 'Return Qty',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: colorScheme.surfaceContainerHighest,
//                         ),
//                         keyboardType: TextInputType.number,
//                         enabled: false,
//                       ),
//                       const SizedBox(height: 10),
//                       // Defective Qty field
//                       TextFormField(
//                         controller: defectiveQtyControllers[index],
//                         decoration: InputDecoration(
//                           labelText: 'Defective Qty',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         keyboardType: TextInputType.number,
//                         onChanged: (newValue) {
//                           num? filledQty = items[index].filledQty;
//                           int defectiveQty = int.tryParse(newValue) ?? 0;
//                           int returnQty =
//                               int.tryParse(returnQtyControllers[index].text) ??
//                                   0;
//
//                           if (newValue.isEmpty) {
//                             returnQtyControllers[index].text =
//                                 filledQty.toString();
//                           } else if (defectiveQty > 0) {
//                             int? f = filledQty?.toInt();
//                             if (defectiveQty > filledQty!) {
//                               debugPrint("def3");
//                               showFlushBar(
//                                   context, Constants.defectiveQtyItemReturn);
//                             } else {
//                               int remainingReturnQty = f! - defectiveQty;
//                               returnQtyControllers[index].text =
//                                   remainingReturnQty.toString();
//                             }
//                           } else {
//                             returnQtyControllers[index].text =
//                                 filledQty.toString();
//                           }
//                           defectiveQtyControllers[index].text =
//                               defectiveQty.toString();
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       Divider(color: colorScheme.outline),
//                       const SizedBox(height: 4),
//                     ],
//                   ),
//                 );
//               }).values.toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text(
//                 'Close',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 14,
//                   color: colorScheme.onSurfaceVariant,
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 List<Map<String, dynamic>> updatedItemDetails = [];
//                 bool isValid = true;
//                 bool isValidDefStock = true;
//                 bool isValidEmptyStock = true;
//                 String errorMessage = "";
//
//                 for (int i = 0; i < items.length; i++) {
//                   int returnQty =
//                       int.tryParse(returnQtyControllers[i].text) ?? 0;
//                   int defectiveQty =
//                       int.tryParse(defectiveQtyControllers[i].text) ?? 0;
//                   num? filledQty = items[i].filledQty;
//
//                   GetCurrentStcOfGodownKeeperModel? currentStock =
//                   getCurrentStcOfGodownKeeper.firstWhere(
//                         (stock) => stock.itemId == items[i].itemId,
//                     orElse: () => GetCurrentStcOfGodownKeeperModel(),
//                   );
//
//                   num currentStkDef = currentStock.currentStkDefective ?? 0;
//                   num currentStkEmpty = currentStock.currentStkEmpty ?? 0;
//
//                   if (returnQty > currentStkEmpty) {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16)),
//                           title: const Text(""),
//                           content: Text(
//                             "The following items have a quantity greater than the available stock:\n\n" +
//                                 (items[i].itemName ?? ''),
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text("OK"),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                     isValidEmptyStock = false;
//                     debugPrint("def2");
//                     errorMessage =
//                     "Return quantity and EMR quantity cannot exceed the current stock for ${items[i].itemName}.";
//                     debugPrint("errorMessage$errorMessage");
//                     return;
//                   } else {
//                     if (defectiveQty > currentStkDef) {
//                       debugPrint("def1");
//                       showFlushBar(
//                           context, Constants.defectiveSaleQtyDailySale);
//                       isValidDefStock = false;
//                       errorMessage =
//                       "Defective qty exceeds current defective stock for this item, kindly check the qty entered or add defective stock.";
//                       return;
//                     }
//
//                     if (returnQty + defectiveQty > filledQty!) {
//                       showFlushBar(context, Constants.defectiveQtyItemReturn);
//                       isValid = false;
//                       errorMessage =
//                       "Defective quantity must be less than the return quantity.";
//                       return;
//                     }
//
//                     updatedItemDetails.add({
//                       "ItemId": items[i].itemId,
//                       "EmptyReturnQty": returnQty,
//                       "DefectiveQty": defectiveQty,
//                     });
//                   }
//                 }
//
//                 if (!isValidDefStock) {
//                   showFlushBar(context, Constants.defectiveSaleQtyDailySale);
//                 } else {
//                   if (!isValid) {
//                     showFlushBar(context, Constants.defectiveQtyItemReturn);
//                   } else {
//                     await sendItemDetailsToApi(updatedItemDetails, receiptId);
//                     if (mounted) {
//                       Navigator.of(context).pop();
//                     }
//                   }
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: colorScheme.primary,
//                 foregroundColor: colorScheme.onPrimary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               child: const Text(
//                 'Out',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> sendItemDetailsToApi(
//       List<Map<String, dynamic>> itemDetails, num? receiptId) async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       String distributorId = preferences.getString('DistributorId') ?? '';
//       String? addedBy = preferences.getString('StaffId');
//       String? token = preferences.getString('token');
//
//       final requestBody = json.encode({
//         "ReceiptId": receiptId,
//         "DistributorId": distributorId,
//         "AddedBy": addedBy,
//         "ItemDetails": itemDetails,
//       });
//
//       final response = await http.post(
//         Uri.parse(AppUrl.ItemReturnAddEdit),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: requestBody,
//       );
//
//       print("Request requestBodyItemReturnAddEdit: ${requestBody}");
//       if (response.statusCode == 200) {
//         Future.delayed(const Duration(milliseconds: 300), () {
//           if (!mounted) return;
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName);
//         });
//         print("Request successfulItemReturnAddEdit: ${response.body}");
//       } else {
//         print("Request failedItemReturnAddEdit: ${response.statusCode}");
//       }
//     } else {
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchCurrentStock() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token');
//
//       try {
//         final response = await http.get(
//           Uri.parse(
//               '${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         );
//         print("Request URL ItemCurrentStkList: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         print(
//             "API Response Status ItemCurrentStkList: ${response.statusCode}");
//         print("API Response ItemCurrentStkList: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getCurrentStcOfGodownKeeper = data
//                 .map((json) =>
//                 GetCurrentStcOfGodownKeeperModel.fromJson(json))
//                 .toList();
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//           showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         setState(() {
//           isLoading = false;
//         });
//         showFlushBar(context, Constants.listGettingFail);
//       }
//     } else {
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> checkAndSaveDayEndData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     String? StaffId = prefs.getString('StaffId');
//     int? staffIds = int.parse(StaffId!);
//     int? distributorIds = int.parse(distributorId!);
//     try {
//       final response = await http.get(
//         Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $bearerToken",
//         },
//       );
//       debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
//       debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
//       if (response.statusCode == 200) {
//         List<dynamic> apiResponse = json.decode(response.body);
//
//         if (apiResponse.isEmpty) {
//           saveFlag = false;
//           print("The list is empty, no data to save.");
//         } else {
//           saveFlag = true;
//           var dayEndData = apiResponse[0];
//           int DSRSaved = dayEndData['DSRSaved'] ?? 0;
//           int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
//           int OpClSaved = dayEndData['OpClSaved'] ?? 0;
//         }
//       } else {
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }
//
//   Future<void> fetchTransactionList() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? bearerToken = prefs.getString('token');
//       int dId = int.parse(distributorId!);
//       int gId = int.parse(godownId!);
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken',
//         },
//       );
//       debugPrint(
//           "GetStockTransferDtls" +
//               '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
//       debugPrint("GetStockTransferDtls" + response.body);
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _stockTransferList = data
//               .map((json) => GetStockTransferListModel.fromJson(json))
//               .toList();
//           bool hasZeroStkTrans = false;
//           for (int i = 0; i < _stockTransferList.length; i++) {
//             if (_stockTransferList[i].isStkTrans == 0) {
//               hasZeroStkTrans = true;
//               debugPrint("Found item with isStkTrans = 0");
//               break;
//             }
//           }
//           if (hasZeroStkTrans) {
//             stockTransferFlag = false;
//           } else {
//             stockTransferFlag = true;
//           }
//         });
//         isLoading = false;
//       } else {
//         refreshTokens();
//         isLoading = false;
//         throw Exception(Constants.listGettingFail);
//       }
//     } else {
//       refreshTokens();
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
//             fetchCurrentStock();
//             checkAndSaveDayEndData();
//             fetchTransactionList();
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
//         String title = "Expired";
//         String message =
//             "Your session is expire. Click ok to login again.";
//         String btnLabel = "Ok";
//         return Platform.isIOS
//             ? WillPopScope(
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//           child: CupertinoAlertDialog(
//             title: Text(title, style: Styling.bodyTitle),
//             content: Text(message, style: Styling.bodyTitle),
//             actions: <Widget>[
//               TextButton(
//                 child: Text(btnLabel, style: Styling.blueClrText),
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
// // ── Qty row widget ──
// class _QtyRow extends StatelessWidget {
//   const _QtyRow({required this.labels, required this.values});
//   final List<String> labels;
//   final List<String> values;
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Row(
//       children: List.generate(labels.length, (i) {
//         return Expanded(
//           child: Column(
//             crossAxisAlignment: i == 0
//                 ? CrossAxisAlignment.start
//                 : labels.length > 2 && i == labels.length ~/ 2
//                 ? CrossAxisAlignment.center
//                 : CrossAxisAlignment.end,
//             children: [
//               Text(
//                 labels[i],
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                   color: colorScheme.onSurfaceVariant,
//                   letterSpacing: 0.2,
//                 ),
//               ),
//               const SizedBox(height: 3),
//               Text(
//                 values[i],
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: colorScheme.onSurface,
//                   letterSpacing: -0.3,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
//
// // ── Icon action button ──
// class _IconActionButton extends StatelessWidget {
//   const _IconActionButton({
//     required this.icon,
//     required this.color,
//     required this.bg,
//     required this.onPressed,
//   });
//   final IconData icon;
//   final Color color;
//   final Color bg;
//   final VoidCallback onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: bg,
//       borderRadius: BorderRadius.circular(12),
//       child: InkWell(
//         onTap: () {
//           HapticFeedback.lightImpact();
//           onPressed();
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Icon(icon, color: color, size: 20),
//         ),
//       ),
//     );
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
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../ConstantScreen/widgets.dart';
// import '../../../User/Login/provider/LoginProvider.dart';
// import '../../../User/splashscreen/page/splash_screen.dart';
// import '../../../Utils/CustomeAlertDialog.dart';
// import '../../../Utils/CustomAppBar.dart';
// import '../../../Utils/Styling.dart';
// import '../../../Utils/app_url.dart';
// import '../../../Utils/constants.dart';
// import '../../../Utils/shared_preference.dart';
// import '../../BottomNavigationForGodownKeeper.dart';
// import '../../DeliveryBoyModel/GetStockTransferListModel.dart';
// import '../AddItem/ItemReceiptScreen.dart';
// import '../CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
// import '../EditItem/Model/GetItemReceiptListModel.dart';
// import 'package:http/http.dart' as http;
//
// class ItemReturnScreenListItem extends StatefulWidget {
//   GetItemReceiptListModel _listModel;
//
//   ItemReturnScreenListItem(this._listModel, {Key? key}) : super(key: key);
//
//   @override
//   State<ItemReturnScreenListItem> createState() =>
//       _ItemReturnScreenListItemState();
// }
//
// class _ItemReturnScreenListItemState extends State<ItemReturnScreenListItem> {
//   bool isListViewVisible = false;
//   List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
//   bool isLoading = true;
//   bool saveFlag = false;
//   bool stockTransferFlag = false;
//   List<GetStockTransferListModel> _stockTransferList = [];
//   String? mobileNo;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCurrentStock();
//     checkAndSaveDayEndData();
//     fetchTransactionList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     var value = widget._listModel;
//
//     if (value == null || value == "") {
//       return const SizedBox.shrink();
//     }
//
//     final bool isOut = value.returnOn != "0001-01-01T00:00:00";
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: colorScheme.surface,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: colorScheme.primary.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border(
//           left: BorderSide(
//             color: isOut ? colorScheme.secondary : colorScheme.primary,
//             width: 3,
//           ),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // ── Header row ──
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 10, 10, 8),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Vehicle icon — compact
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: colorScheme.primaryContainer,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     Icons.local_shipping_rounded,
//                     color: colorScheme.primary,
//                     size: 18,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 // Vehicle info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Vehicle No.',
//                         style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                           color: colorScheme.onSurfaceVariant,
//                           letterSpacing: 0.3,
//                         ),
//                       ),
//                       const SizedBox(height: 1),
//                       Text(
//                         value.vehicleNo?.toString() ?? '—',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w800,
//                           color: colorScheme.onSurface,
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Right: date + status badge
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     // Status badge
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: isOut
//                             ? colorScheme.secondaryContainer
//                             : colorScheme.primaryContainer,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         isOut ? 'Out' : 'Pending',
//                         style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700,
//                           color: isOut
//                               ? colorScheme.secondary
//                               : colorScheme.primary,
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     // Date
//                     Text(
//                       value.receiptDate != null
//                           ? DateFormat('dd MMM yy')
//                           .format(DateTime.parse(value.receiptDate!))
//                           : '',
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w500,
//                         color: colorScheme.onSurfaceVariant,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // ── Expanded item list ──
//           if (isListViewVisible) ...[
//             Divider(height: 1, color: colorScheme.outline.withOpacity(0.5)),
//             ListView.separated(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: value.itemDetails?.length ?? 0,
//               separatorBuilder: (_, __) => Divider(
//                 height: 1,
//                 color: colorScheme.outline.withOpacity(0.4),
//               ),
//               itemBuilder: (context, index) {
//                 final item = value.itemDetails![index];
//                 final stockInfo = getCurrentStcOfGodownKeeper.firstWhere(
//                       (stock) => stock.itemId == item.itemId,
//                   orElse: () => GetCurrentStcOfGodownKeeperModel(),
//                 );
//
//                 return Padding(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Item name + stock chip
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               item.itemName ?? '—',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w700,
//                                 color: colorScheme.onSurface,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 7, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: colorScheme.primaryContainer,
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               'Stk: ${stockInfo.currentStkEmpty ?? 0}',
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w700,
//                                 color: colorScheme.primary,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//
//                       // Qty details
//                       value.returnOn == "0001-01-01T00:00:00"
//                           ? _QtyRow(
//                         labels: const [
//                           'Filled Qty',
//                           'EMR Qty',
//                           'Invoice Qty'
//                         ],
//                         values: [
//                           item.filledQty?.toString() ?? '0',
//                           item.eMRQty?.toString() ?? '0',
//                           item.invoiceQty?.toString() ?? '0',
//                         ],
//                       )
//                           : _QtyRow(
//                         labels: const [
//                           'Empty Return',
//                           'Defective Return',
//                         ],
//                         values: [
//                           item.emptyReturnQty?.toString() ?? '0',
//                           item.defectiveReturnQty?.toString() ?? '0',
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//
//           // ── Footer: toggle + action buttons ──
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
//             child: Row(
//               children: [
//                 // View More / Less toggle
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       isListViewVisible = !isListViewVisible;
//                     });
//                   },
//                   borderRadius: BorderRadius.circular(8),
//                   child: Padding(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           isListViewVisible ? 'View Less' : 'View More',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: colorScheme.primary,
//                           ),
//                         ),
//                         const SizedBox(width: 2),
//                         Icon(
//                           isListViewVisible
//                               ? Icons.keyboard_arrow_up_rounded
//                               : Icons.keyboard_arrow_down_rounded,
//                           size: 18,
//                           color: colorScheme.primary,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const Spacer(),
//
//                 // Action buttons — only when expanded & not returned
//                 if (isListViewVisible &&
//                     value.returnOn == "0001-01-01T00:00:00") ...[
//                   _IconActionButton(
//                     icon: Icons.local_shipping_rounded,
//                     color: colorScheme.primary,
//                     bg: colorScheme.primaryContainer,
//                     onPressed: () {
//                       if (saveFlag) {
//                         showFlushBar(context, Constants.dayEndCompleted);
//                       } else {
//                         if (stockTransferFlag) {
//                           var itemsToShow = value.itemDetails
//                               ?.where((item) => item.filledQty != 0)
//                               .toList();
//                           var receiptId = value.receiptId;
//                           showDetailsDialog(context, itemsToShow!, receiptId);
//                         } else {
//                           CustomAlertDialog.showCustomAlert(
//                               context, Constants.stockNotAccepted);
//                         }
//                       }
//                     },
//                   ),
//                   const SizedBox(width: 6),
//                   _IconActionButton(
//                     icon: Icons.edit_rounded,
//                     color: colorScheme.secondary,
//                     bg: colorScheme.secondaryContainer,
//                     onPressed: () {
//                       if (saveFlag) {
//                         showFlushBar(context, Constants.dayEndCompleted);
//                       } else {
//                         if (stockTransferFlag) {
//                           var itemsToShow = value.itemDetails?.toList();
//                           var receiptId = value.receiptId;
//                           var vehicleNo = value.vehicleNo.toString();
//                           var receiptDate = value.receiptDate.toString();
//                           if (itemsToShow != null && itemsToShow.isNotEmpty) {
//                             Navigator.pushNamed(
//                               context,
//                               ItemReceiptScreen.screenName,
//                               arguments: {
//                                 'vehicleNo': vehicleNo,
//                                 'receiptDate': receiptDate,
//                                 'itemsToShow': itemsToShow,
//                                 'modeChange': "Edit",
//                                 'receiptID': receiptId
//                               },
//                             );
//                           } else {
//                             showFlushBar(context, Constants.nodataFound);
//                           }
//                         } else {
//                           CustomAlertDialog.showCustomAlert(
//                               context, Constants.stockNotAccepted);
//                         }
//                       }
//                     },
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void showDetailsDialog(
//       BuildContext context, List<ItemDetails> items, num? receiptId) {
//     List<TextEditingController> returnQtyControllers = [];
//     List<TextEditingController> defectiveQtyControllers = [];
//
//     for (var item in items) {
//       returnQtyControllers
//           .add(TextEditingController(text: item.filledQty.toString()));
//       defectiveQtyControllers.add(TextEditingController(text: "0"));
//     }
//
//     final colorScheme = Theme.of(context).colorScheme;
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: Row(
//             children: [
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   color: colorScheme.primaryContainer,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(Icons.swap_horiz_rounded,
//                     color: colorScheme.primary, size: 20),
//               ),
//               const SizedBox(width: 10),
//               const Expanded(
//                 child: Text(
//                   'Item Return Details',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ],
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: items.asMap().map((index, item) {
//                 return MapEntry(
//                   index,
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: colorScheme.primaryContainer,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           item.itemName ?? '—',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: colorScheme.primary,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       TextFormField(
//                         controller: returnQtyControllers[index],
//                         decoration: InputDecoration(
//                           labelText: 'Return Qty',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: colorScheme.surfaceContainerHighest,
//                         ),
//                         keyboardType: TextInputType.number,
//                         enabled: false,
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: defectiveQtyControllers[index],
//                         decoration: InputDecoration(
//                           labelText: 'Defective Qty',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         keyboardType: TextInputType.number,
//                         onChanged: (newValue) {
//                           num? filledQty = items[index].filledQty;
//                           int defectiveQty = int.tryParse(newValue) ?? 0;
//                           int returnQty =
//                               int.tryParse(returnQtyControllers[index].text) ??
//                                   0;
//
//                           if (newValue.isEmpty) {
//                             returnQtyControllers[index].text =
//                                 filledQty.toString();
//                           } else if (defectiveQty > 0) {
//                             int? f = filledQty?.toInt();
//                             if (defectiveQty > filledQty!) {
//                               debugPrint("def3");
//                               showFlushBar(
//                                   context, Constants.defectiveQtyItemReturn);
//                             } else {
//                               int remainingReturnQty = f! - defectiveQty;
//                               returnQtyControllers[index].text =
//                                   remainingReturnQty.toString();
//                             }
//                           } else {
//                             returnQtyControllers[index].text =
//                                 filledQty.toString();
//                           }
//                           defectiveQtyControllers[index].text =
//                               defectiveQty.toString();
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       Divider(color: colorScheme.outline),
//                       const SizedBox(height: 4),
//                     ],
//                   ),
//                 );
//               }).values.toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text(
//                 'Close',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 14,
//                   color: colorScheme.onSurfaceVariant,
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 List<Map<String, dynamic>> updatedItemDetails = [];
//                 bool isValid = true;
//                 bool isValidDefStock = true;
//                 bool isValidEmptyStock = true;
//                 String errorMessage = "";
//
//                 for (int i = 0; i < items.length; i++) {
//                   int returnQty =
//                       int.tryParse(returnQtyControllers[i].text) ?? 0;
//                   int defectiveQty =
//                       int.tryParse(defectiveQtyControllers[i].text) ?? 0;
//                   num? filledQty = items[i].filledQty;
//
//                   GetCurrentStcOfGodownKeeperModel? currentStock =
//                   getCurrentStcOfGodownKeeper.firstWhere(
//                         (stock) => stock.itemId == items[i].itemId,
//                     orElse: () => GetCurrentStcOfGodownKeeperModel(),
//                   );
//
//                   num currentStkDef = currentStock.currentStkDefective ?? 0;
//                   num currentStkEmpty = currentStock.currentStkEmpty ?? 0;
//
//                   if (returnQty > currentStkEmpty) {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16)),
//                           title: const Text(""),
//                           content: Text(
//                             "The following items have a quantity greater than the available stock:\n\n" +
//                                 (items[i].itemName ?? ''),
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text("OK"),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                     isValidEmptyStock = false;
//                     debugPrint("def2");
//                     errorMessage =
//                     "Return quantity and EMR quantity cannot exceed the current stock for ${items[i].itemName}.";
//                     debugPrint("errorMessage$errorMessage");
//                     return;
//                   } else {
//                     if (defectiveQty > currentStkDef) {
//                       debugPrint("def1");
//                       showFlushBar(
//                           context, Constants.defectiveSaleQtyDailySale);
//                       isValidDefStock = false;
//                       errorMessage =
//                       "Defective qty exceeds current defective stock for this item, kindly check the qty entered or add defective stock.";
//                       return;
//                     }
//
//                     if (returnQty + defectiveQty > filledQty!) {
//                       showFlushBar(context, Constants.defectiveQtyItemReturn);
//                       isValid = false;
//                       errorMessage =
//                       "Defective quantity must be less than the return quantity.";
//                       return;
//                     }
//
//                     updatedItemDetails.add({
//                       "ItemId": items[i].itemId,
//                       "EmptyReturnQty": returnQty,
//                       "DefectiveQty": defectiveQty,
//                     });
//                   }
//                 }
//
//                 if (!isValidDefStock) {
//                   showFlushBar(context, Constants.defectiveSaleQtyDailySale);
//                 } else {
//                   if (!isValid) {
//                     showFlushBar(context, Constants.defectiveQtyItemReturn);
//                   } else {
//                     await sendItemDetailsToApi(updatedItemDetails, receiptId);
//                     if (mounted) {
//                       Navigator.of(context).pop();
//                     }
//                   }
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: colorScheme.primary,
//                 foregroundColor: colorScheme.onPrimary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               child: const Text(
//                 'Out',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> sendItemDetailsToApi(
//       List<Map<String, dynamic>> itemDetails, num? receiptId) async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       String distributorId = preferences.getString('DistributorId') ?? '';
//       String? addedBy = preferences.getString('StaffId');
//       String? token = preferences.getString('token');
//
//       final requestBody = json.encode({
//         "ReceiptId": receiptId,
//         "DistributorId": distributorId,
//         "AddedBy": addedBy,
//         "ItemDetails": itemDetails,
//       });
//
//       final response = await http.post(
//         Uri.parse(AppUrl.ItemReturnAddEdit),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: requestBody,
//       );
//
//       print("Request requestBodyItemReturnAddEdit: ${requestBody}");
//       if (response.statusCode == 200) {
//         Future.delayed(const Duration(milliseconds: 300), () {
//           if (!mounted) return;
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName);
//         });
//         print("Request successfulItemReturnAddEdit: ${response.body}");
//       } else {
//         print("Request failedItemReturnAddEdit: ${response.statusCode}");
//       }
//     } else {
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchCurrentStock() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token');
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         );
//         print("Request URL ItemCurrentStkList: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         print("API Response Status ItemCurrentStkList: ${response.statusCode}");
//         print("API Response ItemCurrentStkList: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getCurrentStcOfGodownKeeper = data
//                 .map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json))
//                 .toList();
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//           showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         setState(() {
//           isLoading = false;
//         });
//         showFlushBar(context, Constants.listGettingFail);
//       }
//     } else {
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> checkAndSaveDayEndData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     String? StaffId = prefs.getString('StaffId');
//     int? staffIds = int.parse(StaffId!);
//     int? distributorIds = int.parse(distributorId!);
//     try {
//       final response = await http.get(
//         Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $bearerToken",
//         },
//       );
//       debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
//       debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
//       if (response.statusCode == 200) {
//         List<dynamic> apiResponse = json.decode(response.body);
//
//         if (apiResponse.isEmpty) {
//           saveFlag = false;
//           print("The list is empty, no data to save.");
//         } else {
//           saveFlag = true;
//           var dayEndData = apiResponse[0];
//           int DSRSaved = dayEndData['DSRSaved'] ?? 0;
//           int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
//           int OpClSaved = dayEndData['OpClSaved'] ?? 0;
//         }
//       } else {
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }
//
//   Future<void> fetchTransactionList() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? bearerToken = prefs.getString('token');
//       int dId = int.parse(distributorId!);
//       int gId = int.parse(godownId!);
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken',
//         },
//       );
//       debugPrint("GetStockTransferDtls" +
//           '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
//       debugPrint("GetStockTransferDtls" + response.body);
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _stockTransferList = data
//               .map((json) => GetStockTransferListModel.fromJson(json))
//               .toList();
//           bool hasZeroStkTrans = false;
//           for (int i = 0; i < _stockTransferList.length; i++) {
//             if (_stockTransferList[i].isStkTrans == 0) {
//               hasZeroStkTrans = true;
//               debugPrint("Found item with isStkTrans = 0");
//               break;
//             }
//           }
//           if (hasZeroStkTrans) {
//             stockTransferFlag = false;
//           } else {
//             stockTransferFlag = true;
//           }
//         });
//         isLoading = false;
//       } else {
//         refreshTokens();
//         isLoading = false;
//         throw Exception(Constants.listGettingFail);
//       }
//     } else {
//       refreshTokens();
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
//             fetchCurrentStock();
//             checkAndSaveDayEndData();
//             fetchTransactionList();
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
//         String title = "Expired";
//         String message = "Your session is expire. Click ok to login again.";
//         String btnLabel = "Ok";
//         return Platform.isIOS
//             ? WillPopScope(
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//           child: CupertinoAlertDialog(
//             title: Text(title, style: Styling.bodyTitle),
//             content: Text(message, style: Styling.bodyTitle),
//             actions: <Widget>[
//               TextButton(
//                 child: Text(btnLabel, style: Styling.blueClrText),
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
// // ── Qty row widget ──
// class _QtyRow extends StatelessWidget {
//   const _QtyRow({required this.labels, required this.values});
//   final List<String> labels;
//   final List<String> values;
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Row(
//       children: List.generate(labels.length, (i) {
//         return Expanded(
//           child: Column(
//             crossAxisAlignment: i == 0
//                 ? CrossAxisAlignment.start
//                 : labels.length > 2 && i == labels.length ~/ 2
//                 ? CrossAxisAlignment.center
//                 : CrossAxisAlignment.end,
//             children: [
//               Text(
//                 labels[i],
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                   color: colorScheme.onSurfaceVariant,
//                   letterSpacing: 0.2,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 values[i],
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w800,
//                   color: colorScheme.onSurface,
//                   letterSpacing: -0.3,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
//
// // ── Icon action button ──
// class _IconActionButton extends StatelessWidget {
//   const _IconActionButton({
//     required this.icon,
//     required this.color,
//     required this.bg,
//     required this.onPressed,
//   });
//   final IconData icon;
//   final Color color;
//   final Color bg;
//   final VoidCallback onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: bg,
//       borderRadius: BorderRadius.circular(10),
//       child: InkWell(
//         onTap: () {
//           HapticFeedback.lightImpact();
//           onPressed();
//         },
//         borderRadius: BorderRadius.circular(10),
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Icon(icon, color: color, size: 18),
//         ),
//       ),
//     );
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
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../ConstantScreen/widgets.dart';
// import '../../../User/Login/provider/LoginProvider.dart';
// import '../../../User/splashscreen/page/splash_screen.dart';
// import '../../../Utils/CustomeAlertDialog.dart';
// import '../../../Utils/CustomAppBar.dart';
// import '../../../Utils/Styling.dart';
// import '../../../Utils/app_url.dart';
// import '../../../Utils/constants.dart';
// import '../../../Utils/shared_preference.dart';
// import '../../BottomNavigationForGodownKeeper.dart';
// import '../../DeliveryBoyModel/GetStockTransferListModel.dart';
// import '../AddItem/ItemReceiptScreen.dart';
// import '../CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
// import '../EditItem/Model/GetItemReceiptListModel.dart';
// import 'package:http/http.dart' as http;
//
// class ItemReturnScreenListItem extends StatefulWidget {
//   GetItemReceiptListModel _listModel;
//
//   ItemReturnScreenListItem(this._listModel, {Key? key}) : super(key: key);
//
//   @override
//   State<ItemReturnScreenListItem> createState() =>
//       _ItemReturnScreenListItemState();
// }
//
// class _ItemReturnScreenListItemState extends State<ItemReturnScreenListItem> {
//   bool isListViewVisible = false;
//   List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
//   bool isLoading = true;
//   bool saveFlag = false;
//   bool stockTransferFlag = false;
//   List<GetStockTransferListModel> _stockTransferList = [];
//   String? mobileNo;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCurrentStock();
//     checkAndSaveDayEndData();
//     fetchTransactionList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     var value = widget._listModel;
//
//     if (value == null || value == "") {
//       return const SizedBox.shrink();
//     }
//
//     final bool isOut = value.returnOn != "0001-01-01T00:00:00";
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: colorScheme.surface,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: colorScheme.primary.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border(
//           left: BorderSide(
//             color: isOut ? colorScheme.secondary : colorScheme.primary,
//             width: 3,
//           ),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // ── Header row ──
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 10, 10, 8),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Vehicle icon — compact
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: colorScheme.primaryContainer,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     Icons.local_shipping_rounded,
//                     color: colorScheme.primary,
//                     size: 18,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 // Vehicle info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Vehicle No.',
//                         style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                           color: colorScheme.onSurfaceVariant,
//                           letterSpacing: 0.3,
//                         ),
//                       ),
//                       const SizedBox(height: 1),
//                       Text(
//                         value.vehicleNo?.toString() ?? '—',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w800,
//                           color: colorScheme.onSurface,
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Right: date + status badge
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     // Status badge
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 3),
//                       decoration: BoxDecoration(
//                         color: isOut
//                             ? colorScheme.secondaryContainer
//                             : colorScheme.primaryContainer,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         isOut ? 'Out' : 'Pending',
//                         style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700,
//                           color: isOut
//                               ? colorScheme.secondary
//                               : colorScheme.primary,
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     // Date
//                     Text(
//                       value.receiptDate != null
//                           ? DateFormat('dd MMM yy')
//                           .format(DateTime.parse(value.receiptDate!))
//                           : '',
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w500,
//                         color: colorScheme.onSurfaceVariant,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // ── Expanded item list ──
//           if (isListViewVisible) ...[
//             Divider(height: 1, color: colorScheme.outline.withOpacity(0.5)),
//             ListView.separated(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: value.itemDetails?.length ?? 0,
//               separatorBuilder: (_, __) => Divider(
//                 height: 1,
//                 color: colorScheme.outline.withOpacity(0.4),
//               ),
//               itemBuilder: (context, index) {
//                 final item = value.itemDetails![index];
//                 final stockInfo = getCurrentStcOfGodownKeeper.firstWhere(
//                       (stock) => stock.itemId == item.itemId,
//                   orElse: () => GetCurrentStcOfGodownKeeperModel(),
//                 );
//
//                 return Padding(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Item name + stock chip
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               item.itemName ?? '—',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w700,
//                                 color: colorScheme.onSurface,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 7, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: colorScheme.primaryContainer,
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               'Stk: ${stockInfo.currentStkEmpty ?? 0}',
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w700,
//                                 color: colorScheme.primary,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//
//                       // Qty details
//                       value.returnOn == "0001-01-01T00:00:00"
//                           ? _QtyRow(
//                         labels: const [
//                           'Filled Qty',
//                           'EMR Qty',
//                           'Invoice Qty'
//                         ],
//                         values: [
//                           item.filledQty?.toString() ?? '0',
//                           item.eMRQty?.toString() ?? '0',
//                           item.invoiceQty?.toString() ?? '0',
//                         ],
//                       )
//                           : _QtyRow(
//                         labels: const [
//                           'Empty Return',
//                           'Defective Return',
//                         ],
//                         values: [
//                           item.emptyReturnQty?.toString() ?? '0',
//                           item.defectiveReturnQty?.toString() ?? '0',
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//
//           // ── Footer: toggle + action buttons ──
//           Padding(
//             padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
//             child: Row(
//               children: [
//                 // View More / Less toggle
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       isListViewVisible = !isListViewVisible;
//                     });
//                   },
//                   borderRadius: BorderRadius.circular(8),
//                   child: Padding(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           isListViewVisible ? 'View Less' : 'View More',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: colorScheme.primary,
//                           ),
//                         ),
//                         const SizedBox(width: 2),
//                         Icon(
//                           isListViewVisible
//                               ? Icons.keyboard_arrow_up_rounded
//                               : Icons.keyboard_arrow_down_rounded,
//                           size: 18,
//                           color: colorScheme.primary,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 const Spacer(),
//
//                 // Action buttons — only when expanded & not returned
//                 if (isListViewVisible &&
//                     value.returnOn == "0001-01-01T00:00:00") ...[
//                   _IconActionButton(
//                     icon: Icons.local_shipping_rounded,
//                     color: colorScheme.primary,
//                     bg: colorScheme.primaryContainer,
//                     onPressed: () {
//                       if (saveFlag) {
//                         showFlushBar(context, Constants.dayEndCompleted);
//                       } else {
//                         if (stockTransferFlag) {
//                           var itemsToShow = value.itemDetails
//                               ?.where((item) => item.filledQty != 0)
//                               .toList();
//                           var receiptId = value.receiptId;
//                           showDetailsDialog(context, itemsToShow!, receiptId);
//                         } else {
//                           CustomAlertDialog.showCustomAlert(
//                               context, Constants.stockNotAccepted);
//                         }
//                       }
//                     },
//                   ),
//                   const SizedBox(width: 6),
//                   _IconActionButton(
//                     icon: Icons.edit_rounded,
//                     color: colorScheme.secondary,
//                     bg: colorScheme.secondaryContainer,
//                     onPressed: () {
//                       if (saveFlag) {
//                         showFlushBar(context, Constants.dayEndCompleted);
//                       } else {
//                         if (stockTransferFlag) {
//                           var itemsToShow = value.itemDetails?.toList();
//                           var receiptId = value.receiptId;
//                           var vehicleNo = value.vehicleNo.toString();
//                           var receiptDate = value.receiptDate.toString();
//                           if (itemsToShow != null && itemsToShow.isNotEmpty) {
//                             Navigator.pushNamed(
//                               context,
//                               ItemReceiptScreen.screenName,
//                               arguments: {
//                                 'vehicleNo': vehicleNo,
//                                 'receiptDate': receiptDate,
//                                 'itemsToShow': itemsToShow,
//                                 'modeChange': "Edit",
//                                 'receiptID': receiptId
//                               },
//                             );
//                           } else {
//                             showFlushBar(context, Constants.nodataFound);
//                           }
//                         } else {
//                           CustomAlertDialog.showCustomAlert(
//                               context, Constants.stockNotAccepted);
//                         }
//                       }
//                     },
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void showDetailsDialog(
//       BuildContext context, List<ItemDetails> items, num? receiptId) {
//     List<TextEditingController> returnQtyControllers = [];
//     List<TextEditingController> defectiveQtyControllers = [];
//
//     for (var item in items) {
//       returnQtyControllers
//           .add(TextEditingController(text: item.filledQty.toString()));
//       defectiveQtyControllers.add(TextEditingController(text: "0"));
//     }
//
//     final colorScheme = Theme.of(context).colorScheme;
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: Row(
//             children: [
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   color: colorScheme.primaryContainer,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(Icons.swap_horiz_rounded,
//                     color: colorScheme.primary, size: 20),
//               ),
//               const SizedBox(width: 10),
//               const Expanded(
//                 child: Text(
//                   'Item Return Details',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ],
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: items.asMap().map((index, item) {
//                 return MapEntry(
//                   index,
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: colorScheme.primaryContainer,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           item.itemName ?? '—',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: colorScheme.primary,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       TextFormField(
//                         controller: returnQtyControllers[index],
//                         decoration: InputDecoration(
//                           labelText: 'Return Qty',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: colorScheme.surfaceContainerHighest,
//                         ),
//                         keyboardType: TextInputType.number,
//                         enabled: false,
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: defectiveQtyControllers[index],
//                         decoration: InputDecoration(
//                           labelText: 'Defective Qty',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         keyboardType: TextInputType.number,
//                         onChanged: (newValue) {
//                           num? filledQty = items[index].filledQty;
//                           int defectiveQty = int.tryParse(newValue) ?? 0;
//                           int returnQty =
//                               int.tryParse(returnQtyControllers[index].text) ??
//                                   0;
//
//                           if (newValue.isEmpty) {
//                             returnQtyControllers[index].text =
//                                 filledQty.toString();
//                           } else if (defectiveQty > 0) {
//                             int? f = filledQty?.toInt();
//                             if (defectiveQty > filledQty!) {
//                               debugPrint("def3");
//                               showFlushBar(
//                                   context, Constants.defectiveQtyItemReturn);
//                             } else {
//                               int remainingReturnQty = f! - defectiveQty;
//                               returnQtyControllers[index].text =
//                                   remainingReturnQty.toString();
//                             }
//                           } else {
//                             returnQtyControllers[index].text =
//                                 filledQty.toString();
//                           }
//                           defectiveQtyControllers[index].text =
//                               defectiveQty.toString();
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       Divider(color: colorScheme.outline),
//                       const SizedBox(height: 4),
//                     ],
//                   ),
//                 );
//               }).values.toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text(
//                 'Close',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 14,
//                   color: colorScheme.onSurfaceVariant,
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 List<Map<String, dynamic>> updatedItemDetails = [];
//                 bool isValid = true;
//                 bool isValidDefStock = true;
//                 bool isValidEmptyStock = true;
//                 String errorMessage = "";
//
//                 for (int i = 0; i < items.length; i++) {
//                   int returnQty =
//                       int.tryParse(returnQtyControllers[i].text) ?? 0;
//                   int defectiveQty =
//                       int.tryParse(defectiveQtyControllers[i].text) ?? 0;
//                   num? filledQty = items[i].filledQty;
//
//                   GetCurrentStcOfGodownKeeperModel? currentStock =
//                   getCurrentStcOfGodownKeeper.firstWhere(
//                         (stock) => stock.itemId == items[i].itemId,
//                     orElse: () => GetCurrentStcOfGodownKeeperModel(),
//                   );
//
//                   num currentStkDef = currentStock.currentStkDefective ?? 0;
//                   num currentStkEmpty = currentStock.currentStkEmpty ?? 0;
//
//                   if (returnQty > currentStkEmpty) {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16)),
//                           title: const Text(""),
//                           content: Text(
//                             "The following items have a quantity greater than the available stock:\n\n" +
//                                 (items[i].itemName ?? ''),
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text("OK"),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                     isValidEmptyStock = false;
//                     debugPrint("def2");
//                     errorMessage =
//                     "Return quantity and EMR quantity cannot exceed the current stock for ${items[i].itemName}.";
//                     debugPrint("errorMessage$errorMessage");
//                     return;
//                   } else {
//                     if (defectiveQty > currentStkDef) {
//                       debugPrint("def1");
//                       showFlushBar(
//                           context, Constants.defectiveSaleQtyDailySale);
//                       isValidDefStock = false;
//                       errorMessage =
//                       "Defective qty exceeds current defective stock for this item, kindly check the qty entered or add defective stock.";
//                       return;
//                     }
//
//                     if (returnQty + defectiveQty > filledQty!) {
//                       showFlushBar(context, Constants.defectiveQtyItemReturn);
//                       isValid = false;
//                       errorMessage =
//                       "Defective quantity must be less than the return quantity.";
//                       return;
//                     }
//
//                     updatedItemDetails.add({
//                       "ItemId": items[i].itemId,
//                       "EmptyReturnQty": returnQty,
//                       "DefectiveQty": defectiveQty,
//                     });
//                   }
//                 }
//
//                 if (!isValidDefStock) {
//                   showFlushBar(context, Constants.defectiveSaleQtyDailySale);
//                 } else {
//                   if (!isValid) {
//                     showFlushBar(context, Constants.defectiveQtyItemReturn);
//                   } else {
//                     await sendItemDetailsToApi(updatedItemDetails, receiptId);
//                     if (mounted) {
//                       Navigator.of(context).pop();
//                     }
//                   }
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: colorScheme.primary,
//                 foregroundColor: colorScheme.onPrimary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               child: const Text(
//                 'Out',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> sendItemDetailsToApi(
//       List<Map<String, dynamic>> itemDetails, num? receiptId) async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       String distributorId = preferences.getString('DistributorId') ?? '';
//       String? addedBy = preferences.getString('StaffId');
//       String? token = preferences.getString('token');
//
//       final requestBody = json.encode({
//         "ReceiptId": receiptId,
//         "DistributorId": distributorId,
//         "AddedBy": addedBy,
//         "ItemDetails": itemDetails,
//       });
//
//       final response = await http.post(
//         Uri.parse(AppUrl.ItemReturnAddEdit),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: requestBody,
//       );
//
//       print("Request requestBodyItemReturnAddEdit: ${requestBody}");
//       if (response.statusCode == 200) {
//         Future.delayed(const Duration(milliseconds: 300), () {
//           if (!mounted) return;
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName);
//         });
//         print("Request successfulItemReturnAddEdit: ${response.body}");
//       } else {
//         print("Request failedItemReturnAddEdit: ${response.statusCode}");
//       }
//     } else {
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> fetchCurrentStock() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? addedBy = prefs.getString('StaffId');
//       String? godownKeeperId = prefs.getString('godownKeeperId');
//       String? token = prefs.getString('token');
//
//       try {
//         final response = await http.get(
//           Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         );
//         print("Request URL ItemCurrentStkList: ${response.request}");
//         print("Request Headers: {'Authorization': 'Bearer $token'}");
//         print("API Response Status ItemCurrentStkList: ${response.statusCode}");
//         print("API Response ItemCurrentStkList: ${response.body}");
//         if (response.statusCode == 200) {
//           final List<dynamic> data = json.decode(response.body);
//           setState(() {
//             getCurrentStcOfGodownKeeper = data
//                 .map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json))
//                 .toList();
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//           showFlushBar(context, Constants.listGettingFail);
//         }
//       } catch (e) {
//         setState(() {
//           isLoading = false;
//         });
//         showFlushBar(context, Constants.listGettingFail);
//       }
//     } else {
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
//
//   Future<void> checkAndSaveDayEndData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     String? StaffId = prefs.getString('StaffId');
//     int? staffIds = int.parse(StaffId!);
//     int? distributorIds = int.parse(distributorId!);
//     try {
//       final response = await http.get(
//         Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $bearerToken",
//         },
//       );
//       debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
//       debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
//       if (response.statusCode == 200) {
//         List<dynamic> apiResponse = json.decode(response.body);
//
//         if (apiResponse.isEmpty) {
//           saveFlag = false;
//           print("The list is empty, no data to save.");
//         } else {
//           saveFlag = true;
//           var dayEndData = apiResponse[0];
//           int DSRSaved = dayEndData['DSRSaved'] ?? 0;
//           int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
//           int OpClSaved = dayEndData['OpClSaved'] ?? 0;
//         }
//       } else {
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }
//
//   Future<void> fetchTransactionList() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? bearerToken = prefs.getString('token');
//       int dId = int.parse(distributorId!);
//       int gId = int.parse(godownId!);
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken',
//         },
//       );
//       debugPrint("GetStockTransferDtls" +
//           '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
//       debugPrint("GetStockTransferDtls" + response.body);
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _stockTransferList = data
//               .map((json) => GetStockTransferListModel.fromJson(json))
//               .toList();
//           bool hasZeroStkTrans = false;
//           for (int i = 0; i < _stockTransferList.length; i++) {
//             if (_stockTransferList[i].isStkTrans == 0) {
//               hasZeroStkTrans = true;
//               debugPrint("Found item with isStkTrans = 0");
//               break;
//             }
//           }
//           if (hasZeroStkTrans) {
//             stockTransferFlag = false;
//           } else {
//             stockTransferFlag = true;
//           }
//         });
//         isLoading = false;
//       } else {
//         refreshTokens();
//         isLoading = false;
//         throw Exception(Constants.listGettingFail);
//       }
//     } else {
//       refreshTokens();
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
//             fetchCurrentStock();
//             checkAndSaveDayEndData();
//             fetchTransactionList();
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
//         String title = "Expired";
//         String message = "Your session is expire. Click ok to login again.";
//         String btnLabel = "Ok";
//         return Platform.isIOS
//             ? WillPopScope(
//           onWillPop: () async {
//             SystemNavigator.pop();
//             return true;
//           },
//           child: CupertinoAlertDialog(
//             title: Text(title, style: Styling.bodyTitle),
//             content: Text(message, style: Styling.bodyTitle),
//             actions: <Widget>[
//               TextButton(
//                 child: Text(btnLabel, style: Styling.blueClrText),
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
// // ── Qty row widget ──
// class _QtyRow extends StatelessWidget {
//   const _QtyRow({required this.labels, required this.values});
//   final List<String> labels;
//   final List<String> values;
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Row(
//       children: List.generate(labels.length, (i) {
//         return Expanded(
//           child: Column(
//             crossAxisAlignment: i == 0
//                 ? CrossAxisAlignment.start
//                 : labels.length > 2 && i == labels.length ~/ 2
//                 ? CrossAxisAlignment.center
//                 : CrossAxisAlignment.end,
//             children: [
//               Text(
//                 labels[i],
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                   color: colorScheme.onSurfaceVariant,
//                   letterSpacing: 0.2,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 values[i],
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w800,
//                   color: colorScheme.onSurface,
//                   letterSpacing: -0.3,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
//
// // ── Icon action button ──
// class _IconActionButton extends StatelessWidget {
//   const _IconActionButton({
//     required this.icon,
//     required this.color,
//     required this.bg,
//     required this.onPressed,
//   });
//   final IconData icon;
//   final Color color;
//   final Color bg;
//   final VoidCallback onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: bg,
//       borderRadius: BorderRadius.circular(10),
//       child: InkWell(
//         onTap: () {
//           HapticFeedback.lightImpact();
//           onPressed();
//         },
//         borderRadius: BorderRadius.circular(10),
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Icon(icon, color: color, size: 18),
//         ),
//       ),
//     );
//   }
// }


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
import '../../BottomNavigationForGodownKeeper.dart';
import '../../DashboardScreen.dart';
import '../../DeliveryBoyModel/GetStockTransferListModel.dart';
import '../../SQCRegister/SQCRegisterScreen.dart';
import '../AddItem/ItemReceiptScreen.dart';
import '../CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
import '../EditItem/Model/GetItemReceiptListModel.dart';
import 'package:http/http.dart' as http;

// ── Design-system imports ──────────────────────────────────────────────
import '../../../Utils/styles/app_colors.dart';
import '../../../Utils/styles/app_spacing.dart';
import '../../../Utils/styles/app_text_styles.dart';

class ItemReturnScreenListItem extends StatefulWidget {
  GetItemReceiptListModel _listModel;

  ItemReturnScreenListItem(this._listModel, {Key? key}) : super(key: key);

  @override
  State<ItemReturnScreenListItem> createState() =>
      _ItemReturnScreenListItemState();
}

class _ItemReturnScreenListItemState extends State<ItemReturnScreenListItem> {
  bool isListViewVisible = false;
  List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
  bool isLoading = true;
  bool saveFlag = false;
  bool stockTransferFlag = false;
  List<GetStockTransferListModel> _stockTransferList = [];
  String? mobileNo;

  @override
  void initState() {
    super.initState();
    fetchCurrentStock();
    checkAndSaveDayEndData();
    fetchTransactionList();
  }

  // ─────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final value = widget._listModel;

    if (value == null || value == "") {
      return const SizedBox.shrink();
    }

    final bool isPending = value.returnOn == "0001-01-01T00:00:00";
    final String formattedDate = value.receiptDate != null
        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(value.receiptDate!))
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(AppOpacity.cardShadow),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(
            color: isPending ? AppColors.primary : AppColors.teal,
            width: 4,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Card header ──────────────────────────────────
            _buildCardHeader(value, formattedDate, isPending),

            // ── Expanded item list ───────────────────────────
            Flexible(
              fit: FlexFit.loose,
              child: Visibility(
                visible: isListViewVisible,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: value.itemDetails?.length,
                  itemBuilder: (context, index) {
                    final item = value.itemDetails![index];
                    final stockInfo = getCurrentStcOfGodownKeeper.firstWhere(
                          (stock) => stock.itemId == item.itemId,
                      orElse: () => GetCurrentStcOfGodownKeeperModel(),
                    );
                    return isPending
                        ? _ItemRowPending(item: item, stockInfo: stockInfo)
                        : _ItemRowReturned(item: item, stockInfo: stockInfo);
                  },
                ),
              ),
            ),

            // ── Card footer: expand toggle + actions ─────────
            _buildCardFooter(value, isPending),
          ],
        ),
      ),
    );
  }

  // ── Card header widget ────────────────────────────────────────────────
  Widget _buildCardHeader(
      GetItemReceiptListModel value,
      String formattedDate,
      bool isPending,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Vehicle number
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primaryXLight,
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                "Vehicle No. - ${value.vehicleNo}",
                style: AppTextStyles.cardTitle,
              ),
            ],
          ),

          // Status badge + date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isPending
                      ? AppColors.primaryXLight
                      : AppColors.tealXLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPending ? "Pending" : "Returned",
                  style: AppTextStyles.labelSm.copyWith(
                    color: isPending ? AppColors.primary : AppColors.teal,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Receipt date
              Text(
                formattedDate,
                style: AppTextStyles.itemReturnDateText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Card footer widget ────────────────────────────────────────────────
  Widget _buildCardFooter(GetItemReceiptListModel value, bool isPending) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm, 2, AppSpacing.sm, AppSpacing.sm),
      child: Row(
        children: [
          // View More / View Less toggle
          GestureDetector(
            onTap: () {
              setState(() {
                isListViewVisible = !isListViewVisible;
              });
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xs, horizontal: AppSpacing.xs),
              child: Row(
                children: [
                  Text(
                    isListViewVisible ? "View Less" : "View More",
                    style: AppTextStyles.itemReturnViewToggle.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Icon(
                    isListViewVisible
                        ? Icons.arrow_drop_up_rounded
                        : Icons.arrow_drop_down_rounded,
                    size: 22,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Out button (ship icon) — only when expanded and pending
          if (isListViewVisible && isPending) ...[
            _ActionIconButton(
              icon: Icons.local_shipping_outlined,
              color: AppColors.primary,
              bgColor: AppColors.primaryXLight,
              onPressed: () {
                if (saveFlag) {
                  showFlushBar(context, Constants.dayEndCompleted);
                } else {
                  if (stockTransferFlag) {
                    var itemsToShow = value.itemDetails
                        ?.where((item) => item.filledQty != 0)
                        .toList();
                    var receiptId = value.receiptId;
                    showDetailsDialog(context, itemsToShow!, receiptId);
                  } else {
                    CustomAlertDialog.showCustomAlert(
                        context, Constants.stockNotAccepted);
                  }
                }
              },
            ),
            const SizedBox(width: AppSpacing.xs),

            // Edit button
            _ActionIconButton(
              icon: Icons.edit_outlined,
              color: AppColors.primary,
              bgColor: AppColors.primaryXLight,
              onPressed: () {
                if (saveFlag) {
                  showFlushBar(context, Constants.dayEndCompleted);
                } else {
                  if (stockTransferFlag) {
                    var itemsToShow = value.itemDetails?.toList();
                    var receiptId = value.receiptId;
                    var vehicleNo = value.vehicleNo.toString();
                    var receiptDate = value.receiptDate.toString();
                    if (itemsToShow != null && itemsToShow.isNotEmpty) {
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
                      showFlushBar(context, Constants.nodataFound);
                    }
                  } else {
                    CustomAlertDialog.showCustomAlert(
                        context, Constants.stockNotAccepted);
                  }
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // DETAILS DIALOG
  // ─────────────────────────────────────────────────────────────────────
  void showDetailsDialog(
      BuildContext context, List<ItemDetails> items, num? receiptId) {
    List<TextEditingController> returnQtyControllers = [];
    List<TextEditingController> defectiveQtyControllers = [];

    for (var item in items) {
      returnQtyControllers
          .add(TextEditingController(text: item.filledQty.toString()));
      defectiveQtyControllers.add(TextEditingController(text: "0"));
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.dialog.topLeft.x),
          ),
          titlePadding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
          title: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.primaryXLight,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const Icon(
                  Icons.assignment_return_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('Item Return Details', style: AppTextStyles.cardTitle),
            ],
          ),
          contentPadding: const EdgeInsets.all(AppSpacing.lg),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items.asMap().map((index, item) {
                return MapEntry(
                  index,
                  _ItemReturnDialogRow(
                    item: item,
                    returnQtyController: returnQtyControllers[index],
                    defectiveQtyController: defectiveQtyControllers[index],
                    onDefectiveChanged: (newValue) {
                      num? filledQty = items[index].filledQty;
                      int defectiveQty = int.tryParse(newValue) ?? 0;

                      if (newValue.isEmpty) {
                        returnQtyControllers[index].text =
                            filledQty.toString();
                      } else if (defectiveQty > 0) {
                        int? f = filledQty?.toInt();
                        if (defectiveQty > filledQty!) {
                          debugPrint("def3");
                          showFlushBar(
                              context, Constants.defectiveQtyItemReturn);
                        } else {
                          int remainingReturnQty = f! - defectiveQty;
                          returnQtyControllers[index].text =
                              remainingReturnQty.toString();
                        }
                      } else {
                        returnQtyControllers[index].text =
                            filledQty.toString();
                      }
                      defectiveQtyControllers[index].text =
                          defectiveQty.toString();
                    },
                  ),
                );
              }).values.toList(),
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textMuted,
                side: const BorderSide(color: AppColors.border),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              ),
              child: Text(
                "Close",
                style: AppTextStyles.button.copyWith(color: AppColors.textMid),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                List<Map<String, dynamic>> updatedItemDetails = [];
                bool isValid = true;
                bool isValidDefStock = true;
                bool isValidEmptyStock = true;
                String errorMessage = "";

                for (int i = 0; i < items.length; i++) {
                  int returnQty =
                      int.tryParse(returnQtyControllers[i].text) ?? 0;
                  int defectiveQty =
                      int.tryParse(defectiveQtyControllers[i].text) ?? 0;
                  num? filledQty = items[i].filledQty;

                  GetCurrentStcOfGodownKeeperModel? currentStock =
                  getCurrentStcOfGodownKeeper.firstWhere(
                        (stock) => stock.itemId == items[i].itemId,
                    orElse: () => GetCurrentStcOfGodownKeeperModel(),
                  );

                  num currentStkDef = currentStock.currentStkDefective ?? 0;
                  num currentStkEmpty = currentStock.currentStkEmpty ?? 0;

                  if (returnQty > currentStkEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return
                        //   AlertDialog(
                        //   title: const Text(""),
                        //   content: Text(
                        //     "The following items have a quantity greater than the available stock:\n\n" +
                        //         (items[i].itemName ?? ''),
                        //   ),
                        //   actions: [
                        //     TextButton(
                        //       onPressed: () => Navigator.pop(context),
                        //       child: const Text("OK"),
                        //     ),
                        //   ],
                        // );
                               Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.red,
                                      size: 26,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  const Text(
                                    "Stock Alert",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111827),
                                    ),
                                    textScaler: TextScaler.noScaling,
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    "The following items have a quantity greater than the available stock:\n\n${items[i].itemName ?? ''}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF6B7280),
                                    ),
                                    textScaler: TextScaler.noScaling,
                                  ),

                                  const SizedBox(height: 20),

                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.blue,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 13),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "OK",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                        textScaler: TextScaler.noScaling,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                      },
                    );
                    isValidEmptyStock = false;
                    debugPrint("def2");
                    errorMessage =
                    "Return quantity and EMR quantity cannot exceed the current stock for ${items[i].itemName}.";
                    debugPrint("errorMessage$errorMessage");
                    return;
                  } else {
                    if (defectiveQty > currentStkDef) {
                      debugPrint("def1");
                      showFlushBar(
                          context, Constants.defectiveSaleQtyDailySale);
                      isValidDefStock = false;
                      errorMessage =
                      "Defective qty exceeds current defective stock for this item, kindly check the qty entered or add defective stock.";
                      return;
                    }

                    if (returnQty + defectiveQty > filledQty!) {
                      showFlushBar(context, Constants.defectiveQtyItemReturn);
                      isValid = false;
                      errorMessage =
                      "Defective quantity must be less than the return quantity.";
                      return;
                    }

                    updatedItemDetails.add({
                      "ItemId": items[i].itemId,
                      "EmptyReturnQty": returnQty,
                      "DefectiveQty": defectiveQty,
                    });
                  }
                }

                if (!isValidDefStock) {
                  showFlushBar(context, Constants.defectiveSaleQtyDailySale);
                } else {
                  if (!isValid) {
                    showFlushBar(context, Constants.defectiveQtyItemReturn);
                  } else {
                    await sendItemDetailsToApi(updatedItemDetails, receiptId);
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                elevation: 0,
              ),
              child: Text(
                "Out",
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // API / BUSINESS LOGIC — unchanged
  Future<void> fetchCurrentStock() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token');

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        print("Request URL ItemCurrentStkList: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        print("API Response Status ItemCurrentStkList: ${response.statusCode}");
        print("API Response ItemCurrentStkList: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getCurrentStcOfGodownKeeper = data
                .map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json))
                .toList();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showFlushBar(context, Constants.listGettingFail);
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
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
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
      );
      debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
      debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
      if (response.statusCode == 200) {
        List<dynamic> apiResponse = json.decode(response.body);

        if (apiResponse.isEmpty) {
          saveFlag = false;
          print("The list is empty, no data to save.");
        } else {
          saveFlag = true;
          var dayEndData = apiResponse[0];
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> sendItemDetailsToApi(
      List<Map<String, dynamic>> itemDetails, num? receiptId) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String distributorId = preferences.getString('DistributorId') ?? '';
      String? addedBy = preferences.getString('StaffId');
      String? token = preferences.getString('token');

      final requestBody = json.encode({
        "ReceiptId": receiptId,
        "DistributorId": distributorId,
        "AddedBy": addedBy,
        "ItemDetails": itemDetails,
      });

      final response = await http.post(
        Uri.parse(AppUrl.ItemReturnAddEdit),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print("Request requestBodyItemReturnAddEdit: ${requestBody}");
      if (response.statusCode == 200) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName);
        });
        print("Request successfulItemReturnAddEdit: ${response.body}");
      } else {
        print("Request failedItemReturnAddEdit: ${response.statusCode}");
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }


  Future<void> fetchTransactionList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? bearerToken = prefs.getString('token');
      int dId = int.parse(distributorId!);
      int gId = int.parse(godownId!);
      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint("GetStockTransferDtls" +
          '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
      debugPrint("GetStockTransferDtls" + response.body);
      if (response.statusCode == 200) {
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
              break;
            }
          }
          if (hasZeroStkTrans) {
            stockTransferFlag = false;
          } else {
            stockTransferFlag = true;
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
      showFlushBar(context, Constants.connectionMessage);
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
            title: Text(title, style: Styling.bodyTitle),
            content: Text(message, style: Styling.bodyTitle),
            actions: <Widget>[
              TextButton(
                child: Text(btnLabel, style: Styling.blueClrText),
                onPressed: () => logoutUser(context),
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

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE SUB-WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

/// Item row shown when vehicle is still pending (returnOn == default).
class _ItemRowPending extends StatelessWidget {
  const _ItemRowPending({required this.item, required this.stockInfo});

  final ItemDetails item;
  final GetCurrentStcOfGodownKeeperModel stockInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 2),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item name + current stock
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Item: ${item.itemName}",
                    style: AppTextStyles.itemReturnItemName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StockChip(
                  label: "Stock",
                  value: "${stockInfo.currentStkEmpty ?? 0}",
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Qty labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filled Qty', style: AppTextStyles.itemReturnQtyLabel),
                Text('EMR Qty', style: AppTextStyles.itemReturnQtyLabel),
                Text('Invoice Qty', style: AppTextStyles.itemReturnQtyLabel),
              ],
            ),
            const SizedBox(height: 4),
            // Qty values
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.filledQty}',
                  style: AppTextStyles.itemReturnQtyValue,
                ),
                Text(
                  '${item.eMRQty}',
                  style: AppTextStyles.itemReturnQtyValue,
                ),
                Text(
                  '${item.invoiceQty}',
                  style: AppTextStyles.itemReturnQtyValue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Item row shown when vehicle has already returned.
class _ItemRowReturned extends StatelessWidget {
  const _ItemRowReturned({required this.item, required this.stockInfo});

  final ItemDetails item;
  final GetCurrentStcOfGodownKeeperModel stockInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 2),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item name + current stock
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Item: ${item.itemName}",
                    style: AppTextStyles.itemReturnItemName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StockChip(
                  label: "Stock",
                  value: "${stockInfo.currentStkEmpty}",
                  color: AppColors.teal,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Qty labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Empty Return Qty', style: AppTextStyles.itemReturnQtyLabel),
                Text('Defective Return Qty', style: AppTextStyles.itemReturnQtyLabel),
              ],
            ),
            const SizedBox(height: 4),
            // Qty values
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.emptyReturnQty}',
                  style: AppTextStyles.itemReturnQtyValue,
                ),
                Text(
                  '${item.defectiveReturnQty}',
                  style: AppTextStyles.itemReturnQtyValue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Small colored chip showing a stock value.
class _StockChip extends StatelessWidget {
  const _StockChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        "$label: $value",
        style: AppTextStyles.labelSm.copyWith(color: color),
      ),
    );
  }
}

/// Small icon-only action button (ship / edit).
class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

/// A single item row inside the "Details for Items Return" dialog.
class _ItemReturnDialogRow extends StatelessWidget {
  const _ItemReturnDialogRow({
    required this.item,
    required this.returnQtyController,
    required this.defectiveQtyController,
    required this.onDefectiveChanged,
  });

  final ItemDetails item;
  final TextEditingController returnQtyController;
  final TextEditingController defectiveQtyController;
  final ValueChanged<String> onDefectiveChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item name badge row
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined,
                    color: AppColors.primary, size: 15),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.itemName ?? '',
                    style: AppTextStyles.itemReturnDialogItemName.copyWith(
                      color: AppColors.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Return Qty (read-only)
          TextFormField(
            controller: returnQtyController,
            decoration: InputDecoration(
              labelText: 'Return Qty',
              labelStyle:
              AppTextStyles.labelMd.copyWith(color: AppColors.textMuted),
            ),
            keyboardType: TextInputType.number,
            enabled: false,
          ),
          const SizedBox(height: AppSpacing.sm),
          // Defective Qty
          TextFormField(
            controller: defectiveQtyController,
            decoration: InputDecoration(
              labelText: 'Defective',
              labelStyle:
              AppTextStyles.labelMd.copyWith(color: AppColors.textMuted),
            ),
            keyboardType: TextInputType.number,
            onChanged: onDefectiveChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.divider, height: 1),
        ],
      ),
    );
  }
}