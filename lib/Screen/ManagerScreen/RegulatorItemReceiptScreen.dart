import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantScreen/widgets.dart';
import '../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
import '../Utils/CustomAppBarManager.dart';
import '../Utils/Styling.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import 'package:http/http.dart' as http;

class RegulatorItemReceiptScreen extends StatefulWidget {
  static const screenName = '/regulatorItemReceiptScreen';
  final bool disableNetworkCallsForTest;

  const RegulatorItemReceiptScreen({super.key, this.disableNetworkCallsForTest = false});

  @override
  State<RegulatorItemReceiptScreen> createState() => _RegulatorItemReceiptScreenState();
}

class _RegulatorItemReceiptScreenState extends State<RegulatorItemReceiptScreen> {
  CylItemListModel? _selectedItemModel;
  List<CylItemListModel> _regulatorItems = [];
  String? _selectedItemName;
  int? selectedItemId;
  String? formattedDate;
  final TextEditingController _regulatorQtyController = TextEditingController();
   TextEditingController _dateController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (!widget.disableNetworkCallsForTest) {
      fetchItems();
    }
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
    _dateController.text = formattedDate!;
  }
  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return
      WillPopScope(
        onWillPop: () async {
          if (argLRAdd == "fromDrawer") {
            Navigator.pop(context);
            return false;
          } else {
            Navigator.pop(context);
            return false;
          }
        },
        child: Scaffold(
          appBar: CustomAppBarManager(
            title: 'Regulator Receipt',
          ),
          body: SingleChildScrollView(  // Wrap the entire body with SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: textWidgetBlueColorWithoutStar("Date")),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: _dateController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: buildInputBorderUpdateStatus("Enter Qty", context),
                          style: Styling.textFormText,
                          onChanged: (value) {

                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: textWidgetBlueColorWithStar("Select Regulator", "*")),
                      Flexible(
                        flex: 1,
                        child: DropdownButtonFormField<CylItemListModel>(
                          decoration: buildInputBorderUpdateStatus("Select Regulator", context),
                          value: _selectedItemModel,
                          style: Styling.textFormText,
                          items: _regulatorItems.map((CylItemListModel item) {
                            return DropdownMenuItem<CylItemListModel>(
                              value: item,
                              child: Text(
                                item.itemName ?? 'Unknown',
                                style: Styling.textFormText,
                              ),
                            );
                          }).toList(),
                          onChanged: (CylItemListModel? selectedItem) {
                            if (selectedItem != null) {
                              setState(() {
                                _selectedItemName = selectedItem.itemName;
                                selectedItemId = selectedItem.itemId!.toInt();
                                _selectedItemModel = selectedItem;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: textWidgetBlueColorWithStar("Empty Qty","*")),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: _regulatorQtyController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: buildInputBorderUpdateStatus("Enter Qty", context),
                          style: Styling.textFormText,
                          onChanged: (value) {

                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () {


                        },
                        child: Text("Submit", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Regulator History", style: Styling.bodyTitleWithBlue),
                  ),
                  SizedBox(height: 10),

                  // Use ListView.builder here
                  // SizedBox(
                  //   height: 200, // Set a fixed height for the ListView
                  //   child: ListView.builder(
                  //     shrinkWrap: true,
                  //     physics: AlwaysScrollableScrollPhysics(),
                  //     itemCount: _stockTransferList.length,
                  //     itemBuilder: (context, index) {
                  //       return StockTransferTOGodownScreenItemUI(_stockTransferList[index]);
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Future<void> fetchItems() async {
    if (widget.disableNetworkCallsForTest) {
      return;
    }
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
        Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/r'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );
      debugPrint("item" + '${AppUrl.GetItemMasterList}/$distributorId/1/r');
      debugPrint("item" + response.body);
      if (response.statusCode == 200) {
        // Parse the response
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _regulatorItems = data.map((json) => CylItemListModel.fromJson(json)).toList();
        });
      } else {

        throw Exception('Unable To Load Data At This Time. Please Try Again');
      }
    } else {
      showFlushBar(
          context,Constants.connectionMessage);
    }
  }
}
