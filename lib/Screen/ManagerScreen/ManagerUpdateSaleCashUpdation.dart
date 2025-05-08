import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantScreen/widgets.dart';
import '../Utils/Styling.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import 'BootomNavigatinBarManager.dart';
import 'ManagerModelClass/CheckConsumerNumberIsValidPrepaid.dart';
import 'ManagerModelClass/ConsumerModel.dart';
import 'ManagerModelClass/DenomModel.dart';
import 'ManagerModelClass/GetConsumerDetailsCredit.dart';
import 'ManagerModelClass/GetConsumerDiscountDetailCredit.dart';
import 'ManagerModelClass/GetExpenceHeadAmountListModel.dart';
import 'ManagerModelClass/GetExpenseDetailListModel.dart';
import 'ManagerModelClass/GetNoteTypeAndIDFroDenominationListModel.dart';
import 'ManagerModelClass/GetUpdateSaleDataForEditModel.dart';
import 'ManagerModelClass/PaymentModeModel.dart';
import 'ManagerModelClass/ReticulatedModel.dart';
import 'ManagerModelClass/TransactionModel.dart';
import 'ManagerUpdateSaleScreen.dart';
import 'package:http/http.dart' as http;

class ManagerUpdateSaleCashUpdation extends StatefulWidget {
  static const screenName = '/managerUpdateSaleCashUpdation';

  const ManagerUpdateSaleCashUpdation({super.key});

  @override
  State<ManagerUpdateSaleCashUpdation> createState() =>
      _ManagerUpdateSaleCashUpdationState();
}

class _ManagerUpdateSaleCashUpdationState
    extends State<ManagerUpdateSaleCashUpdation> {
  int _selectedTabIndex = 0;
  final List<ConsumerModel> _consumerList = [];
  final List<TransactionModel> _transactionList = [];
  final List<ReticulatedModel> _reticulatedList = [];
  final List<DenomModel> _denomModelList = [];
  final TextEditingController _consumerController = TextEditingController();
  final TextEditingController _qtyControllerPrepaid = TextEditingController();
  final TextEditingController _qtyControllerPostpaid = TextEditingController();
  final TextEditingController _qtyControllerCredit = TextEditingController();
  final TextEditingController _qtyControllerCash = TextEditingController();
  final TextEditingController _amountControllerPostpaid =
      TextEditingController();
  final TextEditingController _amountControllerCash = TextEditingController();
  final TextEditingController _amountControllerPrepaid =
      TextEditingController();
  final TextEditingController _amountControllerCredit = TextEditingController();

  final TextEditingController _totalExpectedAmountCash =
      TextEditingController();
  final TextEditingController _totalReceivedAmountCash =
      TextEditingController();
  final TextEditingController _totalBalanceAmountCash = TextEditingController();

  final TextEditingController _transactionCodeControllerPostpaid =
      TextEditingController();
  final TextEditingController _timeControllerPostpaid = TextEditingController();
  final TextEditingController _remarkControllerPostpaid =
      TextEditingController();
  final TextEditingController _remarkControllerCredit = TextEditingController();
  final TextEditingController _vendorCylinderQtyControllerCredit =
      TextEditingController();
  final TextEditingController _vendorCylinderAmountControllerCredit =
      TextEditingController();

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

  ///Return Amount
  final TextEditingController returnQuantity500Controller =
      TextEditingController();
  final TextEditingController returnQuantity200Controller =
      TextEditingController();
  final TextEditingController returnQuantity100Controller =
      TextEditingController();
  final TextEditingController returnQuantity50Controller =
      TextEditingController();
  final TextEditingController returnQuantity20Controller =
      TextEditingController();
  final TextEditingController returnQuantity10Controller =
      TextEditingController();
  final TextEditingController returnQuantity5Controller = TextEditingController();
  final TextEditingController returnQuantity2Controller = TextEditingController();
  final TextEditingController returnQuantity1Controller = TextEditingController();
  final TextEditingController returnQuantity050Controller = TextEditingController();

  // Variables to hold selected values from dropdowns
  String? selectedPaymentMode;
  String? selectedVendorName;
  int? selectedVendorId;
  int _selectedIndex = 0;

  double result500 = 0.0;
  double result200 = 0.0;
  double result100 = 0.0;
  double result50 = 0.0;
  double result20 = 0.0;
  double result10 = 0.0;
  double result5 = 0.0;
  double result2 = 0.0;
  double result1 = 0.0;
  double result050= 0.0;
  double total = 0.0;

  double finalsAmount = 0.0;

  ///Return amount
  double returnResult500 = 0.0;
  double returnResult200 = 0.0;
  double returnResult100 = 0.0;
  double returnResult50 = 0.0;
  double returnResult20 = 0.0;
  double returnResult10 = 0.0;
  double returnResult5 = 0.0;
  double returnResult2 = 0.0;
  double returnResult1 = 0.0;
  double returnResult050 = 0.0;
  double returnTotal = 0.0;

  ///cyl amt
  double amountPrepaidCylinder = 0;
  double amountPostpaidCylinder = 0;
  double amountCreditCylinder = 0;
  double amountCreditCylinderByVendor = 0;
  double amountCashCylinder = 0;

  ///for cyl validatiom
  int prepaidQty = 0;
  int postpaidQty = 0;
  int creditQty = 0;
  int cashQty = 0;
  int? cashQtys = 0;

  var argValue;
  String? delBoyNameName, itemName, vehicleNumber,receiptNoText,actionMode;
  int? saleQty,
      svQty,
      tvQty,
      expAmount,
      dmBal,
      delBoyIDs,
      itemIDs,
      vehicleID,
      salesGkId,
      sakesGKItemID,
      dSCollMgrId,
      prepaidQtyApi,
      postpaidQtyApi,
      creditQtyApi,
      cashQtyApi;

  String? saleQty1, svQty1, tvQty1, amountTotal1, expAmount1, dmBal1;
  double? itemRates, expenseAmtTotal,discountedRateCredit,discountCreditGet,amountTotal,
      delMenBalance,postpaidAmountApi,creditAmountApi,cashAmountApi,prepaidAmountApi,cashTotalExpectedAmount,cashTotalReceiveAmounts,cashBalanceAmount;

  List<GetConsumerDetailsCredit> getConsumerCreditDetailListModel = [];
  GetConsumerDetailsCredit? selectedCustomerModel;

  // List<String> paymentModeCredit = ['Prepaid','Credit','Cash'];
  List<PaymentModeModel> paymentModeCredit = [];
  PaymentModeModel? paymode;
  List<GetConsumerDiscountDetailCredit> getConsumerCreditDiscountDetailListModel = [];
  List<GetExpenseDetailListModel> getExpenseDetailListModel = [];
  List<GetNoteTypeAndIdFroDenominationListModel>
      getNoteTypeAndIdFroDenominationListModel = [];
  bool isLoading = true;

  List<CheckConsumerNumberIsValidPrepaid> getConsumerForPrepaid = [];
  int validConsumerCount = 0;
  int invalidConsumerCount = 0;

  TextEditingController validCountController = TextEditingController();
  TextEditingController invalidCountController = TextEditingController();

  ///expense
  String? _selectedExpenseHead;
  int? _selectedExpenseHeadId;
  final TextEditingController _expenseAmountController =
      TextEditingController();
  final TextEditingController _expenseRemarkController =
      TextEditingController();
  List<GetExpenceHeadAmountListModel> _expensesHeaders = [];
  GetExpenceHeadAmountListModel? _selectedexpensesHeaders;
  bool isCheckedBalanceCash = false;
  int pendingCDCMSCount = 0;

  bool isLumsumAmountAdd = true;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        delBoyNameName = argValue["delBoyName"];
        itemName = argValue["itemName"];
        saleQty = argValue["saleQty"];
        svQty = argValue["svQty"];
        tvQty = argValue["tvQty"];
        // amountTotal = argValue["amountTotal"];
        amountTotal = (argValue["amountTotal"] as num?)?.toDouble();
        itemRates = argValue["itemRate"];
        delBoyIDs = argValue["delBoyID"];
        itemIDs = argValue["itemID"];
        vehicleID = argValue["vehicleID"];
        sakesGKItemID = argValue["sakesGKItemID"];
        salesGkId = argValue["salesGkId"];
        dSCollMgrId = argValue["dSCollMgrId"];
        vehicleNumber = argValue["vehicleNumber"];
        receiptNoText = argValue["receiptNoText"];
        actionMode = argValue["actionModeApi"];
        saleQty1 = saleQty.toString();
        // expAmount = argValue["expAmount"];
        // dmBal = argValue["dmBal"];
        debugPrint("delBoyNameName :- ${delBoyNameName.toString()}");
        debugPrint("itemName :- $itemName");
        debugPrint("saleQty :- $saleQty");
        debugPrint("svQty :- $svQty");
        debugPrint("tvQty :- $tvQty");
        debugPrint("amountTotal :- $amountTotal");
        debugPrint("expAmount :- $expAmount");
        debugPrint("dmBal :- $dmBal");
        debugPrint("itemRates :- $itemRates");
        debugPrint("dSCollMgrId :- $dSCollMgrId");
        debugPrint("actionMode :- $actionMode");
        debugPrint("sakesGKItemID :- $sakesGKItemID");

  paymentModeCredit = [
  PaymentModeModel(paymentmode: 'Prepaid'),
  PaymentModeModel(paymentmode: 'Credit'),
  PaymentModeModel(paymentmode: 'Cash')// Adding the fourth value
  ];
        if(actionMode == "EDIT"){
          prepaidQtyApi = argValue["prepaidQtyApi"];
          prepaidAmountApi = argValue["prepaidAmountApi"];
          postpaidQtyApi = argValue["postpaidQtyApi"];
          postpaidAmountApi = argValue["postpaidAmountApi"];
          creditQtyApi = argValue["creditQtyApi"];
          creditAmountApi = argValue["creditAmountApi"];
          cashQtyApi = argValue["cashQtyApi"];
          cashAmountApi = argValue["cashAmountApi"];
          cashTotalExpectedAmount = argValue["cashTotalExpectedAmount"];
          cashTotalReceiveAmounts = argValue["cashTotalReceiveAmount"];
          cashBalanceAmount = argValue["cashBalanceAmount"];
          debugPrint("expAmount :- $cashTotalExpectedAmount");
          debugPrint("dmBal :- $cashBalanceAmount");
          if(((postpaidAmountApi! > 0) && (postpaidQtyApi! <= 0)) || ((cashAmountApi! > 0) && (cashQtyApi! <= 0))) {
            isLumsumAmountAdd = false;
          }

          _qtyControllerPrepaid.text = prepaidQtyApi.toString();
          _qtyControllerPostpaid.text = postpaidQtyApi.toString();
          _qtyControllerCredit.text = creditQtyApi.toString();
          _qtyControllerCash.text = cashQtyApi.toString();

          prepaidQty =  prepaidQtyApi!;
          postpaidQty = postpaidQtyApi!;
          creditQty = creditQtyApi!;
          cashQty = cashQtyApi!;
          cashQtys = cashQtyApi!;
          pendingCDCMSCount = prepaidQtyApi!;

          _amountControllerPrepaid.text = prepaidAmountApi.toString();
          _amountControllerPostpaid.text = postpaidAmountApi.toString();
          _amountControllerCredit.text = creditAmountApi.toString();
          _amountControllerCash.text = cashAmountApi.toString();

          _totalExpectedAmountCash.text = cashTotalExpectedAmount.toString();
          _totalReceivedAmountCash.text = cashTotalReceiveAmounts.toString();
          _totalBalanceAmountCash.text = cashBalanceAmount.toString();

          amountPrepaidCylinder = prepaidAmountApi!.toDouble();
          amountPostpaidCylinder = postpaidAmountApi!.toDouble();
          amountCreditCylinder = creditAmountApi!.toDouble();
          amountCashCylinder = cashAmountApi!.toDouble();


          debugPrint("cashTotalExpectedAmount :- $cashTotalExpectedAmount");
          _fetchSavedListDataForEdit(dSCollMgrId!,sakesGKItemID!);
          _fetchSavedListDataForEdit(dSCollMgrId!,sakesGKItemID!).whenComplete((){
            setState(() {
              fetchExpenseDetailList();
            });
          });
        }else{
          fetchExpenseDetailList();
        }
        fetchConsumerDetailsCredit();
        fetchConsumerDiscountDetailsCredit();
        getNoteTypeAndIDList();
        fetchExpenseHeaderDetails();
        prepareDenominationData(getNoteTypeAndIdFroDenominationListModel);
        // Add listeners to controllers to rebuild the widget
        _qtyControllerPrepaid.addListener(() {
          setState(() {}); // Triggers a rebuild when the text changes
        });

        _consumerController.addListener(() {
          setState(() {}); // Triggers a rebuild when the text changes
        });
        fetchDeliveryMenBalance(delBoyIDs!);
      });
    });

  }

  @override
  void dispose() {
    _consumerController.dispose();
    super.dispose();
  }

  ///Cash denomination
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
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) +
          (result200 ?? 0.0) +
          (result100 ?? 0.0) +
          (result50 ?? 0.0) +
          (result20 ?? 0.0) +
          (result10 ?? 0.0) +
          (result5 ?? 0.0)+
          (result2 ?? 0.0) +
          (result1 ?? 0.0)+
          (result050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
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
        default:
          break;
      }
      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) +
          (result200 ?? 0.0) +
          (result100 ?? 0.0) +
          (result50 ?? 0.0) +
          (result20 ?? 0.0) +
          (result10 ?? 0.0) +
          (result5 ?? 0.0)+
          (result2 ?? 0.0) +
          (result1 ?? 0.0)+
          (result050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
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
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) +
          (result200 ?? 0.0) +
          (result100 ?? 0.0) +
          (result50 ?? 0.0) +
          (result20 ?? 0.0) +
          (result10 ?? 0.0) +
          (result5 ?? 0.0)+
          (result2 ?? 0.0) +
          (result1 ?? 0.0)+
          (result050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
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
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) +
          (result200 ?? 0.0) +
          (result100 ?? 0.0) +
          (result50 ?? 0.0) +
          (result20 ?? 0.0) +
          (result10 ?? 0.0) +
          (result5 ?? 0.0)+
          (result2 ?? 0.0) +
          (result1 ?? 0.0)+
          (result050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
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
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) +
          (result200 ?? 0.0) +
          (result100 ?? 0.0) +
          (result50 ?? 0.0) +
          (result20 ?? 0.0) +
          (result10 ?? 0.0) +
          (result5 ?? 0.0)+
          (result2 ?? 0.0) +
          (result1 ?? 0.0)+
          (result050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
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
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) +
          (result200 ?? 0.0) +
          (result100 ?? 0.0) +
          (result50 ?? 0.0) +
          (result20 ?? 0.0) +
          (result10 ?? 0.0) +
          (result5 ?? 0.0)+
          (result2 ?? 0.0) +
          (result1 ?? 0.0)+
          (result050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
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
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) +
          (result200 ?? 0.0) +
          (result100 ?? 0.0) +
          (result50 ?? 0.0) +
          (result20 ?? 0.0) +
          (result10 ?? 0.0) +
          (result5 ?? 0.0)+
          (result2 ?? 0.0) +
          (result1 ?? 0.0)+
          (result050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
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
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) +
          (result200 ?? 0.0) +
          (result100 ?? 0.0) +
          (result50 ?? 0.0) +
          (result20 ?? 0.0) +
          (result10 ?? 0.0) +
          (result5 ?? 0.0) +
          (result2 ?? 0.0) +
            (result1 ?? 0.0)+
          (result050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
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
      total = (result500 ?? 0.0) +
          (result200 ?? 0.0) +
          (result100 ?? 0.0) +
          (result50 ?? 0.0) +
          (result20 ?? 0.0) +
          (result10 ?? 0.0) +
          (result5 ?? 0.0) +
          (result2 ?? 0.0) +
          (result1 ?? 0.0)+
          (result050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
    });
  }

  void calculate050Amount(double value) {
    // Get the quantity from the text field
    double qty = double.tryParse(quantity050Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      result050 = qty * 0.50;
      debugPrint("result050$result050");

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
      total = (result500 ?? 0.0) +
          (result200 ?? 0.0) +
          (result100 ?? 0.0) +
          (result50 ?? 0.0) +
          (result20 ?? 0.0) +
          (result10 ?? 0.0) +
          (result5 ?? 0.0) +
          (result2 ?? 0.0) +
          (result1 ?? 0.0) +
          (result050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
    });
  }

  ///Cash denomination Return
  void calculate500AmountReturnAmount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(returnQuantity500Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      returnResult500 = qty * 500;
      // Calculate the amount based on the value
      switch (value) {
        case 500:
          returnResult500 = qty * 500;
          break;
        case 200:
          returnResult200 = qty * 200;
          break;
        case 100:
          returnResult100 = qty * 100;
          break;
        case 50:
          returnResult50 = qty * 50;
          break;
        case 20:
          returnResult20 = qty * 20;
          break;
        case 10:
          returnResult10 = qty * 10;
          break;
        case 5:
          returnResult5 = qty * 5;
          break;
        case 2:
          returnResult2 = qty * 2;
          break;
        case 1:
          returnResult1 = qty * 1;
          break;
        case 0.50:
          returnResult050 = qty * 0.50;
          break;
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      returnTotal = (returnResult500 ?? 0.0) +
          (returnResult200 ?? 0.0) +
          (returnResult100 ?? 0.0) +
          (returnResult50 ?? 0.0) +
          (returnResult20 ?? 0.0) +
          (returnResult10 ?? 0.0) +
          (returnResult5 ?? 0.0)+
          (returnResult2 ?? 0.0)+
          (returnResult1 ?? 0.0)+
          (returnResult050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
    });
  }

  void calculate200AmountReturnAmount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(returnQuantity200Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      returnResult200 = qty * 200;
      switch (value) {
        case 500:
          returnResult500 = qty * 500;
          break;
        case 200:
          returnResult200 = qty * 200;
          break;
        case 100:
          returnResult100 = qty * 100;
          break;
        case 50:
          returnResult50 = qty * 50;
          break;
        case 20:
          returnResult20 = qty * 20;
          break;
        case 10:
          returnResult10 = qty * 10;
          break;
        case 5:
          returnResult5 = qty * 5;
          break;
        case 2:
          returnResult2 = qty * 2;
          break;
        case 1:
          returnResult1 = qty * 1;
          break;
        case 0.50:
          returnResult050 = qty * 0.50;
          break;
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      returnTotal = (returnResult500 ?? 0.0) +
          (returnResult200 ?? 0.0) +
          (returnResult100 ?? 0.0) +
          (returnResult50 ?? 0.0) +
          (returnResult20 ?? 0.0) +
          (returnResult10 ?? 0.0) +
          (returnResult5 ?? 0.0)+
          (returnResult2 ?? 0.0)+
          (returnResult1 ?? 0.0)+
          (returnResult050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
    });
  }

  void calculate100AmountReturnAmount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(returnQuantity100Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      returnResult100 = qty * 100;

      switch (value) {
        case 500:
          returnResult500 = qty * 500;
          break;
        case 200:
          returnResult200 = qty * 200;
          break;
        case 100:
          returnResult100 = qty * 100;
          break;
        case 50:
          returnResult50 = qty * 50;
          break;
        case 20:
          returnResult20 = qty * 20;
          break;
        case 10:
          returnResult10 = qty * 10;
          break;
        case 5:
          returnResult5 = qty * 5;
          break;
        case 2:
          returnResult2 = qty * 2;
          break;
        case 1:
          returnResult1 = qty * 1;
          break;
        case 0.50:
          returnResult050 = qty * 0.50;
          break;
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      returnTotal = (returnResult500 ?? 0.0) +
          (returnResult200 ?? 0.0) +
          (returnResult100 ?? 0.0) +
          (returnResult50 ?? 0.0) +
          (returnResult20 ?? 0.0) +
          (returnResult10 ?? 0.0) +
          (returnResult5 ?? 0.0)+
          (returnResult2 ?? 0.0)+
          (returnResult1 ?? 0.0)+
          (returnResult050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
    });
  }

  void calculate50AmountReturnAmount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(returnQuantity50Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      returnResult50 = qty * 50;

      switch (value) {
        case 500:
          returnResult500 = qty * 500;
          break;
        case 200:
          returnResult200 = qty * 200;
          break;
        case 100:
          returnResult100 = qty * 100;
          break;
        case 50:
          returnResult50 = qty * 50;
          break;
        case 20:
          returnResult20 = qty * 20;
          break;
        case 10:
          returnResult10 = qty * 10;
          break;
        case 5:
          returnResult5 = qty * 5;
          break;
        case 2:
          returnResult2 = qty * 2;
          break;
        case 1:
          returnResult1 = qty * 1;
          break;
        case 0.50:
          returnResult050 = qty * 0.50;
          break;
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      returnTotal = (returnResult500 ?? 0.0) +
          (returnResult200 ?? 0.0) +
          (returnResult100 ?? 0.0) +
          (returnResult50 ?? 0.0) +
          (returnResult20 ?? 0.0) +
          (returnResult10 ?? 0.0) +
          (returnResult5 ?? 0.0)+
          (returnResult2 ?? 0.0)+
          (returnResult1 ?? 0.0)+
          (returnResult050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
    });
  }

  void calculate20AmountReturnAmount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(returnQuantity20Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      returnResult20 = qty * 20;

      switch (value) {
        case 500:
          returnResult500 = qty * 500;
          break;
        case 200:
          returnResult200 = qty * 200;
          break;
        case 100:
          returnResult100 = qty * 100;
          break;
        case 50:
          returnResult50 = qty * 50;
          break;
        case 20:
          returnResult20 = qty * 20;
          break;
        case 10:
          returnResult10 = qty * 10;
          break;
        case 5:
          returnResult5 = qty * 5;
          break;
        case 2:
          returnResult2 = qty * 2;
          break;
        case 1:
          returnResult1 = qty * 1;
          break;
        case 0.50:
          returnResult050 = qty * 0.50;
          break;
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      returnTotal = (returnResult500 ?? 0.0) +
          (returnResult200 ?? 0.0) +
          (returnResult100 ?? 0.0) +
          (returnResult50 ?? 0.0) +
          (returnResult20 ?? 0.0) +
          (returnResult10 ?? 0.0) +
          (returnResult5 ?? 0.0)+
          (returnResult2 ?? 0.0)+
          (returnResult1 ?? 0.0)+
          (returnResult050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
    });
  }

  void calculate10AmountReturnAmount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(returnQuantity10Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      returnResult10 = qty * 10;

      switch (value) {
        case 500:
          returnResult500 = qty * 500;
          break;
        case 200:
          returnResult200 = qty * 200;
          break;
        case 100:
          returnResult100 = qty * 100;
          break;
        case 50:
          returnResult50 = qty * 50;
          break;
        case 20:
          returnResult20 = qty * 20;
          break;
        case 10:
          returnResult10 = qty * 10;
          break;
        case 5:
          returnResult5 = qty * 5;
          break;
        case 2:
          returnResult2 = qty * 2;
          break;
        case 1:
          returnResult1 = qty * 1;
          break;
        case 0.50:
          returnResult050 = qty * 0.50;
          break;
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      returnTotal = (returnResult500 ?? 0.0) +
          (returnResult200 ?? 0.0) +
          (returnResult100 ?? 0.0) +
          (returnResult50 ?? 0.0) +
          (returnResult20 ?? 0.0) +
          (returnResult10 ?? 0.0) +
          (returnResult5 ?? 0.0)+
          (returnResult2 ?? 0.0)+
          (returnResult1 ?? 0.0)+
          (returnResult050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
    });
  }

  void calculate5AmountReturnAmount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(returnQuantity5Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      returnResult5 = qty * 5;

      switch (value) {
        case 500:
          returnResult500 = qty * 500;
          break;
        case 200:
          returnResult200 = qty * 200;
          break;
        case 100:
          returnResult100 = qty * 100;
          break;
        case 50:
          returnResult50 = qty * 50;
          break;
        case 20:
          returnResult20 = qty * 20;
          break;
        case 10:
          returnResult10 = qty * 10;
          break;
        case 5:
          returnResult5 = qty * 5;
          break;
        case 2:
          returnResult2 = qty * 2;
          break;
        case 1:
          returnResult1 = qty * 1;
          break;
        case 0.50:
          returnResult050 = qty * 0.50;
          break;
        default:
          break;
      }
      // Calculate the total of all results, treating null or 0.0 as 0
      returnTotal = (returnResult500 ?? 0.0) +
          (returnResult200 ?? 0.0) +
          (returnResult100 ?? 0.0) +
          (returnResult50 ?? 0.0) +
          (returnResult20 ?? 0.0) +
          (returnResult10 ?? 0.0) +
          (returnResult5 ?? 0.0)+
          (returnResult2 ?? 0.0)+
          (returnResult1 ?? 0.0)+
          (returnResult050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
    });
  }

  void calculate2AmountReturnAmount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(returnQuantity2Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      returnResult2 = qty * 2;

      switch (value) {
        case 500:
          returnResult500 = qty * 500;
          break;
        case 200:
          returnResult200 = qty * 200;
          break;
        case 100:
          returnResult100 = qty * 100;
          break;
        case 50:
          returnResult50 = qty * 50;
          break;
        case 20:
          returnResult20 = qty * 20;
          break;
        case 10:
          returnResult10 = qty * 10;
          break;
        case 5:
          returnResult5 = qty * 5;
          break;
        case 2:
          returnResult2 = qty * 2;
          break;
        case 1:
          returnResult1 = qty * 1;
          break;
        case 0.50:
          returnResult050 = qty * 0.50;
          break;
        default:
          break;
      }
      // Calculate the total of all results, treating null or 0.0 as 0
      returnTotal = (returnResult500 ?? 0.0) +
          (returnResult200 ?? 0.0) +
          (returnResult100 ?? 0.0) +
          (returnResult50 ?? 0.0) +
          (returnResult20 ?? 0.0) +
          (returnResult10 ?? 0.0) +
          (returnResult5 ?? 0.0)+
          (returnResult2 ?? 0.0)+
          (returnResult1 ?? 0.0)+
          (returnResult050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
    });
  }

  void calculate1AmountReturnAmount(int value) {
    // Get the quantity from the text field
    double qty = double.tryParse(returnQuantity1Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      returnResult1 = qty * 1;

      switch (value) {
        case 500:
          returnResult500 = qty * 500;
          break;
        case 200:
          returnResult200 = qty * 200;
          break;
        case 100:
          returnResult100 = qty * 100;
          break;
        case 50:
          returnResult50 = qty * 50;
          break;
        case 20:
          returnResult20 = qty * 20;
          break;
        case 10:
          returnResult10 = qty * 10;
          break;
        case 5:
          returnResult5 = qty * 5;
          break;
        case 2:
          returnResult2 = qty * 2;
          break;
        case 1:
          returnResult1 = qty * 1;
          break;
        case 0.50:
          returnResult050 = qty * 0.50;
          break;
        default:
          break;
      }
      // Calculate the total of all results, treating null or 0.0 as 0
      returnTotal = (returnResult500 ?? 0.0) +
          (returnResult200 ?? 0.0) +
          (returnResult100 ?? 0.0) +
          (returnResult50 ?? 0.0) +
          (returnResult20 ?? 0.0) +
          (returnResult10 ?? 0.0) +
          (returnResult5 ?? 0.0)+
          (returnResult2 ?? 0.0)+
          (returnResult1 ?? 0.0)+
          (returnResult050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
    });
  }

  void calculate050AmountReturnAmount(double value) {
    // Get the quantity from the text field
    double qty = double.tryParse(returnQuantity050Controller.text) ?? 0.0;
    // Calculate the amount (quantity * 500)
    setState(() {
      returnResult050 = qty * 0.50;

      switch (value) {
        case 500:
          returnResult500 = qty * 500;
          break;
        case 200:
          returnResult200 = qty * 200;
          break;
        case 100:
          returnResult100 = qty * 100;
          break;
        case 50:
          returnResult50 = qty * 50;
          break;
        case 20:
          returnResult20 = qty * 20;
          break;
        case 10:
          returnResult10 = qty * 10;
          break;
        case 5:
          returnResult5 = qty * 5;
          break;
        case 2:
          returnResult2 = qty * 2;
          break;
        case 1:
          returnResult1 = qty * 1;
          break;
        case 0.50:
          returnResult050 = qty * 0.50;
          break;
        default:
          break;
      }
      // Calculate the total of all results, treating null or 0.0 as 0
      returnTotal = (returnResult500 ?? 0.0) +
          (returnResult200 ?? 0.0) +
          (returnResult100 ?? 0.0) +
          (returnResult50 ?? 0.0) +
          (returnResult20 ?? 0.0) +
          (returnResult10 ?? 0.0) +
          (returnResult5 ?? 0.0)+
          (returnResult2 ?? 0.0)+
          (returnResult1 ?? 0.0)+
          (returnResult050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
      checkAndShowMessageIfExceeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        if (argLRAdd == "fromDrawer") {
          // Navigator.pushReplacementNamed(context, DashboardScreen.screenName,
          //     arguments: "onBack");
          Navigator.pop(context);
          return false;
        } else {
          Navigator.pop(context);
          // Navigator.pushReplacementNamed(context, DashboardScreen.screenName);
          return false;
        } // In case `null` is returned, return `false`
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1280b3),
          // You can change the color as needed
          automaticallyImplyLeading: false,
          // Disable default back button
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              children: [
                // Back Arrow Button
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    // Navigator.pushReplacementNamed(context, '/managerUpdateSaleScreen');
                    // Navigator.pushNamed(
                    //     context,
                    //     ManagerUpdateSaleScreen
                    //         .screenName);
                    Navigator.pop(context);
                  },
                ),
                // Text Field
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$delBoyNameName",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        "$itemName",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              // Top card showing static values
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50], // Light blue background color
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // First Column (Refill and TV)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: 50,
                                              child: Text('Sale',
                                                  style:
                                                      Styling.itemGreyTextSmall)),
                                          Text(": ${saleQty.toString()}",
                                              style: Styling.itemBlackTestSmall),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: 50,
                                              child: Text('SV',
                                                  style:
                                                      Styling.itemGreyTextSmall)),
                                          Text(": ${svQty.toString()}",
                                              style: Styling.itemBlackTestSmall),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: 50,
                                              child: Text('TV',
                                                  style:
                                                      Styling.itemGreyTextSmall)),
                                          Text(": ${tvQty.toString()}",
                                              style: Styling.itemBlackTestSmall),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Second Column (SV and Amount)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: 80,
                                              child: Text('Sale Amt.',
                                                  style:
                                                      Styling.itemGreyTextSmall)),
                                          Text(
                                              ": ${formatCurrency((amountTotal ?? 0).toDouble())}",
                                              style: Styling.itemBlackTestSmall),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: 80,
                                              child: Text('Exp.Amt.',
                                                  style:
                                                      Styling.itemGreyTextSmall)),
                                          Text(
                                              ": ${(expenseAmtTotal ?? 0).toStringAsFixed(2)}",
                                              style: Styling.itemBlackTestSmall),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: 80,
                                              child: Text('DM Amt.',
                                                  style:
                                                      Styling.itemGreyTextSmall)),
                                          Text(
                                              ": ${(delMenBalance ?? 0).toStringAsFixed(2)}",
                                              style: Styling.itemBlackTestSmall),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     Row(
                                  //       children: [
                                  //         SizedBox(
                                  //             width: 50,
                                  //             child: Text('TV',
                                  //                 style:
                                  //                 Styling.itemGreyTextSmall)),
                                  //         Text(": ${tvQty.toString()}",
                                  //             style: Styling.itemBlackTestSmall),
                                  //       ],
                                  //     ),
                                  //     SizedBox(
                                  //       height: 5,
                                  //     ),
                                  //     Row(
                                  //       children: [
                                  //         SizedBox(
                                  //             width: 50,
                                  //             child: Text('DM\nAmt.',
                                  //                 style:
                                  //                 Styling.itemGreyTextSmall)),
                                  //         Text(
                                  //             ": ${amountTotal ?? 0.toStringAsFixed(2)}",
                                  //             style: Styling.itemBlackTestSmall),
                                  //       ],
                                  //     ),
                                  //   ],
                                  // ),
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _showExpenseBottomSheet(context, delBoyNameName!, vehicleNumber!);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xff1280b3)),
                                        ),
                                        child: Text(
                                          'Exp',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // TabBar with clickable tabs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTabText('Prepaid', 0),
                          _buildTabText('Postpaid', 1),
                          _buildTabText('Reticulated', 2),
                          _buildTabText('Cash', 3),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tab-specific content
              Expanded(
                child: IndexedStack(
                  index: _selectedTabIndex,
                  children: [
                    _buildPrepaidTab(),
                    _buildPostpaidTab(),
                    _buildCreditTab(),
                    _buildCashTab(),
                  ],
                ),
              ),

              // Save button

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if(actionMode == "EDIT"){
                      updateSaleAddEditForMob("EDIT");
                    }else{
                      updateSaleAddEditForMob("ADD");
                    }


                    // prepareDenominationData(
                    //     getNoteTypeAndIdFroDenominationListModel);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(const Color(0xff1280b3)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Text(
                      actionMode == "EDIT"?'Update':'Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabText(String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
                color: _selectedTabIndex == index ? Colors.blue : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          Text(
            index == 3
                ? cashQtys.toString()
                : index == 0
                    ? prepaidQty.toString()
                    : index == 1
                        ? postpaidQty.toString()
                        : index == 2
                            ? creditQty.toString()
                            : "0",
            style: TextStyle(
                color: _selectedTabIndex == index ? Colors.blue : Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 40,
            color:
                _selectedTabIndex == index ? Colors.blue : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildPrepaidTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cylinder Qty with Icon and TextField
            Row(
              children: [
                Expanded(
                    child: textWidgetBlueColorWithoutStar("Cylinder Qty:")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _qtyControllerPrepaid,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // Only digits allowed
                      LengthLimitingTextInputFormatter(3),
                      // Limit to 6 characters
                    ],
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    enabled: false,
                    onChanged: (value) {
                      setState(() {
                        prepaidQty = int.tryParse(value) ?? 0;
                        if(isLumsumAmountAdd){
                          _calculateCylinderAmountPrepaid();
                          _validateQuantities("Prepaid");
                          // calculateBalanceAmountForReceiveAmountCash();
                          _totalReceivedAmountCash.text = '';
                          _totalBalanceAmountCash.text = '';
                        }else{
                          _validateQuantitiesLumsumCase("Prepaid");
                          _calculateCylinderAmountPrepaid();
                          calculateBalanceAmountForReceiveAmountCashLumsumMode();
                          // calculateBalanceAmountForReceiveAmountCashLumsum();
                          _totalReceivedAmountCash.text = '';
                          _totalBalanceAmountCash.text = '';
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            // Amount Text
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     SizedBox(height: 8),
            //     Text('₹${amountPrepaidCylinder.toStringAsFixed(0)}',
            //         style: Styling.itemBlackTest),
            //   ],
            // ),

            Row(
              children: [
                Expanded(child: textWidgetBlueColorWithoutStar("Amount:")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _amountControllerPrepaid,
                    keyboardType: TextInputType.number,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.digitsOnly,
                    //   // Only digits allowed
                    //   LengthLimitingTextInputFormatter(3),
                    //   // Limit to 6 characters
                    // ],
                    enabled: false,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    onChanged: (value) {
                      setState(() {
                        if(isLumsumAmountAdd){
                        }else{
                          calculateBalanceAmountForReceiveAmountCashLumsumMode();
                          _totalReceivedAmountCash.text = '';
                          _totalBalanceAmountCash.text = '';
                        }

                      });
                    },
                  ),
                ),
              ],
            ),
            // Input field and Add button
            Column(
              children: [
                Row(
                  children: [
                    // Text("Consumer No.:",  style: Styling.blueClrText,),
                    Expanded(
                        child:
                            textWidgetBlueColorWithStar("Consumer No.:", "*")),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _consumerController,
                          decoration: InputDecoration(
                            // Label for the text field
                            labelStyle: TextStyle(
                                fontSize: 16, color: Colors.blueAccent),
                          ),
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          // Numeric keyboard
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // Only digits allowed
                            LengthLimitingTextInputFormatter(6),
                            // Limit to 6 characters
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                            if (_consumerController.text.isNotEmpty) {
                              int consumerNumber = int.parse(_consumerController.text);
                                fetchConsumerNumbersPrepaid(consumerNumber);
                            } else {
                            }
                      },
                      // style: ButtonStyle(
                      //   backgroundColor:((_qtyControllerPrepaid.text.isNotEmpty) &&
                      //       (_consumerController.text.isNotEmpty))?
                      //   MaterialStateProperty.all<Color>(
                      //       Color(0xff1280b3)
                      //   ): MaterialStateProperty.all<Color>(
                      //       Color(0xff666666)
                      //   ),
                      // ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                        (_consumerController.text.isNotEmpty)
                            ? Color(0xff1280b3)
                            : Color(0xff666666),
                      )),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: textWidgetBlueColorWithoutStarGreen("Valid:")),
                Flexible(
                  flex: 1,
                  child:
                  TextField(
                    controller: validCountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // Only digits allowed
                      LengthLimitingTextInputFormatter(3),
                      // Limit to 6 characters
                    ],
                    enabled: false,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemGreenText,
                    onChanged: (value) {},
                  ),
                ),
                Expanded(child: textWidgetBlueColorWithoutStarRed("Invalid:")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: invalidCountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // Only digits allowed
                      LengthLimitingTextInputFormatter(3),
                      // Limit to 6 characters
                    ],
                    enabled: false,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemRedText,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Center(
                              child: Text("Cons.No.",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                      verticalDividerVerySmall(),
                      Expanded(
                          flex: 3,
                          child: Center(
                              child: Text("Name",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                      verticalDividerVerySmall(),
                      Expanded(
                          flex: 3,
                          child: Center(
                              child: Text("Remark",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                      verticalDividerVerySmall(),
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: Text("",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  ),
                    Container(
                      color: Colors.blue,
                      height: 1,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      // Ensures the list takes only the required height
                      physics: const NeverScrollableScrollPhysics(),
                      // Disables inner scrolling
                      itemCount: _consumerList.length,
                      itemBuilder: (context, index) {
                        final transaction = _consumerList[index];
                        return Row(
                          children: [
                            // Column 1: Item Name
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text(
                                  transaction.consumerNo.toString(),
                                  style: actionMode == "EDIT"
                                      ? (transaction.InCorrectStatus == 1
                                      ? Styling.itemGreenText
                                      : Styling.itemRedText)
                                      : (transaction.niyojanDel == 1
                                      ? Styling.itemGreenText
                                      : Styling.itemRedText),
                                  // style: transaction.niyojanDel != 1 ?Styling.itemGreenText:Styling.itemRedText,
                                ),
                              ),
                            ),
                            verticalDividerSmall(),
                            // Column 2: Filled
                            Expanded(
                              flex: 3,
                              child: Text(
                                transaction.consumerName.toString(),
                                style: actionMode == "EDIT"
                                    ? (transaction.InCorrectStatus == 1
                                    ? Styling.itemGreenText
                                    : Styling.itemRedText)
                                    : (transaction.niyojanDel == 1
                                    ? Styling.itemGreenText
                                    : Styling.itemRedText),
                                // style: transaction.niyojanDel != 1 ?Styling.itemGreenText:Styling.itemRedText,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            verticalDividerSmall(),
                            // Column 3: SV
                            Expanded(
                              flex: 3,
                              child: Text(
                                transaction.remark.toString(),
                                style: actionMode == "EDIT"
                                    ? (transaction.InCorrectStatus == 1
                                    ? Styling.itemGreenText
                                    : Styling.itemRedText)
                                    : (transaction.niyojanDel == 1
                                    ? Styling.itemGreenText
                                    : Styling.itemRedText),
                                textAlign: TextAlign.left,
                              ),

                            ),
                            verticalDividerSmall(),
                            // Column 4: TV
                            Expanded(
                              flex: 1,
                              child:  IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteConsumer(index);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ) // Consumer list
          ],
        ),
      ),
    );
  }

  Widget _buildPostpaidTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right:5, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: textWidgetBlueColorWithoutStar("Cylinder Qty:")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _qtyControllerPostpaid,
                    keyboardType: TextInputType.number,
                    enabled: isLumsumAmountAdd,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // Only digits allowed
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    onChanged: (value) {
                      setState(() {
                        postpaidQty = int.tryParse(value) ?? 0;
                      });
                      _calculateCylinderAmountPostpaid();
                      _validateQuantities("Postpaid");
                      _totalReceivedAmountCash.clear();
                      _totalBalanceAmountCash.clear();
                    },
                  ),
                ),
              ],
            ),

            // // Amount Text
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     SizedBox(height: 8),
            //     Text(
            //       '₹${amountPostpaidCylinder.toStringAsFixed(0)}',
            //       style: Styling.itemBlackTest,
            //     ),
            //   ],
            // ),

            Row(
              children: [
                // Text(
                //   'Cylinder Qty:',
                //     style: Styling.blueClrText
                // ),
                Expanded(child: textWidgetBlueColorWithoutStar("Amount:")),

                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _amountControllerPostpaid,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      // FilteringTextInputFormatter.digitsOnly,
                      // Only digits allowed
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    onChanged: (value) {
                      setState(() {
                        isLumsumAmountAdd = false;
                        _qtyControllerPostpaid.text = "0";
                        postpaidQty = 0;
                        _qtyControllerCash.text = "0";
                        cashQtys = 0;
                        double amount = double.parse(value);
                        if(actionMode  == "EDIT"){
                          _totalBalanceAmountCash.clear();
                          if(amountTotal! > amount){
                            _calculateCylinderAmountCashtLumsumEdit();
                            calculateBalanceAmountForReceiveAmountCashLumsumMode();
                            if(isLumsumAmountAdd){
                              // calculateBalanceAmountForReceiveAmountCash();
                            }else{
                              _calculateCylinderAmountCashtLumsumEdit();
                              calculateBalanceAmountForReceiveAmountCashLumsumMode();
                              // calculateBalanceAmountForReceiveAmountCashLumsum();
                            }
                          }else{
                            _amountControllerPostpaid.clear();
                            if(isLumsumAmountAdd){
                              // calculateBalanceAmountForReceiveAmountCash();
                            }else{
                              calculateBalanceAmountForReceiveAmountCashLumsumMode();
                              // calculateBalanceAmountForReceiveAmountCashLumsum();
                            }
                          }
                        }else{
                          if(amountTotal! > amount){
                            calculateBalanceAmountForReceiveAmountCashLumsumMode();
                            // calculateBalanceAmountForReceiveAmountCashLumsum();
                            _calculateCylinderAmountCashtLumsumEdit();
                            if(isLumsumAmountAdd){
                              // calculateBalanceAmountForReceiveAmountCash();
                              _calculateCylinderAmountCashtLumsumEdit();
                            }else{
                              calculateBalanceAmountForReceiveAmountCashLumsumMode();
                              // calculateBalanceAmountForReceiveAmountCashLumsum();
                            }
                          }else{
                            _amountControllerPostpaid.clear();
                            if(isLumsumAmountAdd){
                              // calculateBalanceAmountForReceiveAmountCash();
                            }else{
                              calculateBalanceAmountForReceiveAmountCashLumsumMode();
                              // calculateBalanceAmountForReceiveAmountCashLumsum();
                            }
                          }
                        }


                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Visibility(
              visible: isLumsumAmountAdd == false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "(You Can Use Either Qty Or Lumpsum Mode)",
                    style: Styling.redStar,
                  ),
                ],),
            ),
            Row(
              children: [
                Expanded(
                  child: textWidgetBlueColorWithStar("Transaction Code :", "*"),
                ),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _transactionCodeControllerPostpaid,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30),
                    ],
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    onChanged: (value) {
                      // Manually trim spaces at the beginning and end
                      _transactionCodeControllerPostpaid.text = value.trim();
                      _transactionCodeControllerPostpaid.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: _transactionCodeControllerPostpaid
                                  .text.length));
                    },
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(child: textWidgetBlueColorWithoutStar("Time:")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _timeControllerPostpaid,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      // suffixIcon: Icon(
                      //   Icons.access_time,
                      //   color: Color(0xff1280b3),
                      //   size: 18,
                      // ),

                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5),

                    ],
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    onChanged: (value) {},
                    onTap: () {
                      // _selectTime(context);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: textWidgetBlueColorWithoutStar("Remark:")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _remarkControllerPostpaid,
                    maxLength: 250,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // Input field and Add button
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                          if (_transactionCodeControllerPostpaid
                              .text.isNotEmpty) {
                              int? qtyPostpaid =
                                  int.parse(_qtyControllerPostpaid.text);
                              // if (qtyPostpaid > _transactionList.length) {
                                _addTransaction();
                              // } else {
                              //   showFlushBar(context,
                              //       'Transaction Detail Should Not Be Greater Than Cylinder Qty');
                              //   _transactionCodeControllerPostpaid.clear();
                              //   _timeControllerPostpaid.clear();
                              //   _remarkControllerPostpaid.clear();
                              // }
                          }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            (_transactionCodeControllerPostpaid.text.isNotEmpty)
                                ? MaterialStateProperty.all<Color>(
                                    Color(0xff1280b3),
                                  )
                                : MaterialStateProperty.all<Color>(
                                    Color(0xff666666),
                                  ),
                      ),
                      // style: ElevatedButton.styleFrom(
                      //   backgroundColor:_getButtonColor(),
                      //   // Change color based on enabled state
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(50),
                      //   ),
                      // ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Center(
                              child: Text("Trans. Code",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                      verticalDividerVerySmall(),
                      Expanded(
                          flex: 2,
                          child: Center(
                              child: Text("Time",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                      verticalDividerVerySmall(),
                      Expanded(
                          flex: 3,
                          child: Center(
                              child: Text("Remark",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                      verticalDividerVerySmall(),
                      Expanded(
                          flex:1,
                          child: Center(
                              child: Text("",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  ),
                  Container(
                    color: Colors.blue,
                    height: 1,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    // Ensures the list takes only the required height
                    physics: const NeverScrollableScrollPhysics(),
                    // Disables inner scrolling
                    itemCount: _transactionList.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactionList[index];
                      return Row(
                        children: [
                          // Column 1: Item Name
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                transaction.transactionCode.toString(),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ),
                          ),
                          verticalDividerSmall(),
                          // Column 2: Filled
                          Expanded(
                            flex: 2,
                            child: Text(
                              transaction.transTime.toString(),
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          verticalDividerSmall(),
                          // Column 3: SV
                          Expanded(
                            flex: 3,
                            child: Text(
                              transaction.remark.toString(),
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          verticalDividerSmall(),
                          // Column 4: TV
                          Expanded(
                            flex: 1,
                            child:  IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteTransaction(index);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCreditTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right:5, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cylinder Qty with Icon and TextField
            Row(
              children: [
                Expanded(
                    child: textWidgetBlueColorWithStar("Cylinder Qty:", "*")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _qtyControllerCredit,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    onChanged: (value) {
                      setState(() {
                        creditQty = int.tryParse(value) ?? 0;
                        if(isLumsumAmountAdd){
                          _calculateCylinderAmountCredit();
                          _validateQuantities("Credit");
                          // calculateBalanceAmountForReceiveAmountCash();
                          _totalReceivedAmountCash.text = '';
                          _totalBalanceAmountCash.text = '';
                        }else{
                          _validateQuantitiesLumsumCase("Credit");
                          _calculateCylinderAmountCredit();
                          calculateBalanceAmountForReceiveAmountCashLumsumMode();
                          _totalReceivedAmountCash.text = '';
                          _totalBalanceAmountCash.text = '';
                          // calculateBalanceAmountForReceiveAmountCashLumsum();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: textWidgetBlueColorWithStar("Amount:", "*")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _amountControllerCredit,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    enabled: false,
                    onChanged: (value) {
                      // setState(() {
                      //   creditQty = int.tryParse(value) ?? 0;
                      // });
                      // _calculateCylinderAmountCredit();
                      // _validateQuantities("Credit");
                    },
                  ),
                ),
              ],
            ),
            // Payment Mode Section
            Row(
              children: [
                Expanded(flex: 1,
                    child: textWidgetBlueColorWithStar("Customer Name:", "*")),
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<GetConsumerDetailsCredit>(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    ),
                    style: Styling.itemBlackTest,
                    value: selectedCustomerModel,
                    items: getConsumerCreditDetailListModel
                        .map((GetConsumerDetailsCredit vendor) {
                      return DropdownMenuItem<GetConsumerDetailsCredit>(
                        value: vendor,
                        child: Text(vendor.customerName ?? ''),
                      );
                    }).toList(),
                    onChanged: (GetConsumerDetailsCredit? selectedVendor) {
                      if (selectedVendor != null) {
                        selectedVendorName = selectedVendor.customerName;
                        selectedVendorId = selectedVendor.customerId?.toInt();
                        // Handle dropdown selection here
                        print("Selected Vendor Name: $selectedVendorName");
                        print("Selected Vendor ID: $selectedVendorId");
                        selectedCustomerModel = selectedVendor;
                        _vendorCylinderQtyControllerCredit.clear();
                        _vendorCylinderAmountControllerCredit.clear();

                        final discountMatch = getConsumerCreditDiscountDetailListModel.firstWhere(
                              (discount) =>
                          discount.customerId == selectedVendorId &&
                              discount.itemId == itemIDs,
                          orElse: () => GetConsumerDiscountDetailCredit(), // return empty model if not found
                        );

                        if (discountMatch.customerId != null && discountMatch.itemId != null) {
                          final discount = discountMatch.discount ?? 0;
                          final newRate = itemRates! - discount;
                          discountCreditGet = discount.toDouble();
                          print("🎯 Discount found: $discount");
                          print("✅ New Price: $newRate");
                          print("✅ New Price: $discountCreditGet");

                          // Save or display this value
                          setState(() {
                            discountedRateCredit = newRate;

                          });
                        } else {
                          discountedRateCredit = itemRates;
                          if (discountMatch.discount != null) {
                            discountCreditGet = discountMatch.discount!.toDouble();
                          } else {
                            discountCreditGet = 0.0; // Provide a fallback value
                          }
                          // discountCreditGet = discountMatch.discount!.toDouble();
                          print("❌ No matching discount found for this customer and item.");
                          // You can handle it here (e.g., show default rate or show a message)
                        }

                      }
                    },
                  ),
                ),
              ],
            ),
            // Qty and Amount Section
            Row(
              children: [
                Expanded(child: textWidgetBlueColorWithStar("Qty:", "*")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _vendorCylinderQtyControllerCredit,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    style: Styling.itemBlackTest,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      if(_vendorCylinderQtyControllerCredit.text.isNotEmpty){
                        int qtyVendorCylinder =
                        int.parse(_vendorCylinderQtyControllerCredit.text);
                        if (_qtyControllerCredit.text.isNotEmpty) {
                          int qtyCredit = int.parse(_qtyControllerCredit.text);
                          int retTotalQty = getTotalQuantity();
                          if (qtyVendorCylinder > qtyCredit) {
                            showFlushBar(context,
                                Constants.creditQty);
                            _vendorCylinderQtyControllerCredit.clear();
                          }else{
                            if(retTotalQty >= qtyCredit){
                              showFlushBar(context,
                                  Constants.creditQty);
                              _vendorCylinderQtyControllerCredit.clear();
                            }
                          }
                        }else{
                          showFlushBar(context,
                              Constants.creditQty);
                          _vendorCylinderQtyControllerCredit.clear();

                        }
                      }else{
                        showFlushBar(context,
                            Constants.creditQty);
                        _vendorCylinderQtyControllerCredit.clear();

                      }

                      setState(() {
                        _calculateCylinderAmountCreditByVendor();
                        // Update selected value
                      });
                    },
                  ),
                ),
              ],
            ),
            // Amount Field
            Row(
              children: [
                Expanded(child: textWidgetBlueColorWithStar("Amount:", "*")),
                // Flexible(
                //   flex: 1,
                //   child: Text(
                //     '₹${amountCreditCylinderByVendor.toStringAsFixed(0)}',
                //   ),
                // ),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _vendorCylinderAmountControllerCredit,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    style: Styling.itemBlackTest,
                    textAlign: TextAlign.center,
                    enabled: false,
                    onChanged: (value) {
                      // int qtyVendorCylinder =
                      //     int.parse(_vendorCylinderQtyControllerCredit.text);
                      // if (_qtyControllerCredit.text.isNotEmpty) {
                      //   int qtyCredit = int.parse(_qtyControllerCredit.text);
                      //   if (qtyVendorCylinder > qtyCredit) {
                      //     showFlushBar(context,
                      //         'Quantity Should Not Be Greater Than Cylinder Qty');
                      //     _vendorCylinderQtyControllerCredit.clear();
                      //   }
                      // }
                      // setState(() {
                      //   // _calculateCylinderAmountCreditByVendor();
                      //   // Update selected value
                      // });
                    },
                  ),
                ),
              ],
            ),
            // Row(
            //   children: [
            //     Expanded(
            //         child: textWidgetBlueColorWithStar("Payment Mode:", "*")),
            //     Flexible(
            //       flex: 1,
            //       child: DropdownButtonFormField<String>(
            //         decoration: InputDecoration(
            //           contentPadding:
            //           EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            //         ),
            //         style: Styling.itemBlackTest,
            //         items: paymentModeCredit
            //             .map((String value) => DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(value),
            //         ))
            //             .toList(),
            //         onChanged: (value) {
            //           setState(() {
            //             selectedPaymentMode = value; // Update selected value
            //           });
            //         },
            //       ),
            //     ),
            //   ],
            // ),

            Row(
              children: [
                Expanded(
                    child: textWidgetBlueColorWithStar("Payment Mode:", "*")),
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<PaymentModeModel>(
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    ),
                    style: Styling.itemBlackTest,
                    value: paymode,
                    items: paymentModeCredit
                        .map((PaymentModeModel pay) {
                      return DropdownMenuItem<PaymentModeModel>(
                        value: pay,
                        child: Text(pay.paymentmode ?? ''),
                      );
                    }).toList(),
                    onChanged: (PaymentModeModel? paym) {
                      if (paym != null) {
                        selectedPaymentMode = paym.paymentmode;
                        paymode = paym;
                      }
                    },
                  ),
                ),
              ],
            ),

            // Remark Section
            Row(
              children: [
                Expanded(child: textWidgetBlueColorWithoutStar("Remark:")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _remarkControllerCredit,
                    maxLength: 250,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Add Button Section
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_qtyControllerCredit.text.isNotEmpty) {
                      if (selectedPaymentMode != null) {
                        if (selectedVendorId != null) {
                          if (_vendorCylinderQtyControllerCredit
                              .text.isNotEmpty) {
                            int qtyCredit =
                                int.parse(_qtyControllerCredit.text);
                            if (qtyCredit > _reticulatedList.length) {
                              _addReticulated();
                            } else {
                              showFlushBar(context,
                                 Constants.reticulatedCylinderQuantity);
                              setState(() {
                                _vendorCylinderQtyControllerCredit.clear();
                              });
                              print("After Reset: $selectedPaymentMode, $selectedVendorName");

                            }
                          }else{
                            showFlushBar(context,
                                Constants.validCountEnter);
                          }
                        }else{
                          showFlushBar(context,
                              Constants.selectConsumerMode);
                        }
                      }else{
                        showFlushBar(context,
                            Constants.selectPaymentMode);
                      }
                    }else{
                      showFlushBar(context,
                          Constants.validCountEnter);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        _qtyControllerCredit.text.isNotEmpty
                            ? Color(0xff1280b3)
                            : Color(0xff666666)),
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Center(
                              child: Text("Cons. Name",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)))),
                      verticalDividerVerySmall(),
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: Text("Qty",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)))),
                      verticalDividerVerySmall(),
                      Expanded(
                          flex: 2,
                          child: Center(
                              child: Text("Amt.",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)))),
                      verticalDividerVerySmall(),
                      Expanded(
                          flex:2,
                          child: Center(
                              child: Text("Disc Amt.",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,))),
                      verticalDividerVerySmall(),
                      Expanded(
                          flex:2,
                          child: Center(
                              child: Text("Mode",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)))),
                      verticalDividerVerySmall(),
                      Expanded(
                          flex:1,
                          child: Center(
                              child: Text("",
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  ),
              Container(
                color: Colors.blue,
                height: 1,
              ),
                  ListView.builder(
                    shrinkWrap: true,
                    // Ensures the list takes only the required height
                    physics: const NeverScrollableScrollPhysics(),
                    // Disables inner scrolling
                    itemCount: _reticulatedList.length,
                    itemBuilder: (context, index) {
                      final transaction = _reticulatedList[index];
                      return Row(
                        children: [
                          // Column 1: Item Name
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                transaction.customerName.toString(),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ),
                          ),
                          verticalDividerSmall(),
                          // Column 2: Filled
                          Expanded(
                            flex: 1,
                            child: Text(
                              transaction.quantity.toString(),
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          verticalDividerSmall(),
                          // Column 3: SV
                          Expanded(
                            flex: 2,
                            child: Text(
                              transaction.amount!.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          verticalDividerSmall(),
                          Expanded(
                            flex: 2,
                            child: Text(
                              transaction.discountAmount != null
                                  ? transaction.discountAmount!.toStringAsFixed(2)
                                  : '0.00', // or some default value you want to show when null
                              style: TextStyle(fontSize: 14, color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),

                          ),
                          verticalDividerSmall(),
                          Expanded(
                            flex:2,
                            child: Text(
                              transaction.paymentMode.toString(),
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          verticalDividerSmall(),
                          // Column 4: TV
                          Expanded(
                            flex: 1,
                            child:  IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteReticulated(index);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: textWidgetBlueColorWithoutStar("Cylinder Qty:")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _qtyControllerCash,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    enabled: isLumsumAmountAdd,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    onChanged: (value) {
                      setState(() {
                        cashQty = int.tryParse(value) ?? 0;
                        cashQtys = cashQty;
                        _validateQuantitiesLumsumCase("Cash");
                        if(cashQty>0){
                          _calculateCylinderAmountCasht();
                        }else{
                          _totalExpectedAmountCash.text='';
                          _totalBalanceAmountCash.text ='';
                          _totalReceivedAmountCash.text ='';
                          _amountControllerCash.text='';
                        }
                      });

                      // calculateBalanceAmountForReceiveAmountCash();
                      // _validateQuantities("Cash");
                    },
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(child: textWidgetBlueColorWithoutStar("Amount:")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _amountControllerCash,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    inputFormatters: [
                      // FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                      onChanged: (value) {
                        setState(() {
                          isLumsumAmountAdd = false;
                          _qtyControllerCash.text = "0";
                          cashQtys = 0;
                          postpaidQty = 0;
                          _qtyControllerPostpaid.text = "0";

                          double? amt = double.tryParse(value);
                          if (amt == null) {
                            _amountControllerCash.clear(); // Clear or handle invalid input
                            return;
                          }

                          if (amt > amountTotal!) {
                            _amountControllerCash.clear();
                          } else {
                            // calculateBalanceAmountForReceiveAmountCashLumsumMode();
                            // calculateBalanceAmountForReceiveAmountCashLumsum();
                            calculateBalanceAmountForReceiveAmountCashLumsum();
                            _calculateCylinderAmountCashtLumsum();
                            if (isLumsumAmountAdd) {
                              calculateBalanceAmountForReceiveAmountCash();
                            }
                          }
                        });
                      },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Visibility(
              visible: isLumsumAmountAdd == false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "(You Can Use Either Qty Or Lumpsum Mode)",
                    style: Styling.redStar,
                  ),
                ],),
            ),

            Row(
              children: [
                Expanded(
                    child: textWidgetBlueColorWithStar(
                        "Total Expected Amt.:", "*")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _totalExpectedAmountCash,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    onChanged: (value) {
                      // calculateBalanceAmountForReceiveAmountCash();
                    },
                    enabled: false,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                    child: textWidgetBlueColorWithStar(
                        "Total Receive Amt.:", "*")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _totalReceivedAmountCash,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    inputFormatters: [
                      // FilteringTextInputFormatter.digitsOnly,
                      // LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.allow(RegExp(r'^\d{1,10}(\.\d{0,7})?$')),
                    ],
                    enabled: _totalExpectedAmountCash.text.isNotEmpty?true:false,
                    onChanged: (value) {
                      double receivedAmt = double.parse(_totalReceivedAmountCash.text);
                      double expectedAmt = double.parse(_totalExpectedAmountCash.text);
                      if(receivedAmt > expectedAmt){
                        _totalReceivedAmountCash.clear();
                        _totalBalanceAmountCash.clear();
                      }else{
                        calculateBalanceAmountForReceiveAmountCash();
                      }

                    },
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(child: textWidgetBlueColorWithStar("Balance:", "*")),
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _totalBalanceAmountCash,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    onChanged: (value) {},
                    enabled: false,
                  ),
                ),
              ],
            ),
            CheckboxListTile(
                title: Text(
                  "Balance Amount Will Be Added On Delivery Men On Account.",
                  style: Styling.redStar,
                ),
                value: isCheckedBalanceCash,
                onChanged: (bool? value) {
                  setState(() {
                    isCheckedBalanceCash = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.blue; // When checked, background is blue
                    }
                    return Colors.white; // When unchecked, background is white
                  },
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: Row(
                children: [
                  // First Half (Cash Denomination)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0; // Show Container 1
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedIndex == 0
                              ? Colors.blue
                              : Colors.blue[200],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2),
                            bottomLeft: Radius.circular(2),
                          ),
                        ),
                        child: Text(
                          "Cash Denomination",
                          style: Styling.buttonTextBlack.copyWith(
                            color: _selectedIndex == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Second Half (Cash Return)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1; // Show Container 2
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedIndex == 1
                              ? Colors.blue
                              : Colors.blue[200],
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(2),
                            bottomRight: Radius.circular(2),
                          ),
                        ),
                        child: Text(
                          "Cash Return",
                          style: Styling.buttonTextBlack.copyWith(
                            color: _selectedIndex == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: _selectedIndex == 0,
              child: Container(
                decoration: BoxDecoration(
                  // Background color of the box
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1), // Optional: Add rounded corners
                ),
                child: Column(
                  children: [
                    // First Row with Vertical Divider
                    SizedBox(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "Note Type",
                              style: Styling.blueClrText,
                            )), // Centering the text
                          ),
                          Expanded(
                            child: Center(
                                child: Text(
                              "Qty",
                              style: Styling.blueClrText,
                            )), // Centering the text
                          ),
                          Expanded(
                            child: Center(
                                child: Text(
                              "Amount",
                              style: Styling.blueClrText,
                            )), // Centering the text
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
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "500",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          Expanded(
                            child: Center(
                                child: TextField(
                              controller: quantity500Controller,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                              textAlign: TextAlign.center,
                              // Centers the text horizontally
                              decoration: InputDecoration(
                                // Optional: Add a border
                                contentPadding: EdgeInsets
                                    .zero, // Removes padding inside the TextField
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              // Makes the input a number field
                              onChanged: (value) {
                                calculate500Amount(
                                    500); // Update the result when quantity changes
                              },
                            )), // Centering the text
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(result500.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "200",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          Expanded(
                            child: Center(
                                child: TextField(
                              controller: quantity200Controller,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              // Makes the input a number field
                              onChanged: (value) {
                                calculate200Amount(
                                    200); // Update the result when quantity changes
                              },
                            )), // Centering the text
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(result200.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "100",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          Expanded(
                            child: Center(
                                child: TextField(
                              controller: quantity100Controller,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                              textAlign: TextAlign.center,
                              // Centers the text horizontally
                              decoration: InputDecoration(
                                // Optional: Add a border
                                contentPadding: EdgeInsets
                                    .zero, // Removes padding inside the TextField
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              // Makes the input a number field
                              onChanged: (value) {
                                calculate100Amount(
                                    100); // Update the result when quantity changes
                              },
                            )), // Centering the text
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(
                              result100.toStringAsFixed(0),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "50",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          Expanded(
                            child: Center(
                                child: TextField(
                              controller: quantity50Controller,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                              textAlign: TextAlign.center,
                              // Centers the text horizontally
                              decoration: InputDecoration(
                                // Optional: Add a border
                                contentPadding: EdgeInsets
                                    .zero, // Removes padding inside the TextField
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              // Makes the input a number field
                              onChanged: (value) {
                                calculate50Amount(
                                    50); // Update the result when quantity changes
                              },
                            )), // Centering the text
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(result50.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "20",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          Expanded(
                            child: Center(
                                child: TextField(
                              controller: quantity20Controller,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                              textAlign: TextAlign.center,
                              // Centers the text horizontally
                              decoration: InputDecoration(
                                // Optional: Add a border
                                contentPadding: EdgeInsets
                                    .zero, // Removes padding inside the TextField
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              // Makes the input a number field
                              onChanged: (value) {
                                calculate20Amount(
                                    20); // Update the result when quantity changes
                              },
                            )), // Centering the text
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(result20.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "10",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          Expanded(
                            child: Center(
                                child: TextField(
                              controller: quantity10Controller,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                              textAlign: TextAlign.center,
                              // Centers the text horizontally
                              decoration: InputDecoration(
                                // Optional: Add a border
                                contentPadding: EdgeInsets
                                    .zero, // Removes padding inside the TextField
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              // Makes the input a number field
                              onChanged: (value) {
                                calculate10Amount(
                                    10); // Update the result when quantity changes
                              },
                            )), // Centering the text
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(result10.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "5",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          Expanded(
                            child: Center(
                                child: TextField(
                              controller: quantity5Controller,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                              textAlign: TextAlign.center,
                              // Centers the text horizontally
                              decoration: InputDecoration(
                                // Optional: Add a border
                                contentPadding: EdgeInsets
                                    .zero, // Removes padding inside the TextField
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              // Makes the input a number field
                              onChanged: (value) {
                                calculate5Amount(
                                    5); // Update the result when quantity changes
                              },
                            )), // Centering the text
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(result5.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),
///new
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 16),
                                )), // Centering the text
                          ),
                          Text("X"),
                          Expanded(
                            child: Center(
                                child: TextField(
                                  controller: quantity2Controller,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 16),
                                  textAlign: TextAlign.center,
                                  // Centers the text horizontally
                                  decoration: InputDecoration(
                                    // Optional: Add a border
                                    contentPadding: EdgeInsets
                                        .zero, // Removes padding inside the TextField
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  // Makes the input a number field
                                  onChanged: (value) {
                                    calculate2Amount(
                                        2); // Update the result when quantity changes
                                  },
                                )), // Centering the text
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(result2.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),

                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 16),
                                )), // Centering the text
                          ),
                          Text("X"),
                          Expanded(
                            child: Center(
                                child: TextField(
                                  controller: quantity1Controller,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 16),
                                  textAlign: TextAlign.center,
                                  // Centers the text horizontally
                                  decoration: InputDecoration(
                                    // Optional: Add a border
                                    contentPadding: EdgeInsets
                                        .zero, // Removes padding inside the TextField
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  // Makes the input a number field
                                  onChanged: (value) {
                                    calculate1Amount(
                                        1); // Update the result when quantity changes
                                  },
                                )), // Centering the text
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(result1.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),

                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                                  "0.50",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 16),
                                )), // Centering the text
                          ),
                          Text("X"),
                          Expanded(
                            child: Center(
                                child: TextField(
                                  controller: quantity050Controller,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 16),
                                  textAlign: TextAlign.center,
                                  // Centers the text horizontally
                                  decoration: InputDecoration(
                                    // Optional: Add a border
                                    contentPadding: EdgeInsets
                                        .zero, // Removes padding inside the TextField
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  // Makes the input a number field
                                  onChanged: (value) {
                                    calculate050Amount(
                                        0.50); // Update the result when quantity changes
                                  },
                                )), // Centering the text
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(result050.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),

                    ///
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(height: 10),

                    // Total Amount Field
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Collected:',
                              style: Styling.itemBlackTest,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: Container(
                              alignment: Alignment.center,
                              // Ensure the text inside is centered both horizontally and vertically
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1), // Optional: Add rounded corners
                              ),
                              child: Text(
                                total.toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                // Centers the text horizontally
                                style: TextStyle(
                                    fontSize:
                                        16), // Optional: Adjust text style if needed
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Final Total:',
                              style: Styling.itemBlackTest,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: Container(
                              alignment: Alignment.center,
                              // Ensure the text inside is centered both horizontally and vertically
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1), // Optional: Add rounded corners
                              ),
                              child: Text(
                                finalsAmount.toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                // Centers the text horizontally
                                style: TextStyle(
                                    fontSize:
                                        16), // Optional: Adjust text style if needed
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _selectedIndex == 1,
              child: Container(
                decoration: BoxDecoration(
                  // Background color of the box
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1), // Optional: Add rounded corners
                ),
                child: Column(
                  children: [
                    // First Row with Vertical Divider
                    SizedBox(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "Note Type",
                              style: Styling.blueClrText,
                            )), // Centering the text
                          ),
                          Expanded(
                            child: Center(
                                child: Text(
                              "Qty",
                              style: Styling.blueClrText,
                            )), // Centering the text
                          ),
                          Expanded(
                            child: Center(
                                child: Text(
                              "Amount",
                              style: Styling.blueClrText,
                            )), // Centering the text
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
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "500",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          // Expanded(
                          //   child: Center(
                          //       child: TextField(controller:returnQuantity500Controller,
                          //         style: TextStyle(
                          //             fontWeight:
                          //             FontWeight
                          //                 .normal,
                          //             fontSize:
                          //             16),
                          //         textAlign: TextAlign.center, // Centers the text horizontally
                          //         decoration: InputDecoration(
                          //           // Optional: Add a border
                          //           contentPadding: EdgeInsets.zero, // Removes padding inside the TextField
                          //         ),
                          //         keyboardType: TextInputType.number,
                          //         inputFormatters: [
                          //           FilteringTextInputFormatter.digitsOnly,
                          //         ],// Makes the input a number field
                          //         onChanged: (value) {
                          //           calculate500AmountReturnAmount(500); // Update the result when quantity changes
                          //         },
                          //
                          //       )), // Centering the text
                          // ),
                          Expanded(
                            child: Center(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  // Check the condition for enabling/disabling the returnQuantity500Controller
                                  bool isReturnQuantityDisabled =
                                      quantity500Controller.text.isNotEmpty &&
                                          int.tryParse(
                                                  quantity500Controller.text) !=
                                              null &&
                                          int.parse(
                                                  quantity500Controller.text) >
                                              0;

                                  return TextField(
                                    controller: returnQuantity500Controller,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                    // Centers the text horizontally
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets
                                          .zero, // Removes padding inside the TextField
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    // Makes the input a number field
                                    enabled: !isReturnQuantityDisabled,
                                    // Disable based on condition
                                    onChanged: (value) {
                                      calculate500AmountReturnAmount(
                                          500); // Update the result when quantity changes
                                    },
                                  );
                                },
                              ),
                            ),
                          ),

                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(returnResult500.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "200",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          // Expanded(
                          //   child: Center(
                          //       child:
                          //       TextField(
                          //     controller: returnQuantity200Controller,
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.normal, fontSize: 16),
                          //     textAlign: TextAlign.center,
                          //     keyboardType: TextInputType.number,
                          //     inputFormatters: [
                          //       FilteringTextInputFormatter.digitsOnly,
                          //     ],
                          //     // Makes the input a number field
                          //     onChanged: (value) {
                          //       calculate200AmountReturnAmount(
                          //           200); // Update the result when quantity changes
                          //     },
                          //   )
                          //   ), // Centering the text
                          // ),
                          Expanded(
                            child: Center(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  // Check the condition for enabling/disabling the returnQuantity500Controller
                                  bool isReturnQuantityDisabled =
                                      quantity200Controller.text.isNotEmpty &&
                                          int.tryParse(
                                                  quantity200Controller.text) !=
                                              null &&
                                          int.parse(
                                                  quantity200Controller.text) >
                                              0;
                                  return TextField(
                                    controller: returnQuantity200Controller,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    enabled: !isReturnQuantityDisabled,
                                    // Makes the input a number field
                                    onChanged: (value) {
                                      calculate200AmountReturnAmount(
                                          200); // Update the result when quantity changes
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(returnResult200.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "100",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          // Expanded(
                          //   child: Center(
                          //       child:
                          //       TextField(
                          //     controller: returnQuantity100Controller,
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.normal, fontSize: 16),
                          //     textAlign: TextAlign.center,
                          //     // Centers the text horizontally
                          //     decoration: InputDecoration(
                          //       // Optional: Add a border
                          //       contentPadding: EdgeInsets
                          //           .zero, // Removes padding inside the TextField
                          //     ),
                          //     keyboardType: TextInputType.number,
                          //     inputFormatters: [
                          //       FilteringTextInputFormatter.digitsOnly,
                          //     ],
                          //     // Makes the input a number field
                          //     onChanged: (value) {
                          //       calculate100AmountReturnAmount(
                          //           100); // Update the result when quantity changes
                          //     },
                          //   )
                          //   ), // Centering the text
                          // ),
                          Expanded(
                            child: Center(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  // Check the condition for enabling/disabling the returnQuantity500Controller
                                  bool isReturnQuantityDisabled =
                                      quantity100Controller.text.isNotEmpty &&
                                          int.tryParse(
                                                  quantity100Controller.text) !=
                                              null &&
                                          int.parse(
                                                  quantity100Controller.text) >
                                              0;
                                  return TextField(
                                    controller: returnQuantity100Controller,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                    // Centers the text horizontally
                                    decoration: InputDecoration(
                                      // Optional: Add a border
                                      contentPadding: EdgeInsets
                                          .zero, // Removes padding inside the TextField
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    enabled: !isReturnQuantityDisabled,
                                    // Makes the input a number field
                                    onChanged: (value) {
                                      calculate100AmountReturnAmount(
                                          100); // Update the result when quantity changes
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(
                              returnResult100.toStringAsFixed(0),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "50",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          // Expanded(
                          //   child: Center(
                          //       child:
                          //       TextField(
                          //     controller: returnQuantity50Controller,
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.normal, fontSize: 16),
                          //     textAlign: TextAlign.center,
                          //     // Centers the text horizontally
                          //     decoration: InputDecoration(
                          //       // Optional: Add a border
                          //       contentPadding: EdgeInsets
                          //           .zero, // Removes padding inside the TextField
                          //     ),
                          //     keyboardType: TextInputType.number,
                          //     inputFormatters: [
                          //       FilteringTextInputFormatter.digitsOnly,
                          //     ],
                          //     // Makes the input a number field
                          //     onChanged: (value) {
                          //       calculate50AmountReturnAmount(
                          //           50); // Update the result when quantity changes
                          //     },
                          //   )
                          //   ), // Centering the text
                          // ),
                          Expanded(
                            child: Center(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  // Check the condition for enabling/disabling the returnQuantity500Controller
                                  bool isReturnQuantityDisabled =
                                      quantity50Controller.text.isNotEmpty &&
                                          int.tryParse(
                                                  quantity50Controller.text) !=
                                              null &&
                                          int.parse(quantity50Controller.text) >
                                              0;
                                  return TextField(
                                    controller: returnQuantity50Controller,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                    // Centers the text horizontally
                                    decoration: InputDecoration(
                                      // Optional: Add a border
                                      contentPadding: EdgeInsets
                                          .zero, // Removes padding inside the TextField
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    enabled: !isReturnQuantityDisabled,
                                    // Makes the input a number field
                                    onChanged: (value) {
                                      calculate50AmountReturnAmount(
                                          50); // Update the result when quantity changes
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(returnResult50.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "20",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          // Expanded(
                          //   child: Center(
                          //       child:
                          //       TextField(
                          //     controller: returnQuantity20Controller,
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.normal, fontSize: 16),
                          //     textAlign: TextAlign.center,
                          //     // Centers the text horizontally
                          //     decoration: InputDecoration(
                          //       // Optional: Add a border
                          //       contentPadding: EdgeInsets
                          //           .zero, // Removes padding inside the TextField
                          //     ),
                          //     keyboardType: TextInputType.number,
                          //     inputFormatters: [
                          //       FilteringTextInputFormatter.digitsOnly,
                          //     ],
                          //     // Makes the input a number field
                          //     onChanged: (value) {
                          //       calculate20AmountReturnAmount(
                          //           20); // Update the result when quantity changes
                          //     },
                          //   )
                          //   ), // Centering the text
                          // ),
                          Expanded(
                            child: Center(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  // Check the condition for enabling/disabling the returnQuantity500Controller
                                  bool isReturnQuantityDisabled =
                                      quantity20Controller.text.isNotEmpty &&
                                          int.tryParse(
                                                  quantity20Controller.text) !=
                                              null &&
                                          int.parse(quantity20Controller.text) >
                                              0;
                                  return TextField(
                                    controller: returnQuantity20Controller,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                    // Centers the text horizontally
                                    decoration: InputDecoration(
                                      // Optional: Add a border
                                      contentPadding: EdgeInsets
                                          .zero, // Removes padding inside the TextField
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    enabled: !isReturnQuantityDisabled,
                                    // Makes the input a number field
                                    onChanged: (value) {
                                      calculate20AmountReturnAmount(
                                          20); // Update the result when quantity changes
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(returnResult20.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "10",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          // Expanded(
                          //   child: Center(
                          //       child:
                          //       TextField(
                          //     controller: returnQuantity10Controller,
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.normal, fontSize: 16),
                          //     textAlign: TextAlign.center,
                          //     // Centers the text horizontally
                          //     decoration: InputDecoration(
                          //       // Optional: Add a border
                          //       contentPadding: EdgeInsets
                          //           .zero, // Removes padding inside the TextField
                          //     ),
                          //     keyboardType: TextInputType.number,
                          //     inputFormatters: [
                          //       FilteringTextInputFormatter.digitsOnly,
                          //     ],
                          //     // Makes the input a number field
                          //     onChanged: (value) {
                          //       calculate10AmountReturnAmount(
                          //           10); // Update the result when quantity changes
                          //     },
                          //   )
                          //   ), // Centering the text
                          // ),
                          Expanded(
                            child: Center(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  // Check the condition for enabling/disabling the returnQuantity500Controller
                                  bool isReturnQuantityDisabled =
                                      quantity10Controller.text.isNotEmpty &&
                                          int.tryParse(
                                                  quantity10Controller.text) !=
                                              null &&
                                          int.parse(quantity10Controller.text) >
                                              0;
                                  return TextField(
                                    controller: returnQuantity10Controller,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                    // Centers the text horizontally
                                    decoration: InputDecoration(
                                      // Optional: Add a border
                                      contentPadding: EdgeInsets
                                          .zero, // Removes padding inside the TextField
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    enabled: !isReturnQuantityDisabled,
                                    // Makes the input a number field
                                    onChanged: (value) {
                                      calculate10AmountReturnAmount(
                                          10); // Update the result when quantity changes
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(returnResult10.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                              "5",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )), // Centering the text
                          ),
                          Text("X"),
                          // Expanded(
                          //   child: Center(
                          //       child:
                          //       TextField(
                          //     controller: returnQuantity5Controller,
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.normal, fontSize: 16),
                          //     textAlign: TextAlign.center,
                          //     // Centers the text horizontally
                          //     decoration: InputDecoration(
                          //       // Optional: Add a border
                          //       contentPadding: EdgeInsets
                          //           .zero, // Removes padding inside the TextField
                          //     ),
                          //     keyboardType: TextInputType.number,
                          //     inputFormatters: [
                          //       FilteringTextInputFormatter.digitsOnly,
                          //     ],
                          //     // Makes the input a number field
                          //     onChanged: (value) {
                          //       calculate5AmountReturnAmount(
                          //           5); // Update the result when quantity changes
                          //     },
                          //   )
                          //   ), // Centering the text
                          // ),
                          Expanded(
                            child: Center(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  // Check the condition for enabling/disabling the returnQuantity500Controller
                                  bool isReturnQuantityDisabled =
                                      quantity5Controller.text.isNotEmpty &&
                                          int.tryParse(
                                                  quantity5Controller.text) !=
                                              null &&
                                          int.parse(quantity5Controller.text) >
                                              0;
                                  return TextField(
                                    controller: returnQuantity5Controller,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                    // Centers the text horizontally
                                    decoration: InputDecoration(
                                      // Optional: Add a border
                                      contentPadding: EdgeInsets
                                          .zero, // Removes padding inside the TextField
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    enabled: !isReturnQuantityDisabled,
                                    // Makes the input a number field
                                    onChanged: (value) {
                                      calculate5AmountReturnAmount(
                                          5); // Update the result when quantity changes
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(returnResult5.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),

///new
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 16),
                                )), // Centering the text
                          ),
                          Text("X"),
                          // Expanded(
                          //   child: Center(
                          //       child:
                          //       TextField(
                          //     controller: returnQuantity5Controller,
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.normal, fontSize: 16),
                          //     textAlign: TextAlign.center,
                          //     // Centers the text horizontally
                          //     decoration: InputDecoration(
                          //       // Optional: Add a border
                          //       contentPadding: EdgeInsets
                          //           .zero, // Removes padding inside the TextField
                          //     ),
                          //     keyboardType: TextInputType.number,
                          //     inputFormatters: [
                          //       FilteringTextInputFormatter.digitsOnly,
                          //     ],
                          //     // Makes the input a number field
                          //     onChanged: (value) {
                          //       calculate5AmountReturnAmount(
                          //           5); // Update the result when quantity changes
                          //     },
                          //   )
                          //   ), // Centering the text
                          // ),
                          Expanded(
                            child: Center(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  // Check the condition for enabling/disabling the returnQuantity500Controller
                                  bool isReturnQuantityDisabled =
                                      quantity2Controller.text.isNotEmpty &&
                                          int.tryParse(
                                              quantity2Controller.text) !=
                                              null &&
                                          int.parse(quantity2Controller.text) >
                                              0;
                                  return TextField(
                                    controller: returnQuantity2Controller,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                    // Centers the text horizontally
                                    decoration: InputDecoration(
                                      // Optional: Add a border
                                      contentPadding: EdgeInsets
                                          .zero, // Removes padding inside the TextField
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    enabled: !isReturnQuantityDisabled,
                                    // Makes the input a number field
                                    onChanged: (value) {
                                      calculate2AmountReturnAmount(
                                          2); // Update the result when quantity changes
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(returnResult2.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),

                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 16),
                                )), // Centering the text
                          ),
                          Text("X"),
                          // Expanded(
                          //   child: Center(
                          //       child:
                          //       TextField(
                          //     controller: returnQuantity5Controller,
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.normal, fontSize: 16),
                          //     textAlign: TextAlign.center,
                          //     // Centers the text horizontally
                          //     decoration: InputDecoration(
                          //       // Optional: Add a border
                          //       contentPadding: EdgeInsets
                          //           .zero, // Removes padding inside the TextField
                          //     ),
                          //     keyboardType: TextInputType.number,
                          //     inputFormatters: [
                          //       FilteringTextInputFormatter.digitsOnly,
                          //     ],
                          //     // Makes the input a number field
                          //     onChanged: (value) {
                          //       calculate5AmountReturnAmount(
                          //           5); // Update the result when quantity changes
                          //     },
                          //   )
                          //   ), // Centering the text
                          // ),
                          Expanded(
                            child: Center(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  // Check the condition for enabling/disabling the returnQuantity500Controller
                                  bool isReturnQuantityDisabled =
                                      quantity1Controller.text.isNotEmpty &&
                                          int.tryParse(
                                              quantity1Controller.text) !=
                                              null &&
                                          int.parse(quantity1Controller.text) >
                                              0;
                                  return TextField(
                                    controller: returnQuantity1Controller,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                    // Centers the text horizontally
                                    decoration: InputDecoration(
                                      // Optional: Add a border
                                      contentPadding: EdgeInsets
                                          .zero, // Removes padding inside the TextField
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    enabled: !isReturnQuantityDisabled,
                                    // Makes the input a number field
                                    onChanged: (value) {
                                      calculate1AmountReturnAmount(
                                          1); // Update the result when quantity changes
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(returnResult1.toStringAsFixed(0),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),

                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Center the row content
                        children: [
                          // First Text and Divider inside Expanded to ensure equal size
                          Expanded(
                            child: Center(
                                child: Text(
                                  "0.50",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal, fontSize: 16),
                                )), // Centering the text
                          ),
                          Text("X"),
                          // Expanded(
                          //   child: Center(
                          //       child:
                          //       TextField(
                          //     controller: returnQuantity5Controller,
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.normal, fontSize: 16),
                          //     textAlign: TextAlign.center,
                          //     // Centers the text horizontally
                          //     decoration: InputDecoration(
                          //       // Optional: Add a border
                          //       contentPadding: EdgeInsets
                          //           .zero, // Removes padding inside the TextField
                          //     ),
                          //     keyboardType: TextInputType.number,
                          //     inputFormatters: [
                          //       FilteringTextInputFormatter.digitsOnly,
                          //     ],
                          //     // Makes the input a number field
                          //     onChanged: (value) {
                          //       calculate5AmountReturnAmount(
                          //           5); // Update the result when quantity changes
                          //     },
                          //   )
                          //   ), // Centering the text
                          // ),
                          Expanded(
                            child: Center(
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  // Check the condition for enabling/disabling the returnQuantity500Controller
                                  bool isReturnQuantityDisabled =
                                      quantity050Controller.text.isNotEmpty &&
                                          int.tryParse(
                                              quantity050Controller.text) !=
                                              null &&
                                          int.parse(quantity050Controller.text) >
                                              0;
                                  return TextField(
                                    controller: returnQuantity050Controller,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                    // Centers the text horizontally
                                    decoration: InputDecoration(
                                      // Optional: Add a border
                                      contentPadding: EdgeInsets
                                          .zero, // Removes padding inside the TextField
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    enabled: !isReturnQuantityDisabled,
                                    // Makes the input a number field
                                    onChanged: (value) {
                                      calculate050AmountReturnAmount(
                                          0.50); // Update the result when quantity changes
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Text("="),
                          Expanded(
                            child: Center(
                                child: Text(returnResult050.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16))), // Centering the text
                          ),
                        ],
                      ),
                    ),
                    ///
                    Container(
                      color: Colors.black12,
                      height: 1,
                      width: double.infinity,
                    ),
                    SizedBox(height: 10),

                    // Total Amount Field
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Return:',
                              style: Styling.itemBlackTest,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: Container(
                              alignment: Alignment.center,
                              // Ensure the text inside is centered both horizontally and vertically
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1), // Optional: Add rounded corners
                              ),
                              child: Text(
                                returnTotal.toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                // Centers the text horizontally
                                style: TextStyle(
                                    fontSize:
                                        16), // Optional: Adjust text style if needed
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Final Total:',
                              style: Styling.itemBlackTest,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: Container(
                              alignment: Alignment.center,
                              // Ensure the text inside is centered both horizontally and vertically
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1), // Optional: Add rounded corners
                              ),
                              child: Text(
                                finalsAmount.toString(),
                                textAlign: TextAlign.center,
                                // Centers the text horizontally
                                style: TextStyle(
                                    fontSize:
                                        16), // Optional: Adjust text style if needed
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///Prepaid
  Future<void> _addConsumer(String consumerNo,String consumerName,String? orderDates,String? cashmemoDates,String paymentStatuss,String remarks,int niyojandelStatus,int cDCMSDel,int InCorrectStatus,String? payDate,String? deliveryDate, String? settelDate) async {
    if (_consumerController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      String? StaffId = prefs.getString('StaffId');
      int? staffIds = int.parse(StaffId!);
      int? distributorIds = int.parse(distributorId!);

      // bool alreadyExists = _consumerList.any((element) => element.consumerNo == consumerNo);
      //
      // if (alreadyExists) {
      //   // Show a message
      //   showFlushBar(context, "Consumer $consumerNo already added.");
      //   return;
      // }

      setState(() {
        // Add all fields to the model, not just consumerNo
        _consumerList.add(
          ConsumerModel(
            consId: _consumerList.length + 1,
            // You can assign this or get it from the backend
            distributorId: distributorIds,
            // Replace with the actual distributorId
            staffId: delBoyIDs,
            // Replace with the actual staffId
            itemId: itemIDs,
            // Replace with the actual itemId
            consumerNo: consumerNo,
            action: "Add",
            // Specify the action like "Added" or "Updated"
            addedBy: staffIds,
            consumerName: consumerName,
            orderDate: orderDates,
            cashmemoDate: cashmemoDates,
            paymentStatus:paymentStatuss,
            remark:remarks,
            niyojanDel: niyojandelStatus,
            cDCMSDel: cDCMSDel,
            InCorrectStatus: InCorrectStatus,
            PayDate: payDate,
            DeliveryDate: deliveryDate,
            SettDate: settelDate
          ),
        );
        _consumerController.clear();
      });
    }
  }

  void _deleteConsumer(int index) {
    setState(() {
      final removed = _consumerList.removeAt(index);
      if(actionMode == "EDIT"){
        // Check based on previous logic what this entry was
        bool wasValid = removed.InCorrectStatus == 1;

        if (wasValid) {
          validConsumerCount--;
          validCountController.text = validConsumerCount.toString();

          pendingCDCMSCount--;
          _qtyControllerPrepaid.text = pendingCDCMSCount.toString();
          prepaidQty = pendingCDCMSCount;
        } else {
          invalidConsumerCount--;
          invalidCountController.text = invalidConsumerCount.toString();
        }
      }else{
        // Check based on previous logic what this entry was
        bool wasValid = removed.niyojanDel != 1 &&
            removed.remark != "Already Punched In Niyojan" &&
            removed.remark != "Not Found";

        if (wasValid) {
          validConsumerCount--;
          validCountController.text = validConsumerCount.toString();

          pendingCDCMSCount--;
          _qtyControllerPrepaid.text = pendingCDCMSCount.toString();
          prepaidQty = pendingCDCMSCount;
        } else {
          invalidConsumerCount--;
          invalidCountController.text = invalidConsumerCount.toString();
        }
      }


      // _calculateCylinderAmountPrepaid();
      // _validateQuantities("Prepaid");
      setState(() {
        if(isLumsumAmountAdd){
          _calculateCylinderAmountPrepaid();
          _validateQuantities("Prepaid");
          // calculateBalanceAmountForReceiveAmountCash();
        }else{
          _validateQuantitiesLumsumCase("Prepaid");
          _calculateCylinderAmountPrepaid();
          calculateBalanceAmountForReceiveAmountCashLumsumMode();
          // calculateBalanceAmountForReceiveAmountCashLumsum();
        }
      });
    });
  }

  ///Postpaid
  Future<void> _addTransaction() async {
    if (_transactionCodeControllerPostpaid.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      String? StaffId = prefs.getString('StaffId');
      int? staffIds = int.parse(StaffId!);
      int? distributorIds = int.parse(distributorId!);
      String transCode = _transactionCodeControllerPostpaid.text;
      final alreadyExists = _transactionList.any(
              (element) => element.transactionCode == transCode);
      if(!alreadyExists){
        setState(() {
          _transactionList.add(
            TransactionModel(
              transId: _transactionList.length + 1,
              distributorId: distributorIds,
              // Example, replace with actual value
              staffId: delBoyIDs,
              // Example, replace with actual value
              itemId: itemIDs,
              // Example, replace with actual value
              transactionCode: _transactionCodeControllerPostpaid.text,
              transTime: _timeControllerPostpaid.text,
              remark: _remarkControllerPostpaid.text,
              action: "Added",
              // Example action
              addedBy: staffIds, // Example, replace with actual value
            ),
          );
          _transactionCodeControllerPostpaid.clear();
          _timeControllerPostpaid.clear();
          _remarkControllerPostpaid.clear();
        });
      }else{
        showFlushBar(context, Constants.expenseExistMgr);
      }

    }
  }

  void _deleteTransaction(int index) {
    setState(() {
      _transactionList.removeAt(index);
    });
  }

  ///Credit
  Future<void> _addReticulated() async {
    if (selectedVendorName != null &&
        selectedPaymentMode != null &&
        _vendorCylinderQtyControllerCredit.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      String? StaffId = prefs.getString('StaffId');
      int? staffIds = int.parse(StaffId!);
      int? distributorIds = int.parse(distributorId!);
      final alreadyExists = _reticulatedList.any(
              (element) => element.consumerId == selectedVendorId);
      if(!alreadyExists){
        setState(() {
          _reticulatedList.add(
            ReticulatedModel(
              retId: _reticulatedList.length + 1,
              distributorId: distributorIds,
              // Replace with actual value
              staffId: delBoyIDs,
              // Replace with actual value
              itemId: itemIDs,
              // Replace with actual value
              paymentMode: selectedPaymentMode,
              quantity: int.parse(_vendorCylinderQtyControllerCredit.text),
              amount: amountCreditCylinderByVendor,
              consumerId: selectedVendorId,
              // Replace with actual value
              customerName: selectedVendorName,
              reticulatedRemark: _remarkControllerCredit.text,
              action: "Add",
              // Example action
              addedBy: staffIds,
              discountAmount :discountCreditGet,
              // Example value
            ),
          );
          if(selectedPaymentMode == "Cash"){
            if(isLumsumAmountAdd){
              _calculateCylinderAmountCasht();
            }else{
              _calculateCylinderAmountCashtLumsum();
            }
          }
          selectedVendorName = "";
          _vendorCylinderQtyControllerCredit.clear();
          _vendorCylinderAmountControllerCredit.clear();
          selectedPaymentMode = "";
          selectedPaymentMode = null;
          selectedVendorId = null;
          _remarkControllerCredit.clear();
          selectedCustomerModel = null;
          paymode = null;

        });
      }else{
        showFlushBar(context, Constants.expenseExistMgr);
      }

    }
  }

  void _deleteReticulated(int index) {
    setState(() {
      _reticulatedList.removeAt(index);
      if(isLumsumAmountAdd) {
        _calculateCylinderAmountCasht();
      }else{
        _calculateCylinderAmountCashtLumsum();
      }
    });
  }

  ///Amount Calculate cylinde
  void _calculateCylinderAmountPrepaid() {
    // Get the entered quantity and calculate the total amount
    double qty = double.tryParse(_qtyControllerPrepaid.text) ?? 0;
    setState(() {
      amountPrepaidCylinder = qty * itemRates!;
      _amountControllerPrepaid.text = amountPrepaidCylinder.toStringAsFixed(2);
    });
  }

  void _calculateCylinderAmountPostpaid() {
    // Get the entered quantity and calculate the total amount
    double qty = double.tryParse(_qtyControllerPostpaid.text) ?? 0;
    setState(() {
      amountPostpaidCylinder = qty * itemRates!;
      _amountControllerPostpaid.text = amountPostpaidCylinder.toStringAsFixed(2);
    });
  }

  void _calculateCylinderAmountCredit() {
    // Get the entered quantity and calculate the total amount
    double qty = double.tryParse(_qtyControllerCredit.text) ?? 0;
    setState(() {
      amountCreditCylinder = qty * itemRates!;
      _amountControllerCredit.text = amountCreditCylinder.toStringAsFixed(2);
    });
  }

  void _calculateCylinderAmountCreditByVendor() {
    // Get the entered quantity and calculate the total amount
    double qty = double.tryParse(_vendorCylinderQtyControllerCredit.text) ?? 0;
    setState(() {
      if(discountedRateCredit != null) {
        amountCreditCylinderByVendor = qty * discountedRateCredit!;
        _vendorCylinderAmountControllerCredit.text =
            amountCreditCylinderByVendor.toStringAsFixed(2);
      }else{
        amountCreditCylinderByVendor = qty * itemRates!;
        _vendorCylinderAmountControllerCredit.text =
            amountCreditCylinderByVendor.toStringAsFixed(2);
      }
    }
    );
  }

  void _calculateCylinderAmountCasht() {
    // Get the entered quantity and calculate the total amount
    double qty = double.tryParse(_qtyControllerCash.text) ?? 0;

    // Find all items in the reticulated list with paymentMode 'Cash'
    double totalAmountFromCashPaymentMode = 0.0;

    // Loop through the list and check the payment mode
    for (var reticulatedItem in _reticulatedList) {
      if (reticulatedItem.paymentMode == 'Cash') {
        totalAmountFromCashPaymentMode += reticulatedItem.amount ?? 0.0;  // Add the amount of cash items
      }
    }

    // Now calculate the cylinder amount and the total expected amount
    setState(() {
      // Calculate the cylinder amount for the current transaction
      amountCashCylinder = qty * itemRates!;

      // Update the text fields with calculated values
      _amountControllerCash.text = amountCashCylinder.toStringAsFixed(2);

      // Calculate the total expected amount (including the previously added cash amounts)
      double amountCashCylinders = (qty * itemRates!) - expenseAmtTotal! + totalAmountFromCashPaymentMode;
        debugPrint("expecashqtycase $amountCashCylinders");
        debugPrint("totalAmountFromCashPaymentMode $totalAmountFromCashPaymentMode");
      // Update the total expected amount field
      if(amountCashCylinders > 0){
        _totalExpectedAmountCash.text = amountCashCylinders.toStringAsFixed(2);
      }else{
        _totalExpectedAmountCash.text = '';
      }

    });
  }

  void _calculateCylinderAmountCashtLumsumEdit() {
    double expectedAmount = 0;
    double postpaidAmount = double.tryParse(_amountControllerPostpaid.text) ?? 0;
    double prepaidAmount = double.tryParse(_amountControllerPrepaid.text) ?? 0;
    double creditAmount = double.tryParse(_amountControllerCredit.text) ?? 0;

    double totalAmountFromCashPaymentMode = 0.0;

    // Loop through the list and check the payment mode
    for (var reticulatedItem in _reticulatedList) {
      if (reticulatedItem.paymentMode == 'Cash') {
        totalAmountFromCashPaymentMode += reticulatedItem.amount ?? 0.0;  // Add the amount of cash items
      }
    }
    if (postpaidAmount > 0 || prepaidAmount > 0 || creditAmount > 0) {
      expectedAmount = (amountTotal! - postpaidAmount - prepaidAmount - creditAmount + totalAmountFromCashPaymentMode - expenseAmtTotal!);
    } else {
      expectedAmount = amountTotal!.toDouble();
    }

    // Set the calculated balance amount to the controller
    debugPrint("ggggskakrtryfkVD $expectedAmount");
    _amountControllerCash.text = expectedAmount.toStringAsFixed(2);
  }
/// cash balance
  void calculateBalanceAmountForReceiveAmountCash() {
    double balanceAmount = 0;
    double expectedAmount = double.tryParse(_totalExpectedAmountCash.text) ?? 0;
    double receivedAmount = double.tryParse(_totalReceivedAmountCash.text) ?? 0;
    if (expectedAmount > 0) {
      balanceAmount = expectedAmount - receivedAmount;
    } else {
      balanceAmount = 0;
    }
    // Set the calculated balance amount to the controller
    debugPrint("_totalBalanceAmountCash $balanceAmount");
    if(balanceAmount>0){
      _totalBalanceAmountCash.text = balanceAmount.toStringAsFixed(2);
    }else{
      _totalBalanceAmountCash.text = '';
    }

  }

  void calculateBalanceAmountForReceiveAmountCashLumsum() {
    double balanceAmount = 0;
    double postpaidAmount = double.tryParse(_amountControllerPostpaid.text) ?? 0;
    double prepaidAmount = double.tryParse(_amountControllerPrepaid.text) ?? 0;
    double creditAmount = double.tryParse(_amountControllerCredit.text) ?? 0;
    double cashAmount = double.tryParse(_amountControllerCash.text) ?? 0;

    double totalAmountFromCashPaymentMode = 0.0;

    // Loop through the list and check the payment mode
    for (var reticulatedItem in _reticulatedList) {
      if (reticulatedItem.paymentMode == 'Cash') {
        totalAmountFromCashPaymentMode += reticulatedItem.amount ?? 0.0;  // Add the amount of cash items
      }
    }
    if (postpaidAmount > 0 || prepaidAmount > 0 || creditAmount > 0 || cashAmount > 0) {
      balanceAmount = (amountTotal! - postpaidAmount - prepaidAmount - creditAmount - cashAmount + totalAmountFromCashPaymentMode - expenseAmtTotal!);
    } else {
      // balanceAmount = amountTotal!.toDouble();
      debugPrint("balaceerrir");
    }
    setState(() {
      // Set the calculated balance amount to the controller
      if(balanceAmount > amountTotal!){
        debugPrint("$balanceAmount");
        _totalBalanceAmountCash.text = "0";
      }else {
        debugPrint("eeamt$balanceAmount");
        if(balanceAmount>0){
          _totalBalanceAmountCash.text = balanceAmount.toStringAsFixed(2);
        }else{
          _totalBalanceAmountCash.text = '';
        }

      }
    });

  }

  /// expected amount
  void calculateBalanceAmountForReceiveAmountCashLumsumMode() {
    double expectedAmount = 0;
    double postpaidAmount = double.tryParse(_amountControllerPostpaid.text) ?? 0;
    double prepaidAmount = double.tryParse(_amountControllerPrepaid.text) ?? 0;
    double creditAmount = double.tryParse(_amountControllerCredit.text) ?? 0;

    double totalAmountFromCashPaymentMode = 0.0;

    // Loop through the list and check the payment mode
    for (var reticulatedItem in _reticulatedList) {
      if (reticulatedItem.paymentMode == 'Cash') {
        totalAmountFromCashPaymentMode += reticulatedItem.amount ?? 0.0;  // Add the amount of cash items
      }
    }
    if (postpaidAmount > 0 || prepaidAmount > 0 || creditAmount > 0) {
      expectedAmount = (amountTotal! - postpaidAmount - prepaidAmount - creditAmount + totalAmountFromCashPaymentMode - expenseAmtTotal!);
    } else {
      expectedAmount = amountTotal!.toDouble();
    }

    // Set the calculated balance amount to the controller
    debugPrint("expecashqtycaseespense $expectedAmount");
    if(expectedAmount > 0){
      _totalExpectedAmountCash.text = expectedAmount.toStringAsFixed(2);
    }else{
      _totalExpectedAmountCash.text = '';
    }

  }

  void _calculateCylinderAmountCashtLumsum() {
    double expectedAmount = 0;
    double postpaidAmount = double.tryParse(_amountControllerPostpaid.text) ?? 0;
    double prepaidAmount = double.tryParse(_amountControllerPrepaid.text) ?? 0;
    double creditAmount = double.tryParse(_amountControllerCredit.text) ?? 0;
    if (postpaidAmount > 0 || prepaidAmount > 0 || creditAmount > 0) {
      expectedAmount = (amountTotal! - postpaidAmount - prepaidAmount - creditAmount - expenseAmtTotal!);
    } else {
      expectedAmount = amountTotal!.toDouble();
    }

    // Find all items in the reticulated list with paymentMode 'Cash'
    double totalAmountFromCashPaymentMode = 0.0;

    // Loop through the list and check the payment mode
    for (var reticulatedItem in _reticulatedList) {
      if (reticulatedItem.paymentMode == 'Cash') {
        totalAmountFromCashPaymentMode += reticulatedItem.amount ?? 0.0;  // Add the amount of cash items
      }
    }

    // Now calculate the cylinder amount and the total expected amount
    setState(() {
      double amountCashCylinders = expectedAmount - expenseAmtTotal! + totalAmountFromCashPaymentMode;
      debugPrint("expecashqtycaselump $amountCashCylinders");
      if(amountCashCylinders > 0){
        _totalExpectedAmountCash.text = amountCashCylinders.toStringAsFixed(2);
      }else{
        _totalExpectedAmountCash.text = '';
      }

    });
  }

  ///final amount cash validation if exceed

  void checkAndShowMessageIfExceeded() {
    // Convert the text to a double, handle any possible errors if the text is not a valid number
    double totalReceivedAmountCash = double.tryParse(_totalReceivedAmountCash.text) ?? 0.0;

    // Debug: Print both values to check if they're correct
    print('finalAmount: $finalsAmount');
    print('totalReceivedAmountCash: $totalReceivedAmountCash');

    // Check if finalAmount is greater than the total received amount
    if (finalsAmount > totalReceivedAmountCash) {
      // Show a message using a SnackBar if the condition is met
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Final amount exceeds the received amount!'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Optionally, you could show a different message or do nothing
      print('Amount is within the received limit.');
    }
  }

  ///Get Time For Vendor Transaction
  Future<void> _selectTime(BuildContext context) async {
    // Get the current time
    TimeOfDay currentTime = TimeOfDay.now();

    // Open the time picker
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (pickedTime != null) {
      // Update the TextField with the selected time in AM/PM format
      setState(() {
        _timeControllerPostpaid.text = pickedTime.format(context);
      });
    }
  }

  Future<void> fetchConsumerDetailsCredit() async {
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

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse('${AppUrl.GetCustomerList}/$distributorId/1'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body GetCustomerList: ${response.body}");
        debugPrint("request body GetCustomerList: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          // return data
          //     .map((jsonItem) => DailySaleSaummaryListModel.fromJson(jsonItem))
          //     .toList();
          setState(() {
            getConsumerCreditDetailListModel = data
                .map((jsonItem) => GetConsumerDetailsCredit.fromJson(jsonItem))
                .toList();
            isLoading = false;
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

  Future<void> updateSaleAddEditForMob(String actionFlag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? addedBy = prefs.getString('StaffId');
    int? addedBys = int.parse(addedBy!);
    int? distributorIds = int.parse(distributorId!);
    String formatDate(DateTime dateTime) {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final DateTime now = DateTime.now();
    // String formattedDate = formatDate(now);
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final String expneseId = getExpenseIdAsCommaSeparatedString(getExpenseDetailListModel);
    final String consumerNumbers =
        getConsumerNumbersAsCommaSeparatedString(_consumerList);
    // final List<Map<String, dynamic>> consumerDtls =
    //     _consumerList.map((e) => e.toJson()).toList();

    prepareDenominationData(getNoteTypeAndIdFroDenominationListModel);
// Assuming _consumerList is of type List<ConsumerModel>
    final List<Map<String, dynamic>> consumerDtls = _consumerList.map((e) {
      // Convert each ConsumerModel to a Map<String, dynamic>
      Map<String, dynamic> consumerMap = e.toJson();

      // Format DateTime fields to string
      // consumerMap['OrderDate'] = formatDate(consumerMap['OrderDate']);
      // consumerMap['cashmemoDate'] = formatDate(consumerMap['cashmemoDate']);

      // Apply your conditional logic based on the 'ConsumerRemark' field
      if (consumerMap['ConsumerRemark'] == 'Already Punched In Niyojan') {
        consumerMap['InCorrectStatus'] = 3;
        consumerMap['NiyojanDel'] = 0;
        consumerMap['cDCMSDel'] = 0;
      } else if (consumerMap['ConsumerRemark'] == 'Not Found') {
        consumerMap['InCorrectStatus'] = 2;
        consumerMap['NiyojanDel'] = 0;
        consumerMap['cDCMSDel'] = 0;
      } else {
        // If neither condition is met, set default values
        consumerMap['InCorrectStatus'] = 1;
        consumerMap['NiyojanDel'] = 1;
        consumerMap['cDCMSDel'] = consumerMap['cDCMSDel'] ?? 0; // Use current value or default to 0 if not available
      }
      return consumerMap;
    }).toList();

    final List<Map<String, dynamic>> postpaidDtls =
        _transactionList.map((e) => e.toJson()).toList();
    final List<Map<String, dynamic>> reticulatedDtls =
        _reticulatedList.map((e) => e.toJson()).toList();
    final List<Map<String, dynamic>> denominationList =
    _denomModelList.map((e) => e.toJson()).toList();
    debugPrint("denominationList$denominationList");
    int? qtyControllerPrepaids = 0;
    int? qtyControllerPostpaids = 0;
    int? qtyControllerCredits = 0;
    int? qtyControllerCashs = 0;
    if(_qtyControllerPrepaid.text.isNotEmpty){
       qtyControllerPrepaids = int.parse(_qtyControllerPrepaid.text);
    }
    if(_qtyControllerPostpaid.text.isNotEmpty){
     qtyControllerPostpaids = int.parse(_qtyControllerPostpaid.text);
    }
    if(_qtyControllerCredit.text.isNotEmpty){
       qtyControllerCredits = int.parse(_qtyControllerCredit.text);
    }
    if(_qtyControllerCash.text.isNotEmpty){
      qtyControllerCashs = int.parse(_qtyControllerCash.text);
    }

    double? totalExpectedAmountCash = 0;
    double? totalReceivedAmountCash = 0;
    double? totalBalanceAmountCash = 0;
    double? postpaidAmountCash = 0;
    double? prepaidAmountCash = 0;
    double? creditAmountCash = 0;
    double? cashAmountCash = 0;
    if(_totalExpectedAmountCash.text.isNotEmpty){
      totalExpectedAmountCash = double.tryParse(_totalExpectedAmountCash.text);
    }
    if(_totalReceivedAmountCash.text.isNotEmpty){
      totalReceivedAmountCash = double.tryParse(_totalReceivedAmountCash.text);
    }
    if(_totalBalanceAmountCash.text.isNotEmpty){
       totalBalanceAmountCash = double.tryParse(_totalBalanceAmountCash.text);
    }
    if(_amountControllerPostpaid.text.isNotEmpty){
       postpaidAmountCash = double.tryParse(_amountControllerPostpaid.text);
       debugPrint("postpaidAmountCash$postpaidAmountCash");
    }
    if(_amountControllerPrepaid.text.isNotEmpty){
     prepaidAmountCash = double.tryParse(_amountControllerPrepaid.text);
    }
    if(_amountControllerCredit.text.isNotEmpty){
      creditAmountCash = double.tryParse(_amountControllerCredit.text);
    }
    if(_amountControllerCash.text.isNotEmpty){
       cashAmountCash = double.tryParse(_amountControllerCash.text);
    }


    int retTotalQty = getTotalQuantity();
    print('Total Quantity: $retTotalQty');

    double? denoCashRcvd = 0;
    if(finalsAmount > 0){
      denoCashRcvd = finalsAmount;
    }else{
      denoCashRcvd = totalReceivedAmountCash;
    }

    if((qtyControllerPrepaids + qtyControllerPostpaids + qtyControllerCredits + qtyControllerCashs > 0 )||(isLumsumAmountAdd == false)){
      if (retTotalQty != qtyControllerCredits) {
        // Show a message
        showFlushBar(context, Constants.reticulatedCylinderQuantity);
        // You can also return this message from a function or show a snackbar/dialog
        return;
      }
      if(qtyControllerCredits >0){
        if(_reticulatedList.length <= 0){
          showFlushBar(context, Constants.customerDetails);
        }
      }

      if(totalExpectedAmountCash! > 0){
        if(_totalReceivedAmountCash.text.isEmpty) {
          showFlushBar(context, Constants.receivedAmount);
          // You can also return this message from a function or show a snackbar/dialog
          return;
        }else{
          if (totalReceivedAmountCash! > totalExpectedAmountCash!) {
            showFlushBar(context, Constants.receivedAmount);
            // You can also return this message from a function or show a snackbar/dialog
            return;
          }
        }
      }


      if(qtyControllerPostpaids > 0 || postpaidAmountCash! > 0){
        if(_transactionList.length <= 0){
          showFlushBar(context, Constants.transactionDetails);
          // You can also return this message from a function or show a snackbar/dialog
          return;
        }
      }
      if(isLumsumAmountAdd == false){
        if(postpaidAmountCash! + prepaidAmountCash! + creditAmountCash! + cashAmountCash! > amountTotal!){
          showFlushBar(context, Constants.totalReceivedAmountLumpsum);
          // You can also return this message from a function or show a snackbar/dialog
          return;
        }
        if(postpaidAmountCash > 0){
          if(_transactionList.length <= 0){
            showFlushBar(context, Constants.transactionDetails);
            // You can also return this message from a function or show a snackbar/dialog
            return;
          }
        }
      }

      if(finalsAmount > 0){
        if(finalsAmount != totalReceivedAmountCash){
          showFlushBar(context, Constants.denominationAmount);
          // You can also return this message from a function or show a snackbar/dialog
          return;
        }
      }
      if(totalBalanceAmountCash! > 0){
        if(isCheckedBalanceCash == false){
          if(finalsAmount != totalReceivedAmountCash){
            showFlushBar(context, Constants.addBalanceDelBoyAccount);
            // You can also return this message from a function or show a snackbar/dialog
            return;
          }
        }
      }
      int dSCollMgrIds;
      if(actionMode == "EDIT"){
        dSCollMgrIds = dSCollMgrId!;
      }else{
        dSCollMgrIds = 0;
      }

      final Map<String, dynamic> requestBody = {
        "DSCollMgrId": dSCollMgrIds,
        "CollRcptNo":receiptNoText,
        "CollRcptDate": formattedDate,
        "SaleGKId": salesGkId,
        "VehicleId":vehicleID,
        "SaleGKItemId": sakesGKItemID,
        "Rate": itemRates,
        "DailySaleStatus": 5,
        "DenoCashExptd": totalExpectedAmountCash,
        "DenoCashRcvd": denoCashRcvd,
        "DistributorId":distributorIds,
        "ItemId": itemIDs,
        "StaffId": delBoyIDs,
        "PrepaidQty": qtyControllerPrepaids,
        "PrepaidAmt": amountPrepaidCylinder,
        "OnlineQty": qtyControllerPostpaids,
        "OnlineAmt": amountPostpaidCylinder,
        "TransactionDtls": 0,
        "TransactionTime": 0,
        "OnlineRemark": 0,
        "CashQty": qtyControllerCashs,
        "CashAmt": amountCashCylinder,
        "CashDenomDtls": denominationList,
        "PrepaidDtls": consumerDtls,
        "PostpaidDtls": postpaidDtls,
        "ReticulatedDtls": reticulatedDtls,
        "TotalCashReceived": 0,
        "CashBalance":totalBalanceAmountCash,
        "PaymentMode": 0,
        "ReticulatedQty": qtyControllerCredits,
        "ReticulatedAmt": amountCreditCylinder,
        "ReticulatedRemark":'',
        "ExpIdstr":expneseId,
        "AddedBy":addedBys,
        "Action":actionFlag,
      };
      print("requestBodyUpdateSaleAddEditForMob: ${requestBody}");
      requestBody.forEach((key, value) {
        print('$key: $value');
      });

      // Making the POST request
      try {
        final response = await http.post(
          Uri.parse('${AppUrl.UpdateSaleAddEditForMob}'),
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
            arguments: 2, // This opens the third tab
          );
          EasyLoading.showToast(Constants.expenseSendMgr,
              duration: const Duration(milliseconds: 3000));
        } else {
          // Error response
          print("Error UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
        }
      } catch (e) {
        // Exception handling
        print("Exception UpdateSaleAddEditForMob: $e");
      }
    }else{
      print("wrong UpdateSaleAddEditForMob");
      showFlushBar(context, Constants.allDataEmpty);
    }

  }

  String getConsumerNumbersAsCommaSeparatedString(
      List<ConsumerModel> consumerList) {
    // Extract consumerNo and join with commas
    return consumerList
        .map((e) => e.consumerNo)
        .where((e) => e != null)
        .join(',');
  }

  String getExpenseIdAsCommaSeparatedString(
      List<GetExpenseDetailListModel> expenseList) {
    // Extract consumerNo and join with commas
    return expenseList
        .map((e) => e.expId)
        .where((e) => e != null)
        .join(',');
  }

  /// Validate the sum of all quantities culinder
  void _validateQuantities(String payMode) {
    int totalQty = prepaidQty + postpaidQty + creditQty ;
    int cashSaleQtyCalcu = prepaidQty + postpaidQty + creditQty;

    // Check if the total of all entered quantities exceeds the saleQty
    if (totalQty > saleQty!) {
      // If it exceeds, show an error message or reset the value
      showErrorDialog('Total quantity cannot exceed sale quantity.');
      _clearExcessQuantity(payMode);
    } else {
      cashQtys = saleQty! - cashSaleQtyCalcu;
      _qtyControllerCash.text = cashQtys.toString();
      _calculateCylinderAmountCasht();
      // calculateBalanceAmountForReceiveAmountCash();
      // Do something, if necessary (like saving or updating state)
      setState(() {
        // You can perform any logic after validation here
      });
    }
  }

  // Validate the sum of all quantities
  void _validateQuantitiesLumsumCase(String payMode) {
    int totalQty = prepaidQty + postpaidQty + creditQty + cashQty;
    // int cashSaleQtyCalcu = prepaidQty + postpaidQty + creditQty;

    // Check if the total of all entered quantities exceeds the saleQty
    if (totalQty > saleQty!) {
      // If it exceeds, show an error message or reset the value
      showErrorDialog('Total quantity cannot exceed sale quantity.');
      _clearExcessQuantity(payMode);
    } else {
      // cashQtys = saleQty! - cashSaleQtyCalcu;
      // _qtyControllerCash.text = cashQtys.toString();
      // _calculateCylinderAmountCasht();
      // calculateBalanceAmountForReceiveAmountCash();
      // Do something, if necessary (like saving or updating state)
      setState(() {
        // You can perform any logic after validation here
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Function to clear the excess quantity in the last modified field
  void _clearExcessQuantity(String payModes) {
    if (prepaidQty + postpaidQty + creditQty + cashQty > saleQty!) {
      // You can check which controller exceeds the limit and clear it.
      if (prepaidQty + postpaidQty + creditQty + cashQty > saleQty!) {
        // Check which field to clear
        if (payModes == "Prepaid" &&
            prepaidQty > 0 &&
            prepaidQty + postpaidQty + creditQty + cashQty > saleQty!) {
          _qtyControllerPrepaid.clear();
          _amountControllerPrepaid.clear();
          amountPrepaidCylinder = 0;
          prepaidQty = 0; // Reset the value
          debugPrint("prepaid");
        } else if (payModes == "Postpaid" &&
            postpaidQty > 0 &&
            prepaidQty + postpaidQty + creditQty + cashQty > saleQty!) {
          _qtyControllerPostpaid.clear();
          _amountControllerPostpaid.clear();
          amountPostpaidCylinder = 0;
          postpaidQty = 0;
          debugPrint("postpaid");
        } else if (payModes == "Credit" &&
            creditQty > 0 &&
            prepaidQty + postpaidQty + creditQty + cashQty > saleQty!) {
          _qtyControllerCredit.clear();
          amountCreditCylinder = 0;
          _amountControllerCredit.clear();
          creditQty = 0;
          debugPrint("credit");
        } else if (payModes == "Cash" &&
            cashQty > 0 &&
            prepaidQty + postpaidQty + creditQty + cashQty > saleQty!) {
          _qtyControllerCash.clear();
          _amountControllerCash.clear();
          amountCashCylinder = 0;
          cashQty = 0;
          debugPrint("Cash");
        }
      }
    }
  }

  /// get denomination note id from api and set
  List<DenomModel> prepareDenominationData(
      List<GetNoteTypeAndIdFroDenominationListModel>
          getNoteTypeAndIdFroDenominationListModel) {
    _denomModelList.clear(); // Ensure the list is initialized empty

    // Mapping controllers to note types
    Map<double, TextEditingController> quantityControllers = {
      500: quantity500Controller,
      200: quantity200Controller,
      100: quantity100Controller,
      50: quantity50Controller,
      20: quantity20Controller,
      10: quantity10Controller,
      5: quantity5Controller,
      2: quantity2Controller,
      1: quantity1Controller,
      0.50: quantity050Controller,
    };

    Map<double, TextEditingController> returnQuantityControllers = {
      500: returnQuantity500Controller,
      200: returnQuantity200Controller,
      100: returnQuantity100Controller,
      50: returnQuantity50Controller,
      20: returnQuantity20Controller,
      10: returnQuantity10Controller,
      5: returnQuantity5Controller,
      2: returnQuantity2Controller,
      1: returnQuantity1Controller,
      0.50: returnQuantity050Controller,
    };

    // Populate DenomModel for each note type
    quantityControllers.forEach((noteType, controller) {
      // Find the matching note ID
      final noteInfo = getNoteTypeAndIdFroDenominationListModel.firstWhere(
        (model) => model.noteType == noteType,
        orElse: () => GetNoteTypeAndIdFroDenominationListModel(
            id: null, noteType: noteType, isActive: null),
      );

      int? noteId = noteInfo.id?.toInt();

      int? quantity = int.tryParse(controller.text); // Get quantity
      double? totalAmt = quantity != null ? (noteType * quantity) : null;

      int? retQuantity = int.tryParse(
          returnQuantityControllers[noteType]?.text ??
              '0'); // Get return quantity
      double? retTotalAmt = retQuantity != null ? (noteType * retQuantity) : null;

      // Add data to the list only once
      _denomModelList.add(DenomModel(
        id: noteId,
        // Note ID from GetNoteTypeAndIdFroDenominationListModel
        noteType: noteType,
        quantity: quantity,
        totalAmt: totalAmt,
        retNoteQty: retQuantity,
        retNoteAmt: retTotalAmt,
      ));
    });

    // Debug print for confirmation
    debugPrint(
        "_denomModelList: ${_denomModelList.map((e) => e.toJson()).toList()}");
    // Return the final list
    return _denomModelList;
  }

  /// edit mode data bind in denomination
  void populateControllers(List<DenomModel> denomList) {
    // Clear all controllers first
    quantity500Controller.clear();
    quantity200Controller.clear();
    quantity100Controller.clear();
    quantity50Controller.clear();
    quantity20Controller.clear();
    quantity10Controller.clear();
    quantity5Controller.clear();
    quantity2Controller.clear();
    quantity1Controller.clear();
    quantity050Controller.clear();

    returnQuantity500Controller.clear();
    returnQuantity200Controller.clear();
    returnQuantity100Controller.clear();
    returnQuantity50Controller.clear();
    returnQuantity20Controller.clear();
    returnQuantity10Controller.clear();
    returnQuantity5Controller.clear();
    returnQuantity2Controller.clear();
    returnQuantity1Controller.clear();
    returnQuantity050Controller.clear();

    // Map the list to note type and populate the controllers and result variables
    for (var denom in denomList) {
      switch (denom.noteType) {
        case 500:
          quantity500Controller.text = denom.quantity?.toString() ?? '';
          returnQuantity500Controller.text = denom.retNoteQty?.toString() ?? '';
          result500 = denom.totalAmt?.toDouble() ?? 0.0;
          returnResult500 = denom.retNoteAmt?.toDouble() ?? 0.0;
          break;
        case 200:
          quantity200Controller.text = denom.quantity?.toString() ?? '';
          returnQuantity200Controller.text = denom.retNoteQty?.toString() ?? '';
          result200 = denom.totalAmt?.toDouble() ?? 0.0;
          returnResult200 = denom.retNoteAmt?.toDouble() ?? 0.0;
          break;
        case 100:
          quantity100Controller.text = denom.quantity?.toString() ?? '';
          returnQuantity100Controller.text = denom.retNoteQty?.toString() ?? '';
          result100 = denom.totalAmt?.toDouble() ?? 0.0;
          returnResult100 = denom.retNoteAmt?.toDouble() ?? 0.0;
          break;
        case 50:
          quantity50Controller.text = denom.quantity?.toString() ?? '';
          returnQuantity50Controller.text = denom.retNoteQty?.toString() ?? '';
          result50 = denom.totalAmt?.toDouble() ?? 0.0;
          returnResult50 = denom.retNoteAmt?.toDouble() ?? 0.0;
          break;
        case 20:
          quantity20Controller.text = denom.quantity?.toString() ?? '';
          returnQuantity20Controller.text = denom.retNoteQty?.toString() ?? '';
          result20 = denom.totalAmt?.toDouble() ?? 0.0;
          returnResult20 = denom.retNoteAmt?.toDouble() ?? 0.0;
          break;
        case 10:
          quantity10Controller.text = denom.quantity?.toString() ?? '';
          returnQuantity10Controller.text = denom.retNoteQty?.toString() ?? '';
          result10 = denom.totalAmt?.toDouble() ?? 0.0;
          returnResult10 = denom.retNoteAmt?.toDouble() ?? 0.0;
          break;
        case 5:
          quantity5Controller.text = denom.quantity?.toString() ?? '';
          returnQuantity5Controller.text = denom.retNoteQty?.toString() ?? '';
          result5 = denom.totalAmt?.toDouble() ?? 0.0;
          returnResult5 = denom.retNoteAmt?.toDouble() ?? 0.0;
          break;
        case 2:
          quantity2Controller.text = denom.quantity?.toString() ?? '';
          returnQuantity2Controller.text = denom.retNoteQty?.toString() ?? '';
          result2 = denom.totalAmt?.toDouble() ?? 0.0;
          returnResult2 = denom.retNoteAmt?.toDouble() ?? 0.0;
          break;
        case 1:
          quantity1Controller.text = denom.quantity?.toString() ?? '';
          returnQuantity1Controller.text = denom.retNoteQty?.toString() ?? '';
          result1 = denom.totalAmt?.toDouble() ?? 0.0;
          returnResult1 = denom.retNoteAmt?.toDouble() ?? 0.0;
          break;
        case 0.50:
          quantity050Controller.text = denom.quantity?.toString() ?? '';
          returnQuantity050Controller.text = denom.retNoteQty?.toString() ?? '';
          result050 = denom.totalAmt?.toDouble() ?? 0.0;
          returnResult050 = denom.retNoteAmt?.toDouble() ?? 0.0;
          break;
      }
      total = (result500 ?? 0.0) +
          (result200 ?? 0.0) +
          (result100 ?? 0.0) +
          (result50 ?? 0.0) +
          (result20 ?? 0.0) +
          (result10 ?? 0.0) +
          (result5 ?? 0.0) +
          (result2 ?? 0.0) +
          (result1 ?? 0.0)+
          (result050 ?? 0.0);
      // Calculate the total of all results, treating null or 0.0 as 0
      returnTotal = (returnResult500 ?? 0.0) +
          (returnResult200 ?? 0.0) +
          (returnResult100 ?? 0.0) +
          (returnResult50 ?? 0.0) +
          (returnResult20 ?? 0.0) +
          (returnResult10 ?? 0.0) +
          (returnResult5 ?? 0.0)+
          (returnResult2 ?? 0.0)+
          (returnResult1 ?? 0.0)+
          (returnResult050 ?? 0.0);
      // Logic to calculate final amount
      if (total == 0 && returnTotal == 0) {
        finalsAmount = 0;
      } else if (total == 0) {
        finalsAmount = returnTotal;
      } else if (returnTotal == 0) {
        finalsAmount = total;
      } else {
        finalsAmount = total - returnTotal;
      }
    }

    // Debug print to verify results
    debugPrint("Controllers populated with data: $denomList");
    debugPrint(
        "Results - Total: [500: $result500, 200: $result200, 100: $result100, 50: $result50, 20: $result20, 10: $result10, 5: $result5]");
    debugPrint(
        "Results - Return: [500: $returnResult500, 200: $returnResult200, 100: $returnResult100, 50: $returnResult50, 20: $returnResult20, 10: $returnResult10, 5: $returnResult5]");
  }

  /// get note type and from api
  Future<void> getNoteTypeAndIDList() async {
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

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse('${AppUrl.GetCashDenominationItemList}/1'),
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

  /// expense add edit
  Future<void> fetchExpenseDetailList() async {
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

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse(
              '${AppUrl.GetExpenseDetailsListByStaffId}/$distributorId/$delBoyIDs/$dSCollMgrId/1'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint(
            "Response body GetExpenseDetailsListByStaffId: ${response.body}");
        debugPrint(
            "request body GetExpenseDetailsListByStaffId: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getExpenseDetailListModel = data
                .map((jsonItem) => GetExpenseDetailListModel.fromJson(jsonItem))
                .toList();
            isLoading = false;

          });
          double expenseDetailList = 0;

          for (var i = 0; i < getExpenseDetailListModel!.length; i++) {
            double? getExpenseDetailList =
                getExpenseDetailListModel![i].expAmount?.toDouble();
            expenseDetailList += getExpenseDetailList!;
          }
          debugPrint("Response body expenseDetailList: ${expenseDetailList}");
          expenseAmtTotal = expenseDetailList;
          if(isLumsumAmountAdd) {
            setState(() {
              double cashamt = double.parse(_amountControllerCash.text);
              if(cashamt > 0){
                _calculateCylinderAmountCasht();
                if(_totalReceivedAmountCash.text.isNotEmpty) {
                  calculateBalanceAmountForReceiveAmountCash();
                }else{

                }
              }
            });
          }else{
            _calculateCylinderAmountCashtLumsum();
            // calculateBalanceAmountForReceiveAmountCashLumsumMode();
            if(_totalReceivedAmountCash.text.isNotEmpty) {
              calculateBalanceAmountForReceiveAmountCashLumsum();
            }
          }
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

  Future<void> fetchExpenseHeaderDetails() async {
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

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse('${AppUrl.GetExpenseHeaderList}/$distributorId/1'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body GetExpenseHeaderList: ${response.body}");
        debugPrint("request body GetExpenseHeaderList: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          // return data
          //     .map((jsonItem) => DailySaleSaummaryListModel.fromJson(jsonItem))
          //     .toList();
          setState(() {
            _expensesHeaders = data
                .map((jsonItem) =>
                    GetExpenceHeadAmountListModel.fromJson(jsonItem))
                .toList();
            isLoading = false;
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

  Future<void> addExpenseAPI(int expHeadId, String expHeadName,
      double expAmount, String remark, String mode, int expId) async {
    EasyLoading.show();
    Constants.isNetworkAvailable =
        await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
      EasyLoading.dismiss();
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');
        String? StaffId = prefs.getString('StaffId');
        int? staffIds = int.parse(StaffId!);
        int? distributorIds = int.parse(distributorId!);
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
        if (bearerToken == null) {
          isLoading = false;
          EasyLoading.dismiss();
          throw Exception('Bearer token is missing');
        }
        String modeSelected;
        if (mode == "ADD") {
          modeSelected = "ADD";
        } else if (mode == "EDIT") {
          modeSelected = "EDIT";
        } else if (mode == "DELETE") {
          modeSelected = "DELETE";
        } else {
          modeSelected = '';
        }
        // Construct the request body for the POST request
        Map<String, dynamic> requestBody = {
          "ExpId": expId,
          "ExpHeadId": expHeadId,
          "ExpHeadName": expHeadName,
          "DistributorId": distributorIds,
          "VehicleId": vehicleID,
          "ExpDate": formattedDate,
          "StaffId": delBoyIDs,
          "ExpAmount": expAmount,
          "Remark": remark,
          "AddedOn": formattedDate,
          "Action": modeSelected,
          "AddedBy": staffIds
        };

        final response = await http.post(
          Uri.parse('${AppUrl.ExpenseDetailsAddEdit}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            // Ensure the request body is JSON
          },
          body: json.encode(requestBody), // Encode the request body as JSON
        );

        debugPrint("Response body ExpenseDetailsAddEdit: ${response.body}");
        debugPrint(
            "Request body ExpenseDetailsAddEdit: ${response.request}${requestBody}");

        if (response.statusCode == 200) {
          debugPrint("Response body ExpenseDetailsAddEdit: ${response.body}");
          // fetchExpenseDetailList();
          _expenseRemarkController.clear();
          _expenseAmountController.clear();
          _selectedExpenseHeadId = null;
          _selectedExpenseHead = '';
          fetchExpenseDetailList().whenComplete((){
            setState(() {
              EasyLoading.dismiss();
              Navigator.pop(context);
              _showExpenseBottomSheet(context, delBoyNameName!, vehicleNumber!);
            });
          });

          if (mode == "ADD") {
            EasyLoading.showToast(Constants.expenseSendMgr,
                duration: const Duration(milliseconds: 3000));
          } else if (mode == "EDIT") {
            EasyLoading.showToast(Constants.dataUpdated,
                duration: const Duration(milliseconds: 3000));
          } else if (mode == "DELETE") {
            EasyLoading.showToast(Constants.dataDeleted,
                duration: const Duration(milliseconds: 3000));
          } else {
            modeSelected = '';
          }

        } else {
          isLoading = false;
          EasyLoading.dismiss();
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        EasyLoading.dismiss();
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }

  void _showExpenseBottomSheet(
      BuildContext context, String deliveryBoyName, String VehicleNo,
      {GetExpenseDetailListModel? editingItem}) {
    bool isEditMode = editingItem != null;
    if (editingItem != null) {
      _selectedExpenseHead = editingItem.expHeadName;
      _selectedExpenseHeadId = editingItem.expHeadId!.toInt();
      _expenseAmountController.text = editingItem.expAmount?.toStringAsFixed(2) ?? '';
      _expenseRemarkController.text = editingItem.remark ?? '';
    } else {
      _selectedExpenseHead = null;
      _selectedExpenseHeadId = null;
      _expenseAmountController.clear();
      _expenseRemarkController.clear();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Allows the bottom sheet to adapt its height to the content
      builder: (BuildContext context) {
        return Container(
          width:
              MediaQuery.of(context).size.width, // Set width to device's width
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SingleChildScrollView(
            // Wrap content in a scrollable view
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Ensure column size is based on children
              children: [
                Text(
                  "Add Expenses",
                  style: Styling.bodyTitle,
                ),
                SizedBox(height: 16),
                // Delivery Boy and Vehicle info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        "${deliveryBoyName}",
                        style: Styling.itemTitle,
                        textAlign: TextAlign.center, // Center the text
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${VehicleNo}",
                        style: Styling.itemTitle,
                        textAlign: TextAlign.center, // Center the text
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Expense Head dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidgetBlueColorWithStar("Exp.Head:", "*"),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      // Use relative width (60% of screen width)
                      child:
                          // DropdownButtonFormField<
                          //     GetExpenceHeadAmountListModel>(
                          //   decoration: InputDecoration(
                          //     contentPadding: EdgeInsets.symmetric(
                          //         vertical: 12, horizontal: 10),
                          //   ),
                          //   style: Styling.itemBlackTest,
                          //   items: _expensesHeaders
                          //       .map((GetExpenceHeadAmountListModel expenses) {
                          //     return DropdownMenuItem<
                          //         GetExpenceHeadAmountListModel>(
                          //       value: expenses,
                          //       child: Text(expenses.expHeadName ?? ''),
                          //     );
                          //   }).toList(),
                          //   onChanged:
                          //       (GetExpenceHeadAmountListModel? selectedVendor) {
                          //     if (selectedVendor != null) {
                          //       _selectedExpenseHead = selectedVendor.expHeadName;
                          //       _selectedExpenseHeadId =
                          //           selectedVendor.expHeadId?.toInt();
                          //       // Handle dropdown selection here
                          //       print(
                          //           "Selected Vendor Name: $_selectedExpenseHead");
                          //       print(
                          //           "Selected Vendor ID: $_selectedExpenseHeadId");
                          //     }
                          //   },
                          // ),
                          DropdownButtonFormField<
                              GetExpenceHeadAmountListModel>(
                            isExpanded: true,
                        value: _expensesHeaders.any((item) =>
                                item.expHeadId == _selectedExpenseHeadId)
                            ? _expensesHeaders.firstWhere((item) =>
                                item.expHeadId == _selectedExpenseHeadId)
                            : null,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                        ),
                        style: Styling.itemBlackTest,
                        items: _expensesHeaders
                            .map((GetExpenceHeadAmountListModel expenses) {
                          return DropdownMenuItem<
                              GetExpenceHeadAmountListModel>(
                            value: expenses,
                            child:Text(expenses.expHeadName ?? ''),
                          );
                        }).toList(),
                        onChanged:
                            (GetExpenceHeadAmountListModel? selectedExpense) {
                          if (selectedExpense != null) {
                            _selectedExpenseHead = selectedExpense.expHeadName;
                            _selectedExpenseHeadId =
                                selectedExpense.expHeadId?.toInt();
                            print("Selected exp Name: $_selectedExpenseHead");
                            print("Selected exp ID: $_selectedExpenseHeadId");
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Expense Amount input field
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidgetBlueColorWithStar("Exp. Amt:", "*"),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      // Use relative width (60% of screen width)
                      child: TextField(
                        controller: _expenseAmountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$')),
                          LengthLimitingTextInputFormatter(8),
                        ],
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.blueAccent),
                        ),
                        textAlign: TextAlign.center,
                        style: Styling.itemBlackTest,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Remark input field
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidgetBlueColorWithoutStar("Remark:"),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      // Use relative width (60% of screen width)
                      child: TextField(
                        controller: _expenseRemarkController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.blueAccent),
                        ),
                        textAlign: TextAlign.center,
                        style: Styling.itemBlackTest,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Save button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            (_expenseAmountController.text.isNotEmpty &&
                                    _selectedExpenseHead != null)
                                ? Color(0xff1280b3)
                                : Color(0xff666666)),
                      ),
                      onPressed: () {
                        if (_expenseAmountController.text.isNotEmpty &&
                            _selectedExpenseHead!.isNotEmpty) {
                          double expenseAmt =
                              double.parse(_expenseAmountController.text);
                          if (isEditMode) {
                            addExpenseAPI(
                                _selectedExpenseHeadId!,
                                _selectedExpenseHead!,
                                expenseAmt,
                                _expenseRemarkController.text,
                                "EDIT",
                                editingItem.expId!.toInt());
                          } else {
                            addExpenseAPI(
                                _selectedExpenseHeadId!,
                                _selectedExpenseHead!,
                                expenseAmt,
                                _expenseRemarkController.text,
                                "ADD",
                                0);
                          }
                          Navigator.pop(context);
                          _showExpenseBottomSheet(
                              context, deliveryBoyName, VehicleNo);
                          // Close bottom sheet after saving
                        } else {
                          EasyLoading.showToast(Constants.validCountEnter,
                              duration: const Duration(milliseconds: 3000));
                        }
                      },
                      child: Text(
                        isEditMode ? "Update" : "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff1280b3)),
                      ),
                      onPressed: () {
                        Navigator.pop(
                            context); // Close bottom sheet after saving
                      },
                      child: const Text("Close",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Name',
                                style: Styling.buttonTextBlack,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Amount',
                                style: Styling.buttonTextBlack,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Status',
                                style: Styling.buttonTextBlack,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Actions',
                                style: Styling.buttonTextBlack,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    getExpenseDetailListModel.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: getExpenseDetailListModel.length,
                            itemBuilder: (context, index) {
                              final items = getExpenseDetailListModel[index];
                              Color backgroundColor = (index % 2 == 0)
                                  ? Colors.grey[
                                      300]! // Color for even index (first, third, fifth...)
                                  : Colors.white70!;
                              return Container(
                                color: backgroundColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              items.expHeadName.toString(),
                                              style: Styling.buttonTextBlack,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              items.expAmount!.toStringAsFixed(2),
                                              style: Styling.buttonTextBlack,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              items.expStatus.toString(),
                                              style: Styling.buttonTextBlack,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                _showExpenseBottomSheet(context,
                                                    deliveryBoyName, VehicleNo,
                                                    editingItem: items);
                                                // _selectedExpenseHead = items.expHeadName;
                                                // _selectedExpenseHeadId = items.expHeadId!.toInt();
                                                // _expenseAmountController.text = items.expAmount?.toString() ?? '';
                                                // _expenseRemarkController.text = items.remark ?? '';
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                size: 18,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (isEditMode) {
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Confirm Deletion"),
                                                        content: Text(
                                                            "Are you sure you want to delete this record?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close dialog without action
                                                            },
                                                            child: Text("No"),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close dialog
                                                              addExpenseAPI(
                                                                  items
                                                                      .expHeadId!
                                                                      .toInt(),
                                                                  items
                                                                      .expHeadName!,
                                                                  items
                                                                      .expAmount!
                                                                      .toDouble(),
                                                                  items.remark
                                                                      .toString(),
                                                                  "DELETE",
                                                                  items.expId!
                                                                      .toInt());
                                                            },
                                                            child: Text("Yes"),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                size: 18,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            child: Text("No Data Available"),
                          ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// prepaid consumer number chck valid invaid
  Future<void> fetchConsumerNumbersPrepaid(int consumerNo) async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) throw Exception('Bearer token is missing');

      final response = await http.get(
        Uri.parse('${AppUrl.DailySaleCheckCashLessConsumerDtls}/$consumerNo/$distributorId'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      debugPrint("Response body DailySaleCheckCashLessConsumerDtls: ${response.body}");
      debugPrint("Response body DailySaleCheckCashLessConsumerDtls: ${response.request}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          for (var item in data) {
            final consumer = CheckConsumerNumberIsValidPrepaid.fromJson(item);
            final alreadyExists = _consumerList.any(
                    (element) => element.consumerNo == consumer.consumerNo
            );
            if(!alreadyExists){
              bool isValid = consumer.niyojanDel != 1 &&
                  consumer.consumerRemark != "Already Punched In Niyojan" &&
                  consumer.consumerRemark != "Not Found" &&
                  consumer.consumerRemark != "Not Found - Unaccounted";

              if (isValid) {
                validConsumerCount++;
                validCountController.text = validConsumerCount.toString();

                pendingCDCMSCount++;
                _qtyControllerPrepaid.text = pendingCDCMSCount.toString();
                prepaidQty = pendingCDCMSCount;

                await _addConsumer(
                  consumer.consumerNo ?? '',
                  consumer.consumerName ?? '',
                  consumer.orderDate ,
                  consumer.cashDate ,
                  consumer.paymentStatus ?? '',
                  consumer.consumerRemark ?? '',
                  1,
                  consumer.cDCMSDel?.toInt() ?? 0,
                  1,
                  consumer.payDate ,
                  consumer.deliveryDate ,
                  consumer.settDate ,
                );

                // _calculateCylinderAmountPrepaid();
                // _validateQuantities("Prepaid");
               setState(() {
                 if(isLumsumAmountAdd){
                   _calculateCylinderAmountPrepaid();
                   _validateQuantities("Prepaid");
                   // calculateBalanceAmountForReceiveAmountCash();
                   _totalReceivedAmountCash.text = '';
                   _totalBalanceAmountCash.text = '';
                 }else{
                   _validateQuantitiesLumsumCase("Prepaid");
                   _calculateCylinderAmountPrepaid();
                   calculateBalanceAmountForReceiveAmountCashLumsumMode();
                   // calculateBalanceAmountForReceiveAmountCashLumsum();
                   _totalReceivedAmountCash.text = '';
                   _totalBalanceAmountCash.text = '';
                 }
               });
              } else {
                invalidConsumerCount++;
                invalidCountController.text = invalidConsumerCount.toString();

                await _addConsumer(
                  consumer.consumerNo ?? '',
                  consumer.consumerName ?? '',
                  consumer.orderDate ,
                  consumer.cashDate ,
                  consumer.paymentStatus ?? '',
                  consumer.consumerRemark ?? '',
                  0,
                  0,
                  3,
                  consumer.payDate ,
                  consumer.deliveryDate ,
                  consumer.settDate ,
                );
              }
            }else{
              showFlushBar(context, Constants.expenseExistMgr);

            }

          }
        } else {
          // If the response is empty
          final alreadyExists = _consumerList.any(
                  (element) => element.consumerNo == consumerNo.toString()
          );
          if(!alreadyExists){
            invalidConsumerCount++;
            invalidCountController.text = invalidConsumerCount.toString();

            await _addConsumer(
              consumerNo.toString(),
              '',
              null,
              null,
              '',
              'Not Found',
              0,
              0,
              2,
              null,
              null,
              null
            );
          }else{
            showFlushBar(context, Constants.expenseExistMgr);
          }

        }

      } else {
        // Error from server: Treat as invalid
        final alreadyExists = _consumerList.any(
                (element) => element.consumerNo == consumerNo.toString()
        );
        if(!alreadyExists){
          invalidConsumerCount++;
          invalidCountController.text = invalidConsumerCount.toString();

          await _addConsumer(
            consumerNo.toString(),
            '',
            null,
            null,
            '',
            'Not Found',
              0,
              0,
              2,
              null,
              null,
              null
          );
        }else{
          showFlushBar(context, Constants.expenseExistMgr);
        }
      }
    } catch (error) {
      debugPrint("Error: $error");
      final alreadyExists = _consumerList.any(
              (element) => element.consumerNo == consumerNo.toString()
      );
      if(!alreadyExists){
        invalidConsumerCount++;
        invalidCountController.text = invalidConsumerCount.toString();

        await _addConsumer(
          consumerNo.toString(),
          '',
          null,
          null,
          '',
          'Not Found',
            0,
            0,
            2,
            null,
            null,
            null
        );
      }else{
        showFlushBar(context, Constants.expenseExistMgr);
      }
    }
  }

  /// credit consumer diacount fetch
  Future<void> fetchConsumerDiscountDetailsCredit() async {
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

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse('${AppUrl.GetCustDiscountList}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body GetCustDiscountList: ${response.body}");
        debugPrint("request body GetCustDiscountList: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          // return data
          //     .map((jsonItem) => DailySaleSaummaryListModel.fromJson(jsonItem))
          //     .toList();
          setState(() {
            getConsumerCreditDiscountDetailListModel = data
                .map((jsonItem) => GetConsumerDiscountDetailCredit.fromJson(jsonItem))
                .toList();
            isLoading = false;
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

  int getTotalQuantity() {
    return _reticulatedList.fold(0, (sum, item) => sum + (item.quantity ?? 0));
  }

  /// get all table dta for edit mode
  Future<void> _fetchSavedListDataForEdit(int dSCollMgrId, int saleGKItemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? distributorId = prefs.getString('DistributorId');
    String? token = prefs.getString('token');

    // try {
      final response = await http.post(
        Uri.parse(AppUrl.GetDailySaleCollByMgrDataByIdForMob),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'DistributorId': distributorId,
          'DSCollMgrId': dSCollMgrId,
          'SaleGKItemId': saleGKItemId,
        }),
      );

      debugPrint('API Request: ${response.request}');
      debugPrint('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<DenomModel> fetchedDenomList = (data['CashDenomDtls'] as List?)?.map((item) => DenomModel.fromJson(item)).toList() ?? [];

        // final List<ConsumerModel> fetchedConsumerList = (data['consumerDtls'] as List)
        //     .map((item) => ConsumerModel.fromJson(item))
        //     .toList() ?? [];
        final List<ConsumerModel> fetchedConsumerList = (data['consumerDtls'] as List?)?.map((item) => ConsumerModel.fromJson(item)).toList() ?? [];

        final List<TransactionModel> fetchedTransactionList = (data['PostpaidDtls'] as List?)?.map((item) => TransactionModel.fromJson(item)).toList() ?? [];

        final List<ReticulatedModel> fetchedReticulatedList = (data['ReticulatedDtls'] as List?)?.map((item) => ReticulatedModel.fromJson(item)).toList() ?? [];

        setState(() {
          // _denomModelList.clear();
          _consumerList.clear();
          _transactionList.clear();
          _reticulatedList.clear();

          // _denomModelList.addAll(fetchedDenomList);
          _consumerList.addAll(fetchedConsumerList);
          _transactionList.addAll(fetchedTransactionList);
          _reticulatedList.addAll(fetchedReticulatedList);
          populateControllers(fetchedDenomList);
          // debugPrint('_consumerList length: ${_consumerList.length}');
          debugPrint('_denomModelList length: ${_denomModelList.length}');
          debugPrint('_transactionList length: ${_transactionList.length}');
          debugPrint('_reticulatedList length: ${_reticulatedList.length}');

          int validQtys = 0;
          int invalidQtys = 0;

          for (var i = 0; i < fetchedConsumerList!.length; i++) {
            if(fetchedConsumerList[i].InCorrectStatus == 1){
              validQtys ++;
            }else{
              invalidQtys++;
            }
          }
          debugPrint("Response body validQtys: ${validQtys}");
          debugPrint("Response body invalidQtys: ${invalidQtys}");
          validCountController.text = validQtys.toString();
          invalidCountController.text = invalidQtys.toString();
          validConsumerCount = validQtys;
          invalidConsumerCount = invalidQtys;
        });
      } else {
        debugPrint('API Error: ${response.statusCode}');
      }
    // } catch (e) {
    //   print('Error fetching data: $e');
    // }
  }

  /// delivery men balance
  Future<void> fetchDeliveryMenBalance(int staffId) async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
      return null;  // Returning null if there's no connection
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
          Uri.parse('${AppUrl.GetBalanceByStaffId}/$staffId/$distributorId'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body GetBalanceByStaffId: ${response.body}");
        debugPrint("request body GetBalanceByStaffId: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            double balanceAmt = data[0]['BalanceAmt'].toDouble(); // Convert to double if necessary
            debugPrint("BalanceAmt: $balanceAmt");
            setState(() {
              delMenBalance = balanceAmt;
            });
            // Do something with the BalanceAmt, e.g., update your state
          } else {
            throw Exception('No data available');
          }
        } else {
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        debugPrint("Error: $error");
        return null;  // Return null in case of an error
      }
    }
  }

  /// rupee validation
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
}
