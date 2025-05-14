import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ConstantScreen/widgets.dart';
import '../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
import '../Utils/CustomAppBarManager.dart';
import '../Utils/Styling.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import 'package:http/http.dart' as http;
import '../Utils/constants.dart';
import 'BootomNavigatinBarManager.dart';
import 'CashHandoverListViewUI.dart';
import 'CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import 'CashHandoverModelClass/GetCashHandOverDtlsModel.dart';
import 'CashHandoverModelClass/GetStaffDetailsListUserIsMadeModel.dart';
import 'ManagerModelClass/DenomModel.dart';
import 'ManagerModelClass/GetNoteTypeAndIDFroDenominationListModel.dart';
import 'ManagerModelClass/ManagerDSRReportCashDeniminationModel.dart';
class CashHandoverScreen extends StatefulWidget {
  static const screenName = '/cashHandoverScreen';
  const CashHandoverScreen({super.key});

  @override
  State<CashHandoverScreen> createState() => _CashHandoverScreenState();
}

class _CashHandoverScreenState extends State<CashHandoverScreen> {
  List<CylItemListModel> _items = [];
  List<GetStaffDetailsListUserIsMadeModel> staffdetailsmodel = [];
  List<GetCashHandOverDtlsModel> cashInHandDetails = [];
  GetStaffDetailsListUserIsMadeModel? _selectedItemModel;
  List<GetBankMappingDetailsListModel> bankmappingModel = [];
  List<dynamic> dataCashDenominationList = [];
  List<DenomModel>getNoteTypeAndIdFroDenominationListModel = [];
  double totalAmountCashDenomination = 0;
  GetBankMappingDetailsListModel? _selectBankModel;
  DateTime selectedDate = DateTime.now();
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  List<TextEditingController> qtyController = [];
  List<double> amounts = [];
  double totalAmount = 0.0;// Keep track of the total amount.


  String? _selectedItem;
  int? selectedItemId;
  bool isLoading = true;
  Map<int, String?> _selectedItems = {};
  DateTime? date;
  var argValue;
  String? userName,userId;
  double? totalamt;
  List<String> getTransMode = ["ATM","BRANCH"];
  List<String> getTransModeListForBank(GetBankMappingDetailsListModel? bank) {
    // Implement logic to return transaction modes based on the bank
    return ['ATM', 'BRANCH']; // Example
  }
  String? _selectedItemId;
  String? _selectedItemName;
  String? selectedBankName;
  String? selectedBankId;
  String? selectedTransMode;
  int? selecteBankIDApi;
  int? accMappingId;
  bool isCashDenominationListViewVisible = false;
  final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  bool isBankDisabled = false;
  bool isStaffSelected = false;
  double? balancedamt;
  double? cashamt;

  final depositController = TextEditingController();
  bool _isDepositEmpty = false;
  double remainingAmount = 0.0;
  @override
  void initState() {

    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-mm-yyyy').format(now);
    fetchItems();
    fetchStaff();
    fetchBank();
    fetchSavedData();
    fetchStaffList(selectedDate);
    getNoteTypeAndIDList();
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    for (var controller in qtyController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:CustomAppBarManager(
        title: 'Cash Handover - Bank Deposit', // Title or hint text for the text field
      ),
      body:
      Padding(
        padding: const EdgeInsets.only(left: 5.0,right: 5,top: 15,bottom: 15),
        child: SingleChildScrollView(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                      Expanded(
                        child: textWidgetBlueColorWithoutStar(
                            'Deposit Date'),
                      ),
                      Flexible(flex: 1,
                          child: Text("$formattedDate")),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                      Expanded(
                        child: textWidgetBlueColorWithStar(
                          'Deposit By', "*", // Add a parameter to conditionally show the asterisk
                        ),
                      ),
               
                      Flexible(flex: 1,child: Text("$userName")),
                  
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                      Expanded(child: textWidgetBlueColorWithoutStar('Cash In Hand')),
                      Flexible(flex: 1,child: Text('${(totalamt ?? 0).toStringAsFixed(2)}')),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      Expanded(
                        child:
                            textWidgetBlueColorWithStar(
                              'Cash Handover To',
                             "*", // Add a parameter to conditionally show the asterisk
                            ),
                      ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left:0.0),
                      child: DropdownButtonFormField<GetStaffDetailsListUserIsMadeModel>(
                        isExpanded: true,
                        key: formKey1,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        ),
                        value: _selectedItemModel,
                        items: staffdetailsmodel.map((item) {
                          return DropdownMenuItem<GetStaffDetailsListUserIsMadeModel>(
                            value: item,
                            child: Text(
                              item.staffName ?? '',
                              style: Styling.itemBlackTest,
                            ),
                          );
                        }).toList(),
                        onChanged: (selectedItem) {
                          setState(() {
                            _selectedItemModel = selectedItem;
                            _selectedItem = selectedItem?.staffName ?? '';
                            selectedItemId = selectedItem?.userId?.toInt();
                            // Clear bank selection when staff is selected
                            _selectBankModel = null;
                            selectedBankName = null;
                            selectedBankId = null;
                          });
                        },
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  "OR",
                  style:Styling.itemBlackTestSmallReportBold
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      Expanded(
                        child: textWidgetBlueColorWithStar(
                          ' Select Bank \n Account No.',
                          "*" // Add a parameter to conditionally show the asterisk
                        ),
                      ),
                    
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child:
                      DropdownButtonFormField<GetBankMappingDetailsListModel>(
                        isExpanded: true,
                        key: formKey2,
                        decoration: InputDecoration(),
                        value: _selectBankModel,
                        items: bankmappingModel.map((item) {
                          return DropdownMenuItem<GetBankMappingDetailsListModel>(
                            value: item,
                            child: Text(
                              '${item.bankName ?? ''} - ${item.accountNo ?? ''}',
                              style: Styling.itemBlackTest,
                            ),
                          );
                        }).toList(),
                        onChanged: (selectedItem) {
                          setState(() {
                            _selectBankModel = selectedItem;
                            selectedBankName = selectedItem?.bankName;
                            selectedBankId = selectedItem?.accountNo;
                            getTransMode = getTransModeListForBank(selectedItem);
                            selecteBankIDApi = selectedItem?.bankId?.toInt();
                            accMappingId = selectedItem?.mappingId?.toInt();
                            selectedTransMode = null;
                            _selectedItemModel = null;
                            _selectedItem = null;
                            selectedItemId = null;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                      Expanded(
                        child: textWidgetBlueColorWithStar(
                          'Cash Hand/\nDeposit Amt.',
                          "*" // Add a parameter to conditionally show the asterisk
                        ),
                      ),
                   
                  Expanded(
                    child: TextField(
                      controller: depositController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Enter Deposit Amt.',
                        errorText: _isDepositEmpty ? 'Deposit Amt. is Required' : null, // Show error if required
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isDepositEmpty = value.isEmpty;
                          double val = double.parse(value);
                          if(val>totalamt!){
                            depositController.clear();
                            remainingAmount = 0;
                          }else{
                            updateRemainingAmount();
                          }
                        });
                      },
                    ),
                  ),

                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                      Expanded(
                        child: textWidgetBlueColorWithoutStar(
                            'Balanced Amount'
                        ),
                      ),
                          
                          Flexible(flex: 1,child: Text('${remainingAmount.toString()}')),
                    
                ],
              ),
              SizedBox(height: 10),
              if (selectedBankName != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                        Expanded(
                          child: textWidgetBlueColorWithStar(
                            'Select Dep.Mode',"*"// Add a parameter to conditionally show the asterisk
                          ),
                        ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: DropdownButtonFormField<String>(
                          key: formKey3,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          ),
                          value: selectedTransMode, // Bind the selected value
                          items: getTransMode
                              .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTransMode = value; // Update the selected value
                            });
                          },
                          isExpanded: true,
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        color: Colors.blue.shade100,
                      ),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Sr.No.',
                              style: Styling.itemBlackTestBold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          verticalDividerSmall(), // Small vertical divider
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Staff Name',
                              style: Styling.itemBlackTestBold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          verticalDividerSmall(), // Small vertical divider
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Cash In Hand',
                              style: Styling.itemBlackTestBold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    // ListView for Data
                    cashInHandDetails.isNotEmpty
                        ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cashInHandDetails.length,
                      itemBuilder: (context, index) {
                        debugPrint(
                            "Rendering Expense Item: ${cashInHandDetails[index]}");
                        return CashHandoverListViewUI(
                            cashInHandDetails[index],
                            index + 1,
                            cashInHandDetails.length
                        );
                      },
                    )
                        : Container(child: Text('No Records Found')),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCashDenominationListViewVisible =
                        !isCashDenominationListViewVisible; // Toggle ListView visibility
                      });
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child:
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cash denomination",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,),
                                  ),
                                  Icon(
                                    isCashDenominationListViewVisible
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible:
                              isCashDenominationListViewVisible,
                              child:
                              Container(
                                decoration: BoxDecoration(
                                  // Background color of the box
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  border: Border.all(
                                      width:
                                      1), // Optional: Add rounded corners
                                ),
                                child: Column(
                                  children: [
                                    // First Row with Vertical Divider
                                    SizedBox(
                                      height:50,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        // Center the row content
                                        children: [
                                          // First Text and Divider inside Expanded to ensure equal size
                                          Expanded(
                                            flex: 2,
                                            child: Center(
                                                child: Text(
                                                  "Note Type", style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontSize: 14),)), // Centering the text
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Center(
                                                child: Text(
                                                  "Qty", style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontSize: 14),)), // Centering the text
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Center(
                                                child: Text(
                                                  "Amount", style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontSize: 14),)), // Centering the text
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: getNoteTypeAndIdFroDenominationListModel.length,
                                      itemBuilder: (context, index) {
                                        final data = getNoteTypeAndIdFroDenominationListModel[index];
                                        return
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Center(
                                                      child: Text(
                                                        "${data.noteType}",
                                                        style: TextStyle(fontSize: 12),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        "X",
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Center(
                                                      child: TextField(
                                                        controller: qtyController[index],
                                                        keyboardType: TextInputType.number,
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter.digitsOnly,
                                                        ],

                                                        onChanged: (value) {
                                                          setState(() {
                                                            amounts[index] = (double.tryParse(value) ?? 0.0) * data.noteType!;
                                                            totalAmount = amounts.fold(0.0, (sum, amount) => sum + amount);
                                                            debugPrint("totalAmount$totalAmount");
                                                          });
                                                        },
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        "=",
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex:3,
                                                    child: Center(
                                                      child: Text(
                                                        "${amounts[index].toStringAsFixed(2)}",
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                      },
                                    ),
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                              flex: 0,
                                              child: Text("Total Amount : ",
                                                  style: Styling.itemBlackTestBold,
                                                  textAlign: TextAlign.left)),
                                          Expanded(
                                              flex: 0,
                                              child: Text(
                                                totalAmount.toStringAsFixed(2),
                                                style: Styling.itemBlackTestBold,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              // Save Button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Cancel action
                        cancelAction();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
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
                  ),
                  SizedBox(width: 10), // Adds space between buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        //save button action
                        updateCashAddEditForMob();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fetch data from API
  Future<void> fetchItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("item" + '${AppUrl.GetItemMasterList}/$distributorId/1/C');
    debugPrint("item" + response.body);
    if (response.statusCode == 200) {
      // Parse the response
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load items');
    }
  }
  Future<void> fetchStaff() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    //String formattedDate = DateFormat('yyyy-MM-dd').format(date! as DateTime);
    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,

    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetStaffDetailsListUserIsMade}/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetStaffDetailsListUserIsMade : " + '${AppUrl.GetStaffDetailsListUserIsMade}/$distributorId');
    debugPrint("GetStaffDetailsListUserIsMade : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        staffdetailsmodel = data.map((json) {
          // String dateString = json['TransDate'];
          // DateTime date = DateTime.parse(dateString);
          // String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          // json['TransDate'] = formattedDate;

          return GetStaffDetailsListUserIsMadeModel.fromJson(json);
        }).toList();
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }
  Future<void> fetchBank() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetBankMappingDetailsList}/$distributorId/1'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetBankMappingDetailsListModel : " + '${AppUrl.GetBankMappingDetailsList}/$distributorId/0');
    debugPrint("GetBankMappingDetailsListModel : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        bankmappingModel = data.map((json) {
          return GetBankMappingDetailsListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }
  Future<void> getNoteTypeAndIDList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(
          context,  Constants.connectionMessage);
      isLoading = false;
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse('${AppUrl.GetCashDenominationItemList}/0'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint(
            "Response body GetCashDenominationItemList: ${response.body}");
        debugPrint(
            "request body GetCashDenominationItemList: ${response.request}");

        if (response.statusCode == 200) {
          // Decode the response body as a List
          final List<dynamic> jsonResponse = jsonDecode(response.body);

          // Filter the data based on the condition (TransCate == 'DailySale')
          var filteredDataCashDenominationList = jsonResponse
              .map((item) => DenomModel.fromJson(
              item)) // Map to model
              .toList();


          setState(() {
            // Use filtered data to update the UI
            getNoteTypeAndIdFroDenominationListModel = filteredDataCashDenominationList;
            dataCashDenominationList = filteredDataCashDenominationList;
            isLoading = false;

            qtyController = List.generate(
              getNoteTypeAndIdFroDenominationListModel.length,
                  (index) => TextEditingController(),
            );

            amounts = List.generate(
              getNoteTypeAndIdFroDenominationListModel.length,
                  (index) => 0.0,
            );
            // totalAmountCashDenomination = totalAmount;
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }
  Future<void> fetchStaffList(DateTime date) async {
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

        //DateTime now = DateTime.now();
        // String formattedDate = DateFormat('yyyy-MM-dd').format(date!);
        // debugPrint("formattedDate :- ${formattedDate.toString()}");

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        // Construct the request body for the POST request
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        Map<String, dynamic> requestBody = {
          "DistributorId": distributorId,
          "Date": formattedDate,

        };

        final response = await http.post(
          Uri.parse('${AppUrl.GetCashHandOverDtls}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            // Ensure the request body is JSON
          },
          body: json.encode(requestBody), // Encode the request body as JSON
        );

        debugPrint("Response body GetCashHandOverDtls: ${response.body}");
        debugPrint("Request body GetCashHandOverDtls: ${response
            .request}${requestBody}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            cashInHandDetails = data.map((jsonItem) =>
                GetCashHandOverDtlsModel.fromJson(jsonItem)).toList();
            isLoading = false;
            for (var item in cashInHandDetails) {
              if (item.staffId.toString() == userId) {
                print("Matched Staff Total Amount: ${item.totalAmt}");
                totalamt = (item.totalAmt ?? 0.0).toDouble();
                break; // Exit loop after finding the match
              }
            }
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }
  Future<void> fetchSavedData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      userName = preferences.getString("StaffName").toString();
      debugPrint("User Name:- $userName");
    } catch (error) {
      rethrow;
    }
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
  void updateRemainingAmount() {
    final deposit = double.tryParse(depositController.text) ?? 0.0;
    final total = totalamt ?? 0.0;

    setState(() {
      remainingAmount = total - deposit;
    });
  }
  void cancelAction(){
    setState(() {
      _selectedItemModel = null;
      _selectedItem = '';
      selectedItemId = null;
      _selectBankModel = null;
      selectedBankName = '';
      selectedBankId = null;
      depositController.clear();
      selectedTransMode = null;

    });
    formKey1.currentState?.reset();
    formKey2.currentState?.reset();
    formKey3.currentState?.reset();
  }
  Future<void> updateCashAddEditForMob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? addedBy = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(addedBy!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    double hvrBnkDepAmt = 0;
    if(depositController.text.isNotEmpty){
      hvrBnkDepAmt = double.parse(depositController.text);
      if(totalAmount != null){
        if(totalAmount != hvrBnkDepAmt){
          showFlushBar(context, Constants.cashHandOverDeno);
          return;
        }
      }
    }else{
      showFlushBar(context, Constants.cashAmount);
    }

    if((_selectedItem == null || selectedItemId == null) && (selectedBankName == null || selectedBankId == null)){
      showFlushBar(context, Constants.selectValidItemReceipt);
      return;
    }

    if(selectedBankName != null || selectedBankId != null){
      if(selectedTransMode == null){
        showFlushBar(context, Constants.selectValidItemReceipt);
        return;
      }
    }

    final List<Map<String, dynamic>> dataCashDenomination = getNoteTypeAndIdFroDenominationListModel.asMap().entries.map((entry) {
      int index = entry.key;
      var data = entry.value;
      return {
        "NoteId": data.id ?? 0, // Use null-aware operator to handle null values
        "NoteQty": qtyController[index].text.isNotEmpty ? int.tryParse(qtyController[index].text) : 0,
        "NoteAmt": amounts[index],
        "RetNoteQty": 0, // Replace with actual value if available
        "RetNoteAmt": 0.0, // Replace with actual value if available
      };
    }).toList();

    int? bankId;
    int? accMappingIds;
    if(selectedBankName != null) {
      bankId = selecteBankIDApi;
      accMappingIds = accMappingId;
    }else{
      bankId = 0;
      accMappingIds = 0;
    }
    final Map<String, dynamic> requestBody = {
      "HvrBnkDepId": 0,
      "DistributorId":distributorIds,
      "HvrBnkDepDate": formattedDate,
      "HvrBnkDepFrom": userId,
      "CashInHand":totalamt,
      "HandoverToId": selectedItemId,
      "BankId":bankId ,
      "AccMappingId":accMappingIds,
      "HvrBnkDepAmt":hvrBnkDepAmt,
      "BalAmt": remainingAmount,
      "DepositMode":selectedTransMode ?? '',
      "HandoverStatus": 2,
      "AddedBy": userId,
      "UpdatedFrom": 'MOB',
      "DenomDtList": dataCashDenomination,
    };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
      final response = await http.post(
        Uri.parse('${AppUrl.DepositCashAddEdit}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: json.encode(requestBody),
      );
      // print("response UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
      print(
          "requestBody UpdateSaleAddEditForMob: ${response.statusCode} - ${response.request}${requestBody}");

      // Handling response
      if (response.statusCode == 200) {
        // Successful response
        print("Response UpdateSaleAddEditForMob: ${response.body}");

        Navigator.pushNamed(
          context,
          BottomNavBarExample.screenName,
          arguments: 3, // This opens the third tab
        );
        EasyLoading.showToast(Constants.expenseSendMgr,
            duration: const Duration(milliseconds: 3000));
        setState(() {
          fetchStaffList(selectedDate);
        });
      } else {
        // Error response
        print("Error UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
      }
    // } catch (e) {
    //   // Exception handling
    //   print("Exception UpdateSaleAddEditForMob: $e");
    // }
  }

}
