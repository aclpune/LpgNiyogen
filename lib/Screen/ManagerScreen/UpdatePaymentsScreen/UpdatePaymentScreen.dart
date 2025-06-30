import 'dart:convert';

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
import '../CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import '../CashHandoverModelClass/GetCashHandOverDtlsModel.dart';
import '../ManagerModelClass/DenomModel.dart';
import '../ManagerMoreScreen.dart';
import 'GetBalanceByStaffIdModel.dart';
import 'GetCashHandOverDtlsListModel.dart';
import 'GetExpenseHeaderListModel.dart';
import 'GetPaymentDetailListModel.dart';
import 'GetPaymentdetailCashDenominationDtlModel.dart';
import 'GetStaffDetailsListModel.dart';
import 'GetVehicleDetailsByStaffIdModel.dart';
import 'GetVendorMasterListModel.dart';


class UpdatePaymentScreen extends StatefulWidget {
  static const screenName = '/updatePaymentScreen';
  const UpdatePaymentScreen({super.key});

  @override
  State<UpdatePaymentScreen> createState() => _UpdatePaymentScreenState();
}
class _UpdatePaymentScreenState extends State<UpdatePaymentScreen>{

  final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  // final DateTime now = DateTime.now();
  // String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  List<String> getTransMode = ["Cash", "Online"];
  String? selectedTransMode;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  List<String> getTransStaff = ["Staff", "Vendor"];
  String? selectedStaff = "Staff";
  //Map<int, bool> isQtyFilled = {};
  //late List<TextEditingController> qtyControllerReturn;
  //late List<double> amountsReturn;
  //late double returnAmount;
  //late double finalAmountCashDeno;

  late List<TextEditingController> qtyController;
  late List<double> amounts;
  double totalAmount = 0.0;
  late double finalAmountCashDeno;
  late Map<int, bool> isQtyFilled;

  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey4 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey5 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey6 = GlobalKey<FormState>();
  final timeController = TextEditingController();
  final transReviewController = TextEditingController();
  late final _balanceController = TextEditingController();
  bool _isDepositEmpty = false;
  final TranCodeController = TextEditingController();
  final remarkController = TextEditingController();
  TextEditingController vendorNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  bool isCashDenominationListViewVisible = false;
  List<DenomModel>getNoteTypeAndIdFroDenominationListModel = [];
  List<dynamic> dataCashDenominationList = [];
  bool isLoading = true;
  // List<TextEditingController> qtyController = [];
  //List<double> amounts = [];
  // double totalAmount = 0.0;
  List<GetBankMappingDetailsListModel> bankModel = [];
  List<GetPaymentDetailListModel> paymentModel = [];
  GetBankMappingDetailsListModel? _selectBankModel;
  List<GetVendorMasterListModel> vendorModel = [];
  GetVendorMasterListModel? _selectVendor;
  List<GetPaymentdetailCashDenominationDtlModel> denominationModel = [];
  GetPaymentdetailCashDenominationDtlModel? _selectDenomination;
  String? selectedBankName;
  String? selectedBankId;
  double? valueBal;
  bool _isTranscode = false;
  bool _isVendorName = false;
  String? receiptNoText;
  String? receiptNoTextEdit;
  List<dynamic> dataCashInHandList = [];
  DateTime selectedDate = DateTime.now();
  List<GetCashHandOverDtlsListModel> cashdatamodel = [];
  double? totalamt;
  String? userName,userId;
  List<GetStaffDetailsListModel> staffmodel = [];
  List<GetVehicleDetailsByStaffIdModel> vehiclemodel = [];
  List<GetBalanceByStaffIdModel> balancemodel = [];
  GetStaffDetailsListModel? selectedstaff;
  List<GetExpenseHeaderListModel> expenseModel = [];
  GetExpenseHeaderListModel? selectedExpense;
  String? _selectedItem;
  int? selectedItemId;
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
  int? paymentId;
  int? payId;


  @override
  void initState() {

    super.initState();
    getNoteTypeAndIDList();
    fetchBank();
    fetchSavedData();
    getCashHandOverDtlsList(selectedDate);
    getStaffDetailsList();
    getVendorMasterList();
    getExpenseHeaderList();
    loadInitialStaffData();
    getPaymentDetailList();
    //
    getVoucherNoForExpense();


    Future.delayed(Duration.zero, ()  async{

        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        modes = argValue?["modeChange"]?? '';
        if (argValue != null) {
          String payVoucherNoEdit = argValue["payVoucherNoV"] ?? 0;
          receiptNoTextEdit = payVoucherNoEdit;
          String depositDateEdit = argValue["depositDateV"] ?? 0;
          String paymentModeEdit = argValue["paymentModeV"] ?? 0;
          // selectedTransMode = paymentModeEdit;
          String paymentToIDEdit = argValue["paymentToIDV"] ?? 0;
          String staffNameEdit = argValue["staffNameV"] ?? 0;
          // selectedItemId = argValue["staffIdV"] ?? 0;
          selectedItemId = int.tryParse(argValue["staffIdV"] ?? '') ?? 0;
          vendorId = int.tryParse(argValue["vendorIdV"] ?? '') ?? 0;
          vehicleId = int.tryParse(argValue["vehIdV"] ?? '') ?? 0;
          if(getTransMode.contains(paymentModeEdit)){
            selectedTransMode = paymentModeEdit;
          }
          // else if(paymentModeEdit == "Bank"){
          //   selectedTransMode = "Online";
          // }
          else{
            selectedTransMode = null;
          }

          // String payVoucherNoEdit = argValue["payVoucherNoV"] ?? 0;
          // receiptNoText = payVoucherNoEdit;


          // vendorId = argValue["vendorIdV"] ?? 0;
          // vehicleId = argValue["vehIdV"] ?? 0;
          String vehicleNoEdit = argValue["vehicleNoV"] ?? 0;
          // double amountTotalEdit = argValue["amountTotalV"] ?? 0;
          double amountTotalEdit = double.tryParse(argValue["amountTotalV"] ?? '') ?? 0;
          // selectedExpId = argValue["expHeadId"] ?? 0;
          selectedExpId = int.tryParse(argValue["expHeadId"] ?? '') ?? 0;
          String payRemarkEdit = argValue["payRemarkV"] ?? 0;
          String transTimeEdit = argValue["transTimeV"] ?? 0;
          timeController.text = transTimeEdit;
          String transationCodeEdit = argValue["transationCodeV"] ?? 0;
          TranCodeController.text = transationCodeEdit;
          String transRemarkEdit = argValue["transRemarkV"] ?? 0;
          transReviewController.text = transRemarkEdit;
          String expHeadNameEdit = argValue["expHeadNameV"] ?? 0;

          _balanceController.text = amountTotalEdit.toString();
          remarkController.text = transRemarkEdit;
          // selecteBankIDApi = argValue["bankIdV"] ?? 0;
          // accMappingId = argValue["mappingIdV"] ?? 0;
          String accountNoEdit = argValue["accountNoV"] ?? 0;
          selecteBankIDApi = int.tryParse(argValue["bankIdV"] ?? '') ?? 0;
          accMappingId = int.tryParse(argValue["mappingIdV"] ?? '') ?? 0;
          _selectBankModel = bankModel.firstWhere(
                (item) => item.accountNo == accountNoEdit,
            orElse: () => GetBankMappingDetailsListModel(
              bankName: 'Default Bank',
              accountNo: '',
            ),
          );

          paymentId = int.tryParse(argValue["paymentIdV"] ?? '') ?? 0;
          getNoteTypeAndIDList().whenComplete((){
            getPaymentdetailCashDenominationDtl(paymentId!).whenComplete((){
              if(denominationModel.isNotEmpty){
                initializeControllers();
              }else{
                debugPrint("empty");
              }
            });
          });
          // int? paymentIdEdit = int.tryParse(argValue["paymentIdV"] ?? '') ?? 0;
          //
          // getPaymentdetailCashDenominationDtl(paymentIdEdit).whenComplete(() {
          //   if (denominationModel.isNotEmpty) {
          //     initializeControllers();
          //   } else {
          //     debugPrint("empty");
          //   }
          // });
          //   paymentIdEdit = int.tryParse(argValue["paymentIdV"] ?? '') ?? 0;
          //   if(selectedItemId != 0){
          //     selectedStaff = "Staff";
          //     getStaffDetailsList().whenComplete((){
          //       selectedstaff = staffmodel.firstWhere(
          //             (item) => item.staffName == staffNameEdit,
          //         orElse: () => GetStaffDetailsListModel(
          //           staffName: '',
          //
          //         ),
          //       );
          //     });
          // debugPrint("dgkjsljg");
          //   }
          //paymentIdEdit = int.tryParse(argValue["paymentIdV"] ?? '') ?? 0;

          if (selectedItemId != 0) {
            selectedStaff = "Staff";
          }
          else if( vendorId != 0){
            selectedStaff = "Vendor";
          }
          await getStaffDetailsList();
          getStaffDetailsList().whenComplete(() {
            selectedstaff = staffmodel.firstWhere(
                  (item) => item.staffId == selectedItemId,
              orElse: () => GetStaffDetailsListModel(staffName: ''),
            );

            // Call balance and vehicle details functions when editing
            if (selectedstaff?.staffId != null) {
              getBalanceByStaffId(selectedstaff!.staffId.toString());
              getVehicleDetailsByStaffId(selectedstaff!.staffId.toString());
            }

            debugPrint("Staff selected during edit: ${selectedstaff?.staffName}");
          });
          await getVendorMasterList();
          getVendorMasterList().whenComplete((){
            _selectVendor = vendorModel.firstWhere(
                  (item) => item.vendorId == vendorId,
              orElse: () => GetVendorMasterListModel(vendorName: ''),
            );
            debugPrint("vendorName $_selectVendor");
          });

          debugPrint("feffefefef$staffNameEdit");
         await getExpenseHeaderList();
          getExpenseHeaderList().whenComplete((){
            selectedExpense = expenseModel.firstWhere(
                  (item) => item.expHeadName == expHeadNameEdit,
              orElse: () => GetExpenseHeaderListModel(
                expHeadName: '',
              ),
            );
          });
          // loadDenominationData(psvIdEdit!);

          await fetchBank();
          if(accountNoEdit.isNotEmpty && accountNoEdit != "null"){
            final match = bankModel.firstWhere(
                  (item) => item.accountNo?.trim() == accountNoEdit.trim(),
              orElse: () => GetBankMappingDetailsListModel(),
            );

            if((match.accountNo ?? '').isNotEmpty){
              setState(() {
                _selectBankModel = match;
              });
            }
          }
        }

    });
  }

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
          title: 'Update Payment', // Title or hint text for the text field
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
                      Text('${formatCurrency(totalamt ?? 0)}',
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
                          'Pay Voucher No.'),
                    ),
                    Flexible(flex: 1,
                        child:Text(
                          modes == "EDIT" ? (receiptNoTextEdit ?? '') : (receiptNoText ?? ''),
                          style: TextStyle(color: Colors.grey),
                        )
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: textWidgetBlueColorWithoutStar('Deposit Date'),
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
                      child:
                      textWidgetBlueColorWithStar(
                        'Payment Mode',
                        "*", // Add a parameter to conditionally show the asterisk
                      ),
                    ),
                    Flexible(flex: 1,
                      child:
                      DropdownButtonFormField<String>(
                        key: formKey1,
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
                    // Flexible(flex: 1,
                    //   child:
                    //   // DropdownButtonFormField<String>(
                    //   //   key: formKey2,
                    //   //   decoration: InputDecoration(
                    //   //     contentPadding: EdgeInsets.symmetric(
                    //   //         vertical: 12, horizontal: 10),
                    //   //   ),
                    //   //   value: selectedStaff,
                    //   //   // Bind the selected value
                    //   //   items: getTransMode
                    //   //       .map((String value) =>
                    //   //       DropdownMenuItem<String>(
                    //   //         value: value,
                    //   //         child: Text(value),
                    //   //       ))
                    //   //       .toList(),
                    //   //   onChanged: (value) {
                    //   //     setState(() {
                    //   //       selectedStaff =
                    //   //           value; // Update the selected value
                    //   //     });
                    //   //   },
                    //   //   isExpanded: true,
                    //   // ),
                    //   // DropdownButtonFormField<String>(
                    //   //   key: formKey1,
                    //   //   decoration: InputDecoration(
                    //   //     contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    //   //   ),
                    //   //   value: selectedTransMode,
                    //   //   items: ['Cash', 'Online'].map((String value) {
                    //   //     return DropdownMenuItem<String>(
                    //   //       value: value,
                    //   //       child: Text(value),
                    //   //     );
                    //   //   }).toList(),
                    //   //   onChanged: (value) {
                    //   //     setState(() {
                    //   //       selectedTransMode = value!;
                    //   //     });
                    //   //   },
                    //   //   isExpanded: true,
                    //   // ),
                    //
                    // ),
                  ],
                ),

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
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(250), // Limit to 250 characters
                              ],
                              decoration: InputDecoration(
                                labelText: 'Transaction Remark',
                              ),
                              maxLines: 2, // Allows multiline remarks
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: textWidgetBlueColorWithoutStar(
                          'Payment To'
                      ),
                    ),
                    Flexible(flex: 1,
                      child:
                      // DropdownButtonFormField<String>(
                      //   key: formKey2,
                      //   decoration: InputDecoration(
                      //     contentPadding: EdgeInsets.symmetric(
                      //         vertical: 12, horizontal: 10),
                      //   ),
                      //   value: selectedStaff,
                      //   // Bind the selected value
                      //   items: getTransStaff
                      //       .map((String value) =>
                      //       DropdownMenuItem<String>(
                      //         value: value,
                      //         child: Text(value),
                      //       ))
                      //       .toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       selectedStaff =
                      //           value; // Update the selected value
                      //     });
                      //   },
                      //   isExpanded: true,
                      // ),
                      DropdownButtonFormField<String>(
                        key: formKey2,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        ),
                        value: selectedStaff,
                        items: ['Vendor', 'Staff'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStaff = value!;
                          });
                        },
                        isExpanded: true,
                      ),

                    ),
                  ],
                ),
                if(selectedStaff == "Staff")...[
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
                            key: formKey3,
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
                                selectedstaff = selectedItem;
                                _selectedItem = selectedItem?.staffName ?? '';
                                selectedItemId = selectedItem?.staffId?.toInt();
                              });

                              if (selectedItem?.staffId != null) {
                                getBalanceByStaffId(selectedItem!.staffId.toString());
                                getVehicleDetailsByStaffId(selectedItem.staffId.toString());
                              }
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
                        child: textWidgetBlueColorWithoutStar(
                            'Balance'),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          balanceAmount.isNotEmpty ? balanceAmount : '',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: textWidgetBlueColorWithoutStar(
                            'Vehicle No'),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          vehicleNumber.isNotEmpty ? vehicleNumber : 'MH12A0000',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 5),
                if(selectedStaff == "Vendor")...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidgetBlueColorWithStar(
                        'Vendor Name',
                        "*",
                      ),
                      SizedBox(width: 10,),
                      ElevatedButton(
                        onPressed: (){
                          setState(() {
                            _showAddVendorPopup();
                          });
                        },
                        // onPressed: _addNewItem,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(12),
                            backgroundColor: Colors.blue),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child:
                          DropdownButtonFormField<GetVendorMasterListModel>(
                            isExpanded: true,
                            key: formKey5,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            ),
                            value: vendorModel.contains(_selectVendor)?_selectVendor:null ,
                            items: vendorModel.map((item) {
                              return DropdownMenuItem<GetVendorMasterListModel>(
                                value: item,
                                child: Text(
                                  item.vendorName ?? '',
                                  style: Styling.itemBlackTest,
                                ),
                              );
                            }).toList(),
                            onChanged: (selectedItem) {
                              setState(() {
                                _selectVendor = selectedItem;
                                _selectedVendor = selectedItem?.vendorName ?? '';
                                vendorId = selectedItem?.vendorId?.toInt();
                              });
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a vendor';
                                }
                                return null;
                              };
                            },
                          ),
                          // DropdownButtonFormField<GetVendorMasterListModel>(
                          //   value: _selectVendor,
                          //   items: vendorModel.map((item) {
                          //     return DropdownMenuItem<GetVendorMasterListModel>(
                          //       value: item,
                          //       child: Text(item.vendorName ?? ''),
                          //     );
                          //   }).toList(),
                          //   onChanged: (selectedItem) {
                          //     setState(() {
                          //       _selectVendor = selectedItem;
                          //       _selectedVendor = selectedItem?.vendorName ?? '';
                          //       vendorId = selectedItem?.vendorId?.toInt();
                          //     });
                          //   },
                          // )


                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: textWidgetBlueColorWithStar(
                          'Expense Type',
                          "*"
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: DropdownButtonFormField<GetExpenseHeaderListModel>(
                          isExpanded: true,
                          key: formKey6,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          ),
                          value: expenseModel.contains(selectedExpense)?selectedExpense:null,
                          items: expenseModel.map((item) {
                            return DropdownMenuItem<GetExpenseHeaderListModel>(
                              value: item,
                              child: Text(
                                item.expHeadName ?? '',
                                style: Styling.itemBlackTest,
                              ),
                            );
                          }).toList(),
                          onChanged: (selectedItem) {
                            setState(() {
                              selectedExpense = selectedItem;
                              _selectedExp = selectedItem?.expHeadName ?? '';
                              selectedExpId = selectedItem?.expHeadId?.toInt();
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
                        'Total Amount',
                        "*",
                      ),
                    ),
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
                            if(selectedTransMode == 'Cash'){
                              if (val > totalamt!) {
                                _balanceController.clear();
                              }
                            }

                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Total Amount',
                          errorText: _isDepositEmpty ? 'Amount is required' : null,
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
                //SizedBox(height: 5),
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
                          // border: OutlineInputBorder(),
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
                        if (modes == "EDIT") {
                          paymentDetailAddEditForMob(paymentId!, "EDIT");

                        } else {
                          paymentDetailAddEditForMob(0, "ADD");
                        }
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
                  child: paymentModel.isNotEmpty
                      ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: paymentModel.length,
                    itemBuilder: (context, index) {
                      GetPaymentDetailListModel? payList = paymentModel[index];
                      return  Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(child: Text(payList.paymentDate ?? '', style: TextStyle(color: Colors.blue),),),
                              Expanded(child: Text(payList.voucherNo ?? '', style: TextStyle(color: Colors.blue),),),
                              Expanded(
                                flex: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,  // Align the icons to the right
                                  children: [
                                    // Edit Icon
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.blue),  // Icon for edit
                                      onPressed: () {
                                        setState(() {
                                          var payVoucherNo = payList.voucherNo.toString();
                                          var depositDate = payList.paymentDate.toString();
                                          var paymentMode = payList.paymentMode.toString();
                                          var paymentToId = payList.paymentTo.toString();
                                          var staffName = payList.staffName.toString();
                                          var staffId = payList.staffId.toString();
                                          var vendorId = payList.vendorId.toString();
                                          var vehId = payList.vehId.toString();
                                          var vehicleNo = payList.vehicleNo.toString();
                                          var amountTotal = payList.amount.toString();
                                          var expHeadId = payList.expHeadId.toString();
                                          var payRemark = payList.payRemark.toString();
                                          var transTime = payList.transTime.toString();
                                          var transationCode = payList.transationCode.toString();
                                          var transRemark = payList.transRemark.toString();
                                          var expHeadName = payList.expHeadName.toString();
                                          var bankId = payList.bankId.toString();
                                          var mappingId = payList.mappingId.toString();
                                          var accountNo = payList.accountNo.toString();
                                          var paymentId = payList.paymentId.toString();
                                          int payId = int.parse(paymentId);

                                          // Navigate to the target screen and pass the data
                                          Navigator.pushNamed(
                                            context,
                                            UpdatePaymentScreen.screenName,
                                            arguments: {
                                              'payVoucherNoV': payVoucherNo,
                                              'depositDateV': depositDate,
                                              'paymentModeV': paymentMode,
                                              'paymentToIDV': paymentToId,
                                              'staffNameV' : staffName,
                                              'staffIdV': staffId,
                                              'vendorIdV': vendorId,
                                              'vehIdV': vehId,
                                              'vehicleNoV': vehicleNo,
                                              'amountTotalV': amountTotal,
                                              'expHeadId': expHeadId,
                                              'payRemarkV': payRemark,
                                              'transTimeV': transTime,
                                              'transationCodeV': transationCode,
                                              'transRemarkV': transRemark,
                                              'expHeadNameV': expHeadName,
                                              'bankIdV': bankId,
                                              'mappingIdV': mappingId,
                                              'accountNoV': accountNo,
                                              'paymentIdV': paymentId,
                                              'modeChange': "EDIT"
                                            },
                                          );
                                        });
                                      },
                                    ),
                                    // Icon for delete
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red), // Icon for delete
                                      onPressed: () async {
                                        int? pId = (payList.paymentId)?.toInt();
                                        print('Delete button pressedd${payList.paymentId}');
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
                                            paymentDetailAddEditForMob(pId, "DELETE");
                                            print('Delete button pressed$pId');
                                          } else {
                                            print("Receipt ID is null.");
                                          }
                                        } else {
                                          print('Delete action was canceled');
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
                              Expanded(flex:1,child: countTextWidgetText(context,"Account No.", payList.accountNo ?? '')),

                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(flex:1,child: countTextWidgetText(context,"Staff/Vendor Name", payList.staffName ?? '')),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(flex:1,child: countTextWidgetText(context,"Expense Type", payList.expHeadName ?? '')),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(flex:1,child: countTextWidgetText(context,"Total Amount", payList.amount.toString())),
                              Expanded(flex:1,child: countTextWidgetText(context,"Payment Mode", payList.paymentMode ?? '')),
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
      Uri.parse('${AppUrl.GetStaffDetailsList}/$distributorId/1/0'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetStaffDetailsList : " +
        '${AppUrl.GetStaffDetailsList}/$distributorId/1/0');
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

  Future<void> getVendorMasterList() async {
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
      Uri.parse('${AppUrl.GetVendorMasterList}/$distributorId/1'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetVendorMasterList : " +
        '${AppUrl.GetVendorMasterList}/$distributorId/1');
    debugPrint("GetVendorMasterList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        vendorModel = data.map((json) {
          return GetVendorMasterListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getPaymentdetailCashDenominationDtl(int paymentId) async {
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
      Uri.parse('${AppUrl.GetPaymentdetailCashDenominationDtl}/$paymentId/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetPaymentdetailCashDenominationDtl : " +
        '${AppUrl.GetPaymentdetailCashDenominationDtl}/$paymentId/$distributorId');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      debugPrint("GetPaymentdetailCashDenominationDtl : " + '${response.body}');
      setState(() {
        denominationModel = data.map((json) {
          return GetPaymentdetailCashDenominationDtlModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getExpenseHeaderList() async {
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
      Uri.parse('${AppUrl.GetExpenseHeaderList}/$distributorId/1'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetExpenseHeaderList : " +
        '${AppUrl.GetExpenseHeaderList}/$distributorId/1');
    debugPrint("GetExpenseHeaderList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        expenseModel = data.map((json) {
          return GetExpenseHeaderListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
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
        balancemodel = data.map((json) => GetBalanceByStaffIdModel.fromJson(json)).toList();
        balanceAmount = balancemodel.isNotEmpty ? balancemodel.first.balanceAmt.toString() : '';
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
        vehiclemodel = data.map((json) => GetVehicleDetailsByStaffIdModel.fromJson(json)).toList();
        vehicleNumber = vehiclemodel.isNotEmpty ? vehiclemodel.first.vehicleNo ?? '' : '';
        vehicleId = (vehiclemodel.isNotEmpty ? vehiclemodel.first.vehicleId ?? 0 : 0) as int?;
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

  Future<void> getPaymentDetailList() async {
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
      Uri.parse('${AppUrl.GetPaymentDetailList}/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetPaymentDetailListModel : " + '${AppUrl.GetPaymentDetailList}/$distributorId');
    debugPrint("GetPaymentDetailListModel : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        paymentModel = data.map((json) => GetPaymentDetailListModel.fromJson(json)).toList();
        // EasyLoading.dismiss();
        isLoading = false;
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

  void _showAddVendorPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text("Add Vendor Name"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: vendorNameController,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced, // Enforce max length
                    inputFormatters: <TextInputFormatter>[
                    ],
                    decoration: InputDecoration(
                      errorText: _isVendorName ? 'Vendor Name Is Required' : null,

                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          countTextWidgetTextStar(
                            context,
                            'Vendor Name',
                            showAsterisk: true,
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isVendorName = value.isEmpty;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: mobileNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      errorText: _isConCOntactEmpty
                          ? 'Mobile No Is Required'
                          : _isInvalidMobile
                          ? 'Please Enter A Valid Consumer Contact No.'
                          : _isShortLength
                          ? 'Consumer Contact No. must be 10 digits'
                          : null,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          countTextWidgetTextStar(
                            context,
                            'Mobile No',
                            showAsterisk: true,
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isConCOntactEmpty = value.isEmpty;
                        if (value.isNotEmpty) {
                          _isInvalidMobile = !RegExp(r'^[6789]').hasMatch(value); // Check first digit
                          _isShortLength = value.length < 10;
                        } else {
                          _isInvalidMobile = false; // Reset the error if the input is empty
                          _isShortLength = false;
                        }
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    vendorNameController.clear();
                    mobileNumberController.clear();
                    //Navigator.of(context).pop(); // Close popup
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    String vendorName = vendorNameController.text.trim();
                    String mobileNumber = mobileNumberController.text.trim();

                    // Check if the mobile number is valid
                    if (_isConCOntactEmpty || _isInvalidMobile || _isShortLength) {
                      showFlushBar(context, "Invalid mobile number.");
                      return;
                    }

                    // Check if both fields are empty
                    if (vendorName.isEmpty || mobileNumber.isEmpty) {
                      showFlushBar(context, "Both fields are required.");
                      return;
                    }

                    // Proceed with saving
                    saveVendorPopupForMob();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
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
      selectedTransMode = null;
      selectedExpense = null;
      selectedstaff = null;
      selectedItemId = null;
      _selectBankModel = null;
      selectedTransMode = null;
      _selectVendor = null;
      _balanceController.clear();
      TranCodeController.clear();
      timeController.clear();
      remarkController.clear();
      TranCodeController.clear();
      timeController.clear();
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
        getCashHandOverDtlsList(selectedDate);
      });
    } else {
      // Error response
      print("Error UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
    }
  }

  Future<void> paymentDetailAddEditForMob(int paymentId,String action) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(staffId!);
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
    int? paidTo;
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
      } else {
        tranCode = "";
      }
      if (timeController.text.isNotEmpty) {
        tranTime = timeController.text;
      } else {
        tranTime = "";
      }
      if (transReviewController.text.isNotEmpty) {
        tranReview = transReviewController.text;
      } else {
        tranReview = "";
      }
      if (remarkController.text.isNotEmpty) {
        remark = remarkController.text;
      } else {
        remark = "";
      }

      //Condition On Save Button
      if ((selectedTransMode == null || selectedTransMode!.isEmpty) ||
          (selectedStaff == null || selectedStaff!.isEmpty) ||
          (selectedExpense == null)) {
        showFlushBar(context, Constants.reqfield);
        return;
      }

      // Conditional check for cash payment mode
      if (selectedTransMode == 'Cash') {
        if (discountAmt != totalAmount || discountAmt <= 0) {
          showFlushBar(context, Constants.denominationAmount);
          return;
        }
      }

      if (selectedTransMode == 'Online') {
        if (_selectBankModel == null || _selectBankModel!.accountNo == null ||
            _selectBankModel!.accountNo!.isEmpty
        ) {
          showFlushBar(context, Constants.bankname);
          return;
        }

        if (!TranCodeController.text.isNotEmpty) {
          showFlushBar(context, Constants.transCode);
          return;
        }
      }


      if (_selectBankModel != null) {
        bankId = selecteBankIDApi;
        accMappingIds = accMappingId;
      }
      else {
        bankId = 0;
        accMappingIds = 0;
      }

      if (selectedStaff == "Vendor") {
        paidTo = 2;
        staffId = 0.toString();
      } else {
        paidTo = 1;
        vendorId = 0;
      }
    }


    final Map<String, dynamic> requestBody =
    {
      "PaymentId": paymentId,
      "DistributorId":distributorIds,
      "VoucherNo":receiptNoText ?? '',
      "PaymentDate": formattedDate,
      "PaymentMode": selectedTransMode ?? '',
      "PaymentTo":paidTo ?? '',
      "VendorId": vendorId ?? '',
      "StaffId":selectedItemId ?? '',
      "VehId":vehicleId ?? '',
      "ExpHeadId": selectedExpId ?? '',
      "TotalAmtPaid":discountAmt ?? '',
      "PaidFor": 0,
      "PaidForId": 0,
      "TransationCode": tranCode ?? '',
      "TransTime": tranTime ?? '',
      "TransRemark": tranReview ?? '',
      "PayRemark": remark ?? '',
      "BankMappingId": accMappingIds ?? '',
      "BankId": bankId ?? '',
      "AddedBy": userId ?? '',
      "Action": action,
      "DenomAllList": dataCashDenomination,
    };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.PaymentDetailAddEdit}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody UpdateSaleAddEditForMob: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Show a user-friendly error if the response body is 0
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {
        // totalAmount = totalAmount - discountAmt;

        // Process the valid response (JSON or data)
        print("Response PaymentDetailAddEdit: ${response.body}");

        Navigator.pushNamed(
          context,
          UpdatePaymentScreen.screenName,
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
          }else {
            EasyLoading.showToast(
              Constants.expenseSendMgr,
              duration: const Duration(milliseconds: 3000),
            );
          }
        });

        setState(() {
          getPaymentDetailList();
        });
      }
    } else {
      print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }

  void initializeControllers() {
    qtyController = List.generate(denominationModel.length, (index) {
      return TextEditingController(
        text: denominationModel[index].qty?.toString() ?? "0",
      );
    });

    amounts = List.generate(denominationModel.length, (index) {
      final qty = denominationModel[index].qty?.toDouble() ?? 0.0;
      final noteType = denominationModel[index].noteType?.toDouble() ?? 0.0;
      return qty * noteType; // Now returns double
    });


    totalAmount = amounts.fold(0.0, (sum, item) => sum + item);


    isQtyFilled = Map.fromIterable(
      List.generate(denominationModel.length, (index) => index),
      key: (index) => index,
      value: (index) => (denominationModel[index].qty ?? 0) > 0,
    );

  }

}



