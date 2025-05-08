import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ConstantScreen/widgets.dart';
import '../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
import '../Utils/Styling.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import 'package:http/http.dart' as http;
import '../Utils/constants.dart';
import 'CashHandoverListViewUI.dart';
import 'CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import 'CashHandoverModelClass/GetCashHandOverDtlsModel.dart';
import 'CashHandoverModelClass/GetStaffDetailsListUserIsMadeModel.dart';
import 'ManagerModelClass/GetNoteTypeAndIDFroDenominationListModel.dart';
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
  List<GetNoteTypeAndIdFroDenominationListModel>
  getNoteTypeAndIdFroDenominationListModel = [];
  GetBankMappingDetailsListModel? _selectBankModel;
  DateTime selectedDate = DateTime.now();
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();


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
  bool isCashDenominationListViewVisible = false;
  final TextEditingController quantity500Controller = TextEditingController();
  final TextEditingController quantity200Controller = TextEditingController();
  final TextEditingController quantity100Controller = TextEditingController();
  final TextEditingController quantity50Controller = TextEditingController();
  final TextEditingController quantity20Controller = TextEditingController();
  final TextEditingController quantity10Controller = TextEditingController();
  final TextEditingController quantity5Controller = TextEditingController();
  final TextEditingController quantity2Controller = TextEditingController();
  final TextEditingController quantity1Controller = TextEditingController();
  final TextEditingController quantity050Controller = TextEditingController();
  double result500 = 0.0;
  double result200 = 0.0;
  double result100 = 0.0;
  double result50 = 0.0;
  double result20 = 0.0;
  double result10 = 0.0;
  double result5 = 0.0;
  double result2 = 0.0;
  double result1 = 0.0;
  double result050 = 0.0;
  double total = 0.0;
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

    // fetchSavedData();
    // .whenComplete((){
    //   setState(() {
    //     compareStaffId();
    //   });
    // });


  }


  void calculate500Amount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(quantity500Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      result500 = qty * 500;
      // Calculate the amount based on the value
      switch (value) {
        case 500:
          result500 = qty * 500;
          break;
        case 200:
          result200 = qty * 200;
          break;
        case 100:
          result100 = qty * 100;
          break;
        case 50:
          result50 = qty * 50;
          break;
        case 20:
          result20 = qty * 20;
          break;
        case 10:
          result10 = qty * 10;
          break;
        case 5:
          result5 = qty * 5;
          break;
        case 2:
          result2 = qty * 2;
          break;
        case 1:
          result1 = qty * 1;
          break;
        case 0.50:
          result050 = qty * 0.50;
          break;
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0) + (result2 ?? 0.0) + (result1 ?? 0.0) + (result050 ?? 0.0);

    });
  }
  void calculate200Amount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(quantity200Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      result200 = qty * 200;
      switch (value) {
        case 500:
          result500 = qty * 500;
          break;
        case 200:
          result200 = qty * 200;
          break;
        case 100:
          result100 = qty * 100;
          break;
        case 50:
          result50 = qty * 50;
          break;
        case 20:
          result20 = qty * 20;
          break;
        case 10:
          result10 = qty * 10;
          break;
        case 5:
          result5 = qty * 5;
          break;
        case 2:
          result2 = qty * 2;
          break;
        case 1:
          result1 = qty * 1;
          break;
        case 0.50:
          result050 = qty * 0.50;
          break;
        default:
          break;
      }
      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0) + (result2 ?? 0.0) + (result1 ?? 0.0) + (result050 ?? 0.0);
    });
  }
  void calculate100Amount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(quantity100Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      result100 = qty * 100;

      switch (value) {
        case 500:
          result500 = qty * 500;
          break;
        case 200:
          result200 = qty * 200;
          break;
        case 100:
          result100 = qty * 100;
          break;
        case 50:
          result50 = qty * 50;
          break;
        case 20:
          result20 = qty * 20;
          break;
        case 10:
          result10 = qty * 10;
          break;
        case 5:
          result5 = qty * 5;
          break;
        case 2:
          result2 = qty * 2;
          break;
        case 1:
          result1 = qty * 1;
          break;
          case 0.50:
        result050 = qty * 0.50;
        break;

        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0) + (result2 ?? 0.0) + (result1 ?? 0.0) + (result050 ?? 0.0);

    });
  }
  void calculate50Amount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(quantity50Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      result50 = qty * 50;

      switch (value) {
        case 500:
          result500 = qty * 500;
          break;
        case 200:
          result200 = qty * 200;
          break;
        case 100:
          result100 = qty * 100;
          break;
        case 50:
          result50 = qty * 50;
          break;
        case 20:
          result20 = qty * 20;
          break;
        case 10:
          result10 = qty * 10;
          break;
        case 5:
          result5 = qty * 5;
          break;
        case 2:
          result2 = qty * 2;
          break;
        case 1:
          result1 = qty * 1;
          break;
          case 0.50:
        result050 = qty * 0.50;
        break;

        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0) + (result2 ?? 0.0) + (result1 ?? 0.0) + (result050 ?? 0.0);

    });
  }
  void calculate20Amount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(quantity20Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      result20 = qty * 20;

      switch (value) {
        case 500:
          result500 = qty * 500;
          break;
        case 200:
          result200 = qty * 200;
          break;
        case 100:
          result100 = qty * 100;
          break;
        case 50:
          result50 = qty * 50;
          break;
        case 20:
          result20 = qty * 20;
          break;
        case 10:
          result10 = qty * 10;
          break;
        case 5:
          result5 = qty * 5;
          break;
        case 2:
          result2 = qty * 2;
          break;
        case 1:
          result1 = qty * 1;
          break;
        case 0.50:
          result050 = qty * 0.50;
          break;
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0) + (result2 ?? 0.0) + (result1 ?? 0.0) + (result050 ?? 0.0);

    });
  }
  void calculate10Amount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(quantity10Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      result10 = qty * 10;

      switch (value) {
        case 500:
          result500 = qty * 500;
          break;
        case 200:
          result200 = qty * 200;
          break;
        case 100:
          result100 = qty * 100;
          break;
        case 50:
          result50 = qty * 50;
          break;
        case 20:
          result20 = qty * 20;
          break;
        case 10:
          result10 = qty * 10;
          break;
        case 5:
          result5 = qty * 5;
          break;
        case 2:
          result2 = qty * 2;
          break;
        case 1:
          result1 = qty * 1;
          break;
        case 0.50:
          result050 = qty * 0.50;
          break;
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0) + (result2 ?? 0.0) + (result1 ?? 0.0) + (result050 ?? 0.0);

    });
  }
  void calculate5Amount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(quantity5Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      result5 = qty * 5;

      switch (value) {
        case 500:
          result500 = qty * 500;
          break;
        case 200:
          result200 = qty * 200;
          break;
        case 100:
          result100 = qty * 100;
          break;
        case 50:
          result50 = qty * 50;
          break;
        case 20:
          result20 = qty * 20;
          break;
        case 10:
          result10 = qty * 10;
          break;
        case 5:
          result5 = qty * 5;
          break;
        case 2:
          result2 = qty * 2;
          break;
        case 1:
          result1 = qty * 1;
          break;
        case 0.50:
          result050 = qty * 0.50;
          break;
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0) + (result2 ?? 0.0) + (result1 ?? 0.0) + (result050 ?? 0.0);

    });
  }
  void calculate2Amount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(quantity2Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      result2 = qty * 2;

      switch (value) {
        case 500:
          result500 = qty * 500;
          break;
        case 200:
          result200 = qty * 200;
          break;
        case 100:
          result100 = qty * 100;
          break;
        case 50:
          result50 = qty * 50;
          break;
        case 20:
          result20 = qty * 20;
          break;
        case 10:
          result10 = qty * 10;
          break;
        case 5:
          result5 = qty * 5;
          break;
        case 2:
          result2 = qty * 2;
          break;
        case 1:
          result1 = qty * 1;
          break;
        case 0.50:
          result050 = qty * 0.50;
          break;
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0) + (result2 ?? 0.0) + (result1 ?? 0.0) + (result050 ?? 0.0);

    });
  }
  void calculate1Amount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(quantity1Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      result1 = qty * 1;

      switch (value) {
        case 500:
          result500 = qty * 500;
          break;
        case 200:
          result200 = qty * 200;
          break;
        case 100:
          result100 = qty * 100;
          break;
        case 50:
          result50 = qty * 50;
          break;
        case 20:
          result20 = qty * 20;
          break;
        case 10:
          result10 = qty * 10;
          break;
        case 5:
          result5 = qty * 5;
          break;
        case 2:
          result2 = qty *2;
          break;
        case 1:
          result1 = qty * 1;
          break;
          case 0.50:
        result050 = qty * 0.50;
        break;

        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0) + (result2 ?? 0.0) + (result1 ?? 0.0) + (result050 ?? 0.0);

    });
  }
  void calculate050Amount(double value) {
    // Get the quantity from the text field
    double qty = double.tryParse(quantity050Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      result050 = qty * 0.50;

      switch (value) {
        case 500:
          result500 = qty * 500;
          break;
        case 200:
          result200 = qty * 200;
          break;
        case 100:
          result100 = qty * 100;
          break;
        case 50:
          result50 = qty * 50;
          break;
        case 20:
          result20 = qty * 20;
          break;
        case 10:
          result10 = qty * 10;
          break;
        case 5:
          result5 = qty * 5;
          break;
        case 2:
          result2 = qty * 2;
          break;
        case 1:
          result1 = qty * 1;
          break;
        case 0.50:
          result050 = qty * 0.50;
          break;
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0) + (result2 ?? 0.0) + (result1 ?? 0.0) + (result050 ?? 0.0);

    });
  }

  final String formattedDate = DateFormat('dd-mm-yyyy').format(DateTime.now());
  bool isBankDisabled = false;
  bool isStaffSelected = false;
  double? balancedamt;
  double cashamt = 10000.00; // Example value
 // TextEditingController depositController = TextEditingController();
  final depositController = TextEditingController();
  bool _isDepositEmpty = false;
  //final totalController = TextEditingController();
  double remainingAmount = 0.0;
  // void _validateForm() {
  //   setState(() {
  //     // Check if the deposit is empty
  //     _isDepositEmpty = depositController.text.isEmpty;
  //   });


  @override
  Widget build(BuildContext context) {
    var sale = bankmappingModel;

    return Scaffold(
      appBar:AppBar(
        title: Text('Cash Handover - Bank Deposit'), // Title or hint text for the text field
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
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(width: 8),
                      countTextWidgetTextcash(
                        context,'Deposit Date'
                      ),
                      // countTextWidgetTextStar(
                      //   context,
                      //   'Deposit Date',
                      //   showAsterisk: true, // Add a parameter to conditionally show the asterisk
                      // ),
                    ],
                  ),
                  SizedBox(width: 15),
                  Row(
                    children: [
                      Text(": $formattedDate"),
                      SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue),
                      SizedBox(width: 8),
                      countTextWidgetTextStar(
                        context,
                        'Deposit By',
                        showAsterisk: true, // Add a parameter to conditionally show the asterisk
                      ),
                    ],
                  ),
                  SizedBox(width: 30),
                  Row(
                    children: [
                      Text(": $userName"),
                      SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.blue),
                      SizedBox(width: 8),
                      countTextWidgetTextcash(
                        context,'Cash In Hand'
                      ),
                    ],
                  ),
                  SizedBox(width: 12),
                  Row(
                    children: [
                      //totalamt?.toStringAsFixed(2),
                      Text(':${(totalamt ?? 0).toStringAsFixed(2)}'),
                      SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue),
                      SizedBox(width: 8),
                      countTextWidgetTextStar(
                        context,
                        'Cash Handover\n To',
                        showAsterisk: true, // Add a parameter to conditionally show the asterisk
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: DropdownButtonFormField<GetStaffDetailsListUserIsMadeModel>(
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
                            ),
                          );
                        }).toList(),
                        onChanged: (selectedItem) {
                          setState(() {
                            _selectedItemModel = selectedItem;
                            _selectedItem = selectedItem?.staffName ?? '';
                            selectedItemId = selectedItem?.staffId?.toInt();
                            // Clear bank selection when staff is selected
                            _selectBankModel = null;
                            selectedBankName = null;
                            selectedBankId = null;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "OR",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance, color: Colors.blue),
                      SizedBox(width: 8),
                      countTextWidgetTextStar(
                        context,
                        ' Select Bank\n Account No.',
                        showAsterisk: true, // Add a parameter to conditionally show the asterisk
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: DropdownButtonFormField<GetBankMappingDetailsListModel>(
                        key: formKey2,
                        decoration: InputDecoration(),
                        value: _selectBankModel,
                        items: bankmappingModel.map((item) {
                          return DropdownMenuItem<GetBankMappingDetailsListModel>(
                            value: item,
                            child: Text(
                              '${item.bankName ?? ''} - ${item.accountNo ?? ''}',
                            ),
                          );
                        }).toList(),
                        onChanged: (selectedItem) {
                          setState(() {
                            _selectBankModel = selectedItem;
                            selectedBankName = selectedItem?.bankName;
                            selectedBankId = selectedItem?.accountNo;
                            getTransMode = getTransModeListForBank(selectedItem);
                            selectedTransMode = null; // Reset transaction mode
                            // Clear staff selection when bank is selected
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
                  Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.blue),
                      SizedBox(width: 8),
                      countTextWidgetTextStar(
                        context,
                        'Cash Hand/\n Deposit Amt.',
                        showAsterisk: true, // Add a parameter to conditionally show the asterisk
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: depositController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Enter Deposit Amt.',
                        border: OutlineInputBorder(),
                        errorText: _isDepositEmpty ? 'Deposit Amt. is Required' : null, // Show error if required
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isDepositEmpty = value.isEmpty;
                        });
                        updateRemainingAmount();
                      },
                    ),
                  ),
                SizedBox(width: 8),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.monetization_on, color: Colors.blue),
                      SizedBox(width: 8),
                      countTextWidgetTextcash(
                        context,'Balanced\nAmount'
                      ),
                    ],
                  ),
                  SizedBox(width: 45),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(':${remainingAmount.toString()}'),
                          SizedBox(width: 8),
                        ],
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (selectedBankName != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_balance, color: Colors.blue),
                        SizedBox(width: 8),
                        countTextWidgetTextStar(
                          context,
                          'Select Dep.\n Mode',
                          showAsterisk: true, // Add a parameter to conditionally show the asterisk
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
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
                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 20.0),
                    //     child:
                    //     DropdownButtonFormField<String>(
                    //       key: formKey3,
                    //       decoration:
                    //       InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),),
                    //       items: getTransMode
                    //           .map((String value) => DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value),
                    //       ))
                    //           .toList(),
                    //       onChanged: (value) {
                    //         setState(() {
                    //           selectedTransMode = value;
                    //         });
                    //       },
                    //       isExpanded: true,
                    //     ),
                    //   ),
                    // ),
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
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cash denomination",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
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
                                              child: Center(
                                                  child: Text(
                                                      "Note Type", style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 14),)), // Centering the text
                                            ),
                                            Expanded(
                                              child: Center(
                                                  child: Text(
                                                      "Qty", style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 14),)), // Centering the text
                                            ),
                                            Expanded(
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
                                      Container(
                                        color: Colors.black12,
                                        height: 1,
                                        width: double.infinity,
                                      ),
                                      // Second Row with Vertical Divider
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        // Center the row content
                                        children: [
                                          // First Text and Divider inside Expanded to ensure equal size
                                          Expanded(
                                            child: Center(
                                                child: Text(
                                                  "500",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      fontSize: 16),
                                                )), // Centering the text
                                          ),
                                          Text("X"),
                                          Expanded(
                                            child: Center(
                                                child: TextField(controller:quantity500Controller,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16),
                                                  textAlign: TextAlign.center, // Centers the text horizontally
                                                  decoration: InputDecoration(
                                                   // Optional: Add a border
                                                    contentPadding: EdgeInsets.zero, // Removes padding inside the TextField
                                                  ),
                                                  keyboardType: TextInputType.number, // Makes the input a number field
                                                  onChanged: (value) {
                                                    calculate500Amount(500); // Update the result when quantity changes
                                                  },
                                                )), // Centering the text
                                          ),
                                          Text("="),
                                          Expanded(
                                            child: Center(
                                                child: Text(result500.toStringAsFixed(0),
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16))), // Centering the text
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.black12,
                                        height: 1,
                                        width: double.infinity,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        // Center the row content
                                        children: [
                                          // First Text and Divider inside Expanded to ensure equal size
                                          Expanded(
                                            child: Center(
                                                child: Text(
                                                  "200",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      fontSize: 16),
                                                )), // Centering the text
                                          ),
                                          Text("X"),
                                          Expanded(
                                            child: Center(
                                                child: TextField(controller:quantity200Controller,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16),
                                                  textAlign: TextAlign.center,
                                                  keyboardType: TextInputType.number, // Makes the input a number field
                                                  onChanged: (value) {
                                                    calculate200Amount(200); // Update the result when quantity changes
                                                  },)), // Centering the text
                                          ),
                                          Text("="),
                                          Expanded(
                                            child: Center(
                                                child: Text(result200.toStringAsFixed(0),
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16))), // Centering the text
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.black12,
                                        height: 1,
                                        width: double.infinity,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        // Center the row content
                                        children: [
                                          // First Text and Divider inside Expanded to ensure equal size
                                          Expanded(
                                            child: Center(
                                                child: Text(
                                                  "100",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      fontSize: 16),
                                                )), // Centering the text
                                          ),
                                          Text("X"),
                                          Expanded(
                                            child: Center(
                                                child: TextField(controller:quantity100Controller,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16),
                                                  textAlign: TextAlign.center, // Centers the text horizontally
                                                  decoration: InputDecoration(
                                                    // Optional: Add a border
                                                    contentPadding: EdgeInsets.zero, // Removes padding inside the TextField
                                                  ),
                                                  keyboardType: TextInputType.number, // Makes the input a number field
                                                  onChanged: (value) {
                                                    calculate100Amount(100); // Update the result when quantity changes
                                                  },)), // Centering the text
                                          ),
                                          Text("="),
                                          Expanded(
                                            child: Center(
                                                child: Text(result100.toStringAsFixed(0),
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16),
                                                )), // Centering the text
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.black12,
                                        height: 1,
                                        width: double.infinity,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        // Center the row content
                                        children: [
                                          // First Text and Divider inside Expanded to ensure equal size
                                          Expanded(
                                            child: Center(
                                                child: Text(
                                                  "50",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      fontSize: 16),
                                                )), // Centering the text
                                          ),
                                          Text("X"),
                                          Expanded(
                                            child: Center(
                                                child: TextField(controller:quantity50Controller ,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16),  textAlign: TextAlign.center, // Centers the text horizontally
                                                  decoration: InputDecoration(
                                                    // Optional: Add a border
                                                    contentPadding: EdgeInsets.zero, // Removes padding inside the TextField
                                                  ),
                                                  keyboardType: TextInputType.number, // Makes the input a number field
                                                  onChanged: (value) {
                                                    calculate50Amount(50); // Update the result when quantity changes
                                                  },)), // Centering the text
                                          ),
                                          Text("="),
                                          Expanded(
                                            child: Center(
                                                child: Text(result50.toStringAsFixed(0),
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16))), // Centering the text
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.black12,
                                        height: 1,
                                        width: double.infinity,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        // Center the row content
                                        children: [
                                          // First Text and Divider inside Expanded to ensure equal size
                                          Expanded(
                                            child: Center(
                                                child: Text(
                                                  "20",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      fontSize: 16),
                                                )), // Centering the text
                                          ),
                                          Text("X"),
                                          Expanded(
                                            child: Center(
                                                child: TextField(controller:quantity20Controller,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16),
                                                  textAlign: TextAlign.center, // Centers the text horizontally
                                                  decoration: InputDecoration(
                                                    // Optional: Add a border
                                                    contentPadding: EdgeInsets.zero, // Removes padding inside the TextField
                                                  ),
                                                  keyboardType: TextInputType.number, // Makes the input a number field
                                                  onChanged: (value) {
                                                    calculate20Amount(20); // Update the result when quantity changes
                                                  },)), // Centering the text
                                          ),
                                          Text("="),
                                          Expanded(
                                            child: Center(
                                                child: Text(result20.toStringAsFixed(0),
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16))), // Centering the text
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.black12,
                                        height: 1,
                                        width: double.infinity,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        // Center the row content
                                        children: [
                                          // First Text and Divider inside Expanded to ensure equal size
                                          Expanded(
                                            child: Center(
                                                child: Text(
                                                  "10",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      fontSize: 16),
                                                )), // Centering the text
                                          ),
                                          Text("X"),
                                          Expanded(
                                            child: Center(
                                                child: TextField(controller:quantity10Controller,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16),
                                                  textAlign: TextAlign.center, // Centers the text horizontally
                                                  decoration: InputDecoration(
                                                    // Optional: Add a border
                                                    contentPadding: EdgeInsets.zero, // Removes padding inside the TextField
                                                  ),
                                                  keyboardType: TextInputType.number, // Makes the input a number field
                                                  onChanged: (value) {
                                                    calculate10Amount(10); // Update the result when quantity changes
                                                  },)), // Centering the text
                                          ),
                                          Text("="),
                                          Expanded(
                                            child: Center(
                                                child: Text(result10.toStringAsFixed(0),
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16))), // Centering the text
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.black12,
                                        height: 1,
                                        width: double.infinity,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        // Center the row content
                                        children: [
                                          // First Text and Divider inside Expanded to ensure equal size
                                          Expanded(
                                            child: Center(
                                                child: Text(
                                                  "5",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      fontSize: 16),
                                                )), // Centering the text
                                          ),
                                          Text("X"),
                                          Expanded(
                                            child: Center(
                                                child: TextField(controller:quantity5Controller,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16),
                                                  textAlign: TextAlign.center, // Centers the text horizontally
                                                  decoration: InputDecoration(
                                                    // Optional: Add a border
                                                    contentPadding: EdgeInsets.zero, // Removes padding inside the TextField
                                                  ),
                                                  keyboardType: TextInputType.number, // Makes the input a number field
                                                  onChanged: (value) {
                                                    calculate5Amount(5); // Update the result when quantity changes
                                                  },)), // Centering the text
                                          ),
                                          Text("="),
                                          Expanded(
                                            child: Center(
                                                child: Text(result5.toStringAsFixed(0),
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16))), // Centering the text
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.black12,
                                        height: 1,
                                        width: double.infinity,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        // Center the row content
                                        children: [
                                          // First Text and Divider inside Expanded to ensure equal size
                                          Expanded(
                                            child: Center(
                                                child: Text(
                                                  "2",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      fontSize: 16),
                                                )), // Centering the text
                                          ),
                                          Text("X"),
                                          Expanded(
                                            child: Center(
                                                child: TextField(controller:quantity2Controller,
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .normal,
                                                      fontSize:
                                                      16),
                                                  textAlign: TextAlign.center, // Centers the text horizontally
                                                  decoration: InputDecoration(
                                                    // Optional: Add a border
                                                    contentPadding: EdgeInsets.zero, // Removes padding inside the TextField
                                                  ),
                                                  keyboardType: TextInputType.number, // Makes the input a number field
                                                  onChanged: (value) {
                                                    calculate2Amount(2); // Update the result when quantity changes
                                                  },)), // Centering the text
                                          ),
                                          Text("="),
                                          Expanded(
                                            child: Center(
                                                child: Text(result2.toStringAsFixed(0),
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16))), // Centering the text
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.black12,
                                        height: 1,
                                        width: double.infinity,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        // Center the row content
                                        children: [
                                          // First Text and Divider inside Expanded to ensure equal size
                                          Expanded(
                                            child: Center(
                                                child: Text(
                                                  "1",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      fontSize: 16),
                                                )), // Centering the text
                                          ),
                                          Text("X"),
                                          Expanded(
                                            child: Center(
                                                child: TextField(controller:quantity1Controller,
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .normal,
                                                      fontSize:
                                                      16),
                                                  textAlign: TextAlign.center, // Centers the text horizontally
                                                  decoration: InputDecoration(
                                                    // Optional: Add a border
                                                    contentPadding: EdgeInsets.zero, // Removes padding inside the TextField
                                                  ),
                                                  keyboardType: TextInputType.number, // Makes the input a number field
                                                  onChanged: (value) {
                                                    calculate1Amount(1); // Update the result when quantity changes
                                                  },)), // Centering the text
                                          ),
                                          Text("="),
                                          Expanded(
                                            child: Center(
                                                child: Text(result1.toStringAsFixed(0),
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16))), // Centering the text
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.black12,
                                        height: 1,
                                        width: double.infinity,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        // Center the row content
                                        children: [
                                          // First Text and Divider inside Expanded to ensure equal size
                                          Expanded(
                                            child: Center(
                                                child: Text(
                                                  "0.50",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      fontSize: 16),
                                                )), // Centering the text
                                          ),
                                          Text("X"),
                                          Expanded(
                                            child: Center(
                                                child: TextField(controller:quantity050Controller,
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .normal,
                                                      fontSize:
                                                      16),
                                                  textAlign: TextAlign.center, // Centers the text horizontally
                                                  decoration: InputDecoration(
                                                    // Optional: Add a border
                                                    contentPadding: EdgeInsets.zero, // Removes padding inside the TextField
                                                  ),
                                                  keyboardType: TextInputType.number, // Makes the input a number field
                                                  onChanged: (value) {
                                                    calculate050Amount(0.50); // Update the result when quantity changes
                                                  },)), // Centering the text
                                          ),
                                          Text("="),
                                          Expanded(
                                            child: Center(
                                                child: Text(result050.toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontSize:
                                                        16))), // Centering the text
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.black12,
                                        height: 1,
                                        width: double.infinity,
                                      ),
                                      SizedBox(height: 20),

                                      // Total Amount Field
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Total Amount:',style: TextStyle(fontWeight: FontWeight.bold),),
                                            ),
                                            SizedBox(
                                              width: 150,
                                              height: 40,
                                              child: Container(
                                                alignment: Alignment.center, // Ensure the text inside is centered both horizontally and vertically
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(width: 1), // Optional: Add rounded corners
                                                ),
                                                child: Text(
                                                  total.toString(),
                                                  textAlign: TextAlign.center, // Centers the text horizontally
                                                  style: TextStyle(fontSize: 16), // Optional: Adjust text style if needed
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            )
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
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
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
                        saveAction();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
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

              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.blue,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(50),
              //       ),
              //     ),
              //     child: Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
              //   ),
              // ),
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
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getNoteTypeAndIdFroDenominationListModel = data
                .map((jsonItem) =>
                GetNoteTypeAndIdFroDenominationListModel.fromJson(jsonItem))
                .toList();
            isLoading = false;
          });
          // int expenseDetailList = 0;
          //
          // for (var i = 0; i < getExpenseDetailListModel!.length; i++) {
          //   int? getExpenseDetailList = getExpenseDetailListModel![i].expAmount?.toInt();
          //   expenseDetailList += getExpenseDetailList!;
          // }
          // debugPrint("Response body expenseDetailList: ${expenseDetailList}");
          // expenseAmtTotal = expenseDetailList;
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
  void updateRemainingAmount() {
    final deposit = double.tryParse(depositController.text) ?? 0.0;
    final total = cashamt ?? 0.0;

    setState(() {
      remainingAmount = total - deposit;
    });
  }
  void saveAction()
  {

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
  }
