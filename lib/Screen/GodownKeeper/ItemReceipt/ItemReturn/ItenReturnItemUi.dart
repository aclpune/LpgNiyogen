import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ConstantScreen/widgets.dart';
import '../../../Utils/constants.dart';
import '../../DashboardScreen.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCurrentStock();
    checkAndSaveDayEndData();
  }
  @override
  Widget build(BuildContext context) {
    var value = widget._listModel;
    return
    value != null && value != ""?
      Card(
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
                    padding: const EdgeInsets.only(left: 10.0,top: 5),
                    child: Text("Vehicle No. - "+value.vehicleNo.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  ),
                  value.returnOn =="0001-01-01T00:00:00"?
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: saveFlag ? Colors.grey:Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if(saveFlag){

                      }else{
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
                                return AlertDialog(
                                  title: Text("Invalid Quantity"),
                                  content: Text(
                                    "The following items have a filled quantity greater than the available stock:\n\n" +
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
                          showFlushBar(context, "No Items Available", 'No Items For Return.');
                        }
                      }

                    },
                    child: Text("Out"),
                  ) :


                      Text(""),
                  value.returnOn =="0001-01-01T00:00:00"?
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: saveFlag ? Colors.grey:Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if(saveFlag){

                      }else{
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
                              'modeChange' : "Edit",
                              'receiptID' : receiptId

                            },
                          );
                        } else {
                          showFlushBar(context, "No Items Available", 'No Items For Return.');
                        }
                      }

                    },
                    child: Text("Edit"),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isListViewVisible ? "View Less" :"View More"),
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
                              showFlushBar(context, "Invalid Quantity",
                                  'Defective Qty Must Be Small Than Return Quantity!');
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
                  showFlushBar(context, "Invalid Quantity",
                      '$errorMessage');
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
      showFlushBar(context,Constants.connectionTitle,
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
          showFlushBar(context, "Fail",
              'Unable To Load Data At This Time. Please Try Again');
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        showFlushBar(context, "Fail",
            'Unable To Load Data At This Time. Please Try Again');
      }
    }else{
      showFlushBar(context,Constants.connectionTitle,
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

}
