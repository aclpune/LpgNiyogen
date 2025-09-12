import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantScreen/widgets.dart';
import '../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
import '../ManagerScreen/BootomNavigatinBarManager.dart';
import '../ManagerScreen/ManagerModelClass/GetUndocSVStockMovementList.dart';
import '../Utils/Styling.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';

class DashboardUndocumentedDetails extends StatefulWidget {
  static const screenName = '/dashboardUndocumentedDetails';
  @override
  State<StatefulWidget> createState() {
    return _DashboardUndocumentedDetails();
  }
}

class _DashboardUndocumentedDetails extends State<DashboardUndocumentedDetails>{
  String? formattedDate;
  bool isLoading = true;
  List<CylItemListModel> _items = [];
  CylItemListModel? _selectedItemModel;
  String? _selectedItem;
  int? selectedItemId;
  final CylItemListModel allItem = CylItemListModel(itemId: -1, itemName: "ALL");
  List<GetUndocSvStockMovementList> undocumentedSVModel = [];
  double? totalAmount;
  // TextEditingController _consumerNoController = TextEditingController();
  bool isChecked = false;
  bool isTextEntered = false;
  String? errorMessage;
  late List<String> selectedConsumerNos;
  bool isCheckboxEnabled = true; // Default to true, enabling checkboxes
  List<TextEditingController> _consumerNoControllers = [];
  List<bool> isCheckedList = [];
  List<bool> isTextEnteredList = [];

  @override
  void dispose() {
    // Dispose of each controller when the widget is disposed
    for (var controller in _consumerNoControllers) {
      controller.dispose();
    }
    super.dispose();  // Don't forget to call the superclass's dispose method
  }
  void addItem() {
    setState(() {
      // Add a new TextEditingController to the list
      _consumerNoControllers.add(TextEditingController());

      // Add corresponding states for Checkbox and TextField
      isCheckedList.add(false);  // Default state for checkbox
      isTextEnteredList.add(false);  // Default state for text entered
    });
  }


  @override
  void initState() {
    super.initState();
    fetchItems();
    _selectedItemModel = allItem;
    getUndocSVStockMovementList(0);
    _calculateTotalAmount();
    DateTime now = DateTime.now().toUtc();
    formattedDate = now.toIso8601String();
    addItem();
  }
  String nullToDash(String? value) {
    if (value == null || value.toLowerCase() == "null") {
      return "-";  // If value is null or the string "null", replace with '-'
    }
    return value;  // If not null or "null", return the original value
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    var itemCount = undocumentedSVModel.length;
    return
      WillPopScope(
        onWillPop: () async {
      // Show a confirmation dialog
      if (argLRAdd == "fromDrawer") {
        Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
        return false;
      } else {
        Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
        return false;
      } // In case `null` is returned, return `false`
    },
    child:
    Scaffold(
      appBar:
      AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                   // Navigator.pop(context);
                    Navigator.pushNamed(context, BottomNavBarExample.screenName);
                  },
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Undocumented SV',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total: ${formatCurrency(totalAmount!)}',
                              style: TextStyle(fontSize: 14, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'Count: $itemCount',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body:
        Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child:
            Row(
              children: [
                Text("Select Item:",style: Styling.blueClrText),
                Expanded(
                  child:
                  DropdownButtonFormField<CylItemListModel>(
                    decoration: buildInputBorderUpdateStatus("ALL", context),
                    value: _selectedItemModel,
                    items: [
                      DropdownMenuItem<CylItemListModel>(
                        value: allItem,
                        child: Text(
                          "ALL",
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                        ),
                      ),
                      ..._items.map((CylItemListModel item) {
                        return DropdownMenuItem<CylItemListModel>(
                          value: item,
                          child: Text(
                            item.itemName ?? '',
                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                          ),
                        );
                      }).toList(),
                    ],
                      onChanged: (CylItemListModel? selectedItem) {
                        if (selectedItem != null) {
                          setState(() {
                            _selectedItemModel = selectedItem;

                            // Ensure lists have the same length
                            if (_consumerNoControllers.length == isCheckedList.length &&
                                isCheckedList.length == isTextEnteredList.length) {

                              if (selectedItem.itemId == -1) {
                                // "ALL" is selected, disable checkboxes and reset all states
                                isCheckboxEnabled = false;

                                // Clear all TextEditingControllers
                                for (var controller in _consumerNoControllers) {
                                  controller.clear();
                                }

                                // Reset all checkboxes to false
                                for (int i = 0; i < isCheckedList.length; i++) {
                                  isCheckedList[i] = false;
                                }

                                // Reset text field states as well
                                for (int i = 0; i < isTextEnteredList.length; i++) {
                                  isTextEnteredList[i] = false;
                                }

                                // Fetch the list for "ALL" selection
                                getUndocSVStockMovementList(0);

                              } else {
                                // Specific item is selected, enable checkboxes
                                isCheckboxEnabled = true;

                                // Clear all TextEditingControllers
                                for (var controller in _consumerNoControllers) {
                                  controller.clear();
                                }

                                // Reset all checkboxes to false
                                for (int i = 0; i < isCheckedList.length; i++) {
                                  isCheckedList[i] = false;
                                }

                                // Reset all text field states for all items
                                for (int i = 0; i < isTextEnteredList.length; i++) {
                                  isTextEnteredList[i] = false;
                                }

                                // Find the index for the selected item and reset only its state if necessary
                                int selectedIndex = _items.indexWhere((item) => item.itemId == selectedItem.itemId);
                                if (selectedIndex != -1 && selectedIndex < isTextEnteredList.length) {
                                  // Reset selected item's text entry state
                                  isTextEnteredList[selectedIndex] = false;
                                }

                                // Fetch the list for the selected item
                                getUndocSVStockMovementList(selectedItem.itemId?.toInt() ?? 0);
                              }
                            } else {
                              print("Error: Lists have mismatched lengths!");
                            }
                          });
                          print("Selected item: ${selectedItem.itemName}");
                          print("Item ID: ${selectedItem.itemId}");
                          print("Text field controllers: $_consumerNoControllers");
                          print("Checkbox state: $isCheckedList");
                        }
                      },
                      hint: Text('ALL'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:isLoading
                ? Center(child: CircularProgressIndicator()) // Show loader when isLoading is true
                : undocumentedSVModel.isNotEmpty
                ?
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: undocumentedSVModel.length,
              itemBuilder: (context, index) {
                debugPrint("Rendering Expense Item: ${undocumentedSVModel[index]}");
                GetUndocSvStockMovementList? sale = undocumentedSVModel[index];

                // Ensure consumer controllers have the right number of elements
                if (_consumerNoControllers.length <= index) {
                  _consumerNoControllers.add(TextEditingController());
                  isCheckedList.add(false); // Default checkbox state
                  isTextEnteredList.add(false); // Default text state
                }
                return Card(
                    elevation: 4.0, // Add elevation for shadow
                    margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2.0), // Margin around the card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0), // Rounded corners for card
                    ),
                    child: Padding(
                    padding: EdgeInsets.all(12.0), // Padding inside the card
                child:
                  Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 0,
                            child: countTextWidgetTextWithoutHeading(
                                context, DateFormat('dd-MM-yyyy').format(DateTime.parse(sale.sVDate ?? '')))),
                        Expanded(flex: 0, child: countTextWidgetTextWithoutHeading(context, nullToDash(sale.itemName))),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded( child: countTextWidgetTextOnAccount(context, "DC.No/Challan No.", nullToDash(sale.consuDCNo))),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: countTextWidgetText(context, "Doc. Status", nullToDash(sale.isUndocument == true ? "Pending" : (sale.isUndocument == false ? "Received" : ""))),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(flex: 1, child: countTextWidgetText(context, "SV Type", nullToDash(sale.sVType))),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(flex: 1, child: countTextWidgetText(context, "Total Amount", nullToDash(formatCurrency((sale.totalAmount ?? 0.0).toDouble())))),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(flex: 1, child: countTextWidgetText(context, "Cyl. Qty.", nullToDash(sale.cylQty.toString()))),
                        Expanded(
                          flex: 1,
                          child:
                          TextField(
                            controller: _consumerNoControllers[index],
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(6),
                              FilteringTextInputFormatter.digitsOnly, // Allow only digits
                            ],
                            decoration: InputDecoration(
                              labelText: 'Consumer No.',  // Dynamic label for each index
                              labelStyle: TextStyle(
                                fontSize: 10.0,
                              ),
                              isDense: true, // Reduces the height of the TextField
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0), // Reduce vertical space
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                isTextEnteredList[index] = value.isNotEmpty;
                                // If text is cleared, optionally reset checkbox for this index
                                if (!isTextEnteredList[index]) {
                                  isCheckedList[index] = false;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: countTextWidgetText(
                            context,
                            "Con Name",
                            nullToDash(sale.consumerName),
                          ),
                        ),
                        Checkbox(
                          value: isCheckedList[index], // Bind checkbox value to the list
                          onChanged: isTextEnteredList[index] && isCheckboxEnabled
                              ? (bool? value) {
                            setState(() {
                              isCheckedList[index] = value ?? false;  // Update checkbox state
                            });
                          }
                              : null, // Disable the checkbox if the text field is empty or checkboxes are disabled
                          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                            return states.contains(MaterialState.selected)
                                ? Colors.pink
                                : Colors.white;
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              );
               },
            )
                : Center(
              child: Text('No Records Found'),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 15.0,bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    cancelAction();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Adds space between buttons
                ElevatedButton(
                  onPressed: () {
                    verifyUnDocSVDetailsMob();
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10, // Adjust padding to make button smaller
                    ),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    //  ),
    ),
   );
  }

  Future<void> fetchItems() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken =
      prefs.getString('token'); // Assuming the token is stored here

      if (bearerToken == null) {
        throw Exception('Bearer Token Is Missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/c'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );
      debugPrint("item" + '${AppUrl.GetItemMasterList}/$distributorId/1/c');
      debugPrint("item" + response.body);
      if (response.statusCode == 200) {
        // Parse the response
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
        });
      } else {
        throw Exception('Unable To Load Data At This Time. Please Try Again');
      }
    } else {
      showFlushBar(
          context,Constants.connectionMessage);
    }
  }

  Future<void> getUndocSVStockMovementList(int itemId) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');
        String? userId = prefs.getString("UserId");
        String? addedBy = prefs.getString('StaffId');


        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        Map<String, dynamic> requestBody = {
          "DistributorId": distributorId,
          "ItemId": itemId,
        };

        final response = await http.post(
          Uri.parse('${AppUrl.GetUndocSVStockMovementList}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            // Ensure the request body is JSON
          },
          body: json.encode(requestBody), // Encode the request body as JSON
        );

        debugPrint("Response body GetUndocSVStockMovementList: ${response.body}");
        debugPrint("Request body GetUndocSVStockMovementList: ${response.request}${requestBody}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            undocumentedSVModel = data.map((jsonItem) =>
                GetUndocSvStockMovementList.fromJson(jsonItem)).toList();
            _calculateTotalAmount();
            isLoading = false;
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
      }
    }
  }

  void _calculateTotalAmount() {
    // Calculate total amount from all items in undocumentedSVModel
    totalAmount = undocumentedSVModel.fold(
      0.0,
          (sum, report) => sum! + (report.totalAmount ?? 0.0),
    );
    // Debug print
    print("Total Amount: $totalAmount");
  }


  Future<void> verifyUnDocSVDetailsMob() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(staffId!);
    int? distributorIds = int.parse(distributorId!);


    List<Map<String, dynamic>> UndocSVDetails = [];
    // Check if all controllers are empty and all checkboxes are unchecked
    bool allControllersEmpty = _consumerNoControllers.every((controller) => controller.text.isEmpty);
    bool allCheckboxesUnchecked = isCheckedList.every((isChecked) => !isChecked);

    if (allControllersEmpty || allCheckboxesUnchecked) {
      print("No Consumer No. entered and no checkboxes checked. Stopping execution.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Select Check Box.')),
      );
      return;  // Exit the function early
    }
    for (var item in undocumentedSVModel) {
      int index = undocumentedSVModel.indexOf(item);
      String consumerNo = _consumerNoControllers.length > index
          ? _consumerNoControllers[index].text
          : ""; // Default to empty string if there's no controller for this index

      // Ensure the index is within bounds for both _consumerNoControllers and isCheckedList
      if (index >= _consumerNoControllers.length || index >= isCheckedList.length) {
        // Skip this item if the index is out of bounds for either list
        continue;
      }
      bool isConsumerNoEntered = consumerNo.isNotEmpty;
      bool isChecked = isCheckedList[index] ?? false; // Ensure the checkbox state is checked

      // Add the item to the list (including duplicates)
      if (isConsumerNoEntered && isChecked){
        UndocSVDetails.add({
          "PSVId": item.pSVId,
          // Example static value
          "DistributorId": distributorId,
          // Dynamically set from your app's state
          "ProductId": item.productId,
          // Assuming productId is part of the item
          "ConsumerNo": consumerNo,
          // Get the text from the controller
          "ConsuDCNo": item.consuDCNo,
          // Static value, or dynamically set if required
        });
     }
    }
    final Map<String, dynamic> requestBody =
    {
      "DistributorId":distributorId,
      "FromDate":formattedDate,
      "ItemName":"",
      "PSVId":0,
      "ProductId":0,
      "ReferredBy":"",
      "SVDate":formattedDate,
      "SVType":'',
      "StaffId":0,
      "ToDate":formattedDate,
      "UndocSVDetails":UndocSVDetails,
    };
    print("StaffLedgerAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value'); // Log the request body for debugging
    });

    try {
      // Sending HTTP POST request
      final response = await http.post(
        Uri.parse('${AppUrl.VerifyUnDocSVDetails}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken", // Add Bearer token for authorization
        },
        body: json.encode(requestBody), // Send the request body as JSON
      );

      print("requestBody VerifyUnDocSVDetails: ${response.statusCode} - ${response.request}${requestBody}");
      print("Response Status Code: ${response.statusCode}");

      // Check if the response is successful (statusCode 200)
      if (response.statusCode == 200) {
        // Print the full response body for debugging purposes
        print("Response VerifyUnDocSVDetails: ${response.body}");
        var jsonResponse = json.decode(response.body); // if it's JSON
        print("Decoded Response: $jsonResponse");
        // Make sure we are comparing the string value of the response body correctly
        String conNumber = response.body.trim(); // Trim any extra spaces
        print("Raw Response Body: ${response.body}");
        // Check if the response body is "Success"
        if (jsonResponse == "Success") {
          // If the response is "Success", handle the success case
          print("Response true : ${response.body}");

          // Navigate to the dashboard screen
          Navigator.pushNamed(
            context,
            DashboardUndocumentedDetails.screenName,
          );

          // Show a success toast after a small delay (300ms)
          Future.delayed(Duration(milliseconds: 300), () {
            EasyLoading.showToast(
              Constants.expenseSendMgrEdit,
              duration: const Duration(milliseconds: 3000),
            );
          });
        } else {
          // If the response body is not "Success", show the duplicate alert
          print("Response false : ${response.body}");
          Navigator.pushNamed(
            context,
            DashboardUndocumentedDetails.screenName,
          );
          _showDuplicateConsumerAlert(conNumber); // Show the duplicate alert with the response value
        }
      } else {
        // If the response status code is not 200, handle it as an error
        print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");

        EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
      }
    } catch (e) {
      // Catch any unexpected errors, such as network issues
      print("Exception occurred: $e");
      EasyLoading.showToast("An error occurred. Please try again later.", duration: const Duration(milliseconds: 3000));
    }
  }

  void cancelAction() {
    setState(() {
        Navigator.pop(context);
        Navigator.pushNamed(
            context,
            DashboardUndocumentedDetails.screenName// This opens the third tab
        );
    });

  }

  String formatCurrency(double amount) {
    if (amount == 0) {
      return '0.00'; // Return "0.00" if the amount is zero
    }
    final format = NumberFormat('#,##,###.00', 'en_IN'); // Indian locale with comma separator

    // Ensure the result always shows a leading zero before the decimal point
    String formattedAmount = format.format(amount);

    // If there's no integer part, it ensures that a leading zero is added before decimal
    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0' + formattedAmount;
    }
    return formattedAmount;
  }

  void _showDuplicateConsumerAlert(String consumerNo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.close, // You can change the icon to any you prefer
                color: Colors.red, // Optional: color for the icon
              ),
              SizedBox(width: 10), // Adds space between icon and text
              Text('Oops'),
            ],
          ),
          content: Text('$consumerNo Consumer No.Record already exists.'),
          actions: [
            TextButton(
              onPressed: () {
                //Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}