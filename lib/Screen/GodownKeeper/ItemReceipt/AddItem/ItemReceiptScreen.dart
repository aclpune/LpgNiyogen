import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../User/Login/provider/LoginProvider.dart';
import '../../../User/splashscreen/page/splash_screen.dart';
import '../../../Utils/CustomAppBar.dart';
import '../../../Utils/Styling.dart';
import '../../../Utils/app_url.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/shared_preference.dart';
import '../CylItemList/CylItemListModel.dart';

class ItemReceiptScreen extends StatefulWidget {
  static const screenName = '/itemWiseReceipt';

  @override
  _ItemReceiptScreenState createState() => _ItemReceiptScreenState();
}

class _ItemReceiptScreenState extends State<ItemReceiptScreen> {
  // List to keep track of dynamically added sections
  final TextEditingController receiptDateController = TextEditingController();
  final TextEditingController vehicleNoController = TextEditingController();

  List<Map<String, TextEditingController>> items = [];
  String? _selectedItem;
  List<CylItemListModel> _items = [];
  Map<int, String?> _selectedItems = {};
  String? userName,
  userId,
  refreshToken,
  displayName,
  roleId,
  activeStatus,
  password,
  encryptedPassword,
  roleName,
  mobileNo,
  customerId,
  customerCode,
  customerName,
  refNo,
  lastUpdatedDate,
  customerAddress,
  gSTNO,
  email,
  source,
  godownId,
  godownKeeperId,
      distributorId;


  @override
  void initState() {
    super.initState();
    // Add the first item by default
    // Get today's date

    DateTime now = DateTime.now();

    // Format it as 'yyyy-MM-dd', or any format you prefer
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // Set the formatted date as the default value in the TextField
    receiptDateController.text = formattedDate;
    _addNewItem();
    fetchItems();
  }

  void _addNewItem() {
    setState(() {
      items.add({
        'selectItem': TextEditingController(),
        'receivedQty': TextEditingController(),
        'emr': TextEditingController(),
        'invoice': TextEditingController(),
      });
    });
  }

  void _removeLastItem() {
    if (items.length>1) {
      setState(() {
        items.removeLast();
      });
    }
  }

  // Future<void> _submitData() async {
  //   // Fetch shared preference values
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('refNo');
  //   String? godownId = prefs.getString('godownId');
  //   String? addedBy = prefs.getString('userId');
  //   String? GodownKeeperId = prefs.getString('godownKeeperId');
  //
  //   // Build the JSON object
  //   Map<String, dynamic> requestBody = {
  //     'ReceiptId' :1,
  //     'DistributorId': distributorId,
  //     'GodownId': godownId,
  //     'ReceiptDate': receiptDateController.text,
  //     'VehicleNo': vehicleNoController.text,
  //     'GodownKeeperId':GodownKeeperId,
  //     'AddedBy': addedBy,
  //     'Action':'ADD',
  //     'ItemDetails': items.map((item) {
  //       return {
  //         'ItemId': int.tryParse(item['itemId']?.text ?? '0'),
  //         'receivedQty': int.tryParse(item['receivedQty']?.text ?? '0'),
  //         'emr': int.tryParse(item['emr']?.text ?? '0'),
  //         'invoice': int.tryParse(item['invoice']?.text ?? '0'),
  //       };
  //     }).toList(),
  //   };
  //   debugPrint(requestBody.toString());
  // }

  Future<void> _submitData() async {
    // Fetch shared preference values
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('refNo');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('userId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token');
    // Validate InvoiceQty: Check if it is null, empty, or zero
    // Validate InvoiceQty and Selected Item: Check if they are valid
    for (var i = 0; i < items.length; i++) {
      String? invoiceQty = items[i]['invoice']?.text ?? '';
      String? selectedItemName = _selectedItems[i];

      // Check if the selected item is valid (not empty)
      if (selectedItemName == null || selectedItemName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a valid item for all entries!')),
        );
        return; // Stop the submission process
      }

      // Check if InvoiceQty is empty or zero
      if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invoice quantity cannot be empty or zero!')),
        );
        return; // Stop the submission process
      }
    }

    List<Map<String, dynamic>> itemDetails = items.map((item) {
      String? selectedItemName = _selectedItems[items.indexOf(item)];

      CylItemListModel? selectedItem = _items.firstWhere(
            (model) => model.itemName == selectedItemName,  // Comparing by itemName
        orElse: () => CylItemListModel(itemId: 0, itemName: ''), // Default empty item
      );

      return {
        'ItemId': selectedItem.itemId ?? '', // Use the selected itemId, or empty if not selected
        'FilledQty': item['receivedQty']?.text ?? '',
        'EMRQty': item['emr']?.text ?? '',
        'InvoiceQty': item['invoice']?.text ?? '',
      };
    }).toList();
    // Build the full JSON object
    Map<String, dynamic> requestBody = {
      'ReceiptId': 0,
      'DistributorId': distributorId,
      'GodownId': godownId,
      'ReceiptDate': receiptDateController.text,
      'VehicleNo': vehicleNoController.text,
      'GodownKeeperId': godownKeeperId,
      'AddedBy': addedBy,
      'Action': 'ADD',
      'ItemDetails': itemDetails,
    };

    // Convert the map to a JSON string
    String jsonRequestBody = jsonEncode(requestBody);
    debugPrint(jsonRequestBody);
    // Define the API URL

    try {
      // Send POST request to the API
      final response = await http.post(
        Uri.parse(AppUrl.ItemReceiptAddEdit),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonRequestBody,
      );

      // Check the response status
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, print the response body.
        debugPrint('Response: ${response.body}');
        int responseValue = int.tryParse(response.body) ?? 0;
        if(responseValue >0){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Inserted successfully!')),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fail to insert record!')),
          );
        }
        // Handle the success case (e.g., show a success message)
      } else {
        refreshTokens();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fail to insert record! ${response.statusCode}')),
        );
        // If the server does not return a 200 OK response, throw an exception.
        throw Exception('Failed to load data: ${response.statusCode}');

      }
    } catch (e) {
      // Handle any errors (e.g., network issues, timeouts, etc.)
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fail to insert record! $e')),
      );
      // You can also show an error dialog or message to the user here.
    }
  }
  // Fetch data from API
  Future<void> fetchItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('refNo');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here


    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
      debugPrint("item"+'${AppUrl.GetItemMasterList}/$distributorId/1');
    debugPrint("item"+response.body);
    if (response.statusCode == 200) {
      // Parse the response
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
      });
    } else {
      refreshTokens();
      throw Exception('Failed to load items');
    }
  }

  @override
  void dispose() {
    receiptDateController.dispose();
    vehicleNoController.dispose();
    // Dispose controllers to avoid memory leaks
    for (var item in items) {
      item.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Item Receipt', // Title or hint text for the text field
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Receipt Date & Vehicle Number
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: receiptDateController,
                    decoration: InputDecoration(
                      labelText: 'Receipt Date',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                    enabled: false,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: vehicleNoController,
                    decoration: InputDecoration(
                      labelText: 'Vehicle No.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Add New Item and Clear Item Buttons
            Row(
              children: [
                Text(
                  'Add New Item',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _addNewItem,
                  child: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _removeLastItem,
                  child: Icon(Icons.remove),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12),
                    // backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Dynamically added sections
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      children: [
                        // Select Item Dropdown
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Item',
                            border: OutlineInputBorder(),
                          ),
                          items: _items.map((CylItemListModel item) {
                            return DropdownMenuItem<String>(
                              value: item.itemName,
                              child: Text(item.itemName ?? 'Unknown'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              // Store the selected value in the map based on the current index
                              _selectedItems[index] = value;
                              debugPrint('selecyt'+_selectedItems.toString());

                              // Track selection by index
                            });
                            // You can use this value to update any model or perform further logic
                          },
                          value: _selectedItems[index],
                        ),
                        SizedBox(height: 16),
                        // Received Qty, EMR, Invoice Fields
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: items[index]['receivedQty'],
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Filled',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  // Update the sum when the value changes
                                  _updateSum(index);
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: items[index]['emr'],
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                ],
                                decoration: InputDecoration(
                                  labelText: 'EMR',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  // Update the sum when the value changes
                                  _updateSum(index);
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: items[index]['invoice'],
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                ],
                                decoration: InputDecoration(
                                  // labelText: 'Invoice',
                                  labelText: 'Invoice',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Submit Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10), // Add 10px margin on left and right
              child: ElevatedButton(
                onPressed: _submitData,
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white), // Set text color directly if needed
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blue,// Button expands to fill available width// Text color of the button
                  shape: RoundedRectangleBorder( // Optional: Set rounded corners
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
// Function to update the sum
  void _updateSum(int index) {
    // Get the values from the receivedQty and emr controllers
    double receivedQty = double.tryParse(items[index]['receivedQty']?.text ?? '') ?? 0;
    double emr = double.tryParse(items[index]['emr']?.text ?? '') ?? 0;
    if(receivedQty !="" && receivedQty != null){
      if(emr !="" && emr != null){
        double totalSum = receivedQty + emr;
        items[index]['invoice']?.text = totalSum.toInt().toString();
      }else{
        double totalSum = receivedQty + 0;
        items[index]['invoice']?.text = totalSum.toInt().toString();
      }
    }else{
      if(emr !="" && emr != null){
        double totalSum = 0 + emr;
        items[index]['invoice']?.text = totalSum.toInt().toString();
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter at least one quantity!')),
        );
      }
    }

  }

  Future<void> refreshTokens() async {
    LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      userName = preferences.getString('userName').toString();
      userId = preferences.getString('userId').toString();
      refreshToken = preferences.getString('refresh_token').toString();
      displayName = preferences.getString('displayName').toString();
      roleId = preferences.getString('roleId').toString();
      activeStatus = preferences.getString('activeStatus').toString();
      password = preferences.getString('password').toString();
      encryptedPassword = preferences.getString('encryptPass').toString();
      roleName = preferences.getString('roleName').toString();
      mobileNo = preferences.getString('mobileNo').toString();
      customerId = preferences.getString('customerId').toString();
      customerCode = preferences.getString('customerCode').toString();
      customerName = preferences.getString('customerName').toString();
      refNo = preferences.getString('refNo').toString();
      lastUpdatedDate = preferences.getString('lastUpdatedDate').toString();
      customerAddress = preferences.getString('customerAddress').toString();
      gSTNO = preferences.getString('gstno').toString();
      email = preferences.getString('email').toString();
      source = preferences.getString('source').toString();
      godownId = preferences.getString('godownId').toString();
      godownKeeperId = preferences.getString('godownKeeperId').toString();
      distributorId = preferences.getString('distributorId').toString();
      final Future<Map<String, dynamic>> respose = auth.refreshToken(
          userName!,
          userId!,
          refreshToken!,
           displayName,
           roleId,
           activeStatus,
           password,
           encryptedPassword,
           roleName,
           mobileNo,
           customerId,
           customerCode,
           customerName,
           refNo,
           lastUpdatedDate,
           customerAddress,
           gSTNO,
           email,
           source,
           godownId,
           godownKeeperId,
          distributorId,
          context);

      try {
        respose.then((response) {
          EasyLoading.dismiss();
          if (response['status']) {
            debugPrint('RefreshTokenStatus - True');
            fetchItems();
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
