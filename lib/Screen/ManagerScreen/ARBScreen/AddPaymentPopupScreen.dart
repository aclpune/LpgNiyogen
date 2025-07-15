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
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';
import '../CashHandoverModelClass/GetBankMappingDetailsListModel.dart';
import '../ManagerModelClass/DenomModel.dart';
import '../SalaryPaymentScreen/GetCashDenominationDtlsByIdModel.dart';
import '../UpdatePaymentsScreen/GetExpenseHeaderListModel.dart';
import '../UpdatePaymentsScreen/GetPaymentdetailCashDenominationDtlModel.dart';
import 'ArbScreen.dart';
import 'GetARBItemPurListModel.dart';
import 'GetPaymentDetlARBPurLstModel.dart';

class AddPaymentPopupScreen extends StatefulWidget {
  static const screenName = '/addPaymentPopupScreen';

  const AddPaymentPopupScreen({super.key});

  @override
  State<AddPaymentPopupScreen> createState() => _AddPaymentPopupScreenState();
}

class _AddPaymentPopupScreenState extends State<AddPaymentPopupScreen> {

  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  List<String> getTransMode = ["Cash", "Online"];
  String? selectedTransMode;
  List<GetBankMappingDetailsListModel> bankModel = [];
  GetBankMappingDetailsListModel? _selectBankModel;
  //List<GetPaymentdetailCashDenominationDtlModel> denominationModel = [];
  List<GetCashDenominationDtlsByIdModel> denominationModel = [];
  GetCashDenominationDtlsByIdModel? _selectDenomination;
  bool isLoading = true;
  // final String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String? formattedDate;
  List<DenomModel>getNoteTypeAndIdFroDenominationListModel = [];
  List<dynamic> dataCashDenominationList = [];
  late List<TextEditingController> qtyController;
  late List<double> amounts;
  String? selectedBankName;
  String? selectedBankId;
  int? selecteBankIDApi;
  int? accMappingId;
  double totalAmount = 0.0;
  bool _isTranscode = false;
 // bool saveFlag = false;
  final timeController = TextEditingController();
  final transReviewController = TextEditingController();
  final TranCodeController = TextEditingController();
  final remarkController = TextEditingController();
  late final _balanceController = TextEditingController();
  bool isCashDenominationListViewVisible = false;
  List<GetExpenseHeaderListModel> expenseModel = [];
  List<GetPaymentDetlArbPurLstModel> paymentModel = [];
  GetExpenseHeaderListModel? selectedExpense;
  String? _selectedExp;
  int? selectedExpId;
  bool _isDepositEmpty = false;
  String? invoiceNo;
  String? vendorName;
  String? vendorId;
  String? totalBillAmt;
  String? balanceAmt;
  String? arbPurId;
  String? invoiceNoEdit;
  String? amountTotal;
  String? vendorNameEdit;
  String? vendorIdEdit;
  String? totalBillAmtEdit;
  String? balanceAmtEdit;
  int? arbPurIdEdit;
  String? modes;
  var argValue;
  //int? paymentIdEdit;
  int? paymentId;
  late Map<int, bool> isQtyFilled;
  late double finalAmountCashDeno;
  bool isEditMode = false;
  double? getEditTotalAmount;
  bool saveFlag = false;
  List<CahsDenominationMandatoryFlagModel> cashDenoMandatoryList = [];
  bool cashDenominationMandatory = false;
  @override
  void initState() {
    super.initState();
    checkAndSaveDayEndData();
    checkCashDenominationFlagMandatory();
    fetchBank();
    getNoteTypeAndIDList();
    getExpenseHeaderList();
    //checkAndSaveDayEndData();
    DateTime now = DateTime.now().toUtc();
     formattedDate = now.toIso8601String();

    Future.delayed(Duration.zero, ()  {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        invoiceNo = argValue["invoiceNoEdit"];
        vendorName = argValue["VendorNameEdit"];
        vendorId = argValue["VendorIdEdit"];
        totalBillAmt = argValue["totalBillAmtEdit"];
        balanceAmt = argValue["balanceAmt"];
        arbPurId = argValue["arbPurIdEdit"];

        getARBItemPaymentList(int.parse(arbPurId!));
      });
    });


    Future.delayed(Duration.zero, () async{

      argValue = ModalRoute.of(context)?.settings.arguments as Map;

      modes = argValue?["modeChange"]?? '';
      if (argValue != null  && argValue["paymentIdV"] != null) {
        isEditMode = true;
        String bankIdV = argValue["bankIdV"] ?? '';
        debugPrint("bank id1 $bankIdV");
        String paymentModeEdit = argValue["paymentModeV"] ?? '';
        double amountTotalEdit = double.tryParse(argValue["amountTotalV"] ?? '') ?? 0;
        selectedExpId = int.tryParse(argValue["expHeadId"] ?? '') ?? 0;
        String transTimeEdit = argValue["transTimeV"] ?? '';
        timeController.text = transTimeEdit;
        String transationCodeEdit = argValue["transationCodeV"] ?? '';
        TranCodeController.text = transationCodeEdit;
        String transRemarkEdit = argValue["transRemarkV"] ?? '';
        transReviewController.text = transRemarkEdit;
        String expHeadNameEdit = argValue["expHeadNameV"] ?? '';
        _balanceController.text = amountTotalEdit.toString();
        remarkController.text = transRemarkEdit;
        amountTotal = argValue["amountTotalV"];

        getEditTotalAmount = double.tryParse(amountTotal!);
        print('balanceAmt$balanceAmt');
        if (getTransMode.contains(paymentModeEdit)) {
          selectedTransMode = paymentModeEdit;
        } else if(paymentModeEdit == "Bank") {
          selectedTransMode = 'Online';// fallback or handle invalid values
        }else{
          selectedTransMode = null;
        }
        await fetchBank();
        await fetchBank().whenComplete((){
          debugPrint("bank id2 $bankIdV");// wait for data first
          if (bankIdV != null && bankIdV is String && bankIdV.isNotEmpty && bankIdV != "null") {
            debugPrint("bank id3 $bankIdV");
            final match = bankModel.firstWhere(
                  (item) => item.bankId?.toString().trim() == bankIdV.trim(), // Convert bankId to string before calling trim()
              orElse: () => GetBankMappingDetailsListModel(),
              // fallback empty object
            );
            debugPrint("bank id4 $match");
            // Only set if a valid match found
            if ((match.bankId?.toString() ?? '').isNotEmpty) { // Convert bankId to string for comparison
              setState(() {
                debugPrint("bank id5 $match");
                _selectBankModel = match;
                selectedBankName = match.bankName;
                selectedBankId = match.accountNo;
                selecteBankIDApi = match.bankId?.toInt();
                accMappingId = match.mappingId?.toInt();
              });
            }else{
              debugPrint("bank id6 $match");
            }
          }else{
            debugPrint("bank id7 ");
          }
        });

        paymentId = int.tryParse(argValue["paymentIdV"] ?? '') ?? 0;

        getNoteTypeAndIDList().whenComplete((){
          getPaymentdetailCashDenominationDtl(int.parse(arbPurId!)).whenComplete((){
            if(denominationModel.isNotEmpty){
              initializeControllers();
            }else{
              debugPrint("empty");
            }
          });
        });


        getExpenseHeaderList().whenComplete((){
          selectedExpense = expenseModel.firstWhere(
                (item) => item.expHeadName == expHeadNameEdit,
            orElse: () => GetExpenseHeaderListModel(
              expHeadName: '',
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add Payment"),
            SizedBox(height: 4),
          ],
        ),
      ),
      body:  Padding(
    padding: const EdgeInsets.only(left: 5.0,right: 5,top: 15,bottom: 15),
    child: SingleChildScrollView(
    child:
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
         // Expanded(child: Text(${args['InvoiceNo']}, style: TextStyle(color: Colors.blue),),),

         // Expanded(flex:1,child: countTextWidgetText(context,"Inv.No.", invoiceNo != null ? invoiceNo!:'')),
          Expanded(flex:1,child: countTextWidgetTextWithoutHeading(context, invoiceNo != null ? invoiceNo!:'')),

          Expanded(flex:1,child: countTextWidgetText(context,"Vendor Name", vendorName != null ? vendorName!:'')),
        ],
      ),
      SizedBox(height: 5,),
      Row(
        children: [
          Expanded(
            flex: 1,
            child: countTextWidgetText(
                context,
                "Total Bill Amt",
                totalBillAmt !=  null ?totalBillAmt!:''
            ) ,
          ),
          Expanded(flex:1,child: countTextWidgetText(context,"Balance Amt", balanceAmt != null ? balanceAmt!:'')),
        ],
      ),
      SizedBox(height: 10,),
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
        ],
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: textWidgetBlueColorWithStar(
                'Expense Head',
                "*"
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: DropdownButtonFormField<GetExpenseHeaderListModel>(
                isExpanded: true,
                key: formKey2,
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
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: textWidgetBlueColorWithStar(
              'Paid Amount',
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
                  num? balanceAmtNum = num.tryParse(balanceAmt!);
                });
              },
              decoration: InputDecoration(
                hintText: 'Paid Amount',
                hintStyle: TextStyle(
                  fontSize: 12,
                ),
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
      if (selectedTransMode == 'Online')
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child:
                  DropdownButtonFormField<
                      GetBankMappingDetailsListModel>(
                    decoration: InputDecoration(
                      label: countTextWidgetTextStarverysmall(
                        context,
                        'Select Acc No',
                        showAsterisk:
                        true, // Add a parameter to conditionally show the asterisk
                      ),
                    ),
                    value: bankModel.contains(_selectBankModel) ? _selectBankModel : null,

                    items: bankModel.map((item) {
                      return
                        DropdownMenuItem<GetBankMappingDetailsListModel>(
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
                    // hint: Text('Select Acc No'),

                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TranCodeController,
                    maxLengthEnforcement:
                    MaxLengthEnforcement.enforced,
                    // Enforce max length
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
                    decoration: InputDecoration(
                      labelText: 'Time',
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d{0,5}:?$'), // up to 5 digits, optional 1 colon at end
                      ),
                    ],

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
                  child: TextField(
                    controller: transReviewController,
                    decoration: InputDecoration(
                      labelText: 'Transaction Remark',
                    ),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(250),
                      // Limit the length to 30 characters
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
      SizedBox(height: 10),
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
          SizedBox(width: 10),
         // Adds space between buttons
          ElevatedButton(
            onPressed: () {
              if (modes == "EDIT") {
                paymentDetailsAddEditForMob(paymentId!, "EDIT");
              }else {
                paymentDetailsAddEditForMob(0, "ADD");
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
              //"Save",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // ElevatedButton(
          //   onPressed: () async {
          //     // Call checkAndSaveDayEndData to validate the day-end status
          //     await checkAndSaveDayEndData();
          //
          //     // Check if the day-end data is valid (saveFlag is true)
          //     if (saveFlag) {
          //       if (modes == "EDIT") {
          //         paymentDetailsAddEditForMob(paymentId!, "EDIT");
          //       } else {
          //         paymentDetailsAddEditForMob(0, "ADD");
          //       }
          //     } else {
          //       // Show a message to inform the user if the day-end process is incomplete
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(content: Text("Cannot save data. Day-end process is incomplete.")),
          //       );
          //     }
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.blue,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(50),
          //     ),
          //     padding: EdgeInsets.symmetric(
          //       horizontal: 20,
          //       vertical: 10, // Adjust padding to make button smaller
          //     ),
          //   ),
          //   child: Text(
          //     modes == "EDIT" ? 'Update' : 'Save',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 16,
          //     ),
          //   ),
          // ),
        ],
      ),
      SizedBox(height: 10),
      Card(
        child: paymentModel.isNotEmpty
            ? ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: paymentModel.length,
          itemBuilder: (context, index) {
            GetPaymentDetlArbPurLstModel? payList = paymentModel[index];
            return  Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: Text(payList.expHeadName ?? '', style: TextStyle(color: Colors.blue),),),
                    Expanded(child: Text(payList.paymentDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(payList.paymentDate!)) : '', style: TextStyle(color: Colors.blue),),),
                    Expanded(
                      flex: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,  // Align the icons to the right
                        children: [
                          //Edit Icon
                          Opacity(
                            opacity: (balanceAmt == "0" || balanceAmt == "0.0") ? 0.3 : 1.0,
                            child: IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),  // Icon for edit
                              onPressed: () {
                                if(balanceAmt == "0" || balanceAmt == "0.0"){
                                  debugPrint("noedit");
                                }else{
                                  debugPrint("edit");
                                  setState(() {

                                    var paymentMode = payList.paymentMode.toString();
                                    var expHeadId = payList.expHeadId.toString();
                                    var transTime = payList.transTime.toString();
                                    var arbPurId = payList.aRBPurId.toString();
                                    var transationCode = payList.transationCode.toString();
                                    var transRemark = payList.transRemark.toString();
                                    var expHeadName = payList.expHeadName.toString();
                                    var bankId = payList.bankId.toString();
                                    var mappingId = payList.bankMappingId.toString();
                                    var accountNo = payList.accountNo.toString();
                                    var paymentId = payList.paymentId.toString();
                                    var amountTotal = payList.totalAmtPaid.toString();
                                    int payId = int.parse(paymentId);
                                    if (saveFlag) {
                                      print('saveFlag $saveFlag');
                                      showFlushBar(context, Constants.dayEndCompleted);
                                    } else {
                                      Navigator.pushNamed(
                                        context,
                                        AddPaymentPopupScreen.screenName,
                                        arguments: {
                                          'paymentModeV': paymentMode,
                                          'expHeadId': expHeadId,
                                          'transTimeV': transTime,
                                          'transationCodeV': transationCode,
                                          'transRemarkV': transRemark,
                                          'expHeadNameV': expHeadName,
                                          'arbPurIdEditV': arbPurId,
                                          'bankIdV': bankId,
                                          'mappingIdV': mappingId,
                                          'accountNoV': accountNo,
                                          'paymentIdV': paymentId,
                                          'amountTotalV': amountTotal,
                                          'modeChange': "EDIT",
                                          "invoiceNoEdit" : invoiceNo,
                                          "VendorNameEdit" : vendorName,
                                          "VendorIdEdit" : vendorId,
                                          "totalBillAmtEdit" : totalBillAmt,
                                          "balanceAmt" : balanceAmt,
                                          "arbPurIdEdit" : arbPurId,
                                          "amountTotalV" : amountTotal,
                                        },
                                      );
                                    }
                                    // Navigate to the target screen and pass the data
                                  });
                                }
                              },
                            ),
                          ),

                          Opacity(
                            opacity: (double.tryParse(balanceAmt!) == 0.0) ? 0.3 : 1.0, // Parsing balanceAmt to double and checking if it's 0
                            child:
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red), // Icon for delete
                              onPressed: () async {
                                if (saveFlag) {
                                  print('saveFlag $saveFlag');
                                  showFlushBar(context, Constants.dayEndCompleted);
                                } else {
                                  double? parsedBalance = double.tryParse(balanceAmt!); // Try parsing balanceAmt to double
                                  int? pId = (payList.paymentId)?.toInt();
                                  print('Delete button pressed ${payList.paymentId}');

                                  // Show confirmation dialog only if balanceAmt is not 0
                                  if (parsedBalance != null && parsedBalance != 0.0) {
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
                                        paymentDetailsAddEditForMob(pId, "DELETE");
                                        print('Delete button pressed $pId');
                                      } else {
                                        print("Receipt ID is null.");
                                      }
                                    } else {
                                      print('Delete action was canceled');
                                    }
                                  } else {
                                    print('Balance is 0. Cannot delete.');
                                  }
                                }

                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(flex:1,child: countTextWidgetText(context,"Payment Mode", payList.paymentMode == "Bank"?"Online":payList.paymentMode ?? '')),
                    Expanded(flex:1,child: countTextWidgetText(context,"Paid Amt", formatCurrency(payList.totalAmtPaid!.toDouble()))),
                  ],
                ),
                SizedBox(height: 2),
                SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(flex:1,child: countTextWidgetText(context,"Trans Code", payList.transationCode.toString())),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(flex:1,child: countTextWidgetText(context,"Trans Time", payList.transTime.toString())),
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
    );
    // );
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

  Future<void> paymentDetailsAddEditForMob(int paymentId ,String action) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(staffId!);
    int? distributorIds = int.parse(distributorId!);

    double totalAmt = 0.0;
    String remark = '';
    int? bankId;
    int? accMappingIds;
    String? tranCode;
    String? tranTime;
    int? vendorId;
    //int? arbPurId;

    // if(paymentData?.vendorId != null ){
    //   //int vendorId =
    //   vendorId = paymentData?.vendorId;
    // }

    final List<Map<String, dynamic>> dataCashDenomination = getNoteTypeAndIdFroDenominationListModel.asMap().entries.map((entry) {
      int index = entry.key;
      var data = entry.value;
      return {
        "NoteId": data.id ?? 0, // Use null-aware operator to handle null values
        "NoteQty": qtyController[index].text.isNotEmpty ? int.tryParse(qtyController[index].text) : 0,
        "NoteAmt": amounts[index],
      };
    }).toList();

    if (action != "DELETE") {
      // Parse amount if not empty
      if (_balanceController.text.isNotEmpty) {
        totalAmt = double.parse(_balanceController.text);
      }

      double? balanceAmtNum = double.tryParse(balanceAmt!);

      // Validate amount doesn't exceed total
      if(selectedTransMode == "Cash"){
        if(totalAmount > 0){
          if (totalAmt != totalAmount) {
            showFlushBar(context, "Amount exceeds total amount");
            return;
          }
        }
      }
      if(cashDenominationMandatory){
        if(selectedTransMode == "Cash"){
          if(totalAmount > 0){
            if (totalAmt != totalAmount) {
              showFlushBar(context, "Amount exceeds total amount");
              return;
            }
          }else{
            showFlushBar(context, Constants.cashDenominationIsMandatory);
            return;
          }
        }
      }
      double? editAmt;
      if(modes == "EDIT"){
        editAmt = getEditTotalAmount! + balanceAmtNum!;
        debugPrint("getEditTotalAmount $getEditTotalAmount");
        debugPrint("balanceAmtNum $balanceAmtNum");
        if (totalAmt > editAmt) {
          debugPrint("editAmt $editAmt");
          showFlushBar(context, "Paid amount cannot be greater than balance amount ");
          return;
        }
      }else{
        if (totalAmt > balanceAmtNum!) {
          debugPrint("balanceAmtNum $balanceAmtNum");
          showFlushBar(context, "Paid amount cannot be greater than balance amount ");
          return;
        }
      }

      // Validate paid amount is less than or equal to balance


      // Get transaction code
      tranCode = TranCodeController.text.isNotEmpty ? TranCodeController.text : "";

      // Get transaction time
      tranTime = timeController.text.isNotEmpty ? timeController.text : "";

      // Get remark if present
      if (remarkController.text.isNotEmpty) {
        remark = remarkController.text;
      }

      // Set bank and account mapping IDs
      if (_selectBankModel != null) {
        bankId = selecteBankIDApi;
        accMappingIds = accMappingId;
      } else {
        bankId = 0;
        accMappingIds = 0;
      }

      // Validation checks
      if (selectedTransMode == null || selectedTransMode!.isEmpty) {
        showFlushBar(context, "Please select transaction mode");
        return;
      }

      if (selectedExpense == null) {
        showFlushBar(context, "Please select expense");
        return;
      }

      if (_balanceController.text.isEmpty) {
        showFlushBar(context, "Please enter paid amount");
        return;
      }

      if (selectedTransMode == "Online") {
        if (_selectBankModel == null) {
          showFlushBar(context, "Please select bank");
          return;
        }

        if (TranCodeController.text.isEmpty) {
          showFlushBar(context, "Please enter transaction code");
          return;
        }
      }
    }

    final Map<String, dynamic> requestBody =
    {
        "PaymentId":paymentId,
        "DistributorId":distributorId,
        "ARBPurId":arbPurId,
        "PaymentMode":selectedTransMode ?? '',
        "VendorId":vendorId ?? '',
        "ExpHeadId":selectedExpId ?? '',
        "CashCollDenomId":0,
        "BankId":bankId,
        "BankMappingId":accMappingIds ?? '',
        "TransactionCode": tranCode ?? '',
        "TransTime":tranTime ?? '',
        "TotalAmt":totalAmt,
        "TransRemark": remark ?? '',
        "Action":action,
        "AddedBy":userId ?? '',
        "UpdatedFrom":"MOB",
        "CashDenominationList":dataCashDenomination,
        "PaymentDate":formattedDate,

    };
    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.PaymentDetailsAdd}'),
      //InventoryStock/PaymentDetailsAdd
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody PaymentDetailsAdd: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Show a user-friendly error if the response body is 0
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {
        // totalAmount = totalAmount - discountAmt;

        // Process the valid response (JSON or data)
        print("Response AddEditARBItemPurchase: ${response.body}");

        Navigator.pushNamed(
          context,
          ArbScreen.screenName,
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
      }
    } else {
      print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }

  Future<void> getARBItemPaymentList(int? arbPurId) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    // int? arbPurId = prefs.getInt('ARBPurId');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetPaymentDetlARBPurLst}/$distributorId/$arbPurId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("PaymentDetailsAdd : " +
        '${AppUrl.GetPaymentDetlARBPurLst}/$distributorId/$arbPurId');
    debugPrint("PaymentDetailsAdd : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        paymentModel = data.map((json) {
          return GetPaymentDetlArbPurLstModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getPaymentdetailCashDenominationDtl(int ArbPurId) async {
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
      Uri.parse('${AppUrl.GetARBItemPurCashDenoDtlsById}/$ArbPurId/$distributorId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetARBItemPurCashDenoDtlsById : " +
        '${AppUrl.GetARBItemPurCashDenoDtlsById}/$ArbPurId/$distributorId');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      debugPrint("GetARBItemPurCashDenoDtlsById : " + '${response.body}');
      setState(() {
        denominationModel = data.map((json) {
          return GetCashDenominationDtlsByIdModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  // Future<void> checkAndSaveDayEndData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? bearerToken = prefs.getString('token');
  //   String? StaffId = prefs.getString('StaffId');
  //   int? staffIds = int.parse(StaffId!);
  //   int? distributorIds = int.parse(distributorId!);
  //   try {
  //     // Make the GET request
  //     final response = await http.get(
  //       Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $bearerToken", // Pass bearer token in headers
  //       },
  //     );
  //     debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
  //     debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
  //     if (response.statusCode == 200) {
  //       // Parse the API response
  //       List<dynamic> apiResponse = json.decode(response.body);
  //
  //       // Check if the response list is empty
  //       if (apiResponse.isEmpty) {
  //         // If the list is empty, do not save
  //         saveFlag = false;
  //         print("The list is empty, no data to save.");
  //       } else {
  //         // If there is data in the response, process it and save
  //         var dayEndData = apiResponse[0]; // Access the first item in the list (assuming it's an object)
  //
  //         // You can validate the fields in the response as needed
  //         int DSRSaved = dayEndData['DSRSaved'] ?? 0;
  //         int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
  //         int OpClSaved = dayEndData['OpClSaved'] ?? 0;
  //
  //         // Check if all required fields are saved
  //         if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
  //           saveFlag = true;
  //           // If the conditions are met, set the flag and save the data
  //           print("Data is valid, proceeding to save.");
  //         } else {
  //           // If any condition is not met, print a message
  //           print("Data is incomplete. Cannot proceed to save.");
  //         }
  //       }
  //     } else {
  //       // Handle API error
  //
  //       print("Error: ${response.statusCode}");
  //     }
  //   }
  //   catch (e) {
  //
  //     // Exception handling
  //     print("Exception: $e");
  //   }
  // }

  void cancelAction(){
    setState(() {

      selectedBankName = '';
      selectedTransMode = null;
      selectedBankId = null;
      selectedTransMode = null;
      _selectBankModel = null;
      selectedTransMode = null;
      TranCodeController.clear();
      timeController.clear();
      transReviewController.clear();
      selectedExpense = null;
      _balanceController.clear();
       modes = "Save";
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