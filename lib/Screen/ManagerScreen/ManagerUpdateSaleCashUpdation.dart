import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantScreen/widgets.dart';
import '../Utils/Styling.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import 'ManagerModelClass/ConsumerModel.dart';
import 'ManagerModelClass/DenomModel.dart';
import 'ManagerModelClass/GetExpenseDetailListModel.dart';
import 'ManagerModelClass/GetNoteTypeAndIDFroDenominationListModel.dart';
import 'ManagerModelClass/GetVendorDetailListModel.dart';
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
  final TextEditingController returnQuantity5Controller =
      TextEditingController();

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

  var argValue;
  String? delBoyNameName, itemName;
  int? saleQty,
      svQty,
      tvQty,
      amountTotal,
      expAmount,
      dmBal,
      delBoyIDs,
      itemIDs,
      expenseAmtTotal,
      vehicleID,
      salesGkId,
      sakesGKItemID;
  String? saleQty1, svQty1, tvQty1, amountTotal1, expAmount1, dmBal1;
  double? itemRates;

  List<GetVendorDetailListModel> getVendorDetailListModel = [];
  List<GetExpenseDetailListModel> getExpenseDetailListModel = [];
  List<GetNoteTypeAndIdFroDenominationListModel>
      getNoteTypeAndIdFroDenominationListModel = [];
  bool isLoading = true;

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
        amountTotal = argValue["amountTotal"];
        itemRates = argValue["itemRate"];
        delBoyIDs = argValue["delBoyID"];
        itemIDs = argValue["itemID"];
        vehicleID = argValue["vehicleID"];
        sakesGKItemID = argValue["sakesGKItemID"];
        salesGkId = argValue["salesGkId"];
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
        // fetchDailySales(delBoyId!,formattedDate,salesGKId!);
        // deliveryBoyNameController.text = delBoyNameName!;
        // receiptDataController.text = formattedDate;
        fetchVendorDetails();
        fetchExpenseDetailList();
        getNoteTypeAndIDList();
        prepareDenominationData(getNoteTypeAndIdFroDenominationListModel);
        // Add listeners to controllers to rebuild the widget
        _qtyControllerPrepaid.addListener(() {
          setState(() {}); // Triggers a rebuild when the text changes
        });

        _consumerController.addListener(() {
          setState(() {}); // Triggers a rebuild when the text changes
        });
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
          (result5 ?? 0.0);
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
          (result5 ?? 0.0);
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
          (result5 ?? 0.0);
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
          (result5 ?? 0.0);
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
          (result5 ?? 0.0);
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
          (result5 ?? 0.0);
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
          (result5 ?? 0.0);
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
          (returnResult5 ?? 0.0);
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
          (returnResult5 ?? 0.0);
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
          (returnResult5 ?? 0.0);
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
          (returnResult5 ?? 0.0);
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
          (returnResult5 ?? 0.0);
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
          (returnResult5 ?? 0.0);
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
          (returnResult5 ?? 0.0);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        backgroundColor: Colors.blue, // You can change the color as needed
        automaticallyImplyLeading: false, // Disable default back button
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
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      "$itemName",
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
              child:
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                            width: 60,
                                            child: Text('Sale:',
                                                style:
                                                    Styling.itemGreyTextSmall)),
                                        Text(saleQty.toString(),
                                            style: Styling.itemBlackTestSmall),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 60,
                                            child: Text('Sale Amt.:',
                                                style:
                                                Styling.itemGreyTextSmall)),
                                        Text(amountTotal.toString(),
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
                                            width: 60,
                                            child: Text('SV:',
                                                style:
                                                    Styling.itemGreyTextSmall)),
                                        Text(svQty.toString(),
                                            style: Styling.itemBlackTestSmall),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 60,
                                            child: Text('Exp.Amt.:',
                                                style:
                                                    Styling.itemGreyTextSmall)),
                                        Text(amountTotal.toString(),
                                            style: Styling.itemBlackTestSmall),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 60,
                                            child: Text('TV:',
                                                style:
                                                Styling.itemGreyTextSmall)),
                                        Text(tvQty.toString(),
                                            style: Styling.itemBlackTestSmall),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 60,
                                            child: Text('DM Amt.:',
                                                style:
                                                Styling.itemGreyTextSmall)),
                                        Text(amountTotal.toString(),
                                            style: Styling.itemBlackTestSmall),
                                      ],
                                    ),
                                  ],
                                ),
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
                        _buildTabText('Credit', 2),
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
                  updateSaleAddEditForMob();

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
                    'Save',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add Expense action
          // _showExpenseDialog(context,delBoyNameName!,vehicleNos!);
        },
        backgroundColor: Color(0xff1280b3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Exp",style: TextStyle(color: Colors.white,fontSize: 14),),
            Icon(Icons.add, color: Colors.white),
          ],
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
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cylinder Qty with Icon and TextField
                Row(
                  children: [
                    textWidgetBlueColorWithStar("Cylinder Qty:", "*"),
                    // Text(
                    //   'Cylinder Qty:',
                    //     style: Styling.blueClrText
                    // ),
                    SizedBox(width: 10),
                    Container(
                      width: 120,
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
                        onChanged: (value) {
                          setState(() {
                            prepaidQty = int.tryParse(value) ?? 0;
                          });
                          _calculateCylinderAmountPrepaid();
                          _validateQuantities("Prepaid");
                        },
                      ),
                    ),
                  ],
                ),
                // Amount Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text('₹${amountPrepaidCylinder.toStringAsFixed(0)}',
                        style: Styling.itemBlackTest),
                  ],
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),
            // Input field and Add button
            Column(
              children: [
                Row(
                  children: [
                    // Text("Consumer No.:",  style: Styling.blueClrText,),
                    textWidgetBlueColorWithStar("Consumer No.:", "*"),
                    Expanded(
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
                      onPressed:(){
                        if(_qtyControllerPrepaid.text.isNotEmpty){
                       int qtyPrepaid = int.parse(_qtyControllerPrepaid.text) ?? 0;
                       if(_qtyControllerPrepaid.text.isNotEmpty){
                         if(_consumerController.text.isNotEmpty){
                           if(_consumerList.length < qtyPrepaid){
                             _addConsumer();
                           }else{
                             showFlushBar(context,
                                 'Consumer Detail Should Not Be Greater Than Cylinder Qty');
                             _consumerController.clear();
                           }
                         }else{

                         }
                       }else{

                       }
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
                        backgroundColor:
                        MaterialStateProperty.all<Color>(
                            (_qtyControllerPrepaid.text.isNotEmpty && _consumerController.text.isNotEmpty)?
                            Color(0xff1280b3):Color(0xff666666),
                        )
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
              ],
            ),
            const SizedBox(height: 16),

            // Consumer list
            ListView.builder(
              shrinkWrap: true,
              // Ensures the list takes only the required height
              physics: const NeverScrollableScrollPhysics(),
              // Disables inner scrolling
              itemCount: _consumerList.length,
              itemBuilder: (context, index) {
                final consumer = _consumerList[index];
                return Card(
                  child: ListTile(
                    title: Text('Consumer No: ${consumer.consumerNo}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteConsumer(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPrepaidTab() {
  //   return SingleChildScrollView(
  //     child: Padding(
  //       padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Cylinder Qty Section
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   textWidgetBlueColorWithStar("Cylinder Qty:", "*"),
  //                   SizedBox(width: 10),
  //                   Container(
  //                     width: 120,
  //                     child: TextField(
  //                       controller: _qtyControllerPrepaid,
  //                       keyboardType: TextInputType.number,
  //                       inputFormatters: [
  //                         FilteringTextInputFormatter.digitsOnly, // Only digits allowed
  //                         LengthLimitingTextInputFormatter(3), // Limit to 6 characters
  //                       ],
  //                       decoration: InputDecoration(
  //                         labelStyle: TextStyle(color: Colors.blueAccent),
  //                       ),
  //                       textAlign: TextAlign.center,
  //                       style: Styling.itemBlackTest,
  //                       onChanged: (value) {
  //                         _calculateCylinderAmountPrepaid();
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   SizedBox(height: 8),
  //                   Text(
  //                     '₹${amountPrepaidCylinder.toStringAsFixed(0)}',
  //                     style: Styling.itemBlackTest,
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 20),
  //
  //           // Input field and Add button
  //           Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   textWidgetBlueColorWithStar("Consumer No.:", "*"),
  //                   Expanded(
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(16.0),
  //                       child: TextField(
  //                         controller: _consumerController,
  //                         decoration: InputDecoration(
  //                           labelStyle: TextStyle(fontSize: 16, color: Colors.blueAccent),
  //                         ),
  //                         style: TextStyle(fontSize: 18, color: Colors.black),
  //                         textAlign: TextAlign.center,
  //                         keyboardType: TextInputType.number,
  //                         inputFormatters: [
  //                           FilteringTextInputFormatter.digitsOnly, // Only digits allowed
  //                           LengthLimitingTextInputFormatter(6), // Limit to 6 characters
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: _addConsumer,
  //                     style: ButtonStyle(
  //                       backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff1280b3)),
  //                     ),
  //                     child: Text(
  //                       'Add',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 16),
  //
  //           // Container for Static Header and Consumer List
  //           Container(
  //             margin: const EdgeInsets.only(bottom: 8),
  //             padding: const EdgeInsets.all(0),
  //             decoration: BoxDecoration(
  //               border: Border.all(color: Colors.grey),
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Static Header: Consumer Name and Action
  //                 Container(
  //                   margin: const EdgeInsets.only(bottom: 8),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Expanded(
  //                         child: Text(
  //                           'Consumer Name',
  //                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //                       verticalDividerSmall(),
  //                       Expanded(
  //                         child: Text(
  //                           'Action',
  //                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                 // Horizontal Line between header and list
  //                 Divider(
  //                   color: Colors.grey, // Color of the line
  //                   thickness: 1,        // Line thickness
  //                   height: 20,          // Height of the divider (space before and after the line)
  //                 ),
  //
  //                 // ListView.builder for Consumer List
  //                 ListView.builder(
  //                   shrinkWrap: true, // Ensures the list takes only the required height
  //                   physics: const NeverScrollableScrollPhysics(), // Disables inner scrolling
  //                   itemCount: _consumerList.length,
  //                   itemBuilder: (context, index) {
  //                     final consumer = _consumerList[index];
  //
  //                     return Column(
  //                       children: [
  //                         Container(
  //                           margin: const EdgeInsets.only(bottom: 8), // Margin between each consumer row
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Expanded(
  //                                 child: Text(
  //                                   '${consumer.consumerNo}', // Displaying the consumer number
  //                                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                                 ),
  //                               ),
  //                               verticalDividerSmall(),
  //                               Expanded(
  //                                 child: IconButton(
  //                                   icon: const Icon(Icons.delete, color: Colors.red),
  //                                   onPressed: () {
  //                                     _deleteConsumer(index); // Call delete method
  //                                   },
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         Divider(
  //                           color: Colors.grey,      // Line color
  //                           thickness: 1,             // Line thickness
  //                           height: 20,               // Space before and after the line
  //                         ),
  //                       ],
  //                     );
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //
  //
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPostpaidTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cylinder Qty with Icon and TextField
                Row(
                  children: [
                    // Text(
                    //   'Cylinder Qty:',
                    //     style: Styling.blueClrText
                    // ),
                    textWidgetBlueColorWithStar("Cylinder Qty:", "*"),
                    SizedBox(width: 10),
                    Container(
                      width: 120,
                      child: TextField(
                        controller: _qtyControllerPostpaid,
                        keyboardType: TextInputType.number,
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
                        },
                      ),
                    ),
                  ],
                ),
                // Amount Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      '₹${amountPostpaidCylinder.toStringAsFixed(0)}',
                      style: Styling.itemBlackTest,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cylinder Qty with Icon and TextField
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child:
                          // Text(
                          //   'Transaction Reference No:',
                          //     style: Styling.blueClrText
                          // ),
                          textWidgetBlueColorWithStar(
                              "Transaction Code :", "*"),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 150,
                      child: TextField(
                        controller: _transactionCodeControllerPostpaid,
                        maxLength: 30,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.blueAccent),
                        ),

                        textAlign: TextAlign.center,
                        style: Styling.itemBlackTest,
                        onChanged: (value) {
                          // Manually trim spaces at the beginning and end
                          _transactionCodeControllerPostpaid.text = value.trim();
                          _transactionCodeControllerPostpaid.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: _transactionCodeControllerPostpaid
                                      .text.length
                              )
                              );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 150,
                  child:
                  // textWidgetBlueColorWithStar("Time:", "*"),
                  Text(
                    'Time:',
                      style: Styling.blueClrText
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 150,
                  child: TextField(
                    controller: _timeControllerPostpaid,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      suffixIcon: Icon(
                        Icons.access_time,
                        color: Color(0xff1280b3),
                        size: 18,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: Styling.itemBlackTest,
                    onChanged: (value) {},
                    onTap: () {
                      _selectTime(context);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 150,
                  child: Text('Remark:', style: Styling.blueClrText),
                ),
                SizedBox(width: 10),
                Container(
                  width: 150,
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
              height: 20,
            ),
            // Input field and Add button
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed:(){
                        if(_qtyControllerPostpaid.text.isNotEmpty) {
                          if (_transactionCodeControllerPostpaid.text
                              .isNotEmpty) {
                            if (_timeControllerPostpaid.text.isNotEmpty) {
                              int? qtyPostpaid = int.parse(_qtyControllerPostpaid.text);
                              if(qtyPostpaid>_transactionList.length) {
                                _addTransaction();
                              }else{
                                showFlushBar(context,
                                    'Transaction Detail Should Not Be Greater Than Cylinder Qty');
                                _transactionCodeControllerPostpaid.clear();
                                _timeControllerPostpaid.clear();
                                _remarkControllerPostpaid.clear();
                              }
                            }
                          }
                        }
                      } ,
                      style: ButtonStyle(
                          backgroundColor:
                          (_qtyControllerPostpaid.text.isNotEmpty || _qtyControllerPostpaid.text != "")?
                          MaterialStateProperty.all<Color>(
                            Color(0xff1280b3),
                          ):
                          MaterialStateProperty.all<Color>(
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
            Row(
              children: [
                Expanded(flex: 3, child: Center(child: Text("Trans. Code", style: TextStyle(fontWeight: FontWeight.bold)))),
                verticalDividerVerySmall(),
                Expanded(flex: 2, child: Center(child: Text("Time", style: TextStyle(fontWeight: FontWeight.bold)))),
                verticalDividerVerySmall(),
                Expanded(flex: 3, child: Center(child: Text("Remark", style: TextStyle(fontWeight: FontWeight.bold)))),
                verticalDividerVerySmall(),
                Expanded(flex: 2, child: Center(child: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold)))),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              // Ensures the list takes only the required height
              physics: const NeverScrollableScrollPhysics(),
              // Disables inner scrolling
              itemCount: _transactionList.length,
              itemBuilder: (context, index) {
                final transaction = _transactionList[index];
                return
                  Row(
                    children: [
                      // Column 1: Item Name
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding:EdgeInsets.only(left: 5.0),
                          child: Text(
                            transaction.transactionCode.toString(),
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ),
                      ),
                      verticalDividerVerySmall(),
                      // Column 2: Filled
                      Expanded(
                        flex: 2,
                        child: Text(
                          transaction.transTime.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalDividerVerySmall(),
                      // Column 3: SV
                      Expanded(
                        flex: 2,
                        child: Text(
                          transaction.remark.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalDividerVerySmall(),
                      // Column 4: TV
                      Expanded(
                        flex: 2,
                        child: Icon(
                          Icons.delete
                        ),
                      ),
                    ],
                  );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCreditTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cylinder Quantity Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cylinder Qty with Icon and TextField
                Row(
                  children: [
                    SizedBox(width: 8),
                    SizedBox(
                      width: 120,
                      child: textWidgetBlueColorWithStar("Cylinder Qty:", "*"),
                      // Text(
                      //   'Cylinder Qty:',
                      //     style: Styling.blueClrText
                      // ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 120,
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
                          });
                          _calculateCylinderAmountCredit();
                          _validateQuantities("Credit");
                        },
                      ),
                    ),
                  ],
                ),
                // Amount Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      '₹${amountCreditCylinder.toStringAsFixed(0)}',
                      style: Styling.itemBlackTest,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Payment Mode Section
            Row(
              children: [
                SizedBox(width: 8),
                SizedBox(
                  width: 150,
                  child: textWidgetBlueColorWithStar("Payment Mode:", "*"),
                  //   Text(
                  //     'Payment Mode:',
                  //       style: Styling.blueClrText                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    ),
                    style: Styling.itemBlackTest,
                    items: ['Cash', 'Bank']
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMode = value; // Update selected value
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Vendor Name Section
            Row(
              children: [
                Row(
                  children: [
                    SizedBox(width: 8),
                    SizedBox(
                      width: 150,
                      child: textWidgetBlueColorWithStar("Vendor Name:", "*"),
                      // Text(
                      //   'Vendor Name:',
                      //     style: Styling.blueClrText),
                    ),
                  ],
                ),
                Container(
                  width: 200,
                  child: DropdownButtonFormField<GetVendorDetailListModel>(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    ),
                    style: Styling.itemBlackTest,
                    items: getVendorDetailListModel
                        .map((GetVendorDetailListModel vendor) {
                      return DropdownMenuItem<GetVendorDetailListModel>(
                        value: vendor,
                        child: Text(vendor.vendorName ?? ''),
                      );
                    }).toList(),
                    onChanged: (GetVendorDetailListModel? selectedVendor) {
                      if (selectedVendor != null) {
                        selectedVendorName = selectedVendor.vendorName;
                        selectedVendorId = selectedVendor.vendorId?.toInt();
                        // Handle dropdown selection here
                        print("Selected Vendor Name: $selectedVendorName");
                        print("Selected Vendor ID: $selectedVendorId");
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Qty and Amount Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Qty Field
                Row(
                  children: [
                    SizedBox(width: 8),
                    textWidgetBlueColorWithStar("Qty:", "*"),
                    // Text(
                    //   'Qty:',
                    //     style: Styling.blueClrText                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 50,
                      child: TextField(
                        controller: _vendorCylinderQtyControllerCredit,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        style: Styling.itemBlackTest,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          int qtyVendorCylinder = int.parse(_vendorCylinderQtyControllerCredit.text);
                          if(_qtyControllerCredit.text.isNotEmpty){
                          int qtyCredit= int.parse(_qtyControllerCredit.text);
                          if(qtyVendorCylinder > qtyCredit){
                            showFlushBar(context,
                                'Quantity Should Not Be Greater Than Cylinder Qty');
                            _vendorCylinderQtyControllerCredit.clear();
                          }
                          }
                          setState(() {
                            _calculateCylinderAmountCreditByVendor();
                            // Update selected value
                          }
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // Amount Field
                Row(
                  children: [
                    SizedBox(width: 8),
                    textWidgetBlueColorWithStar("Amount:", "*"),

                    // Text(
                    //   'Amount:',
                    //     style: Styling.blueClrText                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 100,
                      child: Text(
                        '₹${amountCreditCylinderByVendor.toStringAsFixed(0)}',

                        // controller: _vendorCylinderAmountControllerCredit,
                        // keyboardType: TextInputType.number,
                        // decoration: InputDecoration(
                        //   hintStyle: TextStyle(color: Colors.grey),
                        //   contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        // ),
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.digitsOnly,
                        // ],
                        // textAlign: TextAlign.center,
                        // style: Styling.itemBlackTest,
                        // enabled: false,
                        // onChanged: (value) {
                        // },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Remark Section
            Row(
              children: [
                SizedBox(width: 8),
                Text('Remark:', style: Styling.blueClrText),
                SizedBox(width: 10),
                Container(
                  width: 150,
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
                  onPressed:(){
                    if(_qtyControllerCredit.text.isNotEmpty){
                      if(selectedPaymentMode!=null){
                        if(selectedVendorName !=null){
                          if(_vendorCylinderQtyControllerCredit.text.isNotEmpty){
                            int qtyCredit = int.parse(_qtyControllerCredit.text);
                            if(qtyCredit > _reticulatedList.length){
                              _addReticulated();
                            }else{
                              showFlushBar(context,
                                  'Vendor Detail Should Not Be Greater Than Cylinder Qty');
                              _vendorCylinderQtyControllerCredit.clear();
                              selectedPaymentMode = '';
                              selectedVendorName = '';
                            }
                          }
                        }
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        _qtyControllerCredit.text.isNotEmpty?
                        Color(0xff1280b3): Color(0xff666666)),
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

            // Reticulated List Section (ListView)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reticulatedList.length,
              itemBuilder: (context, index) {
                final reticulatedItem = _reticulatedList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Wrap each Text widget in an Expanded widget to prevent overflow
                        Expanded(
                          child: Text(
                            'Vendor Name: ${reticulatedItem.vendorName}',
                            overflow: TextOverflow
                                .ellipsis, // This will add "..." if text overflows
                          ),
                        ),
                        SizedBox(width: 8),
                        // Add spacing between the texts
                        Expanded(
                          child: Text(
                            'Qty: ${reticulatedItem.quantity}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '₹${reticulatedItem.amount}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Payment Mode: ${reticulatedItem.paymentMode}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteReticulated(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cylinder Qty with Icon and TextField
                Row(
                  children: [
                    textWidgetBlueColorWithStar("Cylinder Qty:", "*"),
                    // Text(
                    //   'Cylinder Qty:',
                    //     style: Styling.blueClrText
                    // ),
                    SizedBox(width: 10),
                    Container(
                      width: 120,
                      child: TextField(
                        controller: _qtyControllerCash,
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
                            cashQty = int.tryParse(value) ?? 0;
                          });
                          _calculateCylinderAmountCasht();
                          calculateBalanceAmountForReceiveAmountCash();
                          _validateQuantities("Cash");
                        },
                      ),
                    ),
                  ],
                ),
                // Amount Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      '₹${amountCashCylinder.toStringAsFixed(0)}',
                      style: Styling.itemBlackTest,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cylinder Qty with Icon and TextField
                Row(
                  children: [
                    textWidgetBlueColorWithStar("Total Expected Amt.:", "*"),
                    // Text(
                    //   'Cylinder Qty:',
                    //     style: Styling.blueClrText
                    // ),
                    SizedBox(width: 10),
                    Container(
                      width: 120,
                      child: TextField(
                        controller: _totalExpectedAmountCash,
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
                          calculateBalanceAmountForReceiveAmountCash();
                        },
                        enabled: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cylinder Qty with Icon and TextField
                Row(
                  children: [
                    textWidgetBlueColorWithStar("Total Receive Amt.:", "*"),
                    // Text(
                    //   'Cylinder Qty:',
                    //     style: Styling.blueClrText
                    // ),
                    SizedBox(width: 10),
                    Container(
                      width: 120,
                      child: TextField(
                        controller: _totalReceivedAmountCash,
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
                          calculateBalanceAmountForReceiveAmountCash();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cylinder Qty with Icon and TextField
                Row(
                  children: [
                    textWidgetBlueColorWithStar("Balance:", "*"),
                    // Text(
                    //   'Cylinder Qty:',
                    //     style: Styling.blueClrText
                    // ),
                    SizedBox(width: 10),
                    Container(
                      width: 120,
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
              ],
            ),
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
                                total.toStringAsFixed(0),
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
                                finalsAmount.toStringAsFixed(0),
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
                                  return
                                    TextField(
                                      controller: returnQuantity200Controller,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal, fontSize: 16),
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
                                  return
                                    TextField(
                                      controller: returnQuantity100Controller,
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
                                          int.parse(
                                              quantity50Controller.text) >
                                              0;
                                  return
                                    TextField(
                                      controller: returnQuantity50Controller,
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
                                          int.parse(
                                              quantity20Controller.text) >
                                              0;
                                  return
                                    TextField(
                                      controller: returnQuantity20Controller,
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
                                          int.parse(
                                              quantity10Controller.text) >
                                              0;
                                  return
                                    TextField(
                                      controller: returnQuantity10Controller,
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
                                          int.parse(
                                              quantity5Controller.text) >
                                              0;
                                  return
                                    TextField(
                                      controller: returnQuantity5Controller,
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
                                returnTotal.toStringAsFixed(0),
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
                                finalsAmount.toStringAsFixed(0),
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

  // void _addConsumer() {
  //   if (_consumerController.text.isNotEmpty) {
  //     setState(() {
  //       // Creating a ConsumerModel instance with the consumer number
  //       _consumerList.add(
  //         ConsumerModel(
  //           consumerNo: _consumerController.text,
  //           addedOn: DateTime.now(),
  //           // Add other required fields such as addedBy, action, etc.
  //         ),
  //       );
  //       _consumerController.clear();
  //     });
  //   }
  // }

  ///Prepaid
  Future<void> _addConsumer() async {
    if (_consumerController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      String? StaffId = prefs.getString('StaffId');
      int? staffIds = int.parse(StaffId!);
      int? distributorIds = int.parse(distributorId!);
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
            consumerNo: _consumerController.text,
            addedOn: DateTime.now(),
            action: "Add",
            // Specify the action like "Added" or "Updated"
            addedBy: staffIds, // Replace with the actual addedBy value
          ),
        );
        _consumerController.clear();
      });
    }
  }

  void _deleteConsumer(int index) {
    setState(() {
      _consumerList.removeAt(index);
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
            addedOn: DateTime.now(),
            action: "Added",
            // Example action
            addedBy: staffIds, // Example, replace with actual value
          ),
        );
        _transactionCodeControllerPostpaid.clear();
        _timeControllerPostpaid.clear();
        _remarkControllerPostpaid.clear();
      });
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
            amount: amountCreditCylinderByVendor.toInt(),
            vendorId: selectedVendorId,
            // Replace with actual value
            vendorName: selectedVendorName,
            reticulatedRemark: _remarkControllerCredit.text,
            addedOn: DateTime.now(),
            action: "Add",
            // Example action
            addedBy: staffIds, // Example value
          ),
        );
        selectedVendorName = "";
        _vendorCylinderQtyControllerCredit.clear();
        // _vendorCylinderAmountControllerCredit.clear();
        selectedPaymentMode = "";
        _remarkControllerCredit.clear();
      });
    }
  }

  void _deleteReticulated(int index) {
    setState(() {
      _reticulatedList.removeAt(index);
    });
  }

  ///Amount Calculate
  void _calculateCylinderAmountPrepaid() {
    // Get the entered quantity and calculate the total amount
    double qty = double.tryParse(_qtyControllerPrepaid.text) ?? 0;
    setState(() {
      amountPrepaidCylinder = qty * itemRates!;
    });
  }

  void _calculateCylinderAmountPostpaid() {
    // Get the entered quantity and calculate the total amount
    double qty = double.tryParse(_qtyControllerPostpaid.text) ?? 0;
    setState(() {
      amountPostpaidCylinder = qty * itemRates!;
    });
  }

  void _calculateCylinderAmountCredit() {
    // Get the entered quantity and calculate the total amount
    double qty = double.tryParse(_qtyControllerCredit.text) ?? 0;
    setState(() {
      amountCreditCylinder = qty * itemRates!;
    });
  }

  void _calculateCylinderAmountCreditByVendor() {
    // Get the entered quantity and calculate the total amount
    double qty = double.tryParse(_vendorCylinderQtyControllerCredit.text) ?? 0;
    setState(() {
      amountCreditCylinderByVendor = qty * itemRates!;
    });
  }

  void _calculateCylinderAmountCasht() {
    // Get the entered quantity and calculate the total amount
    double qty = double.tryParse(_qtyControllerCash.text) ?? 0;
    setState(() {
      amountCashCylinder = qty * itemRates!;
      double amountCashCylinders = qty * itemRates!;
      _totalExpectedAmountCash.text = amountCashCylinders.toStringAsFixed(0);
    });
  }

// Call this function whenever needed to calculate and update the balance.
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
    _totalBalanceAmountCash.text = balanceAmount.toStringAsFixed(0);
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

  Future<void> fetchVendorDetails() async {
    Constants.isNetworkAvailable =
        await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(
          context, Constants.connectionMessage);
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
          Uri.parse('${AppUrl.GetVendorMasterList}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body GetVendorMasterList: ${response.body}");
        debugPrint("request body GetVendorMasterList: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          // return data
          //     .map((jsonItem) => DailySaleSaummaryListModel.fromJson(jsonItem))
          //     .toList();
          setState(() {
            getVendorDetailListModel = data
                .map((jsonItem) => GetVendorDetailListModel.fromJson(jsonItem))
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

  Future<void> updateSaleAddEditForMob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? StaffId = prefs.getString('StaffId');
    int? staffIds = int.parse(StaffId!);
    int? distributorIds = int.parse(distributorId!);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final String consumerNumbers =
        getConsumerNumbersAsCommaSeparatedString(_consumerList);
    final List<Map<String, dynamic>> consumerDtls =
        _consumerList.map((e) => e.toJson()).toList();
    final List<Map<String, dynamic>> postpaidDtls =
        _transactionList.map((e) => e.toJson()).toList();
    final List<Map<String, dynamic>> reticulatedDtls =
        _reticulatedList.map((e) => e.toJson()).toList();
    int? qtyControllerPrepaids = int.parse(_qtyControllerPrepaid.text);
    int? qtyControllerPostpaids = int.parse(_qtyControllerPostpaid.text);
    int? qtyControllerCredits = int.parse(_qtyControllerCredit.text);
    int? qtyControllerCashs = int.parse(_qtyControllerCash.text);
    prepareDenominationData(
        getNoteTypeAndIdFroDenominationListModel);
    // Request body
    final Map<String, dynamic> requestBody = {
      "pkId": 0,
      "id": 0,
      "PPId": 0,
      "RetiId": 0,
      "DSCollMgrId": 0,
      "CollRcptDate": formattedDate,
      "SaleGKId": salesGkId,
      "SaleGKItemId": sakesGKItemID,
      "Rate": itemRates,
      "DailySaleStatus": 5,
      "DenoCashExptd": 500,
      "DenoCashRcvd": 480,
      "CashBalance": 20,
      "VehicleId": vehicleID,
      "DistributorId": distributorIds,
      "PrepaidCons": consumerNumbers,
      "ItemId": itemIDs,
      "StaffId": delBoyIDs,
      "PrepaidQty": qtyControllerPrepaids,
      "PrepaidAmt": amountPrepaidCylinder,
      "ConsumerNo": 0,
      "OnlineQty": qtyControllerPostpaids,
      "OnlineAmt": amountPostpaidCylinder,
      "TransactionDtls": 0,
      "TransactionTime": 0,
      "OnlineRemark": 0,
      "CashQty": qtyControllerCashs,
      "CashAmt": amountCashCylinder,
      "TotalCashReceived": 0,
      "PaymentMode": 0,
      "ReticulatedQty": qtyControllerCredits,
      "ReticulatedAmt": amountCreditCylinder,
      "ReticulatedRemark": 0,
      "CashDenomDtls":_denomModelList,
      "consumerDtls": 0,
      "PostpaidDtls": postpaidDtls,
      "ReticulatedDtls": reticulatedDtls
    };

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
      print("response: ${response.statusCode} - ${response.body}");
      print("requestBody: ${response.statusCode} - ${response.request}${requestBody}");
      // Handling response
      if (response.statusCode == 200) {
        // Successful response
        print("Response: ${response.body}");
      } else {
        // Error response
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      // Exception handling
      print("Exception: $e");
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

  Future<void> fetchExpenseDetailList() async {
    Constants.isNetworkAvailable =
        await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(
          context, Constants.connectionMessage);
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
              '${AppUrl.GetExpenseDetailsListByStaffId}/$distributorId/$delBoyIDs'),
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
          int expenseDetailList = 0;

          for (var i = 0; i < getExpenseDetailListModel!.length; i++) {
            int? getExpenseDetailList =
                getExpenseDetailListModel![i].expAmount?.toInt();
            expenseDetailList += getExpenseDetailList!;
          }
          debugPrint("Response body expenseDetailList: ${expenseDetailList}");
          expenseAmtTotal = expenseDetailList;
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

  // Validate the sum of all quantities
  void _validateQuantities(String payMode) {
    int totalQty = prepaidQty + postpaidQty + creditQty + cashQty;

    // Check if the total of all entered quantities exceeds the saleQty
    if (totalQty > saleQty!) {
      // If it exceeds, show an error message or reset the value
      showErrorDialog('Total quantity cannot exceed sale quantity.');
      _clearExcessQuantity(payMode);
    } else {
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

  // Function to clear the excess quantity in the last modified field
  void _clearExcessQuantity(String payModes) {
    if (prepaidQty + postpaidQty + creditQty + cashQty > saleQty!) {
      // You can check which controller exceeds the limit and clear it.
      if (prepaidQty + postpaidQty + creditQty + cashQty > saleQty!) {
        // Check which field to clear
        if (payModes == "Prepaid" && prepaidQty > 0 &&
            prepaidQty + postpaidQty + creditQty + cashQty > saleQty!) {
          _qtyControllerPrepaid.clear();
          amountPrepaidCylinder = 0;
          prepaidQty = 0; // Reset the value
          debugPrint("prepaid");
        } else if (payModes == "Postpaid" && postpaidQty > 0 &&
            prepaidQty + postpaidQty + creditQty + cashQty > saleQty!) {
          _qtyControllerPostpaid.clear();
          amountPostpaidCylinder = 0;
          postpaidQty = 0;
          debugPrint("postpaid");
        } else if (payModes == "Credit" && creditQty > 0 &&
            prepaidQty + postpaidQty + creditQty + cashQty > saleQty!) {
          _qtyControllerCredit.clear();
          amountCreditCylinder = 0;
          creditQty = 0;
          debugPrint("credit");
        } else if (payModes == "Cash" && cashQty > 0 &&
            prepaidQty + postpaidQty + creditQty + cashQty > saleQty!) {
          _qtyControllerCash.clear();
          amountCashCylinder = 0;
          cashQty = 0;
          debugPrint("Cash");
        }
      }
    }
  }

  List<DenomModel> prepareDenominationData(
      List<GetNoteTypeAndIdFroDenominationListModel>
          getNoteTypeAndIdFroDenominationListModel) {
    _denomModelList.clear(); // Ensure the list is initialized empty

    // Mapping controllers to note types
    Map<int, TextEditingController> quantityControllers = {
      500: quantity500Controller,
      200: quantity200Controller,
      100: quantity100Controller,
      50: quantity50Controller,
      20: quantity20Controller,
      10: quantity10Controller,
      5: quantity5Controller,
    };

    Map<int, TextEditingController> returnQuantityControllers = {
      500: returnQuantity500Controller,
      200: returnQuantity200Controller,
      100: returnQuantity100Controller,
      50: returnQuantity50Controller,
      20: returnQuantity20Controller,
      10: returnQuantity10Controller,
      5: returnQuantity5Controller,
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
      int? totalAmt = quantity != null ? (noteType * quantity) : null;

      int? retQuantity = int.tryParse(
          returnQuantityControllers[noteType]?.text ??
              '0'); // Get return quantity
      int? retTotalAmt = retQuantity != null ? (noteType * retQuantity) : null;

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

  void populateControllers(List<DenomModel> denomList) {
    // Clear all controllers first
    quantity500Controller.clear();
    quantity200Controller.clear();
    quantity100Controller.clear();
    quantity50Controller.clear();
    quantity20Controller.clear();
    quantity10Controller.clear();
    quantity5Controller.clear();

    returnQuantity500Controller.clear();
    returnQuantity200Controller.clear();
    returnQuantity100Controller.clear();
    returnQuantity50Controller.clear();
    returnQuantity20Controller.clear();
    returnQuantity10Controller.clear();
    returnQuantity5Controller.clear();

    // Initialize result variables
    double result500 = 0.0;
    double result200 = 0.0;
    double result100 = 0.0;
    double result50 = 0.0;
    double result20 = 0.0;
    double result10 = 0.0;
    double result5 = 0.0;

    double returnResult500 = 0.0;
    double returnResult200 = 0.0;
    double returnResult100 = 0.0;
    double returnResult50 = 0.0;
    double returnResult20 = 0.0;
    double returnResult10 = 0.0;
    double returnResult5 = 0.0;

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
      }
    }

    // Debug print to verify results
    debugPrint("Controllers populated with data: $denomList");
    debugPrint(
        "Results - Total: [500: $result500, 200: $result200, 100: $result100, 50: $result50, 20: $result20, 10: $result10, 5: $result5]");
    debugPrint(
        "Results - Return: [500: $returnResult500, 200: $returnResult200, 100: $returnResult100, 50: $returnResult50, 20: $returnResult20, 10: $returnResult10, 5: $returnResult5]");
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

  Color _getButtonColor() {
      if ((_qtyControllerPostpaid.text.isNotEmpty) && (_transactionCodeControllerPostpaid.text.isNotEmpty)
          && (_timeControllerPostpaid.text.isNotEmpty)) {
        return Colors.blue;
      }
      return Colors.grey;
  }
}
