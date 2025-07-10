import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/CustomAppBarManager.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../BootomNavigatinBarManager.dart';
import '../CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';
import '../CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import '../CashHandoverModelClass/GetCashHandOverDtlsModel.dart';
import '../ManagerModelClass/DenomModel.dart';
import '../ManagerMoreScreen.dart';
import '../UpdatePaymentsScreen/GetCashHandOverDtlsListModel.dart';
import '../UpdatePaymentsScreen/GetStaffDetailsListModel.dart';
import 'GetCashDenominationDtlsByIdModel.dart';
import 'GetSalaryIncentiveEntryListModel.dart';

class SalaryPaymentScreen extends StatefulWidget {
  static const screenName = '/salaryPaymentScreen';
  const SalaryPaymentScreen({super.key});

  @override
  State<SalaryPaymentScreen> createState() => _SalaryPaymentScreenState();
}
class _SalaryPaymentScreenState extends State<SalaryPaymentScreen>{

  final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  List<String> getpaidAgainstSalary = ["Commission Charges", "Salary", "Incentive", "Advance"];
  String? selectedpaidAgainstSalary;
  List<String> getTransMode = ["Cash", "Online"];
  String? selectedTransMode;
  GetBankMappingDetailsListModel? _selectBankModel;
  List<GetSalaryIncentiveEntryListModel> listModel = [];
  List<GetCashDenominationDtlsByIdModel> returndenominationModel = [];
  final String cDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  late List<TextEditingController> qtyController;
  late List<double> amounts;
  double totalAmount = 0.0;
  late double finalAmountCashDeno;
  late Map<int, bool> isQtyFilled;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey5 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey6 = GlobalKey<FormState>();
  final timeController = TextEditingController();
  final transReviewController = TextEditingController();
  late final _balanceController = TextEditingController();
  final TranCodeController = TextEditingController();
  final remarkController = TextEditingController();
  TextEditingController vendorNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  bool _isDepositEmpty = false;
  bool isCashDenominationListViewVisible = false;
  List<DenomModel>getNoteTypeAndIdFroDenominationListModel = [];
  List<dynamic> dataCashDenominationList = [];
  bool isLoading = true;
  List<GetCashHandOverDtlsListModel> cashdatamodel = [];
  List<GetStaffDetailsListModel> staffmodel = [];
  GetStaffDetailsListModel? selectedstaff;
   bool isvisibilityStaffStatus = false;
  List<GetBankMappingDetailsListModel> bankModel = [];
  String? selectedBankName;
  String? selectedBankId;
  double? valueBal;
  bool _isTranscode = false;
  bool _isVendorName = false;
  String? receiptNoText;
  String? cashInHandEdit;
  List<dynamic> dataCashInHandList = [];
  DateTime selectedDate = DateTime.now();

  double? totalAmt;
  String? userName,userId;
  String? _selectedItem;
  int? selectedItemId;
  int? selectedItemType;
  String? _selectedExp;
  int? selectedExpId;
  String? _selectedVendor;
  int? vendorId;
  String? _errorText;
  bool _isConCOntactEmpty = false;
  bool _isInvalidMobile = false;
  bool _isShortLength = false;
  String balanceAmount = '';
  String vehicleNumber = '';
  int? vehicleId = 0;
  int? selecteBankIDApi;
  int? accMappingId;
  bool isEditing = false;
  var argValue;
  String? modes;
  int? salaryEntryId;
  int? payId;
  bool saveFlag = false;
  // @override
  // void initState() {
  //   super.initState();
  //   getNoteTypeAndIDList();
  //   fetchBank();
  //   fetchSavedData();
  //    getCashHandOverDtlsList(selectedDate);
  //   getStaffDetailsList();
  //   loadInitialStaffData();
  //   getSalaryPaymentList();
  //   getVoucherNoForExpense();
  //
  //   Future.delayed(Duration.zero, () {
  //     setState(() async {
  //       argValue = ModalRoute.of(context)?.settings.arguments as Map;
  //       modes = argValue?["modeChange"]?? '';
  //       if (argValue != null) {
  //         String paymentModeEdit = argValue["paymentModeV"] ?? 0;
  //          selectedTransMode = paymentModeEdit;
  //         String staffNameEdit = argValue["staffNameV"] ?? 0;
  //         selectedItemId = int.tryParse(argValue["staffIdV"] ?? '') ?? 0;
  //         String paidModeEdit = argValue["paidModeV"] ?? 0;
  //         selectedpaidAgainstSalary = paidModeEdit;
  //         int selectecteItemTypeEdit = argValue["ItemTypeV"];
  //         selectedItemType = selectecteItemTypeEdit;
  //         //updateSelectedPaidAgainstSalary() = paidModeEdit;
  //         //updateSelectedPaidAgainstSalary();
  //        // filteredPaidAgainstSalary = paidModeEdit;
  //         double amountTotalEdit = double.tryParse(argValue["amountTotalV"] ?? '') ?? 0;
  //         selectedExpId = int.tryParse(argValue["expHeadId"] ?? '') ?? 0;
  //         String payRemarkEdit = argValue["payRemarkV"] ?? 0;
  //         String transTimeEdit = argValue["transTimeV"] ?? 0;
  //         String transRemarkEdit = argValue["transRemarkV"] ?? 0;
  //         String transationCodeEdit = argValue["transationCodeV"] ?? 0;
  //         String accountNoEdit = argValue["accountNoV"] ?? 0;
  //         selecteBankIDApi = int.tryParse(argValue["bankIdV"] ?? '') ?? 0;
  //         accMappingId = int.tryParse(argValue["mappingIdV"] ?? '') ?? 0;
  //         salaryEntryId = int.tryParse(argValue["salaryEntryIDV"] ?? '') ?? 0;
  //
  //         timeController.text = transTimeEdit;
  //         TranCodeController.text = transationCodeEdit;
  //         transReviewController.text = transRemarkEdit;
  //         _balanceController.text = amountTotalEdit.toString();
  //         remarkController.text = payRemarkEdit;
  //
  //
  //         if(filteredPaidAgainstSalary.contains(paidModeEdit)){
  //           selectedpaidAgainstSalary = paidModeEdit;
  //           selectedItemType = selectecteItemTypeEdit;
  //         } else{
  //           selectedpaidAgainstSalary = null;
  //         }
  //
  //         // if(getpaidAgainstSalary.contains(paidModeEdit)){
  //         //   selectedpaidAgainstSalary = paidModeEdit;
  //         //   selectedItemType = selectecteItemTypeEdit;
  //         // } else{
  //         //   selectedpaidAgainstSalary = null;
  //         // }
  //
  //         //Edit Action For Transaction Mode
  //         if(getTransMode.contains(paymentModeEdit)){
  //           selectedTransMode = paymentModeEdit;
  //         }else if(paymentModeEdit == "Bank"){
  //            selectedTransMode = "Online";
  //          } else{
  //           selectedTransMode = null;
  //         }
  //
  //         //Edit Action On Selected Staff
  //         if (selectedItemId != 0) {
  //           getStaffDetailsList().whenComplete(() {
  //             selectedstaff = staffmodel.firstWhere(
  //                   (item) => item.staffName == staffNameEdit,
  //               orElse: () => GetStaffDetailsListModel(staffName: ''),
  //             );
  //             debugPrint("Staff selected during edit: ${selectedstaff?.staffName}");
  //           });
  //         }
  //
  //         //Edit Action On Cash Denomination
  //         getNoteTypeAndIDList().whenComplete((){
  //           getReceiptCashDenominationDtl(salaryEntryId!).whenComplete(() {
  //             if (returndenominationModel.isNotEmpty) {
  //               initializeControllers();
  //             } else {
  //               debugPrint("Denomination data is empty");
  //             }
  //           });
  //         });
  //
  //         //Edit Action On Bank Mode
  //         // await fetchBank();
  //         // if(accountNoEdit.isNotEmpty && accountNoEdit != "null"){
  //         //   final match = bankModel.firstWhere(
  //         //         (item) => item.accountNo?.trim() == accountNoEdit.trim(),
  //         //     orElse: () => GetBankMappingDetailsListModel(),
  //         //   );
  //         //
  //         //   if((match.accountNo ?? '').isNotEmpty){
  //         //     setState(() {
  //         //       _selectBankModel = match;
  //         //     });
  //         //   }
  //         // }
  //         await fetchBank();
  //         if(accountNoEdit.isNotEmpty && accountNoEdit != "null"){
  //           final match = bankModel.firstWhere(
  //                 (item) => item.accountNo?.trim() == accountNoEdit.trim(),
  //             orElse: () => GetBankMappingDetailsListModel(),
  //           );
  //
  //           if((match.accountNo ?? '').isNotEmpty){
  //             setState(() {
  //               _selectBankModel = match;
  //             });
  //           }
  //         }
  //       }
  //     });
  //   });
  // }
  List<CahsDenominationMandatoryFlagModel> cashDenoMandatoryList = [];
  bool cashDenominationMandatory = false;
  @override
  void initState() {
    super.initState();
    checkAndSaveDayEndData();
    checkCashDenominationFlagMandatory();
    // First, execute asynchronous operations without calling setState
    getNoteTypeAndIDList();
    fetchBank();
    fetchSavedData();
    getCashHandOverDtlsList(selectedDate);
    getStaffDetailsList();
    loadInitialStaffData();
    getSalaryPaymentList();
    getVoucherNoForExpense();

    // Then, execute delayed tasks that involve async code
    Future.delayed(Duration.zero, () async {
      // Fetch data from arguments
      argValue = ModalRoute.of(context)?.settings.arguments as Map?;
      modes = argValue?["modeChange"] ?? '';

      if (argValue != null) {
        String paymentModeEdit = argValue["paymentModeV"] ?? 0;
        selectedTransMode = paymentModeEdit;

        String staffNameEdit = argValue["staffNameV"] ?? 0;
        selectedItemId = int.tryParse(argValue["staffIdV"] ?? '') ?? 0;

        String paidModeEdit = argValue["paidModeV"] ?? 0;
        selectedpaidAgainstSalary = paidModeEdit;

        double amountTotalEdit = double.tryParse(argValue["amountTotalV"] ?? '') ?? 0;
        selectedExpId = int.tryParse(argValue["expHeadId"] ?? '') ?? 0;
        String payRemarkEdit = argValue["payRemarkV"] ?? 0;
        String transTimeEdit = argValue["transTimeV"] ?? 0;
        String transRemarkEdit = argValue["transRemarkV"] ?? 0;
        String transationCodeEdit = argValue["transationCodeV"] ?? 0;
        String accountNoEdit = argValue["accountNoV"] ?? 0;
        selecteBankIDApi = int.tryParse(argValue["bankIdV"] ?? '') ?? 0;
        accMappingId = int.tryParse(argValue["mappingIdV"] ?? '') ?? 0;
        salaryEntryId = int.tryParse(argValue["salaryEntryIDV"] ?? '') ?? 0;
        if (filteredPaidAgainstSalary.contains(paidModeEdit)) {
          selectedpaidAgainstSalary = paidModeEdit;

        } else {
          selectedpaidAgainstSalary = null;
        }
        // Set controller texts
        timeController.text = transTimeEdit;
        TranCodeController.text = transationCodeEdit;
        transReviewController.text = transRemarkEdit;
        _balanceController.text = amountTotalEdit.toString();
        remarkController.text = payRemarkEdit;



        // Edit action for transaction mode
        if (getTransMode.contains(paymentModeEdit)) {
          selectedTransMode = paymentModeEdit;
        } else if (paymentModeEdit == "Bank") {
          selectedTransMode = "Online";
        } else {
          selectedTransMode = null;
        }

        // Edit action for selected staff
        if (selectedItemId != 0) {
          await getStaffDetailsList(); // Wait for staff details list to load
          selectedstaff = staffmodel.firstWhere(
                (item) => item.staffId == selectedItemId,
            orElse: () => GetStaffDetailsListModel(staffName: ''),
          );
          debugPrint("Staff selected during edit: ${selectedstaff?.staffId}");
          setState(() {
            // Assuming 'staffType' is part of your staff model
            selectedItemType = selectedstaff?.staffType != null
                ? int.tryParse(selectedstaff!.staffType.toString())
                : null;
            debugPrint("selectecteItemTypeEditint $selectedItemType");

          });
        }


        // Edit action for cash denomination
        await getNoteTypeAndIDList(); // Wait for denomination data
        await getReceiptCashDenominationDtl(salaryEntryId!); // Get denomination details
        if (returndenominationModel.isNotEmpty) {
          initializeControllers();
        } else {
          debugPrint("Denomination data is empty");
        }

        // Edit action for bank mode
        await fetchBank();
        if (accountNoEdit.isNotEmpty && accountNoEdit != "null") {
          final match = bankModel.firstWhere(
                (item) => item.accountNo?.trim() == accountNoEdit.trim(),
            orElse: () => GetBankMappingDetailsListModel(),
          );

          if ((match.accountNo ?? '').isNotEmpty) {
            setState(() {
              _selectBankModel = match;
            });
          }
        }
      }
    });
  }

  // void updateSelectedPaidAgainstSalary() {
  //   if (filteredPaidAgainstSalary.contains(paidModeEdit)) {
  //     selectedpaidAgainstSalary = paidModeEdit;
  //   } else {
  //     selectedpaidAgainstSalary = null; // or some default value
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return
      WillPopScope(
        onWillPop: () async {
          if (argLRAdd == "fromDrawer") {
            Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
            return false;
          } else {
            Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
            return false;
          }
        },
        child: Scaffold(
        appBar:CustomAppBarManager(
          title: 'Salary Payment', // Title or hint text for the text field
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
                          'Cash In Hand'),
                    ),
                    Flexible(flex: 1,
                      child:
                      Text('${formatCurrency(totalAmt ?? 0)}',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: textWidgetBlueColorWithoutStar('Paid Date'),
                    ),
                    Flexible(flex: 1,
                      child: Text("$formattedDate",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: textWidgetBlueColorWithStar(
                            'Staff Name',
                            "*"
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left:0.0),
                          child:
                          DropdownButtonFormField<GetStaffDetailsListModel>(
                            isExpanded: true,
                            key: formKey1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            ),
                            value:staffmodel.contains(selectedstaff)?selectedstaff:null ,
                            items: staffmodel.map((item) {
                              return DropdownMenuItem<GetStaffDetailsListModel>(
                                value: item,
                                child: Text(
                                  item.staffName ?? '',
                                  style: Styling.itemBlackTest,
                                ),
                              );
                            }).toList(),
                            onChanged: (selectedItem) {
                              setState(() {
                                debugPrint("on chabge");
                                selectedstaff = selectedItem;
                                _selectedItem = selectedItem?.staffName ?? '';
                                selectedItemId = selectedItem?.staffId?.toInt();
                                selectedItemType = selectedItem?.staffType?.toInt();
                                debugPrint("selectedItemType $selectedItemType");
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                 // SizedBox(height: 10),
                  SizedBox(height: 5),
                Visibility(
                    visible: selectedstaff != null && selectedItemType != 2, // Only visible when a staff is selected
                    child:
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child:
                      textWidgetBlueColorWithStar(
                        'Paid Against',
                        "*", // Add a parameter to conditionally show the asterisk
                      ),
                    ),
                    Flexible(
                 flex: 1,
                        child:
                        // DropdownButtonFormField<String>(
                        //   key: formKey2,
                        //   decoration: InputDecoration(
                        //     contentPadding: EdgeInsets.symmetric(
                        //         vertical: 12, horizontal: 10),
                        //   ),
                        //   value: selectedpaidAgainstSalary,
                        //   // Bind the selected value
                        //   items: filteredPaidAgainstSalary.map((String value) =>
                        //       DropdownMenuItem<String>(
                        //         value: value,
                        //         child: Text(value),
                        //       ))
                        //       .toList(),
                        //   onChanged: (value) {
                        //     setState(() {
                        //       selectedpaidAgainstSalary =
                        //           value;
                        //     });
                        //   },
                        //   isExpanded: true,
                        // ),
                        DropdownButtonFormField<String>(
                          key: formKey2,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          ),
                          // value: selectedpaidAgainstSalary,
                          value:filteredPaidAgainstSalary.contains(selectedpaidAgainstSalary)?selectedpaidAgainstSalary:null ,
                          // Ensure the list has no duplicate values
                          items: filteredPaidAgainstSalary.toSet().toList().map((String value) =>
                              DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              )
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedpaidAgainstSalary = value;
                            });
                          },
                          isExpanded: true,
                        ),

                    ),
                   ],
                  ),
                ),
               // SizedBox(height: 10),
                //SizedBox(height: 5),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: textWidgetBlueColorWithStar(
                        'Paid Salary Amount',
                        "*",
                      ),
                    ),
                    // Flexible(
                    //   flex: 1,
                    //   child: TextField(
                    //     controller: _balanceController,
                    //     keyboardType: TextInputType.number,
                    //     // inputFormatters: [
                    //     //   FilteringTextInputFormatter.deny(RegExp(r'\s')), // Disallow spaces
                    //     //
                    //     // ],
                    //     onChanged: (value) {
                    //
                    //       setState(() {
                    //         _isDepositEmpty = value.isEmpty;
                    //         double val = double.tryParse(value.replaceAll(',', '')) ?? 0;
                    //         if (val > totalAmt!) {
                    //           _balanceController.clear();
                    //         }
                    //       });
                    //     },
                    //     decoration: InputDecoration(
                    //       hintText: 'Enter paid Salary Amount',
                    //       errorText: _isDepositEmpty ? 'Paid Salary Amt is required' : null,
                    //       errorStyle: TextStyle(color: Colors.red),
                    //       focusedErrorBorder: UnderlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.red),
                    //       ),
                    //       errorBorder: UnderlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.red),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Flexible(
                      flex: 1,
                      child: TextField(
                        controller: _balanceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')), // Disallow spaces
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow digits and one decimal
                          LengthLimitingTextInputFormatter(9), // Limit to 9 characters total
                        ],
                        onChanged: (value) {
                          setState(() {
                            _isDepositEmpty = value.isEmpty;
                            double val = double.tryParse(value.replaceAll(',', '')) ?? 0;


                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter paid Salary Amount',
                          errorText: _isDepositEmpty ? 'Paid Salary Amt is required and must be greater than zero' : null,
                          errorStyle: TextStyle(color: Colors.red),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                  SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child:
                      textWidgetBlueColorWithStar(
                        'Payment Mode',
                        "*", // Add a parameter to conditionally show the asterisk
                      ),
                    ),
                    Flexible(flex: 1,
                      child:
                      DropdownButtonFormField<String>(
                        key: formKey4,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                        ),

                        value: selectedTransMode,
                        // Bind the selected value
                        items: getTransMode.map((String value) =>
                            DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedTransMode =
                                value;
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                if(selectedTransMode == "Online")
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child:
                            DropdownButtonFormField<
                                GetBankMappingDetailsListModel>(
                              value:bankModel.contains(_selectBankModel)?_selectBankModel:null ,
                              items: bankModel.map((item) {
                                return DropdownMenuItem<
                                    GetBankMappingDetailsListModel>(
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
                                  selecteBankIDApi = selectedItem?.bankId?.toInt();
                                  accMappingId = selectedItem?.mappingId?.toInt();
                                });
                              },
                              hint: Text('Select Acc No'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:
                            TextField(
                              controller: TranCodeController,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced, // Enforce max length
                              // inputFormatters: <TextInputFormatter>[
                              //   LengthLimitingTextInputFormatter(30), // Limit the length to 30 characters
                              // ],
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(30), // Limit to 30 characters
                                FilteringTextInputFormatter.deny(
                                  RegExp(r'[^\u0000-\u007F]'), // Block emojis and non-ASCII characters
                                ),
                                FilteringTextInputFormatter.deny(
                                  RegExp(r'\s'), // Block all whitespace including space, tab, etc.
                                ),
                              ],
                              decoration: InputDecoration(
                                errorText: _isTranscode
                                    ? 'Transaction code is Required'
                                    : null,
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    countTextWidgetTextStar(
                                      context,
                                      'Transaction Code',
                                      showAsterisk: true,
                                    ),
                                  ],
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _isTranscode = value.isEmpty;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: timeController,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.allow(
                              //     RegExp(r'^\d{0,5}:?$'), // up to 5 digits, optional 1 colon at end
                              //   ),
                              // ],
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}:?\d{0,2}$')),
                                LengthLimitingTextInputFormatter(5),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Time',
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child:
                            TextField(
                              controller: transReviewController,
                              decoration: InputDecoration(
                                labelText: 'Transaction Remark',
                              ),
                              maxLines: 2, // Allows multiline remarks
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(250), // Limit to 250 characters
                              ],
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: textWidgetBlueColorWithoutStar(
                          'Enter Remark'
                      ),
                    ),
                    Flexible(flex: 1,
                      child:
                      TextField(
                        controller: remarkController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(250), // Limit to 250 characters
                        ],
                        decoration: InputDecoration(
                          labelText: 'Remark',
                        ),
                        maxLines: 2, // Allows multiline remarks
                      ),
                    ),
                  ],
                ),
                if(selectedTransMode == "Cash")
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isCashDenominationListViewVisible =
                            !isCashDenominationListViewVisible;
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
                                        cashDenominationMandatory?"Cash Denomination Is Mandatory":
                                        "Cash denomination",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,),
                                      ),
                                    ],
                                  ),
                                ),
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
                                      SizedBox(
                                        height:50,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
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
                                                            FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                                            LengthLimitingTextInputFormatter(3),    // Limit input to 3 digits only
                                                          ],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              // Update amounts based on the index
                                                              amounts[index] = (double.tryParse(value) ?? 0.0) * data.noteType!;

                                                              // Recalculate totalAmount
                                                              totalAmount = amounts.fold(0.0, (sum, amount) => sum + amount);
                                                              debugPrint("totalAmount: $totalAmount");

                                                              // Parse the balance input
                                                              final valueBal = double.tryParse(_balanceController.text);

                                                              // Validate the balance
                                                              if (valueBal == null) {
                                                                // Handle invalid input
                                                                showFlushBar(context, Constants.cashAmount);
                                                              } else if (valueBal < totalAmount) {
                                                                // Handle insufficient balance
                                                                showFlushBar(context, Constants.amountEqual);
                                                              }
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
                                                child: Text("Amount : ",
                                                    style: Styling.itemBlackTestBold,
                                                    textAlign: TextAlign.left)),
                                            Expanded(
                                              flex: 0,
                                              child: Text(
                                                totalAmount.toStringAsFixed(2),
                                                style: Styling.itemBlackTestBold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(width: 10), // Adds space between buttons
                    ElevatedButton(
                      onPressed: () {
                        if (saveFlag) {
                          print('saveFlag $saveFlag');
                          showFlushBar(context, Constants.dayEndCompleted);
                        } else {
                          if (modes == "EDIT") {
                            SalaryIncentiveEntryAddEdit(salaryEntryId!, "EDIT");

                          } else {
                            SalaryIncentiveEntryAddEdit(0, "ADD");
                          }
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:saveFlag?Colors.grey:Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10, // Adjust padding to make button smaller
                        ),
                      ),
                      child: Text(
                        modes == "EDIT" ? 'Update' : 'Save',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Card(
                  child: listModel.isNotEmpty
                      ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listModel.length,
                    itemBuilder: (context, index) {
                      GetSalaryIncentiveEntryListModel? payList = listModel[index];
                      return  Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Expanded(child: Text( payList.paidDate ?? '', style: TextStyle(color: Colors.blue),),),
                              Expanded(child: Text(payList.paidDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(payList.paidDate!)) : '', style: TextStyle(color: Colors.blue),),),
                              Expanded(child: Text(payList.staffName ?? '', style: TextStyle(color: Colors.blue),),),
                              Expanded(
                                flex: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,  // Align the icons to the right
                                  children: [
                                    // Edit Icon
                                    IconButton(
                                      icon: Icon(Icons.edit, color:saveFlag?Colors.blueGrey:Colors.blue),  // Icon for edit
                                      onPressed: () {
                                        setState(() {
                                          var paidDate = payList.paidDate.toString();
                                          var paymentMode = payList.paymentMode.toString();
                                          var staffName = payList.staffName.toString();
                                          var staffId = payList.staffId.toString();
                                          var paidAgainst = payList.paidAgainst.toString();
                                          var amountTotal = payList.paidSalaryAmt.toString();
                                          var transTime = payList.transactionTime.toString();
                                          var transationCode = payList.transactionCode.toString();
                                          var transRemark = payList.transactionRemark.toString();
                                          var bankId = payList.bankId.toString();
                                          var itemType = payList.runtimeType.toString();
                                          var mappingId = payList.bankMappingId.toString();
                                          var accountNo = payList.accountNo.toString();
                                          var remark = payList.remark.toString();
                                          var salaryEntryId = payList.salaryEntryId.toString();
                                          //int payId = int.parse(salaryEntryId);
                                          // Navigate to the target screen and pass the data
                                          if (saveFlag) {
                                            print('saveFlag $saveFlag');
                                            showFlushBar(context, Constants.dayEndCompleted);
                                          } else {
                                            Navigator.pushNamed(
                                              context,
                                              SalaryPaymentScreen.screenName,
                                              arguments: {
                                                'depositDateV': paidDate,
                                                'paymentModeV': paymentMode,
                                                'staffNameV' : staffName,
                                                'staffIdV': staffId,
                                                'paidModeV': paidAgainst,
                                                'amountTotalV': amountTotal,
                                                'payRemarkV': remark,
                                                'transTimeV': transTime,
                                                'transationCodeV': transationCode,
                                                'transRemarkV': transRemark,
                                                'bankIdV': bankId,
                                                'ItemTypeV': itemType,
                                                'mappingIdV': mappingId,
                                                'accountNoV': accountNo,
                                                'salaryEntryIDV': salaryEntryId,
                                                'modeChange': "EDIT"
                                              },
                                            );
                                          }
                                        });
                                      },
                                    ),
                                    // Icon for delete
                                    IconButton(
                                      icon: Icon(Icons.delete, color:saveFlag?Colors.redAccent:Colors.red), // Icon for delete
                                      onPressed: () async {
                                        if (saveFlag) {
                                          print('saveFlag $saveFlag');
                                          showFlushBar(context, Constants.dayEndCompleted);
                                        } else {
                                          int? pId = (payList.salaryEntryId)?.toInt();
                                          print('Delete button pressedd${payList.salaryEntryId}');
                                          // Show confirmation dialog
                                          bool? confirmDelete = await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Are you sure?'),
                                                content: const Text('You want to delete?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(false); // User pressed Cancel
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(true); // User pressed Delete
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          // If user confirmed deletion
                                          if (confirmDelete == true) {
                                            if (pId != null) {
                                              SalaryIncentiveEntryAddEdit(pId, "DELETE");
                                              print('Delete button pressed$pId');
                                            } else {
                                              print("Receipt ID is null.");
                                            }
                                          } else {
                                            print('Delete action was canceled');
                                          }
                                        }

                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(flex:1,child: countTextWidgetText(context,"Paid Against", payList.paidAgainst ?? '')),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(flex:1,child: countTextWidgetText(context,"Paid Salary Amount", payList.paidSalaryAmt.toString())),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(flex:1,child: countTextWidgetText(context,"Payment Mode", payList.paymentMode ?? '')),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(flex:1,child: countTextWidgetText(context,"Remark", payList.remark.toString())),
                            ],
                          ),
                          Divider(
                              color: Colors.white70, thickness: 3),
                        ],
                      );
                    },
                  )
                      : Center(
                    child: Text('No Records Found'),
                  ),
                ),
              ],
            ),
          ),
        ),
            ),
      );
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

  Future<void> fetchBank() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetBankMappingDetailsList}/$distributorId/0'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetBankMappingDetailsListModel : " +
        '${AppUrl.GetBankMappingDetailsList}/$distributorId/0');
    debugPrint("GetBankMappingDetailsListModel : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        bankModel = data.map((json) {
          return GetBankMappingDetailsListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getVoucherNoForExpense() async {
    EasyLoading.show();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) {
        isLoading = false;
        EasyLoading.dismiss();
        throw Exception('Bearer token is missing');
      }
      debugPrint('mnhfgjfjf');
      final response = await http.get(
        Uri.parse(
            '${AppUrl.GetVoucherNoForExpense}/$distributorId'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      if (response.statusCode == 200) {
        // Assuming response.body is the string you want to set.
        String receiptNo = response.body;
        debugPrint('mnhfgjfjf$receiptNo');// Remove any leading/trailing spaces
        receiptNo = receiptNo.replaceAll('"', '');
        setState(() {
          receiptNoText = receiptNo;
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.dismiss();
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      print('Error: $e');
    }
  }

  Future<void> getCashHandOverDtlsList(DateTime date) async {
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
        debugPrint("Request body GetCashHandOverDtls: ${response.request}${requestBody}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            cashdatamodel = data.map((jsonItem) =>
                GetCashHandOverDtlsListModel.fromJson(jsonItem)).toList();
            isLoading = false;
            for (var item in cashdatamodel) {
              // debugPrint("userId $userId item.staffId.toString() ${item.staffId.toString()}");

              if (item.staffId.toString() == userId) {
                // debugPrint("userId $userId item.staffId.toString() ${item.staffId.toString()}");
                print("Matched Staff Total Amount: ${item.totalAmt}");
                totalAmt = (item.totalAmt ?? 0.0).toDouble();

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

  Future<void> getBalanceByStaffId(String staffId) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetBalanceByStaffId}/$staffId/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
       // balancemodel = data.map((json) => GetBalanceByStaffIdModel.fromJson(json)).toList();
      //  balanceAmount = balancemodel.isNotEmpty ? balancemodel.first.balanceAmt.toString() : '';
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load balance');
    }
  }

  Future<void> getVehicleDetailsByStaffId(String staffId) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetVehicleDetailsByStaffId}/$distributorId/$staffId'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
       // vehiclemodel = data.map((json) => GetVehicleDetailsByStaffIdModel.fromJson(json)).toList();
       // vehicleNumber = vehiclemodel.isNotEmpty ? vehiclemodel.first.vehicleNo ?? '' : '';
      //  vehicleId = (vehiclemodel.isNotEmpty ? vehiclemodel.first.vehicleId ?? 0 : 0) as int?;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load vehicle details');
    }
  }

  Future<void> loadInitialStaffData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? staffId = prefs.getString('StaffId');
    if (staffId != null) {
      await getVehicleDetailsByStaffId(staffId);
      await getBalanceByStaffId(staffId);
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

  Future<void> getSalaryPaymentList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetSalaryIncentiveEntryList}/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetSalaryIncentiveEntryList : " + '${AppUrl.GetSalaryIncentiveEntryList}/$distributorId');
    debugPrint("GetSalaryIncentiveEntryList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        listModel = data.map((json) => GetSalaryIncentiveEntryListModel.fromJson(json)).toList();
         EasyLoading.dismiss();
        isLoading = false;
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getStaffDetailsList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetStaffDetailsList}/$distributorId/0/0'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetStaffDetailsList : " +
        '${AppUrl.GetStaffDetailsList}/$distributorId/0/0');
    debugPrint("GetStaffDetailsList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        staffmodel = data.map((json) {
          return GetStaffDetailsListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
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

  void cancelAction(){
    setState(() {
      _selectedItem = '';
      selectedBankName = '';
      balanceAmount = '0.0';
      vehicleNumber = '';
      totalAmount = 0.0;
      selectedTransMode = null;
      selectedBankId = null;
      selectedstaff = null;
      selectedItemId = null;
      _selectBankModel = null;
      selectedpaidAgainstSalary = null;
      _balanceController.clear();
      TranCodeController.clear();
      timeController.clear();
      remarkController.clear();
      transReviewController.clear();
      modes = "Save";
    });
  }

  Future<void> saveVendorPopupForMob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? addedBy = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(addedBy!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String? vendorName = vendorNameController.text;
    String? vendorMobNo = mobileNumberController.text;

    final Map<String, dynamic> requestBody = {
      "VendorId":0,
      "DistributorId": distributorId,
      "VendorName": vendorName,
      "ContactNumber":vendorMobNo,
      "IsActive":1,
      "AddedBy":userId,
      "Action":"ADD"
    };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.SaveVendorMaster}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
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
        //getCashHandOverDtlsList(selectedDate);
      });
    } else {
      // Error response
      print("Error UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
    }
  }

  Future<void> SalaryIncentiveEntryAddEdit(int salaryEntryId,String action) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    double discountAmt = 0.0;
    String? tranCode;
    String? tranTime;
    String? tranReview;
    String? remark;
    int? bankId;
    int? accMappingIds;

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

    if(action != "DELETE") {
      if (_balanceController.text.isNotEmpty) {
        discountAmt = double.parse(_balanceController.text);
      }

      if (TranCodeController.text.isNotEmpty) {
        tranCode = TranCodeController.text;
      }else {
        tranCode = "";
      }

      if (timeController.text.isNotEmpty) {
        tranTime = timeController.text;
      }else {
        tranTime = "";
      }

      if (transReviewController.text.isNotEmpty) {
        tranReview = transReviewController.text;
      }else {
        tranReview = "";
      }

      if (remarkController.text.isNotEmpty) {
        remark = remarkController.text;
      }else {
        remark = "";
      }

      if (selectedBankName != null) {
        bankId = selecteBankIDApi;
        accMappingIds = accMappingId;
      }else {
        bankId = 0;
        accMappingIds = 0;
      }

      if (selectedTransMode == null || selectedTransMode!.isEmpty)
      {
        showFlushBar(context, Constants.TransMode);
        return;
      }

      if (selectedstaff == null || selectedstaff!.staffName == null ||
          selectedstaff!.staffName!.isEmpty) {
        showFlushBar(context, Constants.selStaff);
        return;
      }


      if((selectedpaidAgainstSalary == null || selectedpaidAgainstSalary!.isEmpty)){
        showFlushBar(context, Constants.pedagainst);
        return;
      }

      if (!_balanceController.text.isNotEmpty) {
        showFlushBar(context, Constants.salaryAmt);
        return;
      }
      if(selectedTransMode == 'Cash'){
        if (discountAmt > totalAmt!) {
          showFlushBar(context, "Salary Amount Can Not Be Greater Than Cash In Hand Amount.");
          return;
        }
      }

      if (selectedTransMode == 'Online') {
        if (_selectBankModel == null || _selectBankModel!.accountNo == null ||
            _selectBankModel!.accountNo!.isEmpty
        ) {
          showFlushBar(context, Constants.selStaff);
          return;
        }

        if (!TranCodeController.text.isNotEmpty) {
          showFlushBar(context, Constants.transCode);
          return;
        }
      }
      // Conditional check for cash payment mode

      if (selectedTransMode == 'Cash'){
        if(totalAmount != null || totalAmount>0){
          if(discountAmt != totalAmount || discountAmt <= 0) {
            showFlushBar(context, Constants.denominationAmount);
            return;
          }
        }
      }

      if (selectedTransMode == 'Cash'){
        if(cashDenominationMandatory){
          if(totalAmount != null || totalAmount>0){
            if(discountAmt != totalAmount || discountAmt <= 0) {
              showFlushBar(context, Constants.denominationAmount);
              return;
            }
          }else{
            showFlushBar(context, Constants.cashDenominationIsMandatory);
            return;
          }
        }
      }
    }



    final Map<String, dynamic> requestBody =
    {
      "SalaryEntryId": salaryEntryId,
      "DistributorId":distributorId,
      "PaidDate":formattedDate,
      "StaffId": selectedItemId ?? '',
      "PaidAgainst": selectedpaidAgainstSalary ?? '',
      "PaidSalaryAmt":discountAmt ?? '',
      "PaymentMode": selectedTransMode ?? '',
      "TransactionCode":tranCode ?? '',
      "TransactionTime": tranTime ?? '',
      "TransactionRemark": tranReview ?? '',
      "Remark": remark ?? '',
      "BankMappingId": accMappingIds ?? '',
      "BankId": bankId ?? '',
      "AddedBy": userId ?? '',
      "Action": action,
      "DenomDtList": dataCashDenomination,
    };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.SalaryIncentiveEntryAddEdit}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody SalaryIncentiveEntryAddEdit: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Show a user-friendly error if the response body is 0
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      }
      else if (response.body == '-1') {
        EasyLoading.showToast(
          Constants.expenseExistMgr,
          duration: const Duration(milliseconds: 3000),
        );
      }
      else {
        // Process the valid response (JSON or data)
        print("Response PaymentDetailAddEdit: ${response.body}");

        Navigator.pushNamed(
          context,
          ManagerMoreScree.screenName,
        );

        Future.delayed(Duration(milliseconds: 300), () {
          if (action == "DELETE") {
            EasyLoading.showToast(
              Constants.expenseSendMgrDelete,
              duration: const Duration(milliseconds: 3000),
            );
          }else if(action == "EDIT") {
            EasyLoading.showToast(
              Constants.expenseSendMgrEdit,
              duration: const Duration(milliseconds: 3000),
            );
          }
          else {
            EasyLoading.showToast(
              Constants.expenseSendMgr,
              duration: const Duration(milliseconds: 3000),
            );
          }
        });
        setState(() {
          getSalaryPaymentList();
        });
      }
    } else {
      print("Error SalaryIncentiveEntryAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }

  Future<void> getReceiptCashDenominationDtl(int ReceiptId) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetCashDenominationDtlsById}/$ReceiptId/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetCashDenominationDtlsById : " +
        '${AppUrl.GetCashDenominationDtlsById}/$ReceiptId/$distributorId');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      debugPrint("GetCashDenominationDtlsById : " + '${response.body}');
      setState(() {
        returndenominationModel = data.map((json) {
          return GetCashDenominationDtlsByIdModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  void initializeControllers() {
    qtyController = List.generate(returndenominationModel.length, (index) {
      return TextEditingController(
        text: returndenominationModel[index].qty?.toString() ?? "0",
      );
    });

    amounts = List.generate(returndenominationModel.length, (index) {
      final qty = returndenominationModel[index].qty?.toDouble() ?? 0.0;
      final noteType = returndenominationModel[index].noteType?.toDouble() ?? 0.0;
      return qty * noteType; // Now returns double
    });

    totalAmount = amounts.fold(0.0, (sum, item) => sum + item);

    isQtyFilled = Map.fromIterable(
      List.generate(returndenominationModel.length, (index) => index),
      key: (index) => index,
      value: (index) => (returndenominationModel[index].qty ?? 0) > 0,
    );

  }

  List<String> get filteredPaidAgainstSalary {
    if (selectedItemType == 0) {
      return ["Salary", "Incentive", "Advance"];
    } else if (selectedItemType == 1) {
      return ["Commission Charges", "Incentive", "Advance"];
    } else {
      return getpaidAgainstSalary; // fallback in case of invalid type
    }
  }

  Future<void> checkAndSaveDayEndData() async {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false // Disable dismissing the loader by tapping
      ..userInteractions = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    int? distributorIds = int.parse(distributorId!);
    try {
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
        List<dynamic> apiResponse = json.decode(response.body);
        if (apiResponse.isEmpty) {
          saveFlag = false;
          print("The list is empty, no data to save.");
        } else {
          var dayEndData = apiResponse[0];
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;
          if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
            saveFlag = true;
            print("Data is valid, proceeding to save.");
          } else {
            print("Data is incomplete. Cannot proceed to save.");
          }
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
  Future<void> checkCashDenominationFlagMandatory() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
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
          Uri.parse('${AppUrl.GetPageActionPermissionDtls}/$distributorId/All'),
          headers: {
            'Authorization': 'Bearer $bearerToken', // Add Bearer token here
          },
        );
        debugPrint("Response body GetPageActionPermissionDtls: ${response.body}");
        debugPrint("Request body GetPageActionPermissionDtls: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            cashDenoMandatoryList = data.map((jsonItem) =>
                CahsDenominationMandatoryFlagModel.fromJson(jsonItem)).toList();
            isLoading = false;
            for (var item in cashDenoMandatoryList) {
              if (item.distributorId.toString() == distributorId && item.permissionFor == "Cash Denomination" && item.isActive == 1) {
                print("Flag truet:");
                cashDenominationMandatory = true;
                break; // Exit loop after finding the match
              }else{
                cashDenominationMandatory = false;
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
}



