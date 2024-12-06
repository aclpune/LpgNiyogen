import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    var value = widget._listModel;
    return
      Card(
      child: SingleChildScrollView(  // Make the Column scrollable
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Set min to shrink-wrap the Column
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0,top: 5),
                    child: Text("Vehicle No. - "+value.vehicleNo.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  ),
                  value.returnOn =="0001-01-01T00:00:00"?
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      var itemsToShow = value.itemDetails?.where(
                            (item) => item.filledQty != 0,
                      ).toList();
                      var receiptId = value.receiptId;
                      if (itemsToShow != null && itemsToShow.isNotEmpty) {
                        showDetailsDialog(context, itemsToShow,receiptId);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No items with isReturnSent == 0')),
                        );
                      }
                    },
                    child: Text("Out"),
                  ):
                      Text(""),
                ],
              ),
            ),
            // Use Flexible instead of Expanded
            Flexible(
              fit: FlexFit.loose,  // Allow ListView to take only as much space as it needs
              child: Visibility(
                visible: isListViewVisible,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,  // Shrink-wrap ListView to fit within available space
                  itemCount: value.itemDetails?.length,
                  itemBuilder: (context, index) {
                    final item = value.itemDetails![index];
                    return value.returnOn == "0001-01-01T00:00:00"
                        ? Container(
                      margin: EdgeInsets.all(2.0),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("Item name: ${item.itemName}",style: TextStyle(fontWeight:FontWeight.bold)),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.all(5.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text('Filled Qty: ${item.filledQty}'),
                              //       Text('EMR Qty: ${item.eMRQty}'),
                              //       Text('Invoice Qty: ${item.invoiceQty}'),
                              //     ],
                              //   ),
                              // ),
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
                          child: Text("Item name: ${item.itemName}",style: TextStyle(fontWeight:FontWeight.bold)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("View More"),
                IconButton(
                  icon: Icon(
                    isListViewVisible ? Icons.keyboard_arrow_up_sharp : Icons.keyboard_arrow_down_sharp,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      isListViewVisible = !isListViewVisible; // Toggle ListView visibility
                    });
                  },
                ),
              ],
            ),
          ],
        ),

      ),
    );
  }


  // void showDetailsDialog(BuildContext context, List<ItemDetails> items) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Details for Items Return'),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: items.map((item) {
  //               return Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text("Item Name: ${item.itemName}"),
  //                   Text("Return Qty: ${item.invoiceQty}"),
  //                   Text("Defective: ${item.eMRQty}"),
  //                   Divider(),
  //                 ],
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text("Close"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               // Handle the "Out" action for the items if needed
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text("Out"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
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
                            // If defective quantity is a valid number, subtract it from the filled quantity
                            int remainingReturnQty = f! - defectiveQty;
                            returnQtyControllers[index].text = remainingReturnQty.toString();
                          } else {
                            // Handle invalid inputs, revert to filled quantity if input is invalid
                            returnQtyControllers[index].text = filledQty.toString();
                          }

                          // Update the defective quantity controller
                          defectiveQtyControllers[index].text = defectiveQty.toString();
                        },
                      ),
                      // TextFormField(
                      //   controller: defectiveQtyControllers[index],
                      //   decoration: InputDecoration(labelText: 'Defective'),
                      //   keyboardType: TextInputType.number,
                      // ),
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
              child: Text("Close"),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     // Gather the updated item details, including ItemId, ReturnQty, and DefectiveQty
            //     List<Map<String, dynamic>> updatedItemDetails = [];
            //     for (int i = 0; i < items.length; i++) {
            //       updatedItemDetails.add({
            //         "ItemId": items[i].itemId,
            //         "EmptyReturnQty": int.tryParse(returnQtyControllers[i].text) ?? 0,
            //         "DefectiveQty": int.tryParse(defectiveQtyControllers[i].text) ?? 0,
            //       });
            //     }
            //
            //     // Send the data to the API
            //     await sendItemDetailsToApi(updatedItemDetails, receiptId);
            //
            //     Navigator.of(context).pop(); // Close the dialog
            //   },
            //   child: Text("Out"),
            // ),
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

                  updatedItemDetails.add({
                    "ItemId": items[i].itemId,
                    "EmptyReturnQty": returnQty,
                    "DefectiveQty": defectiveQty,
                  });
                }

                // If validation fails, show an error message
                if (!isValid) {
                  // Display the error message as a SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
                } else {
                  // Send the data to the API if validation is successful
                  await sendItemDetailsToApi(updatedItemDetails, receiptId);

                  // Close the dialog
                  Navigator.of(context).pop();
                }
              },
              child: Text("Out"),
            ),
          ],
        );
      },
    );
  }
  Future<void> sendItemDetailsToApi(List<Map<String, dynamic>> itemDetails, num? receiptId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String distributorId = preferences.getString('distributorId') ?? '';
    String? addedBy = preferences.getString('userId');
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
      print("Request successful: ${response.body}");
    } else {
      // Handle failure response
      print("Request failed: ${response.statusCode}");
    }
  }

// Function to send data to the API
//   Future<void> sendItemDetailsToApi(List<Map<String, dynamic>> itemDetails, num? receiptId) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//    String DistributorIds = preferences.getString('distributorId').toString();
//     // Construct the request body
//     final requestBody = json.encode({
//       "ReceiptId": receiptId,
//       "DistributorId": DistributorIds,
//       "AddedBy": 4,
//       "ItemDetails": itemDetails,
//     });
//
//     // Send the HTTP POST request
//     final response = await http.post(
//       Uri.parse(AppUrl.ItemReturnAddEdit),
//       headers: {'Content-Type': 'application/json'},
//       body: requestBody,
//     );
//     print("Request requestBody: ${requestBody}");
//     if (response.statusCode == 200) {
//       // Handle successful response (for example, show a success message)
//       print("Request successful: ${response.body}");
//     } else {
//       // Handle failure response (for example, show an error message)
//       print("Request failed: ${response.statusCode}");
//     }
//   }
}
