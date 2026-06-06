import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../Database/GodownKeeperDB/UpdateRefillSaleDB.dart';
import '../../ConstantScreen/widgets.dart';
import '../../DashboardModel/TodaysOpeningStockDataModel.dart';
import '../../ManagerScreen/ManagerModelClass/GetConsumerDetailsCredit.dart';
import '../../User/Login/provider/LoginProvider.dart';
import '../../User/splashscreen/page/splash_screen.dart';
import '../../Utils/CustomAppBar.dart';
import '../../Utils/CustomeAlertDialog.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/size_config.dart';
import '../../Utils/styles/app_spacing.dart';
import '../BottomNavigationForGodownKeeper.dart';
import '../DashboardScreen.dart';
import '../DeliveryBoyModel/DeliveryBoyInfoModel.dart';
import '../DeliveryBoyModel/GetSVTVConsumerListModel.dart';
import '../DeliveryBoyModel/GetStockTransferListModel.dart';
import '../DeliveryBoyModel/ItemData.dart';
import '../DeliveryBoyModel/StockSubmitToManagerListModel.dart';
import '../DeliveryBoyModel/VehicleNumberGetModel.dart';
import '../ImbalanceEmpty/ImabalanceEmptyListModel.dart';
import '../ImbalanceEmpty/ImbalanceSheet.dart';
import '../ItemReceipt/CylItemList/CylItemListModel.dart';
import '../ItemReceipt/CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
// import '../../utils/BoxShadow/styles.dart';
import '../../Utils/styles/app_colors.dart';
import '../../Utils/styles/app_text_styles.dart';

class DailyRefillSalePage extends StatefulWidget {
  static const screenName = '/stockReturnFromDelBoy';
  final StockSubmitToManagerListModel? sale;
  final num? saleGKId;
  final num? dMId;
  final String? flagAdd;

  const DailyRefillSalePage(
      {required this.sale,
        required this.saleGKId,
        required this.dMId,
        required this.flagAdd});

  @override
  _DailyRefillSalePageState createState() => _DailyRefillSalePageState();
}

class _DailyRefillSalePageState extends State<DailyRefillSalePage> {
  final TextEditingController deliveryDateController = TextEditingController();
  final TextEditingController vehicleNoController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  List<CylItemListModel> _items = [];
  List<DeliveryBoyInfoModel> _delBoyInfo = [];
  String? vehicleNo;
  num? vehicleId;
  List<VehicleNumberGetModel> vehicleList = [];
  bool isListViewVisible = false;
  // Map<int, String?> _selectedItems = {};
  List<ImabalanceEmptyListModel> receiptList = [];

  ///sv consumer
  List<GetSvtvConsumerListModel> getSvtvConsumerList = [];
  List<String> consumerNumbers = []; // This will hold the consumer numbers
  List<String> selectedConsumerNumbers = []; // This will store selected consumer numbers
  TextEditingController consumerController = TextEditingController();
  double totalCylinderQty = 0;
  List<int> selectedCylinderQuantities = [];
  List<int> selectedSVUniqueID = [];
  List<String> originalConsumerNumbersSV = [];
  Map<String, int> originalConsumerQtySV = {};
  Map<String, int> originalSVUniqueIdMap = {};
  final TextEditingController svSearchController = TextEditingController();
  String svSearchQuery = '';
  ///tv consumer
  List<GetSvtvConsumerListModel> getSvtvConsumerListTV = [];
  List<String> consumerNumbersTV = [];
  List<String> selectedConsumerNumbersTV = []; // This will store selected consumer numbers
  TextEditingController consumerControllerTV = TextEditingController();
  double totalCylinderQtyTV = 0;
  List<int> selectedCylinderQuantitiesTV = [];
  List<String> originalConsumerNumbersTV = [];
  Map<String, int> originalConsumerQtyTV = {};
  final TextEditingController tvSearchController = TextEditingController();
  String tvSearchQuery = '';
  bool isLoading = true;
  List<ItemData> data = []; // List to hold rows for the DataTable
  List<ItemData> newList = [];
  late Future<List<ItemData>> itemList;
  int? _editingItemId;
  CylItemListModel? _selectedItemModel;
  bool isPhysicalStockListViewVisible = false;
  int? imbalaceSum = 0;
  List<String> selectedConsumers =['Consumer 1', 'Consumer 2', 'Consumer 3', 'Consumer 4', 'Consumer 5'];

  // Controllers for each text field
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _filledController = TextEditingController();
  final TextEditingController _svController = TextEditingController();
  final TextEditingController _tvController = TextEditingController();
  final TextEditingController _emptyController = TextEditingController();
  final TextEditingController _defectiveController = TextEditingController();
  final TextEditingController _lessEmptyController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _svRemarkController = TextEditingController();
  final TextEditingController _tvRemarkController = TextEditingController();

  bool isDeliverySelected = false;
  bool isCustomerSelected = false;
  List<GetConsumerDetailsCredit> getConsumerCreditDetailListModel = [];
  GetConsumerDetailsCredit? selectedCustomerModel;
  String? selectedVendorName;
  int? selectedVendorId;
  final TextEditingController _totalImbalanceQtyDMCustomer = TextEditingController();
  final TextEditingController _totalImbalanceQtyDMQty= TextEditingController();
  List<Map<String, dynamic>> entries = [];
  List<int> selectedConsumerIDLessEmpty = [];
  List<int> selectedConsumerQtyLessEmpty = [];
  List<String> selectedCustomerNamesLessEmpty = []; // optional for display
  int? remainingDMQty;
  int? editModeRemainQty;
  int? oldLessEmptyQty;
  int? initialDMQty;

  String? _selectedItem;
  int? selectedItemId;
  String? selectedDelBoyName;
  int? selectedDelBoyId;
  bool isVisible = true;
  List<String> remarksList = [];
  List<String> tvConsumerList = [];
  UpdateRefillSale? updateRefillSale;
  List<ItemData> itemDetailDelBoy = [];

  List<Map<String, Object?>> _dataGetFromDBDelBoy = [];
  String? mobileNo;// List to store fetched data
  String? flagEditMode;
  late Future<List<StockSubmitToManagerListModel>> stockDataFuture;
  List<Map<String, Object?>> _datastockDataFuture = [];
  List<TodaysOpeningStockDataModel> todaysOpeningStock = [];
  List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
  num? filledStock = 0;
  num? editFilledStock ;
  String? formattedDate;
  var argValue;
  String? delBoyNameName;
  int? delBoyIDs;
  bool stockTransferFlag = false;
  List<GetStockTransferListModel> _stockTransferList = [];
  bool saveFlag = false;

  void _addNewItem() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedDateNew = DateFormat('yyyy-MM-dd').format(now) + 'T00:00:00';
    // Validate input for the empty cylinder count

    if (_emptyController.text.isEmpty) {

      showFlushBar(context,
          'Add Empty Cylinder Count!');
    } else {
      // Parse all input values to integers (default to 0 if empty)
      int filledValue = int.tryParse(_filledController.text) ?? 0;
      int svValue = int.tryParse(_svController.text) ?? 0;
      int tvValue = int.tryParse(_tvController.text) ?? 0;
      int emptyValue = int.tryParse(_emptyController.text) ?? 0;
      int defectiveValue = int.tryParse(_defectiveController.text) ?? 0;
      int lessEmptyValue = int.tryParse(_lessEmptyController.text) ?? 0;
      debugPrint("filledStock $filledStock");

      if (filledValue <= (filledStock ?? 0)) {
        if (filledValue >= lessEmptyValue) {
          if (filledValue >= svValue) {
            // if (filledValue >= tvValue) {
            if (filledValue >= defectiveValue) {
              if (emptyValue >= 0) {
                // Check if the item already exists for the given deliveryBoyId
                bool itemExists = await updateRefillSale!.checkIfItemExists(
                    selectedItemId.toString(),
                    selectedDelBoyId.toString(),
                    formattedDate);
                bool itemExistInDMDatabaseToday = await updateRefillSale!
                    .checkIfItemExistsInAPIDatabase(
                    selectedItemId.toString(), selectedDelBoyId.toString(),
                    formattedDateNew);
                debugPrint(selectedItemId.toString());
                debugPrint(selectedDelBoyId.toString());
                debugPrint(formattedDate);
                if (itemExists) {
                  showFlushBar(context,
                      Constants.recordAlreadyExist);
                } else {
                  if (itemExistInDMDatabaseToday) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(""),
                          content: Text("Do you want to start a new trip?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(
                                    false); // Cancel deletion
                              },
                              child: Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  List<String> consumerNumberss = getConsumerNumbers();
                                  List<int> cylinderQuantities = getCylinderQuantities();

                                  print("Consumer Numbers: $consumerNumberss");
                                  print("Cylinder Quantities: $cylinderQuantities");

                                  String remarksString = consumerNumberss.isEmpty ? '' : consumerNumberss.join(', ');
                                  print('Sending remarks to API: $remarksString');

                                  String svCounts = cylinderQuantities.isEmpty ? '' : cylinderQuantities.join(', ');
                                  print('Sending remarks to API: $svCounts');

                                  List<int> sVUniqueconsumerNumberss = getSVUniqueConsumerNumbers();
                                  print("Cylinder sVUniqueconsumerNumberss: $sVUniqueconsumerNumberss");
                                  String svUniqueConsString = sVUniqueconsumerNumberss.isEmpty ? '' : sVUniqueconsumerNumberss.join(', ');
                                  print('Sending remarks to API: $svUniqueConsString');

                                  // String tvConsumerNoString = tvConsumerList.isEmpty ? '' : tvConsumerList.join(', ');
                                  // print('Sending tvConsumerNoString to API: $tvConsumerNoString');
                                  List<String> consumerNumberssTV = getConsumerNumbersTV();
                                  List<int> cylinderQuantitiesTV = getCylinderQuantitiesTV();

                                  String tvConsumerNoString = consumerNumberssTV.isEmpty ? '' : consumerNumberssTV.join(', ');
                                  print('Sending tvConsumerNoString to API: $tvConsumerNoString');

                                  String tvCount = cylinderQuantitiesTV.isEmpty ? '' : cylinderQuantitiesTV.join(', ');
                                  print('Sending tvConsumerNoString to API: $tvConsumerNoString');

                                  // List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
                                  // String lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                  //
                                  //
                                  // List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
                                  // String lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                  //
                                  // List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
                                  // String lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                  // String lessEmptyDMQty =  _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;

                                  // Ensure that all fields have valid values
                                  String filledValue = _filledController.text.isEmpty ? '' : _filledController.text;
                                  String svValue =
                                  _svController.text.isEmpty ? '' : _svController
                                      .text;
                                  String tvValue =
                                  _tvController.text.isEmpty ? '' : _tvController
                                      .text;
                                  String emptyValue = _emptyController.text
                                      .isEmpty
                                      ? ''
                                      : _emptyController.text;
                                  String defectiveValue = _defectiveController
                                      .text.isEmpty
                                      ? ''
                                      : _defectiveController.text;
                                  // String lessEmptyValue = _lessEmptyController
                                  //     .text.isEmpty
                                  //     ? ''
                                  //     : _lessEmptyController.text;

                                  String lessEmptyValue = _lessEmptyController.text.trim().isEmpty
                                      ? '0'
                                      : _lessEmptyController.text.trim();

                                  String remarkValue = _remarkController.text
                                      .isEmpty
                                      ? ''
                                      : _remarkController.text;
                                  //int lessEmpt= int.parse(lessEmptyValue);
                                  int lessEmpt = int.tryParse(lessEmptyValue) ?? 0;


                                  List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
                                  String lessEmptyConsIdString = '';

                                  List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
                                  String lessEmptyConsNameString = '';

                                  List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
                                  String lessEmptyConsQtyString = '';
                                  String lessEmptyDMQty = '';

                                  if(lessEmpt > 0){
                                    int customerTotal = lessEmptyConsumerQty.fold(0, (sum, item) => sum + item);
                                    int dmQty = int.tryParse(_totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text) ?? 0;
                                    int totalUsedQty = (dmQty ?? 0) + customerTotal;
                                    int enteredQty = int.tryParse(_lessEmptyController.text) ?? 0;
                                    if(totalUsedQty != enteredQty){
                                      showFlushBar(context, "Less Empty Quantity Must Be Equal To Custome And DM Quantity..");
                                      return;
                                    }

                                    if(isDeliverySelected == true && isCustomerSelected == true){
                                      if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                        showFlushBar(context, "Select Customer For Imbalance.");
                                        return;
                                      }
                                      lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                                      lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                      lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                      lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                    }else if(isDeliverySelected == true && isCustomerSelected == false){
                                      lessEmptyDMQty = _lessEmptyController.text.isEmpty ? '' : _lessEmptyController.text;
                                      lessEmptyConsIdString = '';
                                      lessEmptyConsNameString = '';
                                      lessEmptyConsQtyString = '';
                                    }else if(isDeliverySelected == false && isCustomerSelected == false){
                                      if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                        showFlushBar(context, "Select Customer or Delivery Men For Imbalance.");
                                        return;
                                      }
                                    }else if(isDeliverySelected == false && isCustomerSelected == true){
                                      if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                        showFlushBar(context, "Select Customer For Imbalance.");
                                        return;
                                      }
                                      lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                                      lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                      lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                      lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                    }
                                  }else{
                                    lessEmptyDMQty = '';
                                    lessEmptyConsIdString = '';
                                    lessEmptyConsNameString = '';
                                    lessEmptyConsQtyString = '';
                                  }
                                  // Create an ItemData object from the input fields
                                  ItemData newItem = ItemData(
                                    date: deliveryDateController.text,
                                    deliveryBoyName: selectedDelBoyName
                                        .toString(),
                                    delBoyId: selectedDelBoyId.toString(),
                                    vehicleNo: vehicleNo.toString() ?? '',

                                    // Handle empty vehicle number
                                    itemName: _selectedItem.toString(),
                                    itemID: selectedItemId.toString(),
                                    filled: filledValue,
                                    sv: svValue,
                                    tv: tvValue,
                                    empty: emptyValue,
                                    defective: defectiveValue,
                                    lessEmpty: lessEmptyValue,
                                    remark: remarkValue,
                                    svRemark: remarksString,
                                    svCount: svCounts,
                                    tvConsumerNo: tvConsumerNoString,
                                    tvCount: tvCount,
                                    updateFlag: 'pending',
                                    itemAddedDate: formattedDate,
                                    sVUniqueId: svUniqueConsString,
                                    lessEmptyCustomer: lessEmptyConsNameString,
                                    lessEmptyDMCount: lessEmptyDMQty,
                                    lessEmptyCustomerCount: lessEmptyConsQtyString,
                                    lessEmptyCustomerId: lessEmptyConsIdString,
                                  );

                                  // Insert the ItemData object into the database
                                  updateRefillSale?.insertUpdateRefillSale(
                                      [newItem]);

                                  setState(() {
                                    fetchData(selectedDelBoyId.toString(),
                                        deliveryDateController.text);

                                    _selectedItemModel =
                                    null; // Clear the selected item in the dropdown
                                    _selectedItem = '';
                                  });

                                  // Clear the input fields after adding the item
                                  _filledController.clear();
                                  _svController.clear();
                                  _tvController.clear();
                                  _emptyController.clear();
                                  _defectiveController.clear();
                                  _lessEmptyController.clear();
                                  _remarkController.clear();
                                  _svRemarkController.clear();
                                  remarksList.clear();
                                  tvConsumerList.clear();
                                  selectedConsumerNumbers.clear();
                                  selectedCylinderQuantities.clear();
                                  selectedSVUniqueID.clear();
                                  totalCylinderQty = 0;
                                  selectedConsumerNumbersTV.clear();
                                  selectedCylinderQuantitiesTV.clear();
                                  totalCylinderQtyTV = 0;
                                  originalConsumerNumbersTV.clear();
                                  originalConsumerQtySV.clear();
                                  originalConsumerQtyTV.clear();
                                  originalConsumerNumbersSV.clear();
                                  originalSVUniqueIdMap.clear();
                                  selectedConsumerIDLessEmpty.clear();
                                  selectedConsumerQtyLessEmpty.clear();
                                  selectedCustomerNamesLessEmpty.clear();
                                  _totalImbalanceQtyDMQty.clear();
                                  _totalImbalanceQtyDMCustomer.clear();
                                  isDeliverySelected = false;
                                  isCustomerSelected = false;
                                }
                                );
                                Navigator.of(context).pop(
                                    true); // Proceed with deletion
                              },
                              child: Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else {
                    setState(() {

                      List<String> consumerNumberss = getConsumerNumbers();
                      List<int> cylinderQuantities = getCylinderQuantities();

                      print("Consumer Numbers: $consumerNumberss");
                      print("Cylinder Quantities: $cylinderQuantities");

                      String remarksString = consumerNumberss.isEmpty ? '' : consumerNumberss.join(', ');
                      print('Sending remarks to API: $remarksString');

                      String svCounts = cylinderQuantities.isEmpty ? '' : cylinderQuantities.join(', ');
                      print('Sending remarks to API: $svCounts');

                      List<int> sVUniqueconsumerNumberss = getSVUniqueConsumerNumbers();
                      print("Cylinder sVUniqueconsumerNumberss: $sVUniqueconsumerNumberss");
                      String svUniqueConsString = sVUniqueconsumerNumberss.isEmpty ? '' : sVUniqueconsumerNumberss.join(', ');
                      print('Sending remarks to API: $svUniqueConsString');

                      ///tv
                      List<String> consumerNumberssTV = getConsumerNumbersTV();
                      List<int> cylinderQuantitiesTV = getCylinderQuantitiesTV();

                      String tvConsumerNoString = consumerNumberssTV.isEmpty ? '' : consumerNumberssTV.join(', ');
                      print('Sending tvConsumerNoString to API: $tvConsumerNoString');

                      String tvCount = cylinderQuantitiesTV.isEmpty ? '' : cylinderQuantitiesTV.join(', ');
                      print('Sending tvConsumerNoString to API: $tvConsumerNoString');

                      // List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
                      // String lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                      //
                      //
                      // List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
                      // String lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                      //
                      // List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
                      // String lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                      // String lessEmptyDMQty =  _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                      // Ensure that all fields have valid values
                      String filledValue = _filledController.text.isEmpty
                          ? ''
                          : _filledController.text;
                      String svValue =
                      _svController.text.isEmpty ? '' : _svController.text;
                      String tvValue =
                      _tvController.text.isEmpty ? '' : _tvController.text;
                      String emptyValue = _emptyController.text.isEmpty
                          ? ''
                          : _emptyController.text;
                      String defectiveValue = _defectiveController.text.isEmpty
                          ? ''
                          : _defectiveController.text;

                      // String lessEmptyValue = _lessEmptyController.text.isEmpty
                      //     ? ''
                      //     : _lessEmptyController.text;

                      String lessEmptyValue = _lessEmptyController.text.trim().isEmpty
                          ? '0'
                          : _lessEmptyController.text.trim();

                      String remarkValue = _remarkController.text.isEmpty
                          ? ''
                          : _remarkController.text;
                      //int lessEmpt= int.parse(lessEmptyValue);
                      int lessEmpt = int.tryParse(lessEmptyValue) ?? 0;

                      List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
                      String lessEmptyConsIdString = '';

                      List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
                      String lessEmptyConsNameString = '';

                      List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
                      String lessEmptyConsQtyString = '';
                      String lessEmptyDMQty = '';

                      if(lessEmpt > 0){
                        int customerTotal = lessEmptyConsumerQty.fold(0, (sum, item) => sum + item);
                        int dmQty = int.tryParse(_totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text) ?? 0;
                        int totalUsedQty = (dmQty ?? 0) + customerTotal;
                        int enteredQty = int.tryParse(_lessEmptyController.text) ?? 0;
                        if(totalUsedQty != enteredQty){
                          showFlushBar(context, "Less Empty Quantity Must Be Equal To Custome And DM Quantity..");
                          return;
                        }
                        if(isDeliverySelected == true && isCustomerSelected == true){
                          if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                            showFlushBar(context, "Select Customer For Imbalance.");
                            return;
                          }
                          lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                          lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                          lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                          lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                        }else if(isDeliverySelected == true && isCustomerSelected == false){
                          lessEmptyDMQty = _lessEmptyController.text.isEmpty ? '' : _lessEmptyController.text;
                          lessEmptyConsIdString = '';
                          lessEmptyConsNameString = '';
                          lessEmptyConsQtyString = '';
                        }else if(isDeliverySelected == false && isCustomerSelected == false){
                          if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                            showFlushBar(context, "Select Customer or Delivery Men For Imbalance.");
                            return;
                          }
                        }else if(isDeliverySelected == false && isCustomerSelected == true){
                          if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                            showFlushBar(context, "Select Customer For Imbalance.");
                            return;
                          }
                          lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                          lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                          lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                          lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                        }
                      }else{
                        lessEmptyDMQty = '';
                        lessEmptyConsIdString = '';
                        lessEmptyConsNameString = '';
                        lessEmptyConsQtyString = '';
                      }
                      // Create an ItemData object from the input fields
                      ItemData newItem = ItemData(
                        date: deliveryDateController.text,
                        deliveryBoyName: selectedDelBoyName.toString(),
                        delBoyId: selectedDelBoyId.toString(),
                        vehicleNo: vehicleNo.toString() ?? '',
                        // Handle empty vehicle number
                        itemName: _selectedItem.toString(),
                        itemID: selectedItemId.toString(),
                        filled: filledValue,
                        sv: svValue,
                        tv: tvValue,
                        empty: emptyValue,
                        defective: defectiveValue,
                        lessEmpty: lessEmptyValue,
                        remark: remarkValue,
                        svRemark: remarksString,
                        svCount: svCounts,
                        tvConsumerNo: tvConsumerNoString,
                        tvCount: tvCount,
                        updateFlag: 'pending',
                        itemAddedDate: formattedDate,
                        sVUniqueId: svUniqueConsString,
                        lessEmptyCustomer: lessEmptyConsNameString,
                        lessEmptyDMCount: lessEmptyDMQty,
                        lessEmptyCustomerCount: lessEmptyConsQtyString,
                        lessEmptyCustomerId: lessEmptyConsIdString,
                      );

                      // Insert the ItemData object into the database
                      updateRefillSale?.insertUpdateRefillSale([newItem]);

                      setState(() {
                        fetchData(selectedDelBoyId.toString(),
                            deliveryDateController.text);

                        _selectedItemModel =
                        null; // Clear the selected item in the dropdown
                        _selectedItem = '';
                      });

                      // Clear the input fields after adding the item
                      _filledController.clear();
                      _svController.clear();
                      _tvController.clear();
                      _emptyController.clear();
                      _defectiveController.clear();
                      _lessEmptyController.clear();
                      _remarkController.clear();
                      _svRemarkController.clear();
                      remarksList.clear();
                      tvConsumerList.clear();
                      selectedConsumerNumbers.clear();
                      selectedCylinderQuantities.clear();
                      selectedSVUniqueID.clear();
                      totalCylinderQty = 0;
                      selectedConsumerNumbersTV.clear();
                      selectedCylinderQuantitiesTV.clear();
                      totalCylinderQtyTV = 0;
                      originalConsumerNumbersTV.clear();
                      originalConsumerQtyTV.clear();
                      originalConsumerNumbersSV.clear();
                      originalConsumerQtySV.clear();
                      originalSVUniqueIdMap.clear();
                      selectedConsumerIDLessEmpty.clear();
                      selectedConsumerQtyLessEmpty.clear();
                      selectedCustomerNamesLessEmpty.clear();
                      _totalImbalanceQtyDMQty.clear();
                      _totalImbalanceQtyDMCustomer.clear();
                      isDeliverySelected = false;
                      isCustomerSelected = false;
                    }
                    );
                  }
                }
              }
              else {
                showFlushBar(context, Constants.countShouldNotBeGreater+"1");
              }
            } else {
              showFlushBar(context, Constants.countShouldNotBeGreater+"2");
            }
            // } else {
            //   showFlushBar(context, "Invalid Count",
            //       'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
            // }
          } else {
            showFlushBar(context,Constants.countShouldNotBeGreater+"3");
          }
        } else {
          showFlushBar(context, Constants.countShouldNotBeGreater+"4");
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Constants.totalSaleQtyDailySale)),
        );
        debugPrint("sale1");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
    deliveryDateController.text = formattedDate!;
    updateRefillSale = UpdateRefillSale();
    loadAllData();
    // fetchItems();
    // fetchDeliveryBoyInfo();
    // fetchTransactionList();
    // checkAndSaveDayEndData();
    itemList = updateRefillSale!.getUpdateRefillSaleData();
    updateRefillSale!.deleteCompletedRefillSales();
    debugPrint("itemList" + itemList.toString());
    // _fetchSVConsumerData("SV");
    // fetchCurrentStock();
    if (widget.flagAdd != null) {
      if (widget.flagAdd == "editMode") {
        debugPrint("widget.saleGKId " + widget.saleGKId.toString());
        debugPrint("widget.dMId " + widget.dMId.toString());
        flagEditMode = widget.flagAdd;
        debugPrint("flag " + flagEditMode.toString());
        stockDataFuture = updateRefillSale!.getDeliveryMenDataForEdit(
            widget.saleGKId?.toInt() ?? 0, widget.dMId?.toInt() ?? 0);
        setState(() {
          selectedDelBoyName = widget.sale?.staffName;
          selectedDelBoyId = widget.dMId?.toInt();

          if (selectedDelBoyId != null) {
            final matchingDelBoy = _delBoyInfo.firstWhere(
                  (item) => item.staffId == selectedDelBoyId,
              orElse: () => DeliveryBoyInfoModel(
                staffId: 0,
                staffName: 'Unknown', // Default name if no match is found
              ),
            );

            if (matchingDelBoy.staffId != 0) {
              selectedDelBoyName = matchingDelBoy.staffName;
            }
          }
          vehicleNo = widget.sale?.vehicleNo ?? '';
          debugPrint("vehicleNo $vehicleNo");
          fetchVehicleDetail(selectedDelBoyId!,vehicleNo!);

        });
      } else {
        debugPrint("Empty");
      }
    } else {
      debugPrint("Empty flag");
    }
    // _fetchTodaysOpeningStockData();

    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        debugPrint("delBoyNameName :- ${delBoyNameName.toString()}");
        selectedDelBoyName = argValue["delBoyName"] ?? '';
        selectedDelBoyId = argValue["delBoyID"] ?? 0;
        vehicleNo = argValue["vehicleNo"] ?? '';
        fetchVehicleDetail(selectedDelBoyId!,"");
        fetchData(selectedDelBoyId.toString(),
            deliveryDateController.text);
        _fetchImbalanceData(selectedDelBoyId!);
      });
    });
  }

  Future<void> loadAllData() async {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false
      ..userInteractions = false;

    EasyLoading.show(status: 'Loading...');

    try {
      await Future.wait([
        fetchItems(),
        fetchDeliveryBoyInfo(),
        fetchTransactionList(),
        checkAndSaveDayEndData(),
        fetchCurrentStock(),
        _fetchSVConsumerData("SV"),
        fetchConsumerDetailsCredit(0),

      ]);
    } catch (e) {
      debugPrint("Error loading all data: $e");
      if (mounted) {
        showFlushBar(context, 'Error: ${e.toString()}');
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  // void configLoading() {
  //   EasyLoading.instance
  //     ..loadingStyle = EasyLoadingStyle.light
  //     ..maskType = EasyLoadingMaskType.black // 👈 This disables clicks
  //     ..indicatorType = EasyLoadingIndicatorType.circle
  //     ..userInteractions = false // 👈 Also ensures user cannot interact
  //     ..dismissOnTap = false;
  //
  // }
  void _onEditItem(ItemList item, StockSubmitToManagerListModel v) {
    selectedConsumerIDLessEmpty.clear();
    selectedConsumerQtyLessEmpty.clear();
    selectedCustomerNamesLessEmpty.clear();

    originalConsumerNumbersTV.clear();
    originalConsumerQtyTV.clear();
    originalConsumerNumbersSV.clear();
    originalConsumerQtySV.clear();
    originalSVUniqueIdMap.clear();

    selectedConsumerNumbers.clear();
    selectedCylinderQuantities.clear();
    selectedSVUniqueID.clear();
    selectedConsumerNumbersTV.clear();
    selectedCylinderQuantitiesTV.clear();
    // Populate the fields with the current item data
    setState(() {
      selectedItemId = item.itemId?.toInt();
      _selectedItem = item.itemName.toString();
      _filledController.text = item.filledSaleQty.toString();
      _svController.text = item.sVQty.toString();
      _tvController.text = item.tVQty.toString();
      _emptyController.text = item.emptyRetQty.toString();
      _defectiveController.text = item.deffQty.toString();
      _lessEmptyController.text = item.lessEmptyQty.toString();
      _remarkController.text = item.remark.toString();
      vehicleNo = v.vehicleNo.toString();
      if (editFilledStock == null) {
        editFilledStock = item.filledSaleQty;
      }

      // Ensure selectedDelBoyName is not null and handles empty value gracefully
      selectedDelBoyName =
      v.staffName?.isNotEmpty == true ? v.staffName : 'Unknown';
      selectedDelBoyId = v.dMId?.toInt();

      // String? svRemark = item.sVConsStr?.toString();
      // if (svRemark != null &&
      //     svRemark.isNotEmpty &&
      //     !remarksList.contains(svRemark)) {
      //   remarksList.add(svRemark);
      // }
      // debugPrint("svRemark $svRemark");

      String? tvRemark = item.TVConsStr?.toString();
      if (tvRemark != null &&
          tvRemark.isNotEmpty &&
          !tvConsumerList.contains(tvRemark)) {
        tvConsumerList.add(tvRemark);
      }

      debugPrint("TVConsStr $tvRemark");

      String? svRemark = item.sVConsStr?.toString();
      String? svCount = item.SVQtyStr?.toString();
      String? svUniqueCons = item.PSVIdStr?.toString();
      debugPrint("svCount $svCount");

      if (svRemark != null && svCount != null && svRemark.isNotEmpty && svCount.isNotEmpty) {
        // Split the comma-separated consumer numbers and quantities
        List<String> consumerNumbers = svRemark.split(',').map((e) => e.trim()).toList();
        List<String> quantities = svCount.split(',').map((e) => e.trim()).toList();
        List<String> svUniqueNo = svUniqueCons!.split(',').map((e) => e.trim()).toList();

        // Debugging to check values of consumerNumbers and quantities
        debugPrint("consumerNumbers: $consumerNumbers");
        debugPrint("quantities: $quantities");
        debugPrint("svUniqueNo: $svUniqueNo");

        // Populate the selectedConsumerNumbers and selectedCylinderQuantities lists
        for (int i = 0; i < consumerNumbers.length; i++) {
          String consumerNo = consumerNumbers[i];
          String qtyStr = quantities[i];
          String svUniqueConId = svUniqueNo[i];
          int cylQty = int.tryParse(qtyStr) ?? 0; // Ensure safe parsing
          int svUniqNo = int.tryParse(svUniqueConId) ?? 0; // Ensure safe parsing

          // Log the consumerNo and cylQty to check if the values are correct
          debugPrint("consumerNo: $consumerNo, cylQty: $cylQty");

          // Only add if the consumer number is not already in the list
          if (!selectedConsumerNumbers.contains(consumerNo)) {
            selectedConsumerNumbers.add(consumerNo);
            selectedCylinderQuantities.add(cylQty);
            selectedSVUniqueID.add(svUniqNo);
          }
          if (!originalConsumerNumbersSV.contains(consumerNo)) {
            originalConsumerNumbersSV.add(consumerNo);
          }
          originalConsumerQtySV[consumerNo] = cylQty;
          originalSVUniqueIdMap[consumerNo] = svUniqNo.toInt();
        }
      } else {
        selectedConsumerNumbers.clear();
        selectedCylinderQuantities.clear();
        selectedSVUniqueID.clear();
        originalConsumerNumbersSV.clear();
        originalConsumerQtySV.clear();
        originalSVUniqueIdMap.clear();
      }


      ///tv

      String? svRemarkTV = item.TVConsStr?.toString();
      String? svCountTV = item.TVQtyStr?.toString();
      debugPrint("TVQtyStr $svCount");

      if (svRemarkTV != null && svCountTV != null && svRemarkTV.isNotEmpty && svCountTV.isNotEmpty) {
        // Split the comma-separated consumer numbers and quantities
        List<String> consumerNumbersTV = svRemarkTV.split(',').map((e) => e.trim()).toList();
        List<String> quantitiesTV = svCountTV.split(',').map((e) => e.trim()).toList();

        // Debugging to check values of consumerNumbers and quantities
        debugPrint("consumerNumbers: $consumerNumbersTV");
        debugPrint("quantities: $quantitiesTV");

        // Populate the selectedConsumerNumbers and selectedCylinderQuantities lists
        for (int i = 0; i < consumerNumbersTV.length; i++) {
          String consumerNoTV = consumerNumbersTV[i];
          String qtyStrTV = quantitiesTV[i];
          int cylQtyTV = int.tryParse(qtyStrTV) ?? 0; // Ensure safe parsing

          // Log the consumerNo and cylQty to check if the values are correct
          debugPrint("consumerNo: $consumerNoTV, cylQty: $cylQtyTV");

          // Only add if the consumer number is not already in the list
          if (!selectedConsumerNumbersTV.contains(consumerNoTV)) {
            selectedConsumerNumbersTV.add(consumerNoTV);
            selectedCylinderQuantitiesTV.add(cylQtyTV);
          }
          if (!originalConsumerNumbersTV.contains(consumerNoTV)) {
            originalConsumerNumbersTV.add(consumerNoTV);
          }
          // 🔥 bind quantity correctly
          originalConsumerQtyTV[consumerNoTV] = cylQtyTV;
        }
      } else {
        selectedConsumerNumbersTV.clear();
        selectedCylinderQuantitiesTV.clear();
        originalConsumerNumbersTV.clear();
        originalConsumerQtyTV.clear();
      }

      ///less empty

      _totalImbalanceQtyDMQty.text = item.DMImbQty.toString();
      remainingDMQty = int.tryParse(item.DMImbQty?.toString() ?? '0') ?? 0;
      editModeRemainQty = int.tryParse(item.DMImbQty?.toString()?? '0') ?? 0;
      oldLessEmptyQty = int.tryParse(item.lessEmptyQty?.toString()??'0') ?? 0;
      // String? lessemptyCutomerNames = item['lessEmptyCustomer']?.toString();
      String? lessEmptyCustomerCounts = item.ImbQtyStr?.toString();
      String? lessEmptyCustomerId = item.ImbForIdStr?.toString();
      int count = int.tryParse(_totalImbalanceQtyDMQty.text .toString()) ?? 0;
      debugPrint("count $count");

      if (count > 0) {
        // do your logic here
        isDeliverySelected = true;
      }else{
        isDeliverySelected = false;
      }
      int ids = int.tryParse(lessEmptyCustomerId ?? "") ?? 0;

      debugPrint("lessEmptyCustomerId $lessEmptyCustomerId");
      if(lessEmptyCustomerId != null && lessEmptyCustomerId.isNotEmpty && lessEmptyCustomerCounts != null && lessEmptyCustomerCounts.isNotEmpty && ids > 0){
        // List<String> lessEmptyConsName = lessemptyCutomerNames!.split(',').map((e) => e.trim()).toList();
        List<String> lessEmptyConsId = lessEmptyCustomerId.split(',').map((e) => e.trim()).toList();
        List<String> lessEmptyConsCount = lessEmptyCustomerCounts.split(',').map((e) => e.trim()).toList();
        isCustomerSelected = true;
        for (int i = 0; i < lessEmptyConsId.length; i++) {
          String consId = lessEmptyConsId[i];
          String qtyLessEmpty = lessEmptyConsCount[i];
          // String consNameLessEmpty = lessEmptyConsName[i];
          int qty = int.tryParse(qtyLessEmpty) ?? 0;
          int ids = int.tryParse(consId) ?? 0;
          selectedConsumerIDLessEmpty.add(ids);
          selectedConsumerQtyLessEmpty.add(qty);
          // selectedCustomerNamesLessEmpty.add(consNameLessEmpty);
          /// ✅ FIND CUSTOMER NAME FROM ID
          final customer = getConsumerCreditDetailListModel.firstWhere(
                (e) => e.customerId == ids,
            orElse: () => GetConsumerDetailsCredit(customerName: "Unknown"),
          );

          selectedCustomerNamesLessEmpty.add(customer.customerName ?? "");
        }

      }else{
        selectedConsumerIDLessEmpty.clear();
        selectedConsumerQtyLessEmpty.clear();
        selectedCustomerNamesLessEmpty.clear();
        isCustomerSelected = false;
      }

      _selectedItemModel =
          _items.firstWhere((itemModel) => itemModel.itemId == selectedItemId);

      // Save the ID of the row being edited (optional for database update)
      _editingItemId = int.parse(item.itemId.toString());
      _fetchFilledStockForSelectedItem(selectedItemId!);
    });
  }

  void _onDeleteItem(int selectedItems) async {
    // Populate the fields with the current item data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    await updateRefillSale!.deleteItemFromDatabase(
      itemId: selectedItems,
      saleGKId: widget.saleGKId?.toInt() ?? 0,
      distributorId: int.parse(distributorId!),
    );
    // Update state after async operation
    setState(() {
      stockDataFuture = updateRefillSale!.getDeliveryMenDataForEdit(
        widget.saleGKId?.toInt() ?? 0,
        widget.dMId?.toInt() ?? 0,
      );
    });
  }

  int parseToInt(String text, {int defaultValue = 0}) {
    if (text.isEmpty || int.tryParse(text) == null) {
      return defaultValue;
    }
    return int.parse(text);
  }

  void _updateItem() async {
    // Perform asynchronous operations
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');

    // Debug prints
    print("Item updated: $selectedItemId");
    print("Item selectedItemName: $_selectedItem");
    print("Filled Sale Qty: ${_filledController.text}");
    print("SV Qty: ${_svController.text}");
    print("TV Qty: ${_tvController.text}");
    print("Empty Ret Qty: ${_emptyController.text}");
    print("Def Qty: ${_defectiveController.text}");
    print("Less Empty Qty: ${_lessEmptyController.text}");
    List<String> consumerNumberss = getConsumerNumbers();
    List<int> cylinderQuantities = getCylinderQuantities();

    List<String> consumerNumberssTV = getConsumerNumbersTV();
    List<int> cylinderQuantitiesTV = getCylinderQuantitiesTV();

    print("consumerNumberss Qty: ${consumerNumberss}");
    print("cylinderQuantities Qty: ${cylinderQuantities}");
    print("consumerNumberssTV Qty: ${consumerNumberssTV}");
    print("cylinderQuantitiesTV Qty: ${cylinderQuantitiesTV}");

    List<int> sVUniqueconsumerNumberss = getSVUniqueConsumerNumbers();
    print("Cylinder sVUniqueconsumerNumberss: $sVUniqueconsumerNumberss");
    //
    // List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
    // String lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
    //
    //
    // List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
    // String lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
    //
    // List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
    // String lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
    // String lessEmptyDMQty =  _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;

    int lessEmpt= int.parse(_lessEmptyController.text);

    List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
    String lessEmptyConsIdString = '';

    List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
    String lessEmptyConsNameString = '';

    List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
    String lessEmptyConsQtyString = '';
    String lessEmptyDMQty = '';

    if(lessEmpt > 0){
      int customerTotal = lessEmptyConsumerQty.fold(0, (sum, item) => sum + item);
      int dmQty = int.tryParse(_totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text) ?? 0;
      int totalUsedQty = (dmQty ?? 0) + customerTotal;
      int enteredQty = int.tryParse(_lessEmptyController.text) ?? 0;
      debugPrint("customerTotal $customerTotal dmQty $dmQty totalUsedQty $totalUsedQty enteredQty $enteredQty");
      if(totalUsedQty != enteredQty){
        showFlushBar(context, "Less Empty Quantity Must Be Equal To Custome And DM Quantity..");
        return;
      }
      if(isDeliverySelected == true && isCustomerSelected == true){
        if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
          showFlushBar(context, "Select Customer For Imbalance.");
          return;
        }
        lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
        lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
        lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
        lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
      }else if(isDeliverySelected == true && isCustomerSelected == false){
        lessEmptyDMQty = _lessEmptyController.text.isEmpty ? '' : _lessEmptyController.text;
        lessEmptyConsIdString = '';
        lessEmptyConsNameString = '';
        lessEmptyConsQtyString = '';
      }else if(isDeliverySelected == false && isCustomerSelected == false){
        if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
          showFlushBar(context, "Select Customer or Delivery Men For Imbalance.");
          return;
        }
      }else if(isDeliverySelected == false && isCustomerSelected == true){
        if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
          showFlushBar(context, "Select Customer For Imbalance.");
          return;
        }
        lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
        lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
        lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
        lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
      }
    }else{
      lessEmptyDMQty = '';
      lessEmptyConsIdString = '';
      lessEmptyConsNameString = '';
      lessEmptyConsQtyString = '';
    }

    await updateRefillSale!.updateItemInDatabase(
      itemId: selectedItemId!.toInt() ?? 0,
      saleGKId: widget.saleGKId?.toInt() ?? 0,
      distributorId: int.parse(distributorId!) ?? 0,
      itemName: _selectedItem.toString() ?? '',
      filled: parseToInt(_filledController.text),
      sv: parseToInt(_svController.text),
      tv: parseToInt(_tvController.text),
      wmpty: parseToInt(_emptyController.text),
      defective: parseToInt(_defectiveController.text),
      lessEmpty: parseToInt(_lessEmptyController.text),
      remark: _remarkController.text.toString() ?? '',
      svList: consumerNumberss.join(', ') ?? '',
      tvList: consumerNumberssTV.join(', ') ?? '',
      svQtyList: cylinderQuantities.join(', ') ?? '',
      tvQtyList: cylinderQuantitiesTV.join(', ') ?? '',
      svUniqueConsList: sVUniqueconsumerNumberss.join(', ') ?? '',
      lessEmptyCustomerList :lessEmptyConsIdString ,
      lessEmptyDMCount : parseToInt(lessEmptyDMQty),
      lessEmptyCustomerCountList :lessEmptyConsQtyString ,
    );

    // Update state after async operation
    setState(() {
      stockDataFuture = updateRefillSale!.getDeliveryMenDataForEdit(
        widget.saleGKId?.toInt() ?? 0,
        widget.dMId?.toInt() ?? 0,
      );

      _editingItemId = null;
      _filledController.clear();
      _svController.clear();
      _tvController.clear();
      _emptyController.clear();
      _defectiveController.clear();
      _lessEmptyController.clear();
      _remarkController.clear();
      remarksList.clear();
      tvConsumerList.clear();
      _selectedItemModel = null;
      _selectedItem = '';
      selectedConsumerNumbers.clear();
      selectedCylinderQuantities.clear();
      selectedSVUniqueID.clear();
      totalCylinderQty = 0;
      selectedConsumerNumbersTV.clear();
      selectedCylinderQuantitiesTV.clear();
      totalCylinderQtyTV = 0;
      originalConsumerNumbersTV.clear();
      originalConsumerQtyTV.clear();
      originalConsumerNumbersSV.clear();
      originalConsumerQtySV.clear();
      originalSVUniqueIdMap.clear();
    });
  }

  // ─────────────────────────────────────────────
  // COMPACT UI BUILD METHOD  (UI-only refactor)
  // All business logic, API calls, state
  // and navigation remain 100% unchanged.
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
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
        backgroundColor: AppColors.background2,
        // appBar:
        // AppBar(
        //   surfaceTintColor: Color(0xFFECEFFF),
        //   backgroundColor: Color(0xFFECEFFF), // Set your desired background color
        //   automaticallyImplyLeading: false, // Disable default back button
        //   title: Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //
        //       IconButton(
        //         icon: Icon(Icons.arrow_back, color: Colors.black),
        //         onPressed: () {
        //           Navigator.pushReplacementNamed(
        //               context, '/bottomNavigationForGodownKeeper');
        //         },
        //       ),
        //
        //       // 🖼 Logo
        //       Image.asset(
        //         'assets/playstore.png',
        //         height: 40,
        //         width: 40,
        //       ),
        //
        //       const SizedBox(width: 8),
        //
        //       // 📝 App Name + Subtitle
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Text(
        //             Constants.appName,
        //             style: Styling.appBarTitle.copyWith(color: Colors.black),
        //           ),
        //           const SizedBox(height: 2),
        //           Text(
        //             "Daily Sale",
        //             style: Styling.appBarDesc.copyWith(color: Colors.black),
        //           ),
        //         ],
        //       ),
        //
        //       // 🚀 THIS PUSHES BUTTON TO RIGHT
        //       const Spacer(),
        //       GestureDetector(
        //         onTap: (){
        //           if (stockTransferFlag) {
        //             if (saveFlag) {
        //               showFlushBar(context, Constants.dayEndCompleted);
        //             } else {
        //               showImbalanceBottomSheet(context);
        //             }
        //           } else {
        //             CustomAlertDialog.showCustomAlert(
        //                 context, Constants.stockNotAccepted);
        //           }
        //         },
        //         child: Padding(
        //           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        //           child: Text(
        //               'Add\nImbalance',
        //               style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.normal),
        //               textAlign:TextAlign.center
        //           ),
        //         ),
        //       ),
        //       // 🔘 Imbalance Button (RIGHT SIDE)
        //       // ElevatedButton(
        //       //   onPressed: () {
        //       //     if (stockTransferFlag) {
        //       //       if (saveFlag) {
        //       //         showFlushBar(context, Constants.dayEndCompleted);
        //       //       } else {
        //       //         showImbalanceBottomSheet(context);
        //       //       }
        //       //     } else {
        //       //       CustomAlertDialog.showCustomAlert(
        //       //           context, Constants.stockNotAccepted);
        //       //     }
        //       //   },
        //       //   style: ElevatedButton.styleFrom(
        //       //     backgroundColor: Color(0xFFECEFFF),
        //       //     foregroundColor: Colors.black,
        //       //     shape: RoundedRectangleBorder(
        //       //       borderRadius: BorderRadius.circular(20),
        //       //     ),
        //       //   ),
        //       //   child: const Padding(
        //       //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        //       //     child: Text(
        //       //       'Imbalance',
        //       //       style: TextStyle(fontSize: 14),
        //       //     ),
        //       //   ),
        //       // ),
        //     ],
        //   ),
        // ),
        // ── Floating Add/Update Button ─────────────────────────
        floatingActionButton: ((_filledController.text.isNotEmpty ||
            _tvController.text.isNotEmpty) &&
            selectedDelBoyName != null &&
            _selectedItem != null)
            ? null // FAB hidden; primary Add button inside form is sufficient
            : null,
        body: Column(
          children: [
            AppGradientHeader(
              title: 'Daily Sale',
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.12),
                      foregroundColor: Colors.white,
                      side: const BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                      padding: AppSpacing.appBarActionPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.appBarBtn,
                      ),
                    ),
                    onPressed: () {
                      if (stockTransferFlag) {
                        if (saveFlag) {
                          showFlushBar(context, Constants.dayEndCompleted);
                        } else {
                          showImbalanceBottomSheet(context);
                        }
                      } else {
                        CustomAlertDialog.showCustomAlert(
                            context, Constants.stockNotAccepted);
                      }
                    },
                    child: const Text(
                      'Add Imbalance',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
              subtitle: 'Show Daily Sale',
              // icon: Icons.receipt_long_rounded,
              logoPath: 'assets/playstore.png',
              onBack: () => Navigator.pushReplacementNamed(
                context,
                BottomNavigationForGodownKeeper.screenName,
                arguments: "onBack",
              ),
            ),

          //  ── Scrollable Body ───────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── COMPACT Header Strip ──────────────────────
                    _CompactHeaderCard(
                      date: formattedDate ?? '',
                      delBoyName: selectedDelBoyName ?? '—',
                      vehicleNo: vehicleNo,
                      vehicleList: vehicleList,
                      onVehicleChanged: (value) {
                        setState(() {
                          vehicleNo = value;
                          vehicleId = vehicleList
                              .firstWhere((v) => v.vehicleNo == value)
                              .vehicleId;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // ── Entry Form Section ───────────────────────
                    _CompactSectionLabel(label: 'Add Cylinder Entry'),
                    const SizedBox(height: 6),

                    _FormCard(children: [
                      // Select Item
                      _FormField(
                        label: 'Item',
                        isRequired: true,
                        child: DropdownButtonFormField<CylItemListModel>(
                          decoration: _cleanInputDecoration('Select Item'),
                          value: _selectedItemModel,
                          items: _items
                              .map((CylItemListModel item) {
                            return DropdownMenuItem<CylItemListModel>(
                              value: item,
                              child: Text(
                                item.itemName ?? 'Unknown',
                                style: AppTextStyles.dropdownItem,
                              ),
                            );
                          }).toList(),
                          onChanged: (flagEditMode == 'editMode')
                              ? null
                              : (CylItemListModel? selectedItem) {
                            if (selectedItem != null) {
                              setState(() {
                                _selectedItem =
                                    selectedItem.itemName;
                                selectedItemId =
                                    selectedItem.itemId!.toInt();
                                _selectedItemModel = selectedItem;
                                _fetchFilledStockForSelectedItem(
                                    selectedItemId!);
                              });
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ── Total Sale + Less Empty in one compact row ──
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _CompactFieldLabel(
                              label: 'Total Sale *',
                              child: TextField(
                                controller: _filledController,
                                decoration: _denseInputDecoration('Sale qty'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                style: AppTextStyles.formFieldInput,
                                onChanged: (value) {
                                  setState(() {
                                    int filledQty = int.tryParse(value) ?? 0;
                                    int svQty = int.tryParse(_svController.text) ?? 0;
                                    int tvQty = int.tryParse(_tvController.text) ?? 0;
                                    int defQty = int.tryParse(_defectiveController.text) ?? 0;
                                    int lessEmptyQty = int.tryParse(_lessEmptyController.text) ?? 0;
                                    _emptyController.text = (filledQty - svQty + tvQty - defQty - lessEmptyQty).toString();
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _CompactFieldLabel(
                              label: 'Less Empty',
                              child: TextField(
                                controller: _lessEmptyController,
                                decoration: _denseInputDecoration('Less empty'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                style: AppTextStyles.formFieldInput,
                                onChanged: (value) {
                                  setState(() {
                                    int lessEmpty = int.tryParse(value) ?? 0;
                                    int filledQty = int.tryParse(_filledController.text) ?? 0;
                                    int svQty = int.tryParse(_svController.text) ?? 0;
                                    int tvQty = int.tryParse(_tvController.text) ?? 0;
                                    int defQty = int.tryParse(_defectiveController.text) ?? 0;
                                    _emptyController.text = (filledQty - svQty + tvQty - defQty - lessEmpty).toString();
                                    int totalAssigned = selectedConsumerQtyLessEmpty.fold(0, (s, i) => s + i);
                                    remainingDMQty = lessEmpty - totalAssigned;
                                    _totalImbalanceQtyDMQty.text = remainingDMQty.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Imbalance assignment (appears when less empty > 0)
                      if ((int.tryParse(_lessEmptyController.text) ?? 0) >
                          0) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: AppSpacing.warningPanelPadding,
                          decoration: AppDecorations.warningPanel.copyWith(
                            border: Border.all(color: AppColors.warningBorder, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assign Less Empty To',
                                style: AppTextStyles.warningLabel,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,        // horizontal space between items
                                runSpacing: 8,      // vertical space if items wrap to next line
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  _CheckboxChip(
                                    label: 'Delivery Man',
                                    value: isDeliverySelected,
                                    onChanged: (v) => setState(() => isDeliverySelected = v!),
                                  ),
                                  _CheckboxChip(
                                    label: 'Customer',
                                    value: isCustomerSelected,
                                    onChanged: (v) => setState(() => isCustomerSelected = v!),
                                  ),
                                  if (isCustomerSelected)
                                    GestureDetector(
                                      onTap: () {
                                        int? lessEmpty = int.parse(_lessEmptyController.text);
                                        showSimplePopup(context, lessEmpty);
                                      },
                                      child: Container(
                                        padding: AppSpacing.inlineActionPadding,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: AppRadius.checkboxChip,
                                        ),
                                        child: const Text(
                                          'Select Customer',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     _CheckboxChip(
                              //       label: 'Delivery Man',
                              //       value: isDeliverySelected,
                              //       onChanged: (v) => setState(
                              //               () => isDeliverySelected = v!),
                              //     ),
                              //     const SizedBox(width: 10),
                              //     _CheckboxChip(
                              //       label: 'Customer',
                              //       value: isCustomerSelected,
                              //       onChanged: (v) => setState(
                              //               () => isCustomerSelected = v!),
                              //     ),
                              //     if (isCustomerSelected) ...[
                              //       const SizedBox(width: 10),
                              //       GestureDetector(
                              //         onTap: () {
                              //           int? lessEmpty = int.parse(
                              //               _lessEmptyController.text);
                              //           showSimplePopup(
                              //               context, lessEmpty);
                              //         },
                              //         child: Container(
                              //           padding: AppSpacing.inlineActionPadding,
                              //           decoration: BoxDecoration(
                              //             color: AppColors.primary,
                              //             borderRadius: AppRadius.checkboxChip,
                              //           ),
                              //           child: const Text(
                              //             'Select Customer',
                              //             style: TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 12,
                              //               fontWeight: FontWeight.w700,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 8),

                      // ── SV + TV compact row ─────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _CompactFieldLabel(
                              label: 'SV −',
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _svController,
                                      decoration: _denseInputDecoration('SV qty'),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                      enabled: false,
                                      style: AppTextStyles.formFieldInput,
                                      onChanged: (value) {
                                        setState(() {
                                          int svQty = int.tryParse(value) ?? 0;
                                          int filledQty = int.tryParse(_filledController.text) ?? 0;
                                          int tvQty = int.tryParse(_tvController.text) ?? 0;
                                          int defQty = int.tryParse(_defectiveController.text) ?? 0;
                                          int lessEmptyQty = int.tryParse(_lessEmptyController.text) ?? 0;
                                          _emptyController.text = (filledQty - svQty + tvQty - defQty - lessEmptyQty).toString();
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  InkWell(
                                    onTap: () async {
                                      await _fetchSVConsumerData('SV');
                                      _showConsumerNumberPopup();
                                    },
                                    borderRadius: AppRadius.iconBadge,
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: AppDecorations.infoIconBadge,
                                      child: Icon(Icons.add_rounded, color: AppColors.primary, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _CompactFieldLabel(
                              label: 'TV +',
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _tvController,
                                      decoration: _denseInputDecoration('TV qty'),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                      enabled: false,
                                      style: AppTextStyles.formFieldInput,
                                      onChanged: (value) {
                                        setState(() {
                                          int tvQty = int.tryParse(value) ?? 0;
                                          int filledQty = int.tryParse(_filledController.text) ?? 0;
                                          int svQty = int.tryParse(_svController.text) ?? 0;
                                          int defQty = int.tryParse(_defectiveController.text) ?? 0;
                                          int lessEmptyQty = int.tryParse(_lessEmptyController.text) ?? 0;
                                          _emptyController.text = (filledQty - svQty + tvQty - defQty - lessEmptyQty).toString();
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  InkWell(
                                    onTap: () async {
                                      await _fetchTVConsumerData('TV');
                                      _showConsumerNumberTVPopup();
                                    },
                                    borderRadius: AppRadius.iconBadge,
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: AppColors.tealXLight,
                                        borderRadius: AppRadius.iconBadge,
                                      ),
                                      child: Icon(Icons.add_rounded, color: AppColors.teal, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // ── Defective + Empty (auto) compact row ─────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _CompactFieldLabel(
                              label: 'Defective −',
                              child: TextField(
                                controller: _defectiveController,
                                decoration: _denseInputDecoration('Def qty'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                style: AppTextStyles.formFieldInput,
                                onChanged: (value) {
                                  setState(() {
                                    int defQty = int.tryParse(value) ?? 0;
                                    int filledQty = int.tryParse(_filledController.text) ?? 0;
                                    int svQty = int.tryParse(_svController.text) ?? 0;
                                    int tvQty = int.tryParse(_tvController.text) ?? 0;
                                    int lessEmptyQty = int.tryParse(_lessEmptyController.text) ?? 0;
                                    _emptyController.text = (filledQty - svQty + tvQty - defQty - lessEmptyQty).toString();
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _CompactFieldLabel(
                              label: 'Empty (Auto)',
                              child: TextField(
                                controller: _emptyController,
                                decoration: _denseInputDecoration('Auto').copyWith(
                                  filled: true,
                                  fillColor: AppColors.surfaceMuted,
                                ),
                                keyboardType: TextInputType.number,
                                enabled: false,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Remark
                      _CompactFieldLabel(
                        label: 'Remark',
                        child: TextField(
                          controller: _remarkController,
                          maxLength: 250,
                          decoration: _denseInputDecoration('Optional note'),
                          style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                          inputFormatters: [
                            // Allow only A-Z, a-z, 0-9, space and hyphen
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Za-z0-9\s-]'),
                            ),
                          ],
                        ),
                      ),
                    ]),

                    const SizedBox(height: 10),

                    // ── Add / Update / Clear Buttons ─────────────
                    Row(
                      children: [
                        Expanded(
                          child:
                          ElevatedButton(
                            onPressed:
                            ((_filledController.text.isNotEmpty
                                || _tvController.text.isNotEmpty) &&
                                selectedDelBoyName != null &&
                                _selectedItem != null)
                                ? () async {
                              int filledValue =
                                  int.tryParse(_filledController.text) ?? 0;
                              int svValue =
                                  int.tryParse(_svController.text) ?? 0;
                              int tvValue =
                                  int.tryParse(_tvController.text) ?? 0;
                              int emptyValue =
                                  int.tryParse(_emptyController.text) ?? 0;
                              int defectiveValue =
                                  int.tryParse(_defectiveController.text) ?? 0;
                              int lessEmptyValue =
                                  int.tryParse(_lessEmptyController.text) ?? 0;
                              DateTime now = DateTime.now();
                              String formattedDate =
                              DateFormat('yyyy-MM-dd').format(now);
                              if (_editingItemId != null) {
                                if(flagEditMode == "editMode"){
                                  debugPrint("filledStock $filledStock");
                                  if (filledValue <= (filledStock ?? 0) + (editFilledStock ?? 0)){
                                    if (filledValue >= lessEmptyValue) {
                                      if (filledValue >= svValue) {
                                        // if (filledValue > tvValue) {
                                        if (filledValue >= defectiveValue) {
                                          if (emptyValue >= 0) {
                                            if (_svController.text.isNotEmpty) {
                                              List<String> consumerNumberss = getConsumerNumbers();
                                              List<int> cylinderQuantities = getCylinderQuantities();

                                              List<String> consumerNumberssTV = getConsumerNumbersTV();
                                              List<int> cylinderQuantitiesTV = getCylinderQuantitiesTV();
                                              int currentCount = consumerNumberss
                                                  .map((remark) =>
                                              remark
                                                  .split(',')
                                                  .length)
                                                  .fold(0, (a, b) => a + b);
                                              int svQty = int.parse(
                                                  _svController.text);
                                              // Check if we can add more consumers
                                              if (currentCount > svQty) {
                                                showFlushBar(context,
                                                    Constants.svConsumerCountExceed);
                                              } else {
                                                if (_tvController.text.isNotEmpty) {
                                                  int currentCountTV = consumerNumberssTV
                                                      .map((remark) =>
                                                  remark
                                                      .split(',')
                                                      .length)
                                                      .fold(0, (a, b) => a + b);
                                                  int tvQty = int.parse(
                                                      _tvController.text);
                                                  if (currentCountTV > tvQty) {
                                                    showFlushBar(context, Constants
                                                        .tvConsumerCountExceed);
                                                  } else {
                                                    _updateItem();
                                                  }
                                                } else {
                                                  _updateItem();
                                                }
                                              }
                                            } else {
                                              if (_tvController.text.isNotEmpty) {
                                                List<String> consumerNumberssTV = getConsumerNumbersTV();
                                                List<int> cylinderQuantitiesTV = getCylinderQuantitiesTV();
                                                int currentCountTV = consumerNumberssTV
                                                    .map((remark) =>
                                                remark
                                                    .split(',')
                                                    .length)
                                                    .fold(0, (a, b) => a + b);
                                                int tvQty = int.parse(
                                                    _tvController.text);
                                                if (currentCountTV > tvQty) {
                                                  showFlushBar(context, Constants
                                                      .tvConsumerCountExceed);
                                                } else {
                                                  _updateItem();
                                                }
                                              } else {
                                                _updateItem();
                                              }
                                            }
                                          } else {
                                            showFlushBar(context,
                                                Constants.countShouldNotBeGreater);
                                          }
                                        } else {
                                          showFlushBar(context,
                                              Constants.countShouldNotBeGreater);
                                        }
                                        // } else {
                                        //   showFlushBar(context, "Cylinder Count",
                                        //       'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                        // }
                                      } else {
                                        showFlushBar(context,
                                            Constants.countShouldNotBeGreater);
                                      }
                                    } else {
                                      showFlushBar(
                                          context, Constants.countShouldNotBeGreater);
                                    }
                                  }else{
                                    showFlushBar(context, Constants.totalSaleQtyDailySale);
                                    debugPrint("sale2");
                                  }
                                }else{
                                  if(_dataGetFromDBDelBoy.isNotEmpty) {
                                    debugPrint("filledStock $filledStock");
                                    // if(filledValue > 0) {
                                    if (filledValue <= (filledStock ?? 0)) {
                                      if (filledValue >= lessEmptyValue) {
                                        if (filledValue >= svValue) {
                                          // if (filledValue > tvValue) {
                                          if (filledValue > defectiveValue) {
                                            if (emptyValue >= 0) {
                                              if (_svController.text.isNotEmpty) {
                                                List<String> consumerNumberss = getConsumerNumbers();
                                                List<int> cylinderQuantities = getCylinderQuantities();
                                                int currentCount = consumerNumberss
                                                    .map((remark) =>
                                                remark
                                                    .split(',')
                                                    .length)
                                                    .fold(0, (a, b) => a + b);
                                                int svQty = int.parse(
                                                    _svController.text);
                                                // Check if we can add more consumers
                                                if (currentCount > svQty) {
                                                  showFlushBar(context, Constants
                                                      .svConsumerCountExceed);
                                                } else {
                                                  if (_tvController.text.isNotEmpty) {
                                                    List<String> consumerNumberssTV = getConsumerNumbersTV();
                                                    List<int> cylinderQuantitiesTV = getCylinderQuantitiesTV();
                                                    int currentCountTV = consumerNumberssTV
                                                        .map((remark) =>
                                                    remark
                                                        .split(',')
                                                        .length)
                                                        .fold(0, (a, b) => a + b);
                                                    int tvQty = int.parse(
                                                        _tvController.text);
                                                    if (currentCountTV > tvQty) {
                                                      showFlushBar(context, Constants
                                                          .tvConsumerCountExceed);
                                                    } else {
                                                      List<String> consumerNumberss = getConsumerNumbers();
                                                      List<int> cylinderQuantities = getCylinderQuantities();
                                                      List<int> sVUniqueconsumerNumberss = getSVUniqueConsumerNumbers();

                                                      List<String> consumerNumberssTV = getConsumerNumbersTV();
                                                      List<int> cylinderQuantitiesTV = getCylinderQuantitiesTV();

                                                      int lessEmpt= int.parse(_lessEmptyController.text);

                                                      List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
                                                      String lessEmptyConsIdString = '';

                                                      List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
                                                      String lessEmptyConsNameString = '';

                                                      List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
                                                      String lessEmptyConsQtyString = '';
                                                      String lessEmptyDMQty = '';

                                                      if(lessEmpt > 0){
                                                        int customerTotal = lessEmptyConsumerQty.fold(0, (sum, item) => sum + item);
                                                        int dmQty = int.tryParse(_totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text) ?? 0;
                                                        int totalUsedQty = (dmQty ?? 0) + customerTotal;
                                                        int enteredQty = int.tryParse(_lessEmptyController.text) ?? 0;
                                                        if(totalUsedQty != enteredQty){
                                                          showFlushBar(context, "Less Empty Quantity Must Be Equal To Custome And DM Quantity..");
                                                          return;
                                                        }

                                                        if(isDeliverySelected == true && isCustomerSelected == true){
                                                          if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                                            showFlushBar(context, "Select Customer For Imbalance.");
                                                            return;
                                                          }
                                                          lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                                                          lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                                          lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                                          lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                                        }else if(isDeliverySelected == true && isCustomerSelected == false){
                                                          lessEmptyDMQty = _lessEmptyController.text.isEmpty ? '' : _lessEmptyController.text;
                                                          lessEmptyConsIdString = '';
                                                          lessEmptyConsNameString = '';
                                                          lessEmptyConsQtyString = '';
                                                        }else if(isDeliverySelected == false && isCustomerSelected == false){
                                                          if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                                            showFlushBar(context, "Select Customer or Delivery Men For Imbalance.");
                                                            return;
                                                          }
                                                        }else if(isDeliverySelected == false && isCustomerSelected == true){
                                                          if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                                            showFlushBar(context, "Select Customer For Imbalance.");
                                                            return;
                                                          }
                                                          lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                                                          lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                                          lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                                          lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                                        }
                                                      }else{
                                                        lessEmptyDMQty = '';
                                                        lessEmptyConsIdString = '';
                                                        lessEmptyConsNameString = '';
                                                        lessEmptyConsQtyString = '';
                                                      }

                                                      // List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
                                                      // String lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                                      //
                                                      //
                                                      // List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
                                                      // String lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                                      //
                                                      // List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
                                                      // String lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                                      // String lessEmptyDMQty =  _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                                                      final isUpdated =
                                                      await updateRefillSale
                                                          ?.updateRowByColID(
                                                        _editingItemId!,
                                                        ItemData(
                                                          date:
                                                          deliveryDateController
                                                              .text,
                                                          deliveryBoyName:
                                                          selectedDelBoyName
                                                              .toString(),
                                                          delBoyId:
                                                          selectedDelBoyId
                                                              .toString(),
                                                          vehicleNo:
                                                          vehicleNo.toString(),
                                                          itemName:
                                                          _selectedItem.toString(),
                                                          itemID:
                                                          selectedItemId.toString(),
                                                          filled: _filledController
                                                              .text,
                                                          sv: _svController.text,
                                                          tv: _tvController.text,
                                                          empty: _emptyController
                                                              .text,
                                                          defective:
                                                          _defectiveController.text,
                                                          lessEmpty:
                                                          _lessEmptyController.text,
                                                          remark: _remarkController
                                                              .text,
                                                          svRemark: consumerNumberss.join(', '),
                                                          svCount: cylinderQuantities.join(', '),
                                                          tvConsumerNo: consumerNumberssTV.join(', '),
                                                          tvCount: cylinderQuantitiesTV.join(', '),
                                                          updateFlag: 'pending',
                                                          itemAddedDate: formattedDate,
                                                          sVUniqueId: sVUniqueconsumerNumberss.join(', '),
                                                          lessEmptyCustomer: lessEmptyConsNameString,
                                                          lessEmptyDMCount: lessEmptyDMQty,
                                                          lessEmptyCustomerCount: lessEmptyConsQtyString,
                                                          lessEmptyCustomerId: lessEmptyConsIdString,
                                                        ),
                                                      );

                                                      if (isUpdated == true) {
                                                        EasyLoading.showToast(
                                                            Constants.dataUpdated,
                                                            duration: const Duration(
                                                                milliseconds: 3000));

                                                        fetchData(
                                                            selectedDelBoyId
                                                                .toString(),
                                                            deliveryDateController
                                                                .text);

                                                        setState(() {
                                                          _editingItemId = null;
                                                          _filledController.clear();
                                                          _svController.clear();
                                                          _tvController.clear();
                                                          _emptyController.clear();
                                                          _defectiveController
                                                              .clear();
                                                          _lessEmptyController
                                                              .clear();
                                                          _remarkController.clear();
                                                          remarksList.clear();
                                                          tvConsumerList.clear();
                                                          _selectedItemModel = null;
                                                          _selectedItem = '';
                                                          selectedConsumerNumbers.clear();
                                                          selectedCylinderQuantities.clear();
                                                          selectedSVUniqueID.clear();
                                                          totalCylinderQty = 0;
                                                          selectedConsumerNumbersTV.clear();
                                                          selectedCylinderQuantitiesTV.clear();
                                                          totalCylinderQtyTV = 0;
                                                          originalConsumerNumbersTV.clear();
                                                          originalConsumerQtyTV.clear();
                                                          originalConsumerNumbersSV.clear();
                                                          originalConsumerQtySV.clear();
                                                          originalSVUniqueIdMap.clear();
                                                          selectedConsumerIDLessEmpty.clear();
                                                          selectedConsumerQtyLessEmpty.clear();
                                                          selectedCustomerNamesLessEmpty.clear();
                                                          _totalImbalanceQtyDMQty.clear();
                                                          _totalImbalanceQtyDMCustomer.clear();
                                                          isDeliverySelected = false;
                                                          isCustomerSelected = false;
                                                        });
                                                      } else {
                                                        showFlushBar(context,
                                                            Constants
                                                                .recordAlreadyExist);
                                                      }
                                                    }
                                                  } else {
                                                    List<String> consumerNumberss = getConsumerNumbers();
                                                    List<int> cylinderQuantities = getCylinderQuantities();
                                                    List<int> sVUniqueconsumerNumberss = getSVUniqueConsumerNumbers();

                                                    List<String> consumerNumberssTV = getConsumerNumbersTV();
                                                    List<int> cylinderQuantitiesTV = getCylinderQuantitiesTV();

                                                    int lessEmpt= int.parse(_lessEmptyController.text);

                                                    List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
                                                    String lessEmptyConsIdString = '';

                                                    List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
                                                    String lessEmptyConsNameString = '';

                                                    List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
                                                    String lessEmptyConsQtyString = '';
                                                    String lessEmptyDMQty = '';

                                                    if(lessEmpt > 0){
                                                      int customerTotal = lessEmptyConsumerQty.fold(0, (sum, item) => sum + item);
                                                      int dmQty = int.tryParse(_totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text) ?? 0;
                                                      int totalUsedQty = (dmQty ?? 0) + customerTotal;
                                                      int enteredQty = int.tryParse(_lessEmptyController.text) ?? 0;
                                                      if(totalUsedQty != enteredQty){
                                                        showFlushBar(context, "Less Empty Quantity Must Be Equal To Custome And DM Quantity..");
                                                        return;
                                                      }
                                                      if(isDeliverySelected == true && isCustomerSelected == true){
                                                        if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                                          showFlushBar(context, "Select Customer For Imbalance.");
                                                          return;
                                                        }
                                                        lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                                                        lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                                        lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                                        lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                                      }else if(isDeliverySelected == true && isCustomerSelected == false){
                                                        lessEmptyDMQty = _lessEmptyController.text.isEmpty ? '' : _lessEmptyController.text;
                                                        lessEmptyConsIdString = '';
                                                        lessEmptyConsNameString = '';
                                                        lessEmptyConsQtyString = '';
                                                      }else if(isDeliverySelected == false && isCustomerSelected == false){
                                                        if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                                          showFlushBar(context, "Select Customer or Delivery Men For Imbalance.");
                                                          return;
                                                        }
                                                      }else if(isDeliverySelected == false && isCustomerSelected == true){
                                                        if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                                          showFlushBar(context, "Select Customer For Imbalance.");
                                                          return;
                                                        }
                                                        lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                                                        lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                                        lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                                        lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                                      }
                                                    }else{
                                                      lessEmptyDMQty = '';
                                                      lessEmptyConsIdString = '';
                                                      lessEmptyConsNameString = '';
                                                      lessEmptyConsQtyString = '';
                                                    }

                                                    // List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
                                                    // String lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                                    //
                                                    //
                                                    // List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
                                                    // String lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                                    //
                                                    // List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
                                                    // String lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                                    // String lessEmptyDMQty =  _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                                                    final isUpdated =
                                                    await updateRefillSale
                                                        ?.updateRowByColID(
                                                      _editingItemId!,
                                                      ItemData(
                                                        date:
                                                        deliveryDateController
                                                            .text,
                                                        deliveryBoyName:
                                                        selectedDelBoyName
                                                            .toString(),
                                                        delBoyId:
                                                        selectedDelBoyId
                                                            .toString(),
                                                        vehicleNo:
                                                        vehicleNo.toString(),
                                                        itemName:
                                                        _selectedItem.toString(),
                                                        itemID:
                                                        selectedItemId.toString(),
                                                        filled: _filledController
                                                            .text,
                                                        sv: _svController.text,
                                                        tv: _tvController.text,
                                                        empty: _emptyController
                                                            .text,
                                                        defective:
                                                        _defectiveController.text,
                                                        lessEmpty:
                                                        _lessEmptyController.text,
                                                        remark: _remarkController
                                                            .text,
                                                        svRemark: consumerNumberss.join(', '),
                                                        svCount: cylinderQuantities.join(', '),
                                                        tvConsumerNo: consumerNumberssTV.join(', '),
                                                        tvCount: cylinderQuantitiesTV.join(', '),
                                                        updateFlag: 'pending',
                                                        itemAddedDate: formattedDate,
                                                        sVUniqueId: sVUniqueconsumerNumberss.join(', '),
                                                        lessEmptyCustomer: lessEmptyConsNameString,
                                                        lessEmptyDMCount: lessEmptyDMQty,
                                                        lessEmptyCustomerCount: lessEmptyConsQtyString,
                                                        lessEmptyCustomerId: lessEmptyConsIdString,
                                                      ),
                                                    );

                                                    if (isUpdated == true) {
                                                      EasyLoading.showToast(
                                                          Constants.dataUpdated,
                                                          duration: const Duration(
                                                              milliseconds: 3000));

                                                      fetchData(
                                                          selectedDelBoyId
                                                              .toString(),
                                                          deliveryDateController
                                                              .text);

                                                      setState(() {
                                                        _editingItemId = null;
                                                        _filledController.clear();
                                                        _svController.clear();
                                                        _tvController.clear();
                                                        _emptyController.clear();
                                                        _defectiveController
                                                            .clear();
                                                        _lessEmptyController
                                                            .clear();
                                                        _remarkController.clear();
                                                        remarksList.clear();
                                                        tvConsumerList.clear();
                                                        _selectedItemModel = null;
                                                        _selectedItem = '';
                                                        selectedConsumerNumbers.clear();
                                                        selectedCylinderQuantities.clear();
                                                        selectedSVUniqueID.clear();
                                                        totalCylinderQty = 0;
                                                        selectedConsumerNumbersTV.clear();
                                                        selectedCylinderQuantitiesTV.clear();
                                                        totalCylinderQtyTV = 0;
                                                        originalConsumerNumbersTV.clear();
                                                        originalConsumerQtyTV.clear();
                                                        originalConsumerNumbersSV.clear();
                                                        originalConsumerQtySV.clear();
                                                        originalSVUniqueIdMap.clear();
                                                        selectedConsumerIDLessEmpty.clear();
                                                        selectedConsumerQtyLessEmpty.clear();
                                                        selectedCustomerNamesLessEmpty.clear();
                                                        _totalImbalanceQtyDMQty.clear();
                                                        _totalImbalanceQtyDMCustomer.clear();
                                                        isDeliverySelected = false;
                                                        isCustomerSelected = false;
                                                      });
                                                    } else {
                                                      showFlushBar(context, Constants
                                                          .recordAlreadyExist);
                                                    }
                                                  }
                                                }
                                              } else {
                                                if (_tvController.text.isNotEmpty) {
                                                  List<String> consumerNumberssTV = getConsumerNumbersTV();
                                                  List<int> cylinderQuantitiesTV = getCylinderQuantitiesTV();
                                                  int currentCountTV = consumerNumberssTV
                                                      .map((remark) =>
                                                  remark
                                                      .split(',')
                                                      .length)
                                                      .fold(0, (a, b) => a + b);
                                                  int tvQty = int.parse(
                                                      _tvController.text);
                                                  if (currentCountTV > tvQty) {
                                                    showFlushBar(context, Constants
                                                        .tvConsumerCountExceed);
                                                  } else {
                                                    List<String> consumerNumberss = getConsumerNumbers();
                                                    List<int> cylinderQuantities = getCylinderQuantities();
                                                    List<int> sVUniqueconsumerNumberss = getSVUniqueConsumerNumbers();

                                                    List<String> consumerNumberssTV = getConsumerNumbersTV();
                                                    List<int> cylinderQuantitiesTV = getCylinderQuantitiesTV();

                                                    int lessEmpt= int.parse(_lessEmptyController.text);

                                                    List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
                                                    String lessEmptyConsIdString = '';

                                                    List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
                                                    String lessEmptyConsNameString = '';

                                                    List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
                                                    String lessEmptyConsQtyString = '';
                                                    String lessEmptyDMQty = '';

                                                    if(lessEmpt > 0){
                                                      int customerTotal = lessEmptyConsumerQty.fold(0, (sum, item) => sum + item);
                                                      int dmQty = int.tryParse(_totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text) ?? 0;
                                                      int totalUsedQty = (dmQty ?? 0) + customerTotal;
                                                      int enteredQty = int.tryParse(_lessEmptyController.text) ?? 0;
                                                      if(totalUsedQty != enteredQty){
                                                        showFlushBar(context, "Less Empty Quantity Must Be Equal To Custome And DM Quantity..");
                                                        return;
                                                      }
                                                      if(isDeliverySelected == true && isCustomerSelected == true){
                                                        if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                                          showFlushBar(context, "Select Customer For Imbalance.");
                                                          return;
                                                        }
                                                        lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                                                        lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                                        lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                                        lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                                      }else if(isDeliverySelected == true && isCustomerSelected == false){
                                                        lessEmptyDMQty = _lessEmptyController.text.isEmpty ? '' : _lessEmptyController.text;
                                                        lessEmptyConsIdString = '';
                                                        lessEmptyConsNameString = '';
                                                        lessEmptyConsQtyString = '';
                                                      }else if(isDeliverySelected == false && isCustomerSelected == false){
                                                        if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                                          showFlushBar(context, "Select Customer or Delivery Men For Imbalance.");
                                                          return;
                                                        }
                                                      }else if(isDeliverySelected == false && isCustomerSelected == true){
                                                        if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                                          showFlushBar(context, "Select Customer For Imbalance.");
                                                          return;
                                                        }
                                                        lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                                                        lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                                        lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                                        lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                                      }
                                                    }else{
                                                      lessEmptyDMQty = '';
                                                      lessEmptyConsIdString = '';
                                                      lessEmptyConsNameString = '';
                                                      lessEmptyConsQtyString = '';
                                                    }

                                                    // List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
                                                    // String lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                                    //
                                                    //
                                                    // List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
                                                    // String lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                                    //
                                                    // List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
                                                    // String lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                                    // String lessEmptyDMQty =  _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                                                    final isUpdated =
                                                    await updateRefillSale
                                                        ?.updateRowByColID(
                                                      _editingItemId!,
                                                      ItemData(
                                                        date:
                                                        deliveryDateController
                                                            .text,
                                                        deliveryBoyName:
                                                        selectedDelBoyName
                                                            .toString(),
                                                        delBoyId:
                                                        selectedDelBoyId
                                                            .toString(),
                                                        vehicleNo:
                                                        vehicleNo.toString(),
                                                        itemName:
                                                        _selectedItem.toString(),
                                                        itemID:
                                                        selectedItemId.toString(),
                                                        filled: _filledController
                                                            .text,
                                                        sv: _svController.text,
                                                        tv: _tvController.text,
                                                        empty: _emptyController
                                                            .text,
                                                        defective:
                                                        _defectiveController.text,
                                                        lessEmpty:
                                                        _lessEmptyController.text,
                                                        remark: _remarkController
                                                            .text,
                                                        svRemark: consumerNumberss.join(', '),
                                                        svCount: cylinderQuantities.join(', '),
                                                        tvConsumerNo: consumerNumberssTV.join(', '),
                                                        tvCount: cylinderQuantitiesTV.join(', '),
                                                        updateFlag: 'pending',
                                                        itemAddedDate: formattedDate,
                                                        sVUniqueId: sVUniqueconsumerNumberss.join(', '),
                                                        lessEmptyCustomer: lessEmptyConsNameString,
                                                        lessEmptyDMCount: lessEmptyDMQty,
                                                        lessEmptyCustomerCount: lessEmptyConsQtyString,
                                                        lessEmptyCustomerId: lessEmptyConsIdString,
                                                      ),
                                                    );

                                                    if (isUpdated == true) {
                                                      EasyLoading.showToast(
                                                          Constants.dataUpdated,
                                                          duration: const Duration(
                                                              milliseconds: 3000));

                                                      fetchData(
                                                          selectedDelBoyId
                                                              .toString(),
                                                          deliveryDateController
                                                              .text);

                                                      setState(() {
                                                        _editingItemId = null;
                                                        _filledController.clear();
                                                        _svController.clear();
                                                        _tvController.clear();
                                                        _emptyController.clear();
                                                        _defectiveController
                                                            .clear();
                                                        _lessEmptyController
                                                            .clear();
                                                        _remarkController.clear();
                                                        remarksList.clear();
                                                        tvConsumerList.clear();
                                                        _selectedItemModel = null;
                                                        _selectedItem = '';
                                                        selectedConsumerNumbers.clear();
                                                        selectedCylinderQuantities.clear();
                                                        selectedSVUniqueID.clear();
                                                        totalCylinderQty = 0;
                                                        selectedConsumerNumbersTV.clear();
                                                        selectedCylinderQuantitiesTV.clear();
                                                        totalCylinderQtyTV = 0;
                                                        originalConsumerNumbersTV.clear();
                                                        originalConsumerQtyTV.clear();
                                                        originalConsumerNumbersSV.clear();
                                                        originalConsumerQtySV.clear();
                                                        originalSVUniqueIdMap.clear();
                                                        selectedConsumerIDLessEmpty.clear();
                                                        selectedConsumerQtyLessEmpty.clear();
                                                        selectedCustomerNamesLessEmpty.clear();
                                                        _totalImbalanceQtyDMQty.clear();
                                                        _totalImbalanceQtyDMCustomer.clear();
                                                        isDeliverySelected = false;
                                                        isCustomerSelected = false;
                                                      });
                                                    } else {
                                                      showFlushBar(context, Constants
                                                          .recordAlreadyExist);
                                                    }
                                                  }
                                                } else {
                                                  List<String> consumerNumberss = getConsumerNumbers();
                                                  List<int> cylinderQuantities = getCylinderQuantities();
                                                  List<int> sVUniqueconsumerNumberss = getSVUniqueConsumerNumbers();

                                                  List<String> consumerNumberssTV = getConsumerNumbersTV();
                                                  List<int> cylinderQuantitiesTV = getCylinderQuantitiesTV();

                                                  int lessEmpt= int.parse(_lessEmptyController.text);

                                                  List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
                                                  String lessEmptyConsIdString = '';

                                                  List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
                                                  String lessEmptyConsNameString = '';

                                                  List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
                                                  String lessEmptyConsQtyString = '';
                                                  String lessEmptyDMQty = '';

                                                  if(lessEmpt > 0){
                                                    int customerTotal = lessEmptyConsumerQty.fold(0, (sum, item) => sum + item);
                                                    int dmQty = int.tryParse(_totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text) ?? 0;
                                                    int totalUsedQty = (dmQty ?? 0) + customerTotal;
                                                    int enteredQty = int.tryParse(_lessEmptyController.text) ?? 0;
                                                    if(totalUsedQty != enteredQty){
                                                      showFlushBar(context, "Less Empty Quantity Must Be Equal To Custome And DM Quantity..");
                                                      return;
                                                    }
                                                    if(isDeliverySelected == true && isCustomerSelected == true){
                                                      if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                                        showFlushBar(context, "Select Customer For Imbalance.");
                                                        return;
                                                      }
                                                      lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                                                      lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                                      lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                                      lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                                    }else if(isDeliverySelected == true && isCustomerSelected == false){
                                                      lessEmptyDMQty = _lessEmptyController.text.isEmpty ? '' : _lessEmptyController.text;
                                                      lessEmptyConsIdString = '';
                                                      lessEmptyConsNameString = '';
                                                      lessEmptyConsQtyString = '';
                                                    }else if(isDeliverySelected == false && isCustomerSelected == false){
                                                      if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                                        showFlushBar(context, "Select Customer or Delivery Men For Imbalance.");
                                                        return;
                                                      }
                                                    }else if(isDeliverySelected == false && isCustomerSelected == true){
                                                      if(lessEmptyConsumerID.isEmpty || lessEmptyConsumerID == null){
                                                        showFlushBar(context, "Select Customer For Imbalance.");
                                                        return;
                                                      }
                                                      lessEmptyDMQty = _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;
                                                      lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                                      lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                                      lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                                    }
                                                  }else{
                                                    lessEmptyDMQty = '';
                                                    lessEmptyConsIdString = '';
                                                    lessEmptyConsNameString = '';
                                                    lessEmptyConsQtyString = '';
                                                  }
                                                  // List<int> lessEmptyConsumerID = getCustomerLessEmptyIDs();
                                                  //
                                                  // String lessEmptyConsIdString = lessEmptyConsumerID.isEmpty ? '' : lessEmptyConsumerID.join(', ');
                                                  //
                                                  //
                                                  // List<String> lessEmptyConsumerName = getCustomerLessEmptyNames();
                                                  // String lessEmptyConsNameString = lessEmptyConsumerName.isEmpty ? '' : lessEmptyConsumerName.join(', ');
                                                  //
                                                  // List<int> lessEmptyConsumerQty = getLessEmptyQuantities();
                                                  // String lessEmptyConsQtyString = lessEmptyConsumerQty.isEmpty ? '' : lessEmptyConsumerQty.join(', ');
                                                  // String lessEmptyDMQty =  _totalImbalanceQtyDMQty.text.isEmpty ? '' : _totalImbalanceQtyDMQty.text;

                                                  final isUpdated =
                                                  await updateRefillSale
                                                      ?.updateRowByColID(
                                                    _editingItemId!,
                                                    ItemData(
                                                      date:
                                                      deliveryDateController
                                                          .text,
                                                      deliveryBoyName:
                                                      selectedDelBoyName
                                                          .toString(),
                                                      delBoyId:
                                                      selectedDelBoyId
                                                          .toString(),
                                                      vehicleNo:
                                                      vehicleNo.toString(),
                                                      itemName:
                                                      _selectedItem.toString(),
                                                      itemID:
                                                      selectedItemId.toString(),
                                                      filled: _filledController
                                                          .text,
                                                      sv: _svController.text,
                                                      tv: _tvController.text,
                                                      empty: _emptyController
                                                          .text,
                                                      defective:
                                                      _defectiveController.text,
                                                      lessEmpty:
                                                      _lessEmptyController.text,
                                                      remark: _remarkController
                                                          .text,
                                                      svRemark: consumerNumberss.join(', '),
                                                      svCount: cylinderQuantities.join(', '),
                                                      tvConsumerNo: consumerNumberssTV.join(', '),
                                                      tvCount: cylinderQuantitiesTV.join(', '),
                                                      updateFlag: 'pending',
                                                      itemAddedDate: formattedDate,
                                                      sVUniqueId: sVUniqueconsumerNumberss.join(', '),
                                                      lessEmptyCustomer: lessEmptyConsNameString,
                                                      lessEmptyDMCount: lessEmptyDMQty,
                                                      lessEmptyCustomerCount: lessEmptyConsQtyString,
                                                      lessEmptyCustomerId: lessEmptyConsIdString,
                                                    ),
                                                  );

                                                  if (isUpdated == true) {
                                                    EasyLoading.showToast(
                                                        Constants.dataUpdated,
                                                        duration: const Duration(
                                                            milliseconds: 3000));

                                                    fetchData(
                                                        selectedDelBoyId
                                                            .toString(),
                                                        deliveryDateController
                                                            .text);

                                                    setState(() {
                                                      _editingItemId = null;
                                                      _filledController.clear();
                                                      _svController.clear();
                                                      _tvController.clear();
                                                      _emptyController.clear();
                                                      _defectiveController
                                                          .clear();
                                                      _lessEmptyController
                                                          .clear();
                                                      _remarkController.clear();
                                                      remarksList.clear();
                                                      tvConsumerList.clear();
                                                      _selectedItemModel = null;
                                                      _selectedItem = '';
                                                      selectedConsumerNumbers.clear();
                                                      selectedCylinderQuantities.clear();
                                                      selectedSVUniqueID.clear();
                                                      totalCylinderQty = 0;
                                                      selectedConsumerNumbersTV.clear();
                                                      selectedCylinderQuantitiesTV.clear();
                                                      totalCylinderQtyTV = 0;
                                                      originalConsumerNumbersTV.clear();
                                                      originalConsumerQtyTV.clear();
                                                      originalConsumerNumbersSV.clear();
                                                      originalConsumerQtySV.clear();
                                                      originalSVUniqueIdMap.clear();
                                                      selectedConsumerIDLessEmpty.clear();
                                                      selectedConsumerQtyLessEmpty.clear();
                                                      selectedCustomerNamesLessEmpty.clear();
                                                      _totalImbalanceQtyDMQty.clear();
                                                      _totalImbalanceQtyDMCustomer.clear();
                                                      isDeliverySelected = false;
                                                      isCustomerSelected = false;
                                                    });
                                                  } else {
                                                    showFlushBar(context,
                                                        Constants.recordAlreadyExist);
                                                  }
                                                }
                                              }
                                            } else {
                                              showFlushBar(context,
                                                  Constants.countShouldNotBeGreater);
                                            }
                                          } else {
                                            showFlushBar(context,
                                                Constants.countShouldNotBeGreater);
                                          }
                                          // } else {
                                          //   showFlushBar(context, "Cylinder Count",
                                          //       'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                          // }
                                        } else {
                                          showFlushBar(context,
                                              Constants.countShouldNotBeGreater);
                                        }
                                      } else {
                                        showFlushBar(context,
                                            Constants.countShouldNotBeGreater);
                                      }
                                      // }
                                    }else{
                                      showFlushBar(context, Constants.totalSaleQtyDailySale);
                                      debugPrint("sale3");
                                    }
                                  }else{

                                  }
                                }
                              } else {
                                _addNewItem();
                                debugPrint("Add");
                              }
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ((_filledController
                                  .text.isNotEmpty ||
                                  _tvController.text.isNotEmpty) &&
                                  selectedDelBoyName != null &&
                                  _selectedItem != null)
                                  ? AppColors.primary
                                  : AppColors.textDisabled,
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.formButton,
                              ),
                            ),
                            child: Text(
                              flagEditMode == 'editMode'
                                  ? 'Update'
                                  : (_editingItemId != null &&
                                  _dataGetFromDBDelBoy.isNotEmpty
                                  ? 'Update'
                                  : 'Add Entry'),
                              style: AppTextStyles.button.copyWith(fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _filledController.clear();
                              _svController.clear();
                              _tvController.clear();
                              _emptyController.clear();
                              _defectiveController.clear();
                              _lessEmptyController.clear();
                              _remarkController.clear();
                              remarksList.clear();
                              tvConsumerList.clear();
                              selectedConsumerNumbers.clear();
                              selectedCylinderQuantities.clear();
                              selectedSVUniqueID.clear();
                              totalCylinderQty = 0;
                              selectedConsumerNumbersTV.clear();
                              selectedCylinderQuantitiesTV.clear();
                              totalCylinderQtyTV = 0;
                              originalConsumerNumbersTV.clear();
                              originalConsumerQtyTV.clear();
                              originalConsumerNumbersSV.clear();
                              originalConsumerQtySV.clear();
                              originalSVUniqueIdMap.clear();
                              selectedConsumerIDLessEmpty.clear();
                              selectedConsumerQtyLessEmpty.clear();
                              selectedCustomerNamesLessEmpty.clear();
                              _totalImbalanceQtyDMQty.clear();
                              _totalImbalanceQtyDMCustomer.clear();
                              isDeliverySelected = false;
                              isCustomerSelected = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(72, 44),
                            side: const BorderSide(
                                color: AppColors.border, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.formButton,
                            ),
                          ),
                          child: Text(
                            'Clear',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),

                    // ── Items Table ──────────────────────────────
                    if (_dataGetFromDBDelBoy.isNotEmpty ||
                        flagEditMode == 'editMode') ...[
                      const SizedBox(height: 8),
                      _CompactSectionLabel(label: 'Cylinder Entries'),
                      const SizedBox(height: 6),

                      // Table header
                      Container(
                        padding: AppSpacing.tableHeaderPadding,
                        decoration: AppDecorations.tableHeader,
                        child: const Row(
                          children: [
                            Expanded(flex: 3, child: _TableHeaderCell(text: 'Item')),
                            Expanded(flex: 1, child: _TableHeaderCell(text: 'Sale', center: true)),
                            Expanded(flex: 1, child: _TableHeaderCell(text: 'SV', center: true)),
                            Expanded(flex: 1, child: _TableHeaderCell(text: 'TV', center: true)),
                            Expanded(flex: 1, child: _TableHeaderCell(text: 'Emp', center: true)),
                            Expanded(flex: 1, child: _TableHeaderCell(text: 'Def', center: true)),
                            Expanded(flex: 2, child: _TableHeaderCell(text: 'Action', center: true)),
                          ],
                        ),
                      ),

                      Container(
                        decoration: AppDecorations.tableBody,
                        child: flagEditMode == 'editMode'
                            ? FutureBuilder<
                            List<StockSubmitToManagerListModel>>(
                          future: stockDataFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                    child:
                                    CircularProgressIndicator()),
                              );
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                    child:
                                    Text('No data available.')),
                              );
                            }
                            final stockList = snapshot.data!;
                            return Column(
                              children: stockList
                                  .expand((stock) =>
                                  stock.itemList!.map((item) {
                                    return _EntryRow(
                                      itemName: item.itemName
                                          .toString(),
                                      filled: item.filledSaleQty
                                          .toString(),
                                      sv: item.sVQty.toString(),
                                      tv: item.tVQty.toString(),
                                      empty: item.emptyRetQty
                                          .toString(),
                                      def: item.deffQty
                                          .toString(),
                                      onEdit: () {
                                        setState(() {
                                          _onEditItem(item,
                                              stock);
                                          _editingItemId =
                                              item.itemId
                                                  ?.toInt();
                                        });
                                      },
                                      onDelete: () async {
                                        final confirmDelete =
                                        await showDialog<
                                            bool>(
                                          context: context,
                                          builder: (_) =>
                                              AlertDialog(
                                                title: const Text(
                                                    'Delete Entry'),
                                                content: const Text(
                                                    'Are you sure you want to delete this entry?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: const Text(
                                                        'No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    child: const Text(
                                                        'Yes'),
                                                  ),
                                                ],
                                              ),
                                        );
                                        if (confirmDelete ==
                                            true) {
                                          try {
                                            _onDeleteItem(int.parse(
                                                item.itemId
                                                    .toString()));
                                            stockDataFuture = updateRefillSale!.getDeliveryMenDataForEdit(
                                                widget.saleGKId
                                                    ?.toInt() ??
                                                    0,
                                                widget.dMId
                                                    ?.toInt() ??
                                                    0);
                                            EasyLoading.showToast(
                                                Constants
                                                    .dataDeleted,
                                                duration: const Duration(
                                                    milliseconds:
                                                    3000));
                                          } catch (e) {
                                            showFlushBar(context,
                                                Constants.dataDeletedFail);
                                          }
                                        }
                                      },
                                    );
                                  }))
                                  .toList(),
                            );
                          },
                        )
                            : _dataGetFromDBDelBoy.isNotEmpty
                            ? Column(
                          children: _dataGetFromDBDelBoy
                              .asMap()
                              .entries
                              .map((e) {
                            final item = e.value;
                            final isLast = e.key ==
                                _dataGetFromDBDelBoy.length - 1;
                            return _EntryRow(
                              itemName:
                              item['itemName'].toString(),
                              filled: item['filled'].toString(),
                              sv: item['sv'].toString(),
                              tv: item['tv'].toString(),
                              empty: item['empty'].toString(),
                              def: item['defective'].toString(),
                              isLast: isLast,
                              onEdit: () {
                                setState(() {
                                  _editingItemId = int.parse(
                                      item['itemID'].toString());
                                  _populateFieldsForEdit(item);
                                });
                              },
                              onDelete: () async {
                                final confirmDelete =
                                await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text(
                                        'Delete Entry'),
                                    content: const Text(
                                        'Are you sure?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context)
                                                .pop(false),
                                        child:
                                        const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context)
                                                .pop(true),
                                        child:
                                        const Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmDelete == true) {
                                  try {
                                    if (item.containsKey(
                                        'itemID')) {
                                      String itemId = item[
                                      'itemID']
                                          .toString();
                                      String delBoyId = item[
                                      'delBoyId']
                                          .toString();
                                      await updateRefillSale
                                          ?.deleteRowByDelBoyIdAndItemId(
                                          delBoyId, itemId);
                                      fetchData(
                                          selectedDelBoyId
                                              .toString(),
                                          deliveryDateController
                                              .text);
                                      EasyLoading.showToast(
                                          Constants.dataDeleted,
                                          duration: const Duration(
                                              milliseconds:
                                              3000));
                                    }
                                  } catch (e) {
                                    showFlushBar(context,
                                        Constants.dataDeletedFail);
                                  }
                                }
                              },
                            );
                          }).toList(),
                        )
                            : const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                              child: Text('No pending entries.')),
                        ),
                      ),
                    ],

                    // ── Submit Button ────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (stockTransferFlag) {
                            if (saveFlag) {
                              showFlushBar(
                                  context, Constants.dayEndCompleted);
                            } else {
                              if (flagEditMode == 'editMode') {
                                (stockDataFuture != null)
                                    ? sendEditedDataToApi(context)
                                    : null;
                              } else {
                                (_dataGetFromDBDelBoy.isNotEmpty &&
                                    (selectedDelBoyName != null &&
                                        selectedDelBoyName!.isNotEmpty))
                                    ? sendDataToApi(
                                    selectedDelBoyId.toString(),
                                    deliveryDateController.text)
                                    : null;
                              }
                            }
                          } else {
                            CustomAlertDialog.showCustomAlert(
                                context, Constants.stockNotAccepted);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getButtonColor(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dense input decoration (compact, mobile-optimised) ─────────
  InputDecoration _denseInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.formHint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      filled: true,
      fillColor: AppColors.surfaceMuted,
      border: AppDecorations.formBorderEnabled,
      enabledBorder: AppDecorations.formBorderEnabled,
      focusedBorder: AppDecorations.formBorderFocused,
      disabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.formDropdown,
        borderSide: const BorderSide(color: AppColors.divider),
      ),
    );
  }

  // ── Input decoration helper (kept for backward compat) ──────────
  InputDecoration _cleanInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.formHint,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: AppColors.surfaceMuted,
      border: AppDecorations.formBorderEnabled,
      enabledBorder: AppDecorations.formBorderEnabled,
      focusedBorder: AppDecorations.formBorderFocused,
      disabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.formDropdown,
        borderSide: const BorderSide(color: AppColors.divider),
      ),
    );
  }

  // Function to determine the button color
  Color _getButtonColor() {
    if(flagEditMode == "editMode" ){
      if (flagEditMode == "editMode" &&
          (stockDataFuture != null)) {
        return Colors.blue; // Color for enabled button in edit mode
      }
      return Colors.grey; // Default color for disabled button
    }else{
      if (_dataGetFromDBDelBoy.isNotEmpty &&
          (selectedDelBoyName != null && selectedDelBoyName!.isNotEmpty)) {
        return Colors.blue; // Color for enabled button in edit mode
      }
      return Colors.grey; // Default color for disabled button
    }

  }

  // Fetch data from API Item
  Future<void> fetchItems() async {
    // EasyLoading.instance
    //   ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
    //   ..loadingStyle = EasyLoadingStyle.light
    //   ..dismissOnTap = false // Disable dismissing the loader by tapping
    //   ..userInteractions = false;
    // EasyLoading.show(status: 'Loading...');

    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken =
      prefs.getString('token'); // Assuming the token is stored here

      if (bearerToken == null) {
        throw Exception('Bearer token is missing');

      }
      try{

        final response = await http.get(
          Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
          headers: {
            'Authorization': 'Bearer $bearerToken', // Add Bearer token here
          },
        );
        debugPrint("GetItemMasterList" +
            '${AppUrl.GetItemMasterList}/$distributorId/1/C');
        debugPrint("GetItemMasterList" + response.body);
        if (response.statusCode == 200) {
          // Parse the response
          List<dynamic> data = json.decode(response.body);
          setState(() {
            _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
            _items = _items
                .where(
                    (item) => !item.itemName!.toLowerCase().contains('regulator'))
                .toList();


          });
        } else {

          refreshTokens();
          throw Exception('Failed To Load Items');
        }
      }
      // catch(e){
      //   debugPrint("GetItemMasterList" + e.toString());
      // }
      catch (e, stackTrace) {
        debugPrint("EXCEPTION: $e");
        debugPrint("STACKTRACE: $stackTrace");
      }
    } else {

      showFlushBar(
          context,Constants.connectionMessage);
    }


  }

  // Fetch data from API Del boy
  Future<void> fetchDeliveryBoyInfo() async {
    // EasyLoading.instance
    //   ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
    //   ..loadingStyle = EasyLoadingStyle.light
    //   ..dismissOnTap = false // Disable dismissing the loader by tapping
    //   ..userInteractions = false;
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken =
      prefs.getString('token'); // Assuming the token is stored here

      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }
      try{

        final response = await http.get(
          Uri.parse('${AppUrl.GetStaffDetailsList}/$distributorId/1/2'),
          headers: {
            'Authorization': 'Bearer $bearerToken', // Add Bearer token here
          },
        );
        debugPrint(
            "_delBoyInfo" + '${AppUrl.GetStaffDetailsList}/$distributorId/1/2');
        debugPrint("_delBoyInfo" + response.body);
        if (response.statusCode == 200) {
          // Parse the response
          List<dynamic> data = json.decode(response.body);
          setState(() {
            _delBoyInfo =
                data.map((json) => DeliveryBoyInfoModel.fromJson(json)).toList();
          });
        } else {
          refreshTokens();
          throw Exception(Constants.listGettingFail);
        }
      }
      // catch(e){
      //   debugPrint("_delBoyInfo" + e.toString());
      // }
      catch (e, stackTrace) {
        debugPrint("EXCEPTION1: $e");
        debugPrint("STACKTRACE1: $stackTrace");
      }
    } else {
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }

  Future<void> fetchVehicleDetail(int staffId,String vehicleNumb) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) {
        throw Exception('Bearer Token Is Missing');
      }

      final response = await http.get(
        Uri.parse(
          '${AppUrl.GetVehicleDetailsByStaffId}/$distributorId/0', // always 0
        ),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      debugPrint("GetVehicleDetailsByStaffId ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);

        List<VehicleNumberGetModel> data = responseData
            .map((item) => VehicleNumberGetModel.fromJson(item))
            .toList();

        if (data.isNotEmpty) {
          setState(() {
            vehicleList = data;
            if(flagEditMode == "editMode"){
              /// 🔥 find staff vehicle from full list
              final staffVehicle = vehicleList.firstWhere(
                    (v) => v.vehicleNo == vehicleNumb,
                orElse: () => vehicleList.first,
              );
              vehicleNo = staffVehicle.vehicleNo;
              vehicleId = staffVehicle.vehicleId;
            }else{
              /// 🔥 find staff vehicle from full list
              final staffVehicle = vehicleList.firstWhere(
                    (v) => v.staffId == staffId,
                orElse: () => vehicleList.first,
              );
              vehicleNo = staffVehicle.vehicleNo;
              vehicleId = staffVehicle.vehicleId;
            }



          });
        }
      }
    }
    // catch (e) {
    //   debugPrint("fetchVehicleDetail error: $e");
    // }
    catch (e, stackTrace) {
      debugPrint("EXCEPTION2: $e");
      debugPrint("STACKTRACE2: $stackTrace");
    }
  }

//vehicle info
//   Future<void> fetchVehicleDetail(int staffId) async {
//     // EasyLoading.instance
//     //   ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
//     //   ..loadingStyle = EasyLoadingStyle.light
//     //   ..dismissOnTap = false // Disable dismissing the loader by tapping
//     //   ..userInteractions = false;
//     Constants.isNetworkAvailable =
//         await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken =
//           prefs.getString('token'); // Assuming the token is stored here
//
//       if (bearerToken == null) {
//         throw Exception('Bearer Token Is Missing');
//       }
//         try{
//
//
//       final response = await http.get(
//         Uri.parse(
//             '${AppUrl.GetVehicleDetailsByStaffId}/$distributorId/0'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//         },
//       );
//
//       debugPrint("GetVehicleDetailsByStaffId" +
//           '${AppUrl.GetVehicleDetailsByStaffId}/$distributorId/0');
//       debugPrint("Response body: " + response.body);
//       if (response.statusCode == 200) {
//         List<dynamic> responseData = json.decode(response.body);
//
//         List<VehicleNumberGetModel> data = responseData
//             .map((item) => VehicleNumberGetModel.fromJson(item))
//             .toList();
//
//         if (data.isNotEmpty) {
//           setState(() {
//             vehicleList = data;
//
//             // If vehicleNo already exists (edit / args)
//             final matchedVehicle = vehicleNo != null
//                 ? vehicleList.firstWhere(
//                   (v) => v.vehicleNo == vehicleNo,
//               orElse: () => vehicleList.first,
//             )
//                 : vehicleList.first;
//
//             vehicleNo = matchedVehicle.vehicleNo;
//             vehicleId = matchedVehicle.vehicleId;
//
//             debugPrint("Selected VehicleNo: $vehicleNo");
//             debugPrint("Selected VehicleId: $vehicleId");
//           });
//         }
//
//       }
//
//       // if (response.statusCode == 200) {
//       //   // Parse the response body and map it to VehicleNumberGetModel
//       //   List<dynamic> responseData = json.decode(response.body);
//       //   List<VehicleNumberGetModel> data = responseData
//       //       .map((item) => VehicleNumberGetModel.fromJson(item))
//       //       .toList();
//       //
//       //   // Assuming we want to set the vehicle number from the first vehicle in the list
//       //   if (data.isNotEmpty) {
//       //     setState(() {
//       //       // vehicleNoController.text = data[0].vehicleNo ?? '';
//       //       vehicleNo = data[0].vehicleNo ?? '';
//       //       vehicleId =
//       //           data[0].vehicleId ?? 0;
//       //       debugPrint("vehicleId body: " + vehicleId.toString());// Set the vehicle number (if available)
//       //     });
//       //
//       //   } else {
//       //     // vehicleNoController.text = " " ?? '';
//       //     vehicleNo = " "?? '';
//       //   }
//       // } else {
//       //   // Optionally handle token refresh here or show an error
//       //   throw Exception(Constants.listGettingFail);
//       // }
//         }catch(e){
//           debugPrint("vehicleId body: " + e.toString());
//         }
//     } else {
//       showFlushBar(
//           context, Constants.connectionMessage);
//     }
//   }

  Future<void> sendDataToApi(String deliveryBoyId, String delDate) async {
    EasyLoading.show(status: 'Sending Data...');
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      // try {
      // Get shared preferences for distributorId and bearerToken
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      String? godownKeeperID = prefs.getString('godownKeeperId');
      String? addedBy = prefs.getString('StaffId');
      String? godownID = prefs.getString('godownId');

      if (distributorId == null || bearerToken == null) {
        print('DistributorId or BearerToken is missing');
        return;
      }

      // Fetch the data for the deliveryBoyId
      var getUpdateRefillSale =
      await updateRefillSale?.getUpdateRefillSaleData2(
          deliveryBoyId.toString(), delDate.toString());
      print('No data found for this deliveryBoyId $getUpdateRefillSale');
      if (getUpdateRefillSale == null) {
        print('No data found for this deliveryBoyId');
        return;
      }



      List<ItemData> itemList = [];

      // Convert the fetched data into ItemData objects
      for (var item in getUpdateRefillSale) {
        itemList.add(ItemData.fromJson(item));
      }

      // Format the data into the structure needed for the API
      List<Map<String, dynamic>> apiItemList = itemList.map((item) {
        return {
          "ItemId": item.itemID.toString(),
          // Ensure ItemId is a string for the API request
          "FilledSaleQty": item.filled.toString(),
          "SVQty": item.sv.toString(),
          "TVQty": item.tv.toString(),
          "EmptyRetQty": item.empty.toString(),
          "DeffQty": item.defective.toString(),
          "LessEmptyQty": item.lessEmpty.toString(),
          "Remark": item.remark ?? "",
          "ClosingFilled": "",
          "ClosingEmpty": "",
          "ClosingDef": "",
          "DailySaleStatus": 1,
          "SVConsStr": item.svRemark ?? "",
          "TVConsStr": item.tvConsumerNo ?? "",
          "SVQtyStr": item.svCount ?? "",
          "TVQtyStr": item.tvCount ?? "",
          "PSVIdStr": item.sVUniqueId ?? "",
          "ImbForIdStr": item.lessEmptyCustomerId ?? "",
          "ImbQtyStr": item.lessEmptyCustomerCount ?? "",
          "DMImbQty": item.lessEmptyDMCount.toString(),
        };
      }).toList();

      // Prepare the entire data structure for the API
      Map<String, dynamic> apiData = {
        "SaleGKId": "0", // Assuming this is always 0 for the new sale
        "DistributorId": distributorId,
        "GodownId": godownID,
        "DeliveryDate": deliveryDateController.text.toString(),
        "DMId": deliveryBoyId.toString(),
        "VehicleId": vehicleId, // Use your actual vehicle ID if needed
        "AddedBy": addedBy, // Use the actual user ID
        "Action": "ADD",
        "DailySaleStatus": 1, // Assuming you're adding new data
        "ItemList": apiItemList,
      };

      // Convert data to JSON and send it to the API
      String jsonRequestBody = jsonEncode(apiData);
      debugPrint("jsonRequestBody$jsonRequestBody");
      if (apiItemList != null && apiItemList.isNotEmpty) {
        // Send the API request
        final response = await http.post(
          Uri.parse('${AppUrl.UpdateDailyRefillSale}'), // Your actual API URL
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $bearerToken',
            // Authorization header with Bearer token
          },
          body: jsonRequestBody, // The body of the request
        );
        print('response UpdateDailyRefillSale ${response.body}');
        print('response UpdateDailyRefillSale ${response}');
        print('response UpdateDailyRefillSale ${response.request}');
        print('jsonRequestBody UpdateDailyRefillSale ${jsonRequestBody}');
        // Check response status
        if (response.statusCode == 200) {
          // print('Data sent successfully');
          // EasyLoading.showToast("Data Sent Successfully.",
          //     duration: const Duration(milliseconds: 3000));
          // Navigator.pushReplacementNamed(context, '/deliveryMenListShowScreen');
          // Navigator.pushNamed(
          //   context,
          //   BottomNavigationForGodownKeeper.screenName,
          //   arguments: 1, // This opens the third tab
          // );
          // Navigator.pushReplacementNamed(context, BottomNavigationForGodownKeeper.screenName);

          EasyLoading.dismiss();

          print('Data sent successfully');

          EasyLoading.showToast(
            "Data Sent Successfully.",
            duration: const Duration(seconds: 2),
          );

          await Future.delayed(const Duration(seconds: 2));

          Navigator.pushReplacementNamed(
            context,
            BottomNavigationForGodownKeeper.screenName,
          );
          // Navigator.pop(context);
          // Safely extract ItemIds (ensure they're integers)
          List<int> itemIds = apiItemList.map<int>((item) {
            // Try to safely parse the ItemId string as an integer
            int? itemIdInt = int.tryParse(item["ItemId"]);
            if (itemIdInt == null) {
              // Handle the case where ItemId is not a valid integer (fallback to 0)
              print(
                  "Warning: ItemId '${item["ItemId"]}' is invalid. Defaulting to 0.");
              itemIdInt = 0;
            }
            return itemIdInt!;
          }).toList();

          // Update the refill sale flag to complete after the API call
          await UpdateRefillSale().updateRefillSaleFlagToComplete(
              itemIds, deliveryBoyId, delDate);
          fetchData(selectedDelBoyId.toString(), deliveryDateController.text);
          // Clear selected delivery boy and dropdown
          setState(() {
            selectedDelBoyName = ''; // Clear the delivery boy name
            selectedDelBoyId = null; // Clear delivery boy ID
            _selectedItemModel =
            null; // Clear the selected item in the dropdown
            _selectedItem = ''; // Clear the selected item text
            // vehicleNoController.clear();
            EasyLoading.dismiss();
          });
        } else {
          print('Failed to send data: ${response.statusCode}');
          EasyLoading.showToast("Failed To Send Data.",
              duration: const Duration(milliseconds: 3000));
          EasyLoading.dismiss();
        }
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Enter record for that delivery boy..!')),
        // );
        EasyLoading.dismiss();
      }
      // } catch (e) {
      //   EasyLoading.dismiss();
      //   print('Error sending data to API: $e');
      // }
    } else {
      EasyLoading.dismiss();
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }

  Future<void> fetchData(String deliveryBoyId, String delDate) async {
    try {
      // Fetch data for the given deliveryBoyId
      List<Map<String, Object?>>? fetchedData = await updateRefillSale
          ?.getUpdateRefillSaleData2(deliveryBoyId, delDate.toString());

      if (fetchedData != null && fetchedData.isNotEmpty) {
        setState(() {
          _dataGetFromDBDelBoy = fetchedData;
          print(
              '_dataGetFromDBDelBoy: $_dataGetFromDBDelBoy');
          // Store the fetched data in _data
          // EasyLoading.dismiss();
        });
      } else {
        // Handle the case when no data is returned
        setState(() {
          _dataGetFromDBDelBoy = [];
          print(
              '_dataGetFromDBDelBoy: $_dataGetFromDBDelBoy'); // Store the fetched data in _data
// Empty the list if no data is found
//           EasyLoading.dismiss();
        });
      }
    } catch (e) {
      // EasyLoading.dismiss();
      print('Error fetching data: $e');
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Data Reminder"),
      content: Text(
          "Some data in your text box that you not added for submit plese add that data before submit"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _populateFieldsForEdit(Map<String, Object?> item) {
    setState(() {
      selectedConsumerIDLessEmpty.clear();
      selectedConsumerQtyLessEmpty.clear();
      selectedCustomerNamesLessEmpty.clear();
      // Populate text fields with data from the item
      selectedConsumerNumbers.clear();
      selectedCylinderQuantities.clear();
      selectedSVUniqueID.clear();

      selectedConsumerNumbersTV.clear();
      selectedCylinderQuantitiesTV.clear();
      originalConsumerNumbersTV.clear();
      originalConsumerQtyTV.clear();
      originalConsumerNumbersSV.clear();
      originalConsumerQtySV.clear();
      originalSVUniqueIdMap.clear();

      _filledController.text = item['filled'].toString();
      _svController.text = item['sv'].toString();
      _tvController.text = item['tv'].toString();
      _emptyController.text = item['empty'].toString();
      _defectiveController.text = item['defective'].toString();
      _lessEmptyController.text = item['lessEmpty'].toString();
      _remarkController.text = item['remark']?.toString() ?? '';
      // Initialize lists for consumer numbers and their quantities (SV, TV, etc.)

      // Set the selected item in the dropdown by finding the item in the list
      _selectedItem = item['itemName'].toString();
      selectedItemId = int.parse(item['itemID'].toString());

      debugPrint("selectedItemId: $selectedItemId");
      debugPrint("_selectedItem: $_selectedItem");

      // String? svRemark = item['svRemark']?.toString();
      // if (svRemark != null &&
      //     svRemark.isNotEmpty &&
      //     !selectedConsumerNumbers.contains(svRemark)) {
      //   selectedConsumerNumbers.add(svRemark);
      // }
      // Split the svRemark and svCount values and populate the lists

      //
      // String? svRemark = item['svRemark']?.toString();
      // String? svCount = item['svCount']?.toString();
      //
      // if (svRemark != null && svCount != null) {
      //   // Split the comma-separated consumer numbers and quantities
      //   List<String> consumerNumbers = svRemark.split(',').map((e) => e.trim()).toList();
      //   List<String> quantities = svCount.split(',').map((e) => e.trim()).toList();
      //
      //   // Populate the selectedConsumerNumbers and selectedCylinderQuantities lists
      //   for (int i = 0; i < consumerNumbers.length; i++) {
      //     String consumerNo = consumerNumbers[i];
      //     String qtyStr = quantities[i];
      //     int cylQty = int.tryParse(qtyStr) ?? 0; // Ensure safe parsing
      //
      //     selectedConsumerNumbers.add(consumerNo);
      //     selectedCylinderQuantities.add(cylQty);
      //   }
      // }

      ///sv
      // Split the svRemark and svCount values and populate the lists
      String? svRemark = item['svRemark']?.toString();
      String? svCount = item['svCount']?.toString();
      String? svUniqNo = item['SVUniqueID']?.toString();

      debugPrint("consumerNumbers: $svRemark");
      debugPrint("quantities: $svCount");
      debugPrint("svUniqueNo: $svUniqNo");
      if (svRemark != null && svCount != null && svRemark.isNotEmpty && svCount.isNotEmpty) {

        // Split the comma-separated consumer numbers and quantities
        List<String> consumerNumbers = svRemark.split(',').map((e) => e.trim()).toList();
        List<String> quantities = svCount.split(',').map((e) => e.trim()).toList();
        List<String> svUniqueNo = svUniqNo!.split(',').map((e) => e.trim()).toList();

        // Populate the selectedConsumerNumbers and selectedCylinderQuantities lists
        for (int i = 0; i < consumerNumbers.length; i++) {
          String consumerNo = consumerNumbers[i];
          String qtyStr = quantities[i];
          String svNoUniq = svUniqueNo[i];
          int cylQty = int.tryParse(qtyStr) ?? 0; // Ensure safe parsing
          int svNo = int.tryParse(svNoUniq) ?? 0; // Ensure safe parsing

          // Only add if the consumer number is not already in the list
          if (!selectedConsumerNumbers.contains(consumerNo)) {
            selectedConsumerNumbers.add(consumerNo);
            selectedCylinderQuantities.add(cylQty);
            selectedSVUniqueID.add(svNo);
          }

          if (!originalConsumerNumbersSV.contains(consumerNo)) {
            originalConsumerNumbersSV.add(consumerNo);
          }
          originalConsumerQtySV[consumerNo] = cylQty;
          originalSVUniqueIdMap[consumerNo] = svNo.toInt();

        }
      }else{
        selectedConsumerNumbers.clear();
        selectedCylinderQuantities.clear();
        selectedSVUniqueID.clear();
        originalConsumerNumbersSV.clear();
        originalConsumerQtySV.clear();
        originalSVUniqueIdMap.clear();

      }


      ///
      String? tvRemark = item['tvConsumerNo']?.toString();
      String? tvCount = item['tvCount']?.toString();

      if (tvRemark != null && tvCount != null && tvRemark.isNotEmpty && tvCount.isNotEmpty) {

        // Split the comma-separated consumer numbers and quantities
        List<String> consumerNumbersTV = tvRemark.split(',').map((e) => e.trim()).toList();
        List<String> quantitiesTV = tvCount.split(',').map((e) => e.trim()).toList();

        // Populate the selectedConsumerNumbers and selectedCylinderQuantities lists
        for (int i = 0; i < consumerNumbersTV.length; i++) {
          String consumerNoTV = consumerNumbersTV[i];
          String qtyStrTV = quantitiesTV[i];
          int cylQtyTV = int.tryParse(qtyStrTV) ?? 0; // Ensure safe parsing

          // Only add if the consumer number is not already in the list
          if (!selectedConsumerNumbersTV.contains(consumerNoTV)) {
            selectedConsumerNumbersTV.add(consumerNoTV);
            selectedCylinderQuantitiesTV.add(cylQtyTV);
          }

          if (!originalConsumerNumbersTV.contains(consumerNoTV)) {
            originalConsumerNumbersTV.add(consumerNoTV);
          }
          // 🔥 bind quantity correctly
          originalConsumerQtyTV[consumerNoTV] = cylQtyTV;
        }
      }else{
        selectedConsumerNumbersTV.clear();
        selectedCylinderQuantitiesTV.clear();
        originalConsumerNumbersTV.clear();
        originalConsumerQtyTV.clear();
      }

      ///less empty

      _totalImbalanceQtyDMQty.text = item['lessEmptyDMCount'].toString();
      remainingDMQty = int.tryParse(item['lessEmptyDMCount'].toString()) ?? 0;
      editModeRemainQty = int.tryParse(item['lessEmptyDMCount'].toString()) ?? 0;
      oldLessEmptyQty = int.tryParse(item['lessEmpty'].toString()) ?? 0;

      String? lessemptyCutomerNames = item['lessEmptyCustomer']?.toString();
      String? lessEmptyCustomerCounts = item['lessEmptyCustomerCount']?.toString();
      String? lessEmptyCustomerId = item['lessEmptyCustomerId']?.toString();
      int count = int.tryParse(item['lessEmptyDMCount'].toString()) ?? 0;

      if (count > 0) {
        // do your logic here
        isDeliverySelected = true;
      }else{
        isDeliverySelected = false;
      }
      int ids = int.tryParse(lessEmptyCustomerId ?? "") ?? 0;
      if(lessEmptyCustomerId != null && lessEmptyCustomerId.isNotEmpty && lessEmptyCustomerCounts != null && lessEmptyCustomerCounts.isNotEmpty && ids>0){
        isCustomerSelected = true;
        List<String> lessEmptyConsName = lessemptyCutomerNames!.split(',').map((e) => e.trim()).toList();
        List<String> lessEmptyConsId = lessEmptyCustomerId.split(',').map((e) => e.trim()).toList();
        List<String> lessEmptyConsCount = lessEmptyCustomerCounts.split(',').map((e) => e.trim()).toList();

        for (int i = 0; i < lessEmptyConsId.length; i++) {
          String consId = lessEmptyConsId[i];
          String qtyLessEmpty = lessEmptyConsCount[i];
          String consNameLessEmpty = lessEmptyConsName[i];
          int qty = int.tryParse(qtyLessEmpty) ?? 0;
          int ids = int.tryParse(consId) ?? 0;
          selectedConsumerIDLessEmpty.add(ids);
          selectedConsumerQtyLessEmpty.add(qty);
          selectedCustomerNamesLessEmpty.add(consNameLessEmpty);
        }

      }else{
        selectedConsumerIDLessEmpty.clear();
        selectedConsumerQtyLessEmpty.clear();
        selectedCustomerNamesLessEmpty.clear();
        isCustomerSelected = false;
      }
      // Find the selected item in the list and update _selectedItem
      _selectedItemModel =
          _items.firstWhere((itemModel) => itemModel.itemId == selectedItemId);

      // Save the ID of the row being edited (optional for database update)
      _editingItemId = int.parse(item['ID'].toString());
      _fetchFilledStockForSelectedItem(selectedItemId!);
    });
  }

  void _showPopup(int emptyCount, int delMenId, int itemId) {
    TextEditingController countController = TextEditingController();
    int remainingCount = emptyCount;
    debugPrint('itemId ${emptyCount},${delMenId},${itemId}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to manage the state inside the dialog
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text("Update Count"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Empty Count: $emptyCount"),
                  SizedBox(height: 10),
                  TextField(
                    controller: countController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter count",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setDialogState(() {
                        // Parse the input and calculate the remaining count
                        int? inputCount = int.tryParse(value);
                        if (emptyCount != null) {
                          if (inputCount! <= emptyCount) {
                            remainingCount = emptyCount - inputCount!;
                            debugPrint("y");
                          } else {
                            showFlushBar(context, Constants.imbalanceCountValidation);
                            countController.text = '';
                            remainingCount = emptyCount;
                            debugPrint("yu");
                          }
                        } else {
                          remainingCount = emptyCount; // Reset if invalid input
                        }
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Remaining Count: $remainingCount",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the popup
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    int? inputCount = int.tryParse(countController.text);
                    if (inputCount != null && inputCount <= emptyCount) {
                      setState(() {
                        emptyCount -= inputCount; // Update the emptyCount state
                      });
                      // Call API with the request body
                      addItemImbalanceQty(delMenId, itemId,inputCount);
                      Navigator.of(context).pop(); // Close the popup
                    } else {
                      showFlushBar(context, Constants.imbalanceCountValidation);
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    // Button expands to fill available width// Text color of the button
                    shape: RoundedRectangleBorder(
                      // Optional: Set rounded corners
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

  Future<void> refreshTokens() async {
    LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      mobileNo = preferences.getString('MobileNo').toString();

      final Future<Map<String, dynamic>> respose =
      auth.refreshToken(mobileNo!, context);

      try {
        respose.then((response) {
          EasyLoading.dismiss();
          if (response['status']) {
            debugPrint('RefreshTokenStatus - True');
            fetchItems();
            fetchDeliveryBoyInfo();
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
        String message = "Your Session Is Expire. Click Ok To Login Again.";
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
                // onPressed: () {},
                onPressed: () => logoutUser(context),

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

  // Future<void> _fetchImbalanceData(int delManId) async {
  //   // EasyLoading.instance
  //   //   ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
  //   //   ..loadingStyle = EasyLoadingStyle.light
  //   //   ..dismissOnTap = false // Disable dismissing the loader by tapping
  //   //   ..userInteractions = false;
  //   Constants.isNetworkAvailable =
  //   await InternetConnectionChecker().hasConnection;
  //   if (Constants.isNetworkAvailable) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? godownId = prefs.getString('godownId');
  //     String? addedBy = prefs.getString('StaffId');
  //     String? godownKeeperId = prefs.getString('godownKeeperId');
  //     String? token = prefs.getString('token'); // This is your bearer token
  //     int dId = int.parse(distributorId!);
  //
  //     try {
  //       final response = await http.get(
  //         Uri.parse('${AppUrl.ItemImbalanceList}/$dId/$delManId'),
  //         headers: {
  //           'Authorization': 'Bearer $token', // Add the Bearer token here
  //         },
  //       );
  //       print("Total ImbQty for delManId response ${response.body}");
  //       print("Total ImbQty for delManId request ${response.request}");
  //       if (response.statusCode == 200) {
  //         final List<dynamic> data = json.decode(response.body);
  //
  //         setState(() {
  //           receiptList = data
  //               .map((json) => ImabalanceEmptyListModel.fromJson(json))
  //               .toList();
  //           isLoading = false;
  //           // EasyLoading.dismiss();
  //           // Initialize totalImbQty
  //           num totalImbQty = 0;
  //
  //           // Loop through each receipt and each item inside itemImbDtls to sum ImbQty
  //           for (var receipt in receiptList) {
  //             // Add imbQty to totalImbQty, treating null as 0
  //             totalImbQty +=
  //                 receipt.balImbQty ?? 0; // Corrected summing of imbQty
  //
  //           }
  //
  //           // Log the total imbalance quantity
  //           print("Total ImbQty for delManId $delManId: $totalImbQty");
  //           imbalaceSum = totalImbQty.toInt();
  //           // Optionally, you can store this in a variable or use it in the UI
  //         });
  //       } else {
  //         // Handle non-200 responses
  //         setState(() {
  //           // EasyLoading.dismiss();
  //           isLoading = false;
  //           showFlushBar(context, Constants.listGettingFail);
  //         });
  //
  //       }
  //     } catch (e) {
  //       setState(() {
  //         // EasyLoading.dismiss();
  //         isLoading = false;
  //       });
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(content: Text('Error: $e')),
  //       // );
  //       showFlushBar(context,  Constants.listGettingFail);
  //
  //     }
  //   } else {
  //     // EasyLoading.dismiss();
  //     showFlushBar(
  //         context, Constants.connectionMessage);
  //   }
  // }

  Future<void> _fetchImbalanceData(int delManId) async {
    // EasyLoading.instance
    //   ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
    //   ..loadingStyle = EasyLoadingStyle.light
    //   ..dismissOnTap = false // Disable dismissing the loader by tapping
    //   ..userInteractions = false;
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token
      int dId = int.parse(distributorId!);

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.ItemImbalanceList}/$dId/$delManId'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
          },
        );
        print("Total ImbQty for delManId response ${response.body}");
        print("Total ImbQty for delManId request ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            receiptList = data
                .map((json) => ImabalanceEmptyListModel.fromJson(json))
                .toList();
            isLoading = false;
            // EasyLoading.dismiss();
            // Initialize totalImbQty
            num totalImbQty = 0;

            for (var receipt in receiptList) {
              // Add imbQty to totalImbQty, treating null as 0
              totalImbQty +=
                  receipt.balImbQty ?? 0; // Corrected summing of imbQty

            }

            // Log the total imbalance quantity
            print("Total ImbQty for delManId $delManId: $totalImbQty");
            imbalaceSum = totalImbQty.toInt();
            // Optionally, you can store this in a variable or use it in the UI
          });
        } else {
          // Handle non-200 responses
          setState(() {
            // EasyLoading.dismiss();
            isLoading = false;
            showFlushBar(context, Constants.listGettingFail);
          });

        }
      } catch (e) {
        setState(() {
          // EasyLoading.dismiss();
          isLoading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        showFlushBar(context,  Constants.listGettingFail);
      }
    } else {
      // EasyLoading.dismiss();
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }

  Future<void> addItemImbalanceQty(
      int dmId, int itemID, int imbQty) async {
    // Construct the request payload
    EasyLoading.show(status: 'Sending Data...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token'); // This is your bearer token
    int dId = int.parse(distributorId!);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
      "GodownId": godownId,
      "DMId": dmId,
      "ItemId": itemID,
      "ImbDate": formattedDate,
      "ImbRecQty": imbQty
    };

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.ItemImbalanceQtyAddEdit}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody), // Encode the request body as JSON
      );

      // Print the raw response for debugging
      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");
      print("API Response request: ${response.request} ${requestBody}");

      if (response.statusCode == 200) {
        // Handle success
        print("Imbalance quantity added successfully!");
        EasyLoading.showToast("Data Sent Successfully..",
            duration: const Duration(milliseconds: 3000));
        _fetchImbalanceData(dmId);
        EasyLoading.dismiss();
      } else {
        // Handle error response
        print("Failed to add imbalance quantity: ${response.statusCode}");
        EasyLoading.dismiss();
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred: $e");
      EasyLoading.dismiss();
    }
  }

  void sendEditedDataToApi(BuildContext context) async {
    EasyLoading.show(status: 'Sending Data...');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId') ?? '0';
        String? bearerToken = prefs.getString('token');
        String? addedBy = prefs.getString('StaffId');
        String? godownID = prefs.getString('godownId');

        if (bearerToken == null) {
          print('Bearer token is missing');
          return;
        }

        // Fetch data
        List<StockSubmitToManagerListModel> deliveryData =
        await updateRefillSale!.getDeliveryMenDataForEdit(
            widget.saleGKId?.toInt() ?? 0, widget.dMId?.toInt() ?? 0);
        print('No data found for delivery ${deliveryData}');
        if (deliveryData.isEmpty) {
          print('No data found for delivery');
          EasyLoading.dismiss();
          return;
        }
        int? dailyStatus;
        if(widget.sale?.dailySaleStatus == 3){
          dailyStatus = 4;
        }else if(widget.sale?.dailySaleStatus == 1){
          dailyStatus = 1;
        }

        // Convert delivery data into API format
        List<Map<String, dynamic>> apiItemList = [];
        for (var data in deliveryData) {
          if (data.itemList != null) {
            for (var item in data.itemList!) {
              apiItemList.add({
                "SaleGKItemId": item.SaleGKItemId,
                "ItemId": item.itemId,
                "FilledSaleQty": item.filledSaleQty.toString(),
                "SVQty": item.sVQty.toString(),
                "TVQty": item.tVQty.toString(),
                "EmptyRetQty": item.emptyRetQty.toString(),
                "DeffQty": item.deffQty.toString(),
                "LessEmptyQty": item.lessEmptyQty.toString(),
                "Remark": item.remark ?? "", // Adjust logic if needed
                "ClosingFilled": "",
                "ClosingEmpty": "",
                "ClosingDef": "",
                "DailySaleStatus": dailyStatus,
                "SVConsStr": item.sVConsStr,
                "TVConsStr": item.TVConsStr,
                "SVQtyStr": item.SVQtyStr ?? "",
                "TVQtyStr": item.TVQtyStr ?? "",
                "PSVIdStr": item.PSVIdStr ?? "",
                "ImbForIdStr": item.ImbForIdStr ?? "",
                "ImbQtyStr": item.ImbQtyStr ?? "",
                "DMImbQty": item.DMImbQty ?? "",
              });
            }
          }
        }

        if (apiItemList.isEmpty) {
          showFlushBar(context, Constants.nodataFound);
          EasyLoading.dismiss();
          return;
        }

        // Construct API data
        Map<String, dynamic> apiData = {
          "SaleGKId": widget.saleGKId?.toString() ?? "0",
          "DistributorId": distributorId ?? '',
          "GodownId": godownID,
          "DeliveryDate": formattedDate ?? '',
          "DMId": widget.sale?.dMId ?? '',
          "VehicleId": widget.sale?.vehicleId ?? '',
          "AddedBy": addedBy ?? '',
          "Action": "EDIT",
          "DailySaleStatus": dailyStatus,
          "ItemList": apiItemList,
        };
        print('jsonEncode(apiData): ${(apiData)}');
        // Send API request
        final response = await http.post(
          Uri.parse('${AppUrl.UpdateDailyRefillSale}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $bearerToken',
          },
          body: jsonEncode(apiData),
        );
        print('jsonEncode(apiData) Edit: ${jsonEncode(apiData)}');
        print('jsonEncode(apiData) Edit: ${jsonEncode(apiItemList)}');
        if (response.statusCode == 200) {
          print('Data sent successfully: ${response.body}');
          EasyLoading.showToast("Data Sent Successfully..",
              duration: const Duration(milliseconds: 3000));
          // Navigator.pushReplacementNamed(context, '/deliveryMenListShowScreen');
          // Navigator.pushReplacementNamed(
          //   context,
          //   '/bottomNavigationForGodownKeeper',
          //   arguments: 1, // Pass the index of the tab you want to show (e.g., Delivery Men tab)
          // );
          Navigator.pushReplacementNamed(context, BottomNavigationForGodownKeeper.screenName);

          EasyLoading.dismiss();
        } else {
          print('Failed to send data: ${response.statusCode}');
          showFlushBar(context, Constants.failToInserRecord);
          EasyLoading.dismiss();
        }
      } catch (e) {
        EasyLoading.dismiss();
        print('Error in sending data: $e');
      }
    } else {
      EasyLoading.dismiss();
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }

  Future<void> _fetchTodaysOpeningStockData() async {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false // Disable dismissing the loader by tapping
      ..userInteractions = false;
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token
      int dId = int.parse(distributorId!);
      int godownIdId = int.parse(godownId!);

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.TodaysOpeningStkForGK}/$dId/$godownIdId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
          },
        );
        print("Total ImbQty TodaysOpeningStkForGK response ${response.body}");
        print("Total ImbQty TodaysOpeningStkForGK request ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          setState(() {
            todaysOpeningStock = data.map((json) => TodaysOpeningStockDataModel.fromJson(json)).toList();
            isLoading = false;

            // Optionally, you can store this in a variable or use it in the UI
          });
        } else {
          // Handle non-200 responses
          setState(() {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(Constants.listGettingFail)),
            );
          });

        }
      } catch (e) {
        if(mounted){
          setState(() {
            isLoading = false;
          });
        }

      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

// Add this method to compare total sale with filled stock
  Future<void> fetchCurrentStock() async {
    // EasyLoading.instance
    //   ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
    //   ..loadingStyle = EasyLoadingStyle.light
    //   ..dismissOnTap = false // Disable dismissing the loader by tapping
    //   ..userInteractions = false;

    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if(Constants.isNetworkAvailable){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
            // Any other headers you need can go here
          },
        );
        // Print the URL and the headers (including the Bearer token)
        print("Request URL ItemCurrentStkList: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        // Print the raw response for debugging
        print("API Response Status ItemCurrentStkList: ${response.statusCode}");
        print("API Response ItemCurrentStkList: ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getCurrentStcOfGodownKeeper = data.map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json)).toList();
            isLoading = false;
            // EasyLoading.dismiss();
          });
        } else {
          // Handle non-200 responses
          setState(() {
            isLoading = false;
            // EasyLoading.dismiss();
            showFlushBar(context, Constants.listGettingFail);
          });

        }
      } catch (e) {
        if (mounted) {
          setState(() {
            // EasyLoading.dismiss();
            isLoading = false;
            showFlushBar(context,Constants.listGettingFail);
          });
        }
      }

    }else{
      // EasyLoading.dismiss();
      showFlushBar(context,
          Constants.connectionMessage);
    }

  }

  void _fetchFilledStockForSelectedItem(int itemId) {
    EasyLoading.show();
    GetCurrentStcOfGodownKeeperModel selectedItemStock = getCurrentStcOfGodownKeeper.firstWhere(
          (item) => item.itemId == itemId,
      orElse: () => GetCurrentStcOfGodownKeeperModel(), // Return an empty object if not found
    );

    filledStock = selectedItemStock.currentStkFilled;
    debugPrint("filledStockmethod $filledStock");// Save the filled stock value
    EasyLoading.dismiss();
  }

  Future<void> _fetchSVConsumerData(String flag) async {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false // Disable dismissing the loader by tapping
      ..userInteractions = false;
    EasyLoading.show();
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token
      int dId = int.parse(distributorId!);

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetDailySaleSVTVConsumerDtls_Mob}/$dId/$flag'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
          },
        );
        print("GetDailySaleSVTVConsumerDtls_Mob response ${response.body}");
        print("GetDailySaleSVTVConsumerDtls_Mobrequest ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          // setState(() {
          //   getSvtvConsumerList = data.map((json) => GetSvtvConsumerListModel.fromJson(json)).toList();
          //   isLoading = false;
          //   consumerNumbers = getSvtvConsumerList.map((item) => item.consumerNo.toString()).toList();
          //   EasyLoading.dismiss();
          //
          // }
          // );

          setState(() {
            getSvtvConsumerList = data
                .map((json) => GetSvtvConsumerListModel.fromJson(json))
                .where((item) => item.cylQty != null && item.cylQty! > 0) // Filter consumers with cylQty > 0
                .toList();

            isLoading = false;
            consumerNumbers = getSvtvConsumerList
                .map((item) => item.consumerNo.toString())
                .toList();

            EasyLoading.dismiss();
          });

        } else {
          // Handle non-200 responses
          setState(() {
            EasyLoading.dismiss();
            isLoading = false;
            showFlushBar(context, Constants.listGettingFail);
          });

        }
      } catch (e) {
        if(mounted){
          setState(() {
            EasyLoading.dismiss();
            isLoading = false;
            showFlushBar(context,  Constants.listGettingFail);
          });
        }
      }

    } else {
      EasyLoading.dismiss();
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }

  Future<void> _fetchTVConsumerData(String flag) async {
    EasyLoading.show();
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token
      int dId = int.parse(distributorId!);

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetDailySaleSVTVConsumerDtls_Mob}/$dId/$flag'),
          headers: {
            'Authorization': 'Bearer $token', // Add the Bearer token here
          },
        );
        print("GetDailySaleSVTVConsumerDtls_Mob response ${response.body}");
        print("GetDailySaleSVTVConsumerDtls_Mobrequest ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          // setState(() {
          //   getSvtvConsumerListTV = data.map((json) => GetSvtvConsumerListModel.fromJson(json)).toList();
          //   isLoading = false;
          //   consumerNumbersTV = getSvtvConsumerListTV.map((item) => item.consumerNo.toString()).toList();
          //   EasyLoading.dismiss();
          //
          // });

          setState(() {
            getSvtvConsumerListTV = data
                .map((json) => GetSvtvConsumerListModel.fromJson(json))
                .where((item) => item.cylQty != null && item.cylQty! > 0) // Filter consumers with cylQty > 0
                .toList();

            isLoading = false;
            consumerNumbersTV = getSvtvConsumerListTV
                .map((item) => item.consumerNo.toString())
                .toList();

            EasyLoading.dismiss();
          });

        } else {
          // Handle non-200 responses
          setState(() {
            EasyLoading.dismiss();
            isLoading = false;
          });
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        setState(() {
          EasyLoading.dismiss();
          isLoading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        showFlushBar(context,  Constants.listGettingFail);
      }
    } else {
      EasyLoading.dismiss();
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }
  ///sv
  // void _showConsumerNumberPopup() {
  //   bool showAddedConsumers = false;
  //   svSearchQuery = '';
  //   svSearchController.clear();
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Select Consumer Number'),
  //         content: Container(
  //           width: double.maxFinite, // Make dialog wide
  //           child:
  //           StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //               // Defer the state update to after the build phase using addPostFrameCallback
  //               WidgetsBinding.instance!.addPostFrameCallback((_) {
  //                 // Calculate the sum of the cylQty
  //                 double totalCylinderQty = 0;
  //                 selectedConsumerNumbers.forEach((consumerNo) {
  //                   // Find the corresponding cylinder quantity from the selected list
  //                   int? cylQty = selectedCylinderQuantities[selectedConsumerNumbers.indexOf(consumerNo)];
  //                   totalCylinderQty += cylQty ?? 0;
  //                 });
  //                 // Update SV Cylinder and recalculate using the integer value of totalCylinderQty
  //                 updateSvCylinderAndRecalculate(totalCylinderQty.toInt());
  //               });
  //
  //               return SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     buildConsumerCheckboxListSV(
  //                       setState,
  //                     ),
  //                     // SizedBox(height: 10),
  //                     // // Only show the list of selected consumer numbers after clicking the plus icon
  //                     // if (selectedConsumerNumbers.isNotEmpty)
  //                     //   Column(
  //                     //     crossAxisAlignment: CrossAxisAlignment.start,
  //                     //     children: [
  //                     //       // Text("Added Consumer Numbers:"),
  //                     //       Padding(
  //                     //         padding: const EdgeInsets.only(bottom: 0.0),
  //                     //         child: Row(
  //                     //           children: [
  //                     //             Expanded(flex:2,
  //                     //               child: Text(
  //                     //                 "Cons No.",
  //                     //                 style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
  //                     //               ),
  //                     //             ),
  //                     //             Expanded(flex:1,
  //                     //               child: Text(
  //                     //                 "Quantity",
  //                     //                 style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
  //                     //               ),
  //                     //             ),
  //                     //             Expanded(flex:1,
  //                     //               child: Text(
  //                     //                 "Action",
  //                     //                 style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
  //                     //               ),
  //                     //             ),
  //                     //           ],
  //                     //         ),
  //                     //       ),
  //                     //       ...selectedConsumerNumbers.map((consumerNo) {
  //                     //         // Find the corresponding cylinder quantity from selectedCylinderQuantities list
  //                     //         int cylQty = selectedCylinderQuantities[selectedConsumerNumbers.indexOf(consumerNo)];
  //                     //
  //                     //         return Padding(
  //                     //           padding: const EdgeInsets.only(top: 4.0),
  //                     //           child:
  //                     //           Row(
  //                     //             children: [
  //                     //               Expanded(flex:2,
  //                     //                 child: Text(
  //                     //                   consumerNo,
  //                     //                   style: TextStyle(fontSize: 14),
  //                     //                 ),
  //                     //               ),
  //                     //               SizedBox(width: 15),
  //                     //               // Display the cylinder quantity dynamically
  //                     //               Expanded(flex:1,
  //                     //                 child: Text(
  //                     //                   cylQty.toString(),
  //                     //                   style: TextStyle(fontSize: 14),
  //                     //                 ),
  //                     //               ),
  //                     //               Expanded(flex:1,
  //                     //                 child: IconButton(
  //                     //                   icon: Icon(Icons.delete, color: Colors.black87),
  //                     //                   onPressed: () {
  //                     //                     setState(() {
  //                     //                       // Remove the consumer number and its corresponding cylinder quantity
  //                     //                       int index = selectedConsumerNumbers.indexOf(consumerNo);
  //                     //                       if (index != -1) {
  //                     //                         selectedConsumerNumbers.removeAt(index);
  //                     //                         selectedCylinderQuantities.removeAt(index);
  //                     //                         selectedSVUniqueID.removeAt(index);
  //                     //                       }
  //                     //                     });
  //                     //                     updateTotalCylinderQty(); // Recalculate total cylinder quantity
  //                     //                   },
  //                     //                 ),
  //                     //               ),
  //                     //             ],
  //                     //           ),
  //                     //         );
  //                     //       }).toList(),
  //                     //       // SizedBox(height: 10),
  //                     //       // // Display the total sum of the cylinder quantities
  //                     //       // Text(
  //                     //       //   'Total Cylinder Quantity: ${totalCylinderQty.toStringAsFixed(0)}',
  //                     //       //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                     //       // ),
  //                     //     ],
  //                     //   ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //
  //         ),
  //         actions: [
  //           TextButton(
  //             style: TextButton.styleFrom(
  //               backgroundColor: Colors.blue, // Set the background color here
  //               padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional: Add padding
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text('Done',style: TextStyle(color: Colors.white),),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showConsumerNumberPopup() {
    bool showAddedConsumers = false;
    svSearchQuery = '';
    svSearchController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // ── Shape & background ────────────────────────────────────
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          // ── Title ─────────────────────────────────────────────────
          titlePadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            0,
          ),
          title: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.primaryXLight,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const Icon(
                  Icons.person_search_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Select Consumer Number',
                style: AppTextStyles.cardTitle,
              ),
            ],
          ),

          // ── Content ───────────────────────────────────────────────
          contentPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            0,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                // Defer the state update to after the build phase
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  double totalCylinderQty = 0;
                  selectedConsumerNumbers.forEach((consumerNo) {
                    int? cylQty = selectedCylinderQuantities[
                    selectedConsumerNumbers.indexOf(consumerNo)];
                    totalCylinderQty += cylQty ?? 0;
                  });
                  updateSvCylinderAndRecalculate(totalCylinderQty.toInt());
                });

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildConsumerCheckboxListSV(setState),
                    ],
                  ),
                );
              },
            ),
          ),

          // ── Actions ───────────────────────────────────────────────
          actionsPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                    horizontal: AppSpacing.xl,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Done',
                  style: AppTextStyles.button.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildConsumerNumberDropdown(StateSetter setState, List<String> selectedConsumerNumbersInDialog, Function setShowAddedConsumers) {
    return Row(
      children: [
        Expanded(
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty(); // Return empty if no input
              }
              return consumerNumbers.where((consumerNo) =>
                  consumerNo.toLowerCase().contains(textEditingValue.text.toLowerCase()));
            },
            onSelected: (String selectedConsumerNo) {
              consumerController.text = selectedConsumerNo; // Set text when selected from autocomplete
            },
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                onSubmitted: (_) {
                  String consumerNo = textEditingController.text.trim();
                  print("Entered consumer number: $consumerNo"); // Print the entered consumer number
                  print("Available consumer numbers: $consumerNumbers"); // Print available consumer numbers

                  if (consumerNo.isEmpty || !consumerNumbers.contains(consumerNo)) {
                    print("Consumer number is not valid.");
                    EasyLoading.showToast(Constants.svTvConsumerSelectFromDD, duration: const Duration(milliseconds: 3000));

                  } else {
                    print("Consumer number is valid.");
                    onFieldSubmitted(); // Proceed if valid
                  }
                  // onFieldSubmitted();
                },
                decoration: InputDecoration(
                  labelText: 'Consumer Number',
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline_sharp),
          onPressed: () async {
            String consumerNo = consumerController.text.trim();
            print("Entered consumer number: $consumerNo"); // Print the entered consumer number
            print("Available consumer numbers: $consumerNumbers");
            if (consumerNo.isEmpty || !consumerNumbers.contains(consumerNo)) {
              print("Consumer number is not valid.");
              EasyLoading.showToast(Constants.svTvConsumerSelectFromDD, duration: const Duration(milliseconds: 3000));
              return;
            }
            // Check if consumer number is already in the list
            if (consumerNo.isNotEmpty) {
              if (selectedConsumerNumbersInDialog.contains(consumerNo)) {
                // Show a message that the consumer number is already added
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('This consumer number is already added.')),
                );
              } else {
                bool consumerExists = await updateRefillSale!.checkIfConsumerExistsInDatabaseSV(consumerNo);
                if (consumerExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Consumer number $consumerNo already exists in the database.'))
                  );
                  return; // If the consumer exists, stop further execution
                }
                // setState((){
                // Add selected consumer number to the list and show it below the dropdown
                if (consumerController.text.isNotEmpty &&
                    !selectedConsumerNumbersInDialog.contains(consumerController.text)) {
                  setState(() {
                    String consumerNo = consumerController.text;
                    selectedConsumerNumbersInDialog.add(consumerNo); // Add to list
                    GetSvtvConsumerListModel? consumer = getSvtvConsumerList.firstWhere(
                          (c) => c.consumerNo == consumerNo,
                      orElse: () => GetSvtvConsumerListModel(consumerNo: '', cylQty: 0),
                    );
                    selectedCylinderQuantities.add(consumer.cylQty?.toInt() ?? 0);
                    selectedSVUniqueID.add(consumer.pSVId?.toInt() ?? 0);// Add cylinder quantity to the corresponding list
                    consumerController.clear();
                    // Clear the input field after adding
                    setShowAddedConsumers(true);
                    consumerController.text = '';
                  });
                  updateTotalCylinderQty(); // Recalculate total cylinder quantity
                }
                // });
                Navigator.of(context).pop();
                _showConsumerNumberPopup();
              }
            }

          },
        ),
      ],
    );
  }

// This function can be used to get the separate lists of consumer numbers and cylinder quantities
  List<String> getConsumerNumbers() {
    return selectedConsumerNumbers;
  }

  List<int> getCylinderQuantities() {
    return selectedCylinderQuantities;
  }

  List<int> getSVUniqueConsumerNumbers() {
    return selectedSVUniqueID;
  }

  // This method calculates the total cylinder quantity based on selected consumers
  void updateTotalCylinderQty() {
    totalCylinderQty = 0;  // Reset the total cylinder quantity

    // Loop through all selected consumer numbers
    selectedConsumerNumbers.forEach((consumerNo) {
      // Look up the consumer data using the consumer number
      GetSvtvConsumerListModel? consumer = getSvtvConsumerList.firstWhere(
            (c) => c.consumerNo == consumerNo,
        orElse: () => GetSvtvConsumerListModel(consumerNo: '', cylQty: 0), // Return default if not found
      );

      // Add the consumer's cylinder quantity (cylQty) to the total
      totalCylinderQty += consumer.cylQty ?? 0;
      print('Total Cylinder Quantity sv: $totalCylinderQty');
    });
  }

// Function to update the SV cylinder and trigger the calculation
  void updateSvCylinderAndRecalculate(int svQty) {
    // Update the controller with the new SV quantity
    _svController.text = svQty.toString();

    // Now perform the calculation and update the empty quantity
    setState(() {
      // Get the other quantities
      int filledQty = int.tryParse(_filledController.text) ?? 0;
      int tvQty = int.tryParse(_tvController.text) ?? 0;
      int defQty = int.tryParse(_defectiveController.text) ?? 0;
      int lessEmptyQty = int.tryParse(_lessEmptyController.text) ?? 0;

      // Perform the calculation for the empty quantity
      int emptyQty = filledQty - svQty + tvQty - defQty - lessEmptyQty;

      // Update the empty quantity in the _emptyController text field
      _emptyController.text = emptyQty.toString();
    });
  }

  // Widget buildConsumerCheckboxListSV(StateSetter setState) {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: getSvtvConsumerList.length,
  //     itemBuilder: (context, index) {
  //       final consumer = getSvtvConsumerList[index];
  //
  //       final isSelected = selectedConsumerNumbers.contains(consumer.consumerNo);
  //
  //       return CheckboxListTile(
  //         dense: true,
  //         title: Text(
  //           consumer.consumerNo ?? '',
  //           style: const TextStyle(fontSize: 14),
  //         ),
  //         subtitle: Text(
  //           'Qty: ${consumer.cylQty ?? 0}',
  //           style: const TextStyle(fontSize: 12),
  //         ),
  //         value: isSelected,
  //         onChanged: (bool? value) {
  //           setState(() {
  //             if (value == true) {
  //               // ADD selected consumer
  //               selectedConsumerNumbers.add(consumer.consumerNo!);
  //               selectedCylinderQuantities
  //                   .add(consumer.cylQty?.toInt() ?? 0);
  //               selectedSVUniqueID.add(consumer.pSVId?.toInt() ?? 0);
  //             } else {
  //               // REMOVE consumer
  //               int idx = selectedConsumerNumbers.indexOf(consumer.consumerNo!);
  //               if (idx != -1) {
  //                 selectedConsumerNumbers.removeAt(idx);
  //                 selectedCylinderQuantities.removeAt(idx);
  //                 selectedSVUniqueID.removeAt(idx);
  //               }
  //             }
  //           });
  //
  //           updateTotalCylinderQty(); // 🔥 Recalculate total qty
  //         },
  //       );
  //     },
  //   );
  // }
  // Widget buildConsumerCheckboxListSV(StateSetter setState) {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: getSvtvConsumerList.length,
  //     itemBuilder: (context, index) {
  //       final consumer = getSvtvConsumerList[index];
  //       final consumerNo = consumer.consumerNo ?? '';
  //
  //       final isSelected = selectedConsumerNumbers.contains(consumerNo);
  //
  //       return CheckboxListTile(
  //         dense: true,
  //         title: Text(consumerNo, style: const TextStyle(fontSize: 14)),
  //         subtitle: Text('Qty: ${consumer.cylQty ?? 0}', style: const TextStyle(fontSize: 12)),
  //         value: isSelected,
  //         onChanged: (bool? value) async {
  //           if (value == true) {
  //             // ✅ Check if consumer is already selected
  //             if (selectedConsumerNumbers.contains(consumerNo)) {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(content: Text('This consumer number is already selected.')),
  //               );
  //               return;
  //             }
  //
  //             if(flagEditMode == "editMode" || _editingItemId != null){
  //               if (!originalConsumerNumbersSV.contains(consumerNo)) {
  //                 bool exists =
  //                 await updateRefillSale!.checkIfConsumerExistsInDatabaseSV(
  //                   consumerNo,
  //                 );
  //
  //                 if (exists) {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(
  //                       content: Text(
  //                         'Consumer number $consumerNo already exists in database.',
  //                       ),
  //                     ),
  //                   );
  //                   return;
  //                 }
  //               }
  //
  //             }else{
  //               // ✅ Check if consumer exists in database
  //               bool consumerExists = await updateRefillSale!.checkIfConsumerExistsInDatabaseSV(consumerNo);
  //               if (consumerExists) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(content: Text('Consumer number $consumerNo already exists in the database.')),
  //                 );
  //                 return; // Stop further execution
  //               }
  //             }
  //
  //
  //
  //             // ✅ Add consumer if all checks pass
  //             setState(() {
  //               selectedConsumerNumbers.add(consumerNo);
  //               selectedCylinderQuantities.add(consumer.cylQty?.toInt() ?? 0);
  //               selectedSVUniqueID.add(consumer.pSVId?.toInt() ?? 0);
  //             });
  //           } else {
  //             // REMOVE consumer if unchecked
  //             setState(() {
  //               int idx = selectedConsumerNumbers.indexOf(consumerNo);
  //               if (idx != -1) {
  //                 selectedConsumerNumbers.removeAt(idx);
  //                 selectedCylinderQuantities.removeAt(idx);
  //                 selectedSVUniqueID.removeAt(idx);
  //               }
  //             });
  //           }
  //
  //           updateTotalCylinderQty(); // 🔥 Recalculate total qty
  //         },
  //       );
  //     },
  //   );
  // }
  Widget buildConsumerCheckboxListSV(StateSetter setState) {

    /// 🔥 MERGE API + ORIGINAL EDIT CONSUMERS
    final Map<String, GetSvtvConsumerListModel> merged = {};

    // ORIGINAL edit consumers (force visible)
    for (final consNo in originalConsumerNumbersSV) {
      if (!merged.containsKey(consNo)) {
        merged[consNo] = GetSvtvConsumerListModel(
          consumerNo: consNo,
          cylQty: originalConsumerQtySV[consNo] ?? 0,
          pSVId: originalSVUniqueIdMap[consNo],
        );
      }
    }
    // API consumers
    for (final c in getSvtvConsumerList) {
      if (c.consumerNo != null) {
        merged[c.consumerNo!] = c;
      }
    }

    final list = merged.values.toList();
    final filteredListSV = svSearchQuery.isEmpty
        ? list
        : list.where((c) {
      final no = c.consumerNo ?? '';
      return no.toLowerCase().contains(svSearchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        TextField(
          controller: svSearchController,
          decoration: const InputDecoration(
            hintText: 'Search SV / Consumer Number',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (value) {
            setState(() {
              svSearchQuery = value.trim();
            });
          },
        ),
        SizedBox(height: 8,),
        SizedBox(
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredListSV.length,
            itemBuilder: (context, index) {
              final consumer = filteredListSV[index];
              final consumerNo = consumer.consumerNo ?? '';

              final isSelected =
              selectedConsumerNumbers.contains(consumerNo);

              return CheckboxListTile(
                dense: true,
                title: Text(
                  consumerNo,
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle: Text(
                  'Qty: ${consumer.cylQty ?? 0}',
                  style: const TextStyle(fontSize: 12),
                ),
                value: isSelected,

                onChanged: (bool? value) async {

                  /// ✅ CHECK
                  if (value == true) {

                    if (isSelected) return;

                    // 🔒 DB validation ONLY for NEW consumers
                    if (!originalConsumerNumbersSV.contains(consumerNo)) {
                      final exists =
                      await updateRefillSale!
                          .checkIfConsumerExistsInDatabaseSV(
                        consumerNo,
                      );

                      if (exists) {
                        _showConsumerExistsMessage(consumerNo);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text(
                        //       'Consumer number $consumerNo already exists.',
                        //     ),
                        //   ),
                        // );
                        return;
                      }
                    }

                    // ADD
                    setState(() {
                      selectedConsumerNumbers.add(consumerNo);
                      selectedCylinderQuantities.add(
                        consumer.cylQty?.toInt() ??
                            originalConsumerQtySV[consumerNo] ??
                            0,
                      );
                      selectedSVUniqueID.add(
                          (consumer.pSVId ??
                              originalSVUniqueIdMap[consumerNo] ??
                              0).toInt()
                      );
                    });
                  }

                  /// ❌ UNCHECK (remove ONLY from selected list)
                  else {
                    setState(() {
                      final idx =
                      selectedConsumerNumbers.indexOf(consumerNo);
                      if (idx != -1) {
                        selectedConsumerNumbers.removeAt(idx);
                        selectedCylinderQuantities.removeAt(idx);
                        selectedSVUniqueID.removeAt(idx);
                      }
                    });
                  }

                  updateTotalCylinderQty();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  ///tv
  // void _showConsumerNumberTVPopup() {
  //   bool showAddedConsumers = false;
  //   tvSearchQuery = '';
  //   tvSearchController.clear();
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Select Consumer Number'),
  //         content: Container(
  //           width: double.maxFinite, // Make dialog wide
  //           child:
  //
  //           StatefulBuilder(
  //             builder: (BuildContext context, StateSetter setState) {
  //               // Defer the state update to after the build phase using addPostFrameCallback
  //               WidgetsBinding.instance!.addPostFrameCallback((_) {
  //                 // Calculate the sum of the cylQty
  //                 double totalCylinderQtyTV = 0;
  //                 selectedConsumerNumbersTV.forEach((consumerNo) {
  //                   // Find the corresponding cylinder quantity from the selected list
  //                   int? cylQty = selectedCylinderQuantitiesTV[selectedConsumerNumbersTV.indexOf(consumerNo)];
  //                   totalCylinderQtyTV += cylQty ?? 0;
  //                 });
  //                 // Update SV Cylinder and recalculate using the integer value of totalCylinderQty
  //                 updateSvCylinderAndRecalculateTV(totalCylinderQtyTV.toInt());
  //               });
  //
  //               return SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     buildConsumerCheckboxListTV(
  //                       setState,
  //
  //                     ),
  //                     // SizedBox(height: 10),
  //                     // // Only show the list of selected consumer numbers after clicking the plus icon
  //                     // if (selectedConsumerNumbersTV.isNotEmpty)
  //                     //   Column(
  //                     //     crossAxisAlignment: CrossAxisAlignment.start,
  //                     //     children: [
  //                     //       // Text("Added Consumer Numbers:"),
  //                     //       Padding(
  //                     //         padding: const EdgeInsets.only(bottom: 0.0),
  //                     //         child: Row(
  //                     //           children: [
  //                     //             Expanded(flex:2,
  //                     //               child: Text(
  //                     //                 "Cons No.",
  //                     //                 style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
  //                     //               ),
  //                     //             ),
  //                     //             Expanded(flex:1,
  //                     //               child: Text(
  //                     //                 "Quantity",
  //                     //                 style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
  //                     //               ),
  //                     //             ),
  //                     //             Expanded(flex:1,
  //                     //               child: Text(
  //                     //                 "Action",
  //                     //                 style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
  //                     //               ),
  //                     //             ),
  //                     //           ],
  //                     //         ),
  //                     //       ),
  //                     //       ...selectedConsumerNumbersTV.map((consumerNo) {
  //                     //         // Find the corresponding cylinder quantity from selectedCylinderQuantities list
  //                     //         int cylQty = selectedCylinderQuantitiesTV[selectedConsumerNumbersTV.indexOf(consumerNo)];
  //                     //
  //                     //         return Padding(
  //                     //           padding: const EdgeInsets.only(top: 4.0),
  //                     //           child: Row(
  //                     //             children: [
  //                     //               Expanded(
  //                     //                 flex:2,
  //                     //                 child: Text(
  //                     //                   consumerNo,
  //                     //                   style: TextStyle(fontSize: 16),
  //                     //                 ),
  //                     //               ),
  //                     //               // SizedBox(width: 15),
  //                     //               // Display the cylinder quantity dynamically
  //                     //               Expanded(flex:1,
  //                     //                 child: Text(
  //                     //                   cylQty.toString(),
  //                     //                   style: TextStyle(fontSize: 16),
  //                     //                 ),
  //                     //               ),
  //                     //               Expanded(flex:1,
  //                     //                 child: IconButton(
  //                     //                   icon: Icon(Icons.delete, color: Colors.black87),
  //                     //                   onPressed: () {
  //                     //                     setState(() {
  //                     //                       // Remove the consumer number and its corresponding cylinder quantity
  //                     //                       int index = selectedConsumerNumbersTV.indexOf(consumerNo);
  //                     //                       if (index != -1) {
  //                     //                         selectedConsumerNumbersTV.removeAt(index);
  //                     //                         selectedCylinderQuantitiesTV.removeAt(index);
  //                     //                       }
  //                     //                     });
  //                     //                     updateTotalCylinderQtyTV(); // Recalculate total cylinder quantity
  //                     //                   },
  //                     //                 ),
  //                     //               ),
  //                     //             ],
  //                     //           ),
  //                     //         );
  //                     //       }).toList(),
  //                     //       // SizedBox(height: 10),
  //                     //       // // Display the total sum of the cylinder quantities
  //                     //       // Text(
  //                     //       //   'Total Cylinder Quantity: ${totalCylinderQtyTV.toStringAsFixed(0)}',
  //                     //       //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                     //       // ),
  //                     //     ],
  //                     //   ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             style: TextButton.styleFrom(
  //               backgroundColor: Colors.blue, // Set the background color here
  //               padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Optional: Add padding
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text('Done',style: TextStyle(color: Colors.white),),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showConsumerNumberTVPopup() {
    bool showAddedConsumers = false;
    tvSearchQuery = '';
    tvSearchController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // ── Shape & background ────────────────────────────────────
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          // ── Title ─────────────────────────────────────────────────
          titlePadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            0,
          ),
          title: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.primaryXLight,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: const Icon(
                  Icons.person_search_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Select Consumer Number',
                style: AppTextStyles.cardTitle,
              ),
            ],
          ),

          // ── Content ───────────────────────────────────────────────
          contentPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            0,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                // Defer the state update to after the build phase
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  double totalCylinderQtyTV = 0;
                  selectedConsumerNumbersTV.forEach((consumerNo) {
                    int? cylQty = selectedCylinderQuantitiesTV[
                    selectedConsumerNumbersTV.indexOf(consumerNo)];
                    totalCylinderQtyTV += cylQty ?? 0;
                  });
                  updateSvCylinderAndRecalculateTV(totalCylinderQtyTV.toInt());
                });

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildConsumerCheckboxListTV(setState),
                    ],
                  ),
                );
              },
            ),
          ),

          // ── Actions ───────────────────────────────────────────────
          actionsPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                    horizontal: AppSpacing.xl,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Done',
                  style: AppTextStyles.button.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildConsumerNumberTVDropdown(StateSetter setState, List<String> selectedConsumerNumbersInDialog, Function setShowAddedConsumers) {
    return Row(
      children: [
        Expanded(
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty(); // Return empty if no input
              }
              return consumerNumbersTV.where((consumerNo) =>
                  consumerNo.toLowerCase().contains(textEditingValue.text.toLowerCase()));
            },
            onSelected: (String selectedConsumerNo) {
              consumerControllerTV.text = selectedConsumerNo; // Set text when selected from autocomplete
            },
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                onSubmitted: (_) {
                  // onFieldSubmitted();
                  String consumerNo = textEditingController.text.trim();
                  print("Entered consumer number: $consumerNo"); // Print the entered consumer number
                  print("Available consumer numbers: $consumerNumbersTV"); // Print available consumer numbers

                  if (consumerNo.isEmpty || !consumerNumbersTV.contains(consumerNo)) {
                    print("Consumer number is not valid.");
                    EasyLoading.showToast(Constants.svTvConsumerSelectFromDD, duration: const Duration(milliseconds: 3000));

                  } else {
                    print("Consumer number is valid.");
                    onFieldSubmitted(); // Proceed if valid
                  }

                },
                decoration: InputDecoration(
                  labelText: 'Consumer Number',
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline_sharp),
          onPressed: () async {
            String consumerNo = consumerControllerTV.text.trim();
            print("Entered consumer number: $consumerNo"); // Print the entered consumer number
            print("Available consumer numbers: $consumerNumbersTV");
            if (consumerNo.isEmpty || !consumerNumbersTV.contains(consumerNo)) {
              print("Consumer number is not valid.");
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('This consumer number is not in the list.')),
              // );
              EasyLoading.showToast(Constants.svTvConsumerSelectFromDD, duration: const Duration(milliseconds: 3000));
              return;
            }
            if(consumerNo.isNotEmpty) {
              if (selectedConsumerNumbersInDialog.contains(consumerNo)) {
                // Show a message that the consumer number is already added
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('This consumer number is already added.')),
                );
              }
              else{
                bool consumerExists = await updateRefillSale!.checkIfConsumerExistsInDatabaseTV(consumerNo);
                if (consumerExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Consumer number $consumerNo already exists in the database.'))
                  );
                  return; // If the consumer exists, stop further execution
                }
                // Add selected consumer number to the list and show it below the dropdown
                if (consumerControllerTV.text.isNotEmpty &&
                    !selectedConsumerNumbersInDialog.contains(consumerControllerTV.text)) {
                  setState(() {
                    String consumerNo = consumerControllerTV.text;
                    selectedConsumerNumbersInDialog.add(consumerNo); // Add to list
                    GetSvtvConsumerListModel? consumer = getSvtvConsumerListTV.firstWhere(
                          (c) => c.consumerNo == consumerNo,
                      orElse: () => GetSvtvConsumerListModel(consumerNo: '', cylQty: 0),
                    );
                    selectedCylinderQuantitiesTV.add(consumer.cylQty?.toInt() ?? 0); // Add cylinder quantity to the corresponding list
                    consumerControllerTV.clear(); // Clear the input field after adding
                    setShowAddedConsumers(true); // Show the added consumer numbers list
                  });
                  updateTotalCylinderQtyTV();

                  Navigator.of(context).pop();
                  _showConsumerNumberTVPopup();// Recalculate total cylinder quantity
                }
              }
            }


          },
        ),
      ],
    );
  }

  void updateSvCylinderAndRecalculateTV(int tvQty) {
    // Update the controller with the new SV quantity
    _tvController.text = tvQty.toString();

    // Now perform the calculation and update the empty quantity
    setState(() {

      int filledQty =
          int.tryParse(_filledController.text) ?? 0;
      int svQty =
          int.tryParse(_svController.text) ?? 0;
      int defQty =
          int.tryParse(_defectiveController.text) ??
              0;
      int lessEmptyQty =
          int.tryParse(_lessEmptyController.text) ??
              0;

      int emptyQty = filledQty - svQty + tvQty - defQty - lessEmptyQty;

      _emptyController.text = emptyQty.toString();
    });
  }

  void updateTotalCylinderQtyTV() {
    totalCylinderQtyTV = 0;  // Reset the total cylinder quantity

    // Loop through all selected consumer numbers
    selectedConsumerNumbersTV.forEach((consumerNo) {
      // Look up the consumer data using the consumer number
      GetSvtvConsumerListModel? consumer = getSvtvConsumerListTV.firstWhere(
            (c) => c.consumerNo == consumerNo,
        orElse: () => GetSvtvConsumerListModel(consumerNo: '', cylQty: 0), // Return default if not found
      );
      print('Consumer No: $consumerNo, cylQty: ${consumer?.cylQty}');  // Debug print

      // Add the consumer's cylinder quantity (cylQty) to the total
      totalCylinderQtyTV += consumer.cylQty ?? 0;
      print('Total Cylinder Quantity TV: $totalCylinderQtyTV');
    });
  }

  List<String> getConsumerNumbersTV() {
    return selectedConsumerNumbersTV;
  }

  List<int> getCylinderQuantitiesTV() {
    return selectedCylinderQuantitiesTV;
  }

  // Widget buildConsumerCheckboxList(StateSetter setState) {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemCount: getSvtvConsumerListTV.length,
  //     itemBuilder: (context, index) {
  //       final consumer = getSvtvConsumerListTV[index];
  //
  //       final isSelected =
  //       selectedConsumerNumbersTV.contains(consumer.consumerNo);
  //
  //       return CheckboxListTile(
  //         dense: true,
  //         title: Text(consumer.consumerNo ?? '', style: TextStyle(fontSize: 14)),
  //         subtitle: Text(
  //           'Qty: ${consumer.cylQty ?? 0}',
  //           style: TextStyle(fontSize: 12),
  //         ),
  //         value: isSelected,
  //         onChanged: (bool? value) {
  //           setState(() {
  //             if (value == true) {
  //               selectedConsumerNumbersTV.add(consumer.consumerNo!);
  //               selectedCylinderQuantitiesTV
  //                   .add(consumer.cylQty?.toInt() ?? 0);
  //             } else {
  //               int index = selectedConsumerNumbersTV
  //                   .indexOf(consumer.consumerNo!);
  //               if (index != -1) {
  //                 selectedConsumerNumbersTV.removeAt(index);
  //                 selectedCylinderQuantitiesTV.removeAt(index);
  //               }
  //             }
  //           });
  //
  //           updateTotalCylinderQtyTV(); // 🔥 single place
  //         },
  //       );
  //     },
  //   );
  // }

  Widget buildConsumerCheckboxList(StateSetter setState) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: getSvtvConsumerListTV.length,
      itemBuilder: (context, index) {
        final consumer = getSvtvConsumerListTV[index];
        final consumerNo = consumer.consumerNo ?? '';

        final isSelected = selectedConsumerNumbersTV.contains(consumerNo);

        return CheckboxListTile(
          dense: true,
          title: Text(consumerNo, style: const TextStyle(fontSize: 14)),
          subtitle: Text('Qty: ${consumer.cylQty ?? 0}', style: const TextStyle(fontSize: 12)),
          value: isSelected,
          onChanged: (bool? value) async {
            if (value == true) {
              // ✅ Check if already selected in dialog
              if (selectedConsumerNumbersTV.contains(consumerNo)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('This consumer number is already selected.')),
                );
                return;
              }

              // 🔹 DB check ONLY if not part of original edit data
              if(flagEditMode == "editMode" || _editingItemId != null){
                if (!originalConsumerNumbersTV.contains(consumerNo)) {
                  bool exists =
                  await updateRefillSale!.checkIfConsumerExistsInDatabaseTV(
                    consumerNo,
                  );

                  if (exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Consumer number $consumerNo already exists in database.',
                        ),
                      ),
                    );
                    return;
                  }
                }

              }else{
                // ✅ Check if exists in database
                bool exists = await updateRefillSale!.checkIfConsumerExistsInDatabaseTV(consumerNo);
                if (exists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Consumer number $consumerNo already exists in the database.')),
                  );
                  return;
                }
              }



              // ✅ Add consumer if all checks pass
              setState(() {
                selectedConsumerNumbersTV.add(consumerNo);
                selectedCylinderQuantitiesTV.add(consumer.cylQty?.toInt() ?? 0);
              });
            } else {
              // REMOVE consumer if unchecked
              setState(() {
                int idx = selectedConsumerNumbersTV.indexOf(consumerNo);
                if (idx != -1) {
                  selectedConsumerNumbersTV.removeAt(idx);
                  selectedCylinderQuantitiesTV.removeAt(idx);
                }
              });
            }

            updateTotalCylinderQtyTV();
          },
        );
      },
    );
  }

  Widget buildConsumerCheckboxListTV(StateSetter setState) {

    /// 🔥 MERGE API + ORIGINAL EDIT CONSUMERS
    final Map<String, GetSvtvConsumerListModel> merged = {};

    // ORIGINAL edit consumers (force visible with qty)
    for (final consNo in originalConsumerNumbersTV) {
      merged.putIfAbsent(
        consNo,
            () => GetSvtvConsumerListModel(
          consumerNo: consNo,
          cylQty: originalConsumerQtyTV[consNo] ?? 0,
        ),
      );
    }
    // API consumers
    for (final c in getSvtvConsumerListTV) {
      if (c.consumerNo != null) {
        merged[c.consumerNo!] = c;
      }
    }


    final list = merged.values.toList();
    final filteredList = tvSearchQuery.isEmpty
        ? list
        : list.where((c) {
      final no = c.consumerNo ?? '';
      return no.toLowerCase().contains(tvSearchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        TextField(
          controller: tvSearchController,
          decoration: const InputDecoration(
            hintText: 'Search TV / Consumer Number',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (value) {
            setState(() {
              tvSearchQuery = value.trim();
            });
          },
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final consumer = filteredList[index];
              final consumerNo = consumer.consumerNo ?? '';

              final isSelected =
              selectedConsumerNumbersTV.contains(consumerNo);

              /// 🔥 FINAL QTY LOGIC
              int displayQty;

              if (isSelected) {
                final idx =
                selectedConsumerNumbersTV.indexOf(consumerNo);
                displayQty = selectedCylinderQuantitiesTV[idx];
              } else {
                displayQty =
                    originalConsumerQtyTV[consumerNo] ??
                        consumer.cylQty?.toInt() ??
                        0;
              }

              return CheckboxListTile(
                dense: true,
                title: Text(consumerNo, style: const TextStyle(fontSize: 14)),
                subtitle: Text(
                  'Qty: $displayQty',
                  style: const TextStyle(fontSize: 12),
                ),
                value: isSelected,

                onChanged: (bool? value) async {

                  /// ✅ CHECK
                  if (value == true) {

                    if (isSelected) return;

                    // 🔒 DB validation only for NEW consumers
                    if (!originalConsumerNumbersTV.contains(consumerNo)) {
                      final exists =
                      await updateRefillSale!
                          .checkIfConsumerExistsInDatabaseTV(
                        consumerNo,
                      );

                      if (exists) {
                        _showConsumerExistsMessage(consumerNo);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text(
                        //       'Consumer number $consumerNo already exists.',
                        //     ),
                        //   ),
                        // );
                        return;
                      }
                    }

                    setState(() {
                      selectedConsumerNumbersTV.add(consumerNo);
                      selectedCylinderQuantitiesTV.add(displayQty);
                    });
                  }

                  /// ❌ UNCHECK (keep visible + qty)
                  else {
                    setState(() {
                      final idx =
                      selectedConsumerNumbersTV.indexOf(consumerNo);
                      if (idx != -1) {
                        selectedConsumerNumbersTV.removeAt(idx);
                        selectedCylinderQuantitiesTV.removeAt(idx);
                      }
                    });
                  }

                  updateTotalCylinderQtyTV();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> fetchTransactionList() async {
    // EasyLoading.instance
    //   ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
    //   ..loadingStyle = EasyLoadingStyle.light
    //   ..dismissOnTap = false // Disable dismissing the loader by tapping
    //   ..userInteractions = false;
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
      int dId = int.parse(distributorId!);
      int gId = int.parse(godownId!);
      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }
      try{


        final response = await http.get(
          Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
          headers: {
            'Authorization': 'Bearer $bearerToken', // Add Bearer token here
          },
        );
        debugPrint(
            "GetStockTransferDtls" + '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
        debugPrint("GetStockTransferDtls" + response.body);
        if (response.statusCode == 200) {
          // Parse the response
          List<dynamic> data = json.decode(response.body);
          setState(() {
            _stockTransferList = data.map((json) => GetStockTransferListModel.fromJson(json)).toList();
            bool hasZeroStkTrans = false;
            for (int i = 0; i < _stockTransferList.length; i++) {
              if (_stockTransferList[i].isStkTrans == 0) {
                hasZeroStkTrans = true;
                debugPrint("Found item with isStkTrans = 0");
                break; // No need to continue checking once we find an item with isStkTrans = 0
              }
            }
            if (hasZeroStkTrans) {
              stockTransferFlag = false; // Disable the button
              // showFlushBar(
              //     context, "Action Restricted", "Cannot perform the action as one or more items have isStkTrans = 0");
            } else {
              stockTransferFlag = true; // Enable the button
            }
          });
          isLoading = false;
          // EasyLoading.dismiss();
        } else {
          isLoading = false;
          // EasyLoading.dismiss();
          throw Exception('Failed To Load Items');
        }
      }catch(e){
        debugPrint("Found item with isStkTrans = ${e.toString()}");
      }
    } else {
      isLoading = false;
      // EasyLoading.dismiss();
      showFlushBar(
          context,Constants.connectionMessage);
    }
  }

  Future<void> checkAndSaveDayEndData() async {
    // EasyLoading.instance
    //   ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
    //   ..loadingStyle = EasyLoadingStyle.light
    //   ..dismissOnTap = false // Disable dismissing the loader by tapping
    //   ..userInteractions = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? StaffId = prefs.getString('StaffId');
    int? staffIds = int.parse(StaffId!);
    int? distributorIds = int.parse(distributorId!);
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken", // Pass bearer token in headers
        },
      );
      debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
      debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
      if (response.statusCode == 200) {
        // Parse the API response
        List<dynamic> apiResponse = json.decode(response.body);

        // Check if the response list is empty
        if (apiResponse.isEmpty) {
          // If the list is empty, do not save
          saveFlag = false;
          print("The list is empty, no data to save.");
          // EasyLoading.dismiss();
        } else {
          saveFlag = true;
          // If there is data in the response, process it and save
          var dayEndData = apiResponse[0]; // Access the first item in the list (assuming it's an object)

          // You can validate the fields in the response as needed
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;

          // Check if all required fields are saved
          // if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
          //   saveFlag = true;
          //   // If the conditions are met, set the flag and save the data
          //   print("Data is valid, proceeding to save.");
          //   // EasyLoading.dismiss();
          // } else {
          //   // If any condition is not met, print a message
          //   print("Data is incomplete. Cannot proceed to save.");
          //   // EasyLoading.dismiss();
          // }
        }
      } else {
        // Handle API error
        print("Error: ${response.statusCode}");
        // EasyLoading.dismiss();
      }
    }
    catch (e) {
      // Exception handling
      print("Exception: $e");
      // EasyLoading.dismiss();
    }
  }

  void _showConsumerExistsMessage(String consumerNo) {
    showDialog(
      context: context,
      barrierDismissible: true, // tap outside to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Expanded(
                child: Text('Consumer number $consumerNo already used.'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close this message dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // void showSimplePopup(BuildContext context,int lessEmptyQty) {
  //   int remainingDMQtyShow = lessEmptyQty;
  //   // initial
  //
  //   // if(flagEditMode == "editMode" || _editingItemId != null){
  //   //
  //   // }else{
  //   //   if (remainingDMQty == null) {
  //   //     remainingDMQty = lessEmptyQty;
  //   //     _totalImbalanceQtyDMQty.text = remainingDMQty.toString();
  //   //   }
  //   //
  //   // }
  //
  //   int totalAssigned = selectedConsumerQtyLessEmpty.fold(0, (sum, item) => sum + item);
  //
  //   // Set the global remainingDMQty before opening
  //   remainingDMQty = lessEmptyQty - totalAssigned;
  //   _totalImbalanceQtyDMQty.text = remainingDMQty.toString();
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setModalState) {
  //           return Padding(
  //             padding: EdgeInsets.only(
  //               left: 8,
  //               right:8,
  //               top: 16,
  //               bottom: MediaQuery.of(context).viewInsets.bottom + 16,
  //             ),
  //             child: SingleChildScrollView(
  //               child:
  //               Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text(
  //                     "Update Customer Details",
  //                     style:
  //                     TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                   ),
  //                   SizedBox(height: 20),
  //                   Row(
  //                     children: <Widget>[
  //                       Flexible(
  //                         flex: 4,
  //                         fit: FlexFit.tight,
  //                         child: Text(
  //                           "Entered Less Empty Quantity",
  //                           style: Styling.itemGreyText,
  //                         ),
  //                       ),
  //                       Text(
  //                         " :  ",
  //                         style: Styling.itemGreyText,
  //                       ),
  //                       Flexible(
  //                         flex: 2,
  //                         fit: FlexFit.tight,
  //                         child: Text(
  //                           remainingDMQtyShow.toString(),
  //                           style: Styling.itemBlackTest,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 15),
  //                   Row(
  //                     children: [
  //                       Expanded(child: textWidgetBlueColorWithStar("Select Customer","*")),
  //                       Flexible(
  //                         flex: 1,
  //                         child:
  //                         DropdownButtonFormField<GetConsumerDetailsCredit>(
  //                           decoration: InputDecoration(
  //                             contentPadding:
  //                             EdgeInsets.symmetric(vertical: 12, horizontal: 10),
  //                           ),
  //                           isExpanded: true,
  //                           style: Styling.itemBlackTest,
  //                           value: selectedCustomerModel,
  //                           items: getConsumerCreditDetailListModel
  //                               .map((GetConsumerDetailsCredit vendor) {
  //                             return DropdownMenuItem<GetConsumerDetailsCredit>(
  //                               value: vendor,
  //                               child: Text(vendor.customerName ?? ''),
  //                             );
  //                           }).toList(),
  //                           onChanged:(GetConsumerDetailsCredit? selectedVendor) {
  //                             setModalState((){
  //                               selectedCustomerModel = selectedVendor;
  //                               if (selectedVendor != null) {
  //                                 selectedVendorName = selectedVendor.customerName;
  //                                 selectedVendorId = selectedVendor.customerId?.toInt();
  //                               }
  //                             });
  //
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 10),
  //                   Row(
  //                     children: [
  //                       Expanded(child: textWidgetBlueColorWithStar("Imbalance Qty","*")),
  //                       Flexible(
  //                         flex: 1,
  //                         child: TextField(
  //                           controller: _totalImbalanceQtyDMCustomer,
  //                           decoration: buildInputBorderUpdateStatus(
  //                               "Enter Qty", context),
  //                           style: Styling.textFormText,
  //                           keyboardType: TextInputType.number,
  //                           // Set keyboard type to numeric
  //                           inputFormatters: <TextInputFormatter>[
  //                             FilteringTextInputFormatter.digitsOnly,
  //                             LengthLimitingTextInputFormatter(3),
  //                             // Allow only digits
  //                           ],
  //                           onChanged: (value) {
  //                             setModalState(() { // Use setModalState to update the modal UI
  //                               int inputQty = int.tryParse(value) ?? 0;
  //                               int calculatedRemaining = (remainingDMQty ?? 0) - inputQty;
  //                               _totalImbalanceQtyDMQty.text = calculatedRemaining.toString();
  //                             });
  //                           },
  //                           // onChanged: (value) {
  //                           //   setState(() {
  //                           //     // Get the current value of the filled quantity
  //                           //     int filledQty = int.tryParse(value) ?? 0;
  //                           //     int? qty = 0;
  //                           //    qty = remainingDMQty! - filledQty;
  //                           //     _totalImbalanceQtyDMQty.text = qty!.toString();
  //                           //
  //                           //   });
  //                           // },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 10),
  //                   Row(
  //                     children: [
  //                       Expanded(child: textWidgetBlueColorWithStar("Delivery Men Qty","*")),
  //                       Flexible(
  //                         flex: 1,
  //                         child: TextField(
  //                           controller: _totalImbalanceQtyDMQty,
  //                           decoration: buildInputBorderUpdateStatus(
  //                               "0", context),
  //                           style: Styling.textFormText,
  //                           keyboardType: TextInputType.number,
  //                           enabled: false,
  //                           // Set keyboard type to numeric
  //                           inputFormatters: <TextInputFormatter>[
  //                             FilteringTextInputFormatter.digitsOnly,
  //                             LengthLimitingTextInputFormatter(3),
  //                             // Allow only digits
  //                           ],
  //                           onChanged: (value) {
  //                             setState(() {
  //                               // Get the current value of the filled quantity
  //
  //
  //                             });
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 10),
  //                   Row(mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child:
  //                         SizedBox(
  //                           height: 40, // Button Height
  //                           width: 90, // Button Width
  //                           child:
  //                           ElevatedButton(
  //                             onPressed: () {
  //                               Navigator.pop(context);
  //                             },
  //                             style: ElevatedButton
  //                                 .styleFrom(
  //                               backgroundColor:
  //                               AppColors.surface,
  //                               // Button Color
  //                               // backgroundColor: Color(0xFFfbe9e9),   // Button Color
  //                               foregroundColor:
  //                               Colors.black,
  //                               // Text Color (simple way)
  //                               shape:
  //                               RoundedRectangleBorder(
  //                                 borderRadius:
  //                                 BorderRadius
  //                                     .circular(20),
  //                               ),
  //                               padding: EdgeInsets.zero,
  //
  //                             ),
  //                             child: Text(
  //                               'Close',
  //                               style: TextStyle(
  //                                 fontWeight:
  //                                 FontWeight.bold,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child:
  //                         SizedBox(
  //                           height: 40, // Button Height
  //                           width: 90, // Button Width
  //                           child:
  //                           ElevatedButton(
  //                             onPressed: () {
  //                               if (saveFlag) {
  //                                 showFlushBar(
  //                                     context,
  //                                     Constants
  //                                         .dayEndCompleted);
  //                               } else {
  //                                 if(stockTransferFlag){
  //                                   int filledQty = int.tryParse(_totalImbalanceQtyDMCustomer.text) ?? 0;
  //                                   if (selectedCustomerModel == null || (selectedVendorName?.isEmpty ?? true)) {
  //                                     showFlushBar(context, "Please select customer");
  //                                     return;
  //                                   }
  //                                   if (filledQty <= 0) {
  //                                     showFlushBar(context, "Enter valid qty");
  //                                     return;
  //                                   }
  //                                   if (filledQty > remainingDMQty!) {
  //                                     showFlushBar(context, "Qty exceeds available DM quantity");
  //                                     return;
  //                                   }
  //                                   setModalState(() {
  //                                     remainingDMQty = (remainingDMQty ?? 0) - filledQty;
  //                                     selectedConsumerIDLessEmpty.add(selectedVendorId!);
  //                                     selectedConsumerQtyLessEmpty.add(filledQty);
  //                                     selectedCustomerNamesLessEmpty.add(selectedVendorName!);
  //                                     int dmQty = int.parse(_totalImbalanceQtyDMQty.text);
  //                                     if(dmQty > 0 && isDeliverySelected == false){
  //                                       isDeliverySelected = true;
  //                                     }
  //                                     if(remainingDMQty!<=0){
  //                                       isDeliverySelected = false;
  //                                     }
  //                                     // entries.add({
  //                                     //   "name": selectedVendorName ?? "",
  //                                     //   "qty": filledQty,
  //                                     // });
  //
  //                                     // Reset input
  //                                     _totalImbalanceQtyDMCustomer.clear();
  //                                     selectedCustomerModel = null;
  //                                     selectedVendorName = '';
  //                                     selectedVendorId = 0;
  //                                     filledQty = 0;
  //                                   });
  //                                 }else{
  //                                   CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
  //                                 }
  //                               }
  //                             },
  //                             style: ElevatedButton
  //                                 .styleFrom(
  //                               backgroundColor:
  //                               AppColors.legacyPink,
  //                               // Button Color
  //                               // backgroundColor: Color(0xFFfbe9e9),   // Button Color
  //                               foregroundColor:
  //                               Colors.black,
  //                               // Text Color (simple way)
  //                               shape:
  //                               RoundedRectangleBorder(
  //                                 borderRadius:
  //                                 BorderRadius
  //                                     .circular(20),
  //                               ),
  //                               padding: EdgeInsets.zero,
  //
  //                             ),
  //                             child: Text(
  //                               'Add',
  //                               style: TextStyle(
  //                                 fontWeight:
  //                                 FontWeight.bold,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //
  //                   SizedBox(height: 20),
  //                   Column(
  //                     children: [
  //                       Row(
  //                         children: [
  //                           Expanded(child: Text("Customer", style: TextStyle(fontWeight: FontWeight.bold))),
  //                           Expanded(child: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold))),
  //                         ],
  //                       ),
  //                       Divider(),
  //                       Column(
  //                         children: List.generate(selectedConsumerIDLessEmpty.length, (index) {
  //                           return Row(
  //                             children: [
  //                               Expanded(child: Text(selectedCustomerNamesLessEmpty[index])),
  //                               Expanded(child: Text(selectedConsumerQtyLessEmpty[index].toString())),
  //                               IconButton(
  //                                 icon: Icon(Icons.delete, color: Colors.red),
  //                                 onPressed: () {
  //                                   setModalState(() {
  //                                     remainingDMQty = (remainingDMQty ?? 0) +
  //                                         (selectedConsumerQtyLessEmpty[index] ?? 0);
  //                                     _totalImbalanceQtyDMQty.text = remainingDMQty.toString();
  //                                     selectedConsumerIDLessEmpty.removeAt(index);
  //                                     selectedConsumerQtyLessEmpty.removeAt(index);
  //                                     selectedCustomerNamesLessEmpty.removeAt(index);
  //                                   });
  //                                 },
  //                               ),
  //                             ],
  //                           );
  //                         }),
  //                       )
  //                     ],
  //                   )
  //
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  //
  // }

  void showSimplePopup(BuildContext context, int lessEmptyQty) {
    int remainingDMQtyShow = lessEmptyQty;

    int totalAssigned = selectedConsumerQtyLessEmpty.fold(0, (sum, item) => sum + item);

    // Set the global remainingDMQty before opening
    remainingDMQty = lessEmptyQty - totalAssigned;
    _totalImbalanceQtyDMQty.text = remainingDMQty.toString();

    // ── shared input decoration ──────────────────────────────────────────
    InputDecoration _fieldDecoration(String hint, {bool enabled = true}) {
      return InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.fieldHintText,
        filled: true,
        fillColor: enabled ? AppColors.surface : AppColors.formFieldDisabledFill,
        contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border.withOpacity(0.5), width: 1),
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // ── Drag Handle ───────────────────────────────────────────
                    const SizedBox(height: 10),
                    Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.imbalanceDragHandle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Header Strip ──────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: AppColors.gradPrimary,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                      child: Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white.withOpacity(0.28), width: 1),
                            ),
                            child: const Icon(Icons.person_add_alt_1_rounded,
                                color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Update Customer Details',
                                    style: AppTextStyles.heroScreenTitle
                                        .copyWith(fontSize: 16)),
                                const SizedBox(height: 2),
                                Text('Assign imbalance qty to customers',
                                    style: AppTextStyles.heroSubtitle
                                        .copyWith(fontSize: 11)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Info Banner ───────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.warningBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.warningBorder, width: 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.warningBorder.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.inventory_2_rounded,
                                  color: AppColors.warningText, size: 16),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text('Entered Less Empty Quantity',
                                  style: AppTextStyles.warningBody),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.warningBorder.withOpacity(0.22),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                remainingDMQtyShow.toString(),
                                style: AppTextStyles.warningLabel.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Form Card ─────────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                                color: AppColors.shadowCard,
                                blurRadius: 10,
                                offset: Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // ── Select Customer label ──────────────────────
                            Text('SELECT CUSTOMER',
                                style: AppTextStyles.sectionHeader),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<GetConsumerDetailsCredit>(
                              decoration: _fieldDecoration('Select customer…'),
                              isExpanded: true,
                              style: AppTextStyles.formFieldInput,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.textMuted),
                              value: selectedCustomerModel,
                              items: getConsumerCreditDetailListModel
                                  .map((GetConsumerDetailsCredit vendor) {
                                return DropdownMenuItem<GetConsumerDetailsCredit>(
                                  value: vendor,
                                  child: Text(vendor.customerName ?? '',
                                      style: AppTextStyles.dropdownInputText),
                                );
                              }).toList(),
                              onChanged: (GetConsumerDetailsCredit? selectedVendor) {
                                setModalState(() {
                                  selectedCustomerModel = selectedVendor;
                                  if (selectedVendor != null) {
                                    selectedVendorName = selectedVendor.customerName;
                                    selectedVendorId =
                                        selectedVendor.customerId?.toInt();
                                  }
                                });
                              },
                            ),

                            const SizedBox(height: 14),

                            // ── Qty row ────────────────────────────────────
                            Row(
                              children: [
                                // Imbalance Qty
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('IMBALANCE QTY',
                                              style: AppTextStyles.sectionHeader),
                                          const SizedBox(width: 3),
                                          const Text(' *',
                                              style: TextStyle(
                                                  color: AppColors.red,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800)),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: _totalImbalanceQtyDMCustomer,
                                        decoration:
                                        _fieldDecoration('Enter Qty'),
                                        style: AppTextStyles.formFieldInput,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(3),
                                        ],
                                        onChanged: (value) {
                                          setModalState(() {
                                            int inputQty =
                                                int.tryParse(value) ?? 0;
                                            int calculatedRemaining =
                                                (remainingDMQty ?? 0) - inputQty;
                                            _totalImbalanceQtyDMQty.text =
                                                calculatedRemaining.toString();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // DM Qty (read-only)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('DM QTY',
                                              style: AppTextStyles.sectionHeader),
                                          const SizedBox(width: 3),
                                          const Text(' *',
                                              style: TextStyle(
                                                  color: AppColors.red,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800)),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      TextField(
                                        controller: _totalImbalanceQtyDMQty,
                                        decoration:
                                        _fieldDecoration('0', enabled: false),
                                        style: AppTextStyles.formFieldInput
                                            .copyWith(
                                            color: AppColors.textSecondary),
                                        keyboardType: TextInputType.number,
                                        enabled: false,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(3),
                                        ],
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Action Buttons ────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: Row(
                        children: [
                          // Close
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close_rounded,
                                  size: 16, color: AppColors.textMid),
                              label: Text('Close',
                                  style: AppTextStyles.sqcSaveBtnLabel.copyWith(
                                      color: AppColors.textMid)),
                              style: OutlinedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(vertical: 13),
                                side: const BorderSide(
                                    color: AppColors.border, width: 1.4),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Add
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: AppColors.gradPrimary,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                      color: AppColors.shadowCard,
                                      blurRadius: 8,
                                      offset: Offset(0, 3)),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (saveFlag) {
                                    showFlushBar(context, Constants.dayEndCompleted);
                                  } else {
                                    if (stockTransferFlag) {
                                      int filledQty = int.tryParse(
                                          _totalImbalanceQtyDMCustomer
                                              .text) ??
                                          0;
                                      if (selectedCustomerModel == null ||
                                          (selectedVendorName?.isEmpty ?? true)) {
                                        showFlushBar(
                                            context, "Please select customer");
                                        return;
                                      }
                                      if (filledQty <= 0) {
                                        showFlushBar(
                                            context, "Enter valid qty");
                                        return;
                                      }
                                      if (filledQty > remainingDMQty!) {
                                        showFlushBar(context,
                                            "Qty exceeds available DM quantity");
                                        return;
                                      }
                                      setModalState(() {
                                        remainingDMQty =
                                            (remainingDMQty ?? 0) - filledQty;
                                        selectedConsumerIDLessEmpty
                                            .add(selectedVendorId!);
                                        selectedConsumerQtyLessEmpty
                                            .add(filledQty);
                                        selectedCustomerNamesLessEmpty
                                            .add(selectedVendorName!);
                                        int dmQty = int.parse(
                                            _totalImbalanceQtyDMQty.text);
                                        if (dmQty > 0 &&
                                            isDeliverySelected == false) {
                                          isDeliverySelected = true;
                                        }
                                        if (remainingDMQty! <= 0) {
                                          isDeliverySelected = false;
                                        }
                                        _totalImbalanceQtyDMCustomer.clear();
                                        selectedCustomerModel = null;
                                        selectedVendorName = '';
                                        selectedVendorId = 0;
                                        filledQty = 0;
                                      });
                                    } else {
                                      CustomAlertDialog.showCustomAlert(
                                          context, Constants.stockNotAccepted);
                                    }
                                  }
                                },
                                icon: const Icon(Icons.add_rounded,
                                    size: 16, color: Colors.white),
                                label: Text('Add',
                                    style: AppTextStyles.sqcSaveBtnLabel
                                        .copyWith(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 13),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Customer List ─────────────────────────────────────────
                    if (selectedConsumerIDLessEmpty.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                  color: AppColors.shadowCard,
                                  blurRadius: 10,
                                  offset: Offset(0, 2)),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Table Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryXLight,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text('CUSTOMER',
                                          style:
                                          AppTextStyles.imbalanceColHeader),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text('QTY',
                                          textAlign: TextAlign.center,
                                          style:
                                          AppTextStyles.imbalanceColHeader),
                                    ),
                                    const SizedBox(width: 40),
                                  ],
                                ),
                              ),
                              // Table Rows
                              ...List.generate(
                                  selectedConsumerIDLessEmpty.length, (index) {
                                final isLast = index ==
                                    selectedConsumerIDLessEmpty.length - 1;
                                return Container(
                                  decoration: BoxDecoration(
                                    border: !isLast
                                        ? const Border(
                                        bottom: BorderSide(
                                            color: AppColors.divider,
                                            width: 1))
                                        : null,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 28, height: 28,
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryXLight,
                                                borderRadius:
                                                BorderRadius.circular(8),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                selectedCustomerNamesLessEmpty[
                                                index]
                                                    .isNotEmpty
                                                    ? selectedCustomerNamesLessEmpty[
                                                index][0]
                                                    .toUpperCase()
                                                    : '?',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                selectedCustomerNamesLessEmpty[
                                                index],
                                                style:
                                                AppTextStyles.dataRowLabel,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.tealXLight,
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            selectedConsumerQtyLessEmpty[index]
                                                .toString(),
                                            style: AppTextStyles.badgeText
                                                .copyWith(
                                                color: AppColors.teal),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          setModalState(() {
                                            remainingDMQty =
                                                (remainingDMQty ?? 0) +
                                                    (selectedConsumerQtyLessEmpty[
                                                    index] ??
                                                        0);
                                            _totalImbalanceQtyDMQty.text =
                                                remainingDMQty.toString();
                                            selectedConsumerIDLessEmpty
                                                .removeAt(index);
                                            selectedConsumerQtyLessEmpty
                                                .removeAt(index);
                                            selectedCustomerNamesLessEmpty
                                                .removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          width: 30, height: 30,
                                          decoration: BoxDecoration(
                                            color: AppColors.redXLight,
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                              Icons.delete_outline_rounded,
                                              color: AppColors.red,
                                              size: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

  }


  List<int> getCustomerLessEmptyIDs() {
    return selectedConsumerIDLessEmpty;
  }

  List<String> getCustomerLessEmptyNames() {
    return selectedCustomerNamesLessEmpty;
  }

  List<int> getLessEmptyQuantities() {
    return selectedConsumerQtyLessEmpty;
  }

  // void showImbalanceBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return ImbalanceSheet();
  //     },
  //   );
  // }
  void showImbalanceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,   // opens at 75% of screen
          minChildSize: 0.4,        // can drag down to 40%
          maxChildSize: 0.75,       // cannot expand beyond 75%
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ImbalanceSheet(
                scrollController: scrollController, // pass if ImbalanceSheet uses a scroll view
              ),
            );
          },
        );
      },
    );
  }

  Future<void> fetchConsumerDetailsCredit(int typeId) async {
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

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse('${AppUrl.GetCustomerListByCustType}/$distributorId/1/$typeId'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body GetCustomerListByCustType: ${response.body}");
        debugPrint("request body GetCustomerListByCustType: ${response.request}");

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
            getConsumerCreditDetailListModel.sort((a, b) {
              return (a.customerName ?? '').compareTo(b.customerName ?? '');
            });
            isLoading = false;
            EasyLoading.dismiss();
          });
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
}

// ─────────────────────────────────────────────
// REUSABLE UI COMPONENTS (UI only — no logic)
// ─────────────────────────────────────────────

/// Gradient header strip with back button and imbalance action
class _HeaderStrip extends StatelessWidget {
  const _HeaderStrip({
    required this.onBack,
    required this.onImbalance,
  });
  final VoidCallback onBack;
  final VoidCallback onImbalance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 6, 16, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 22),
                onPressed: onBack,
                splashRadius: 22,
              ),
              // Logo + title
              const SizedBox(width: 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Daily Sale',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Text(
                    'Stock return from delivery man',
                    style: AppTextStyles.heroSubtitle,
                  ),
                ],
              ),
              const Spacer(),
              // Imbalance button
              InkWell(
                onTap: onImbalance,
                borderRadius: AppRadius.iconBadge,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: AppDecorations.heroBackButton,
                  child: const Text(
                    'Imbalance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPACT UI HELPER WIDGETS
// These are NEW layout-only widgets added for compactness.
// All existing helper widgets below are untouched.
// ─────────────────────────────────────────────────────────────────────────────

/// Compact header card: date + del boy + vehicle in a minimal 2-row layout
class _CompactHeaderCard extends StatelessWidget {
  const _CompactHeaderCard({
    required this.date,
    required this.delBoyName,
    required this.vehicleNo,
    required this.vehicleList,
    required this.onVehicleChanged,
  });

  final String date;
  final String delBoyName;
  final String? vehicleNo;
  final List<VehicleNumberGetModel> vehicleList;
  final ValueChanged<String?> onVehicleChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.formCard,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        children: [
          // Row 1: Date + Delivery Man
          Row(
            children: [
              Expanded(
                child: _MiniInfoChip(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: date,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniInfoChip(
                  icon: Icons.person_rounded,
                  label: 'Del. Man',
                  value: delBoyName.isEmpty ? '—' : delBoyName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Row 2: Vehicle dropdown (full width)
          Row(
            children: [
              Icon(Icons.directions_car_rounded,
                  color: AppColors.primaryLight, size: 16),
              const SizedBox(width: 6),
              Text('Vehicle No:', style: AppTextStyles.infoRowLabel),
              const SizedBox(width: 6),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isDense: true,
                    isExpanded: true,
                    value: vehicleNo,
                    hint: Text('Select', style: AppTextStyles.dropdownHint),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textMuted, size: 18),
                    style: AppTextStyles.formFieldInput,
                    items: vehicleList.map((v) {
                      return DropdownMenuItem<String>(
                        value: v.vehicleNo,
                        child: Text(v.vehicleNo ?? '', style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: onVehicleChanged,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Small icon + label + value chip used inside _CompactHeaderCard
class _MiniInfoChip extends StatelessWidget {
  const _MiniInfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.background2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryLight, size: 14),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact section label — smaller than the existing _SectionLabel
class _CompactSectionLabel extends StatelessWidget {
  const _CompactSectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: AppTextStyles.sectionHeader.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}

/// Compact label + child used for dense fields
class _CompactFieldLabel extends StatelessWidget {
  const _CompactFieldLabel({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 3),
        child,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXISTING HELPER WIDGETS (unchanged)
// ─────────────────────────────────────────────────────────────────────────────

/// White rounded card container
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.formCard,
      child: Column(children: children),
    );
  }
}

/// Single info row inside an InfoCard
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.infoRowPadding,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: AppDecorations.infoIconBadge,
            child: Icon(icon, color: AppColors.primaryLight, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.infoRowLabel,
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '—' : value,
                  style: AppTextStyles.infoRowValue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Thin divider for inside info/form cards
class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: AppColors.divider);
  }
}

/// Section label with colored dot
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: AppTextStyles.sectionHeader,
        ),
      ],
    );
  }
}

/// Rounded white form card
class _FormCard extends StatelessWidget {
  const _FormCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: AppDecorations.formCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// Label + input widget row
class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.child,
    this.isRequired = false,
  });

  final String label;
  final Widget child;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label,
                style: AppTextStyles.formFieldLabel,
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

/// Checkbox styled as a chip
class _CheckboxChip extends StatelessWidget {
  const _CheckboxChip({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: AppRadius.checkboxChip,
      child: Container(
        padding: AppSpacing.inlineActionPadding,
        decoration: BoxDecoration(
          color: value ? AppColors.primaryXXLight : AppColors.formFieldFill,
          borderRadius: AppRadius.checkboxChip,
          border: Border.all(
            color: value ? AppColors.primaryLight : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
              size: 16,
              color: value ? AppColors.primary : AppColors.textDisabled,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: value
                  ? AppTextStyles.checkboxChipSelected
                  : AppTextStyles.checkboxChipUnselected,
            ),
          ],
        ),
      ),
    );
  }
}

/// Table header cell
class _TableHeaderCell extends StatelessWidget {
  const _TableHeaderCell({required this.text, this.center = false});
  final String text;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: center ? TextAlign.center : TextAlign.left,
      style: AppTextStyles.tableHeaderCell,
    );
  }
}

/// Single row in the entries table
class _EntryRow extends StatelessWidget {
  const _EntryRow({
    required this.itemName,
    required this.filled,
    required this.sv,
    required this.tv,
    required this.empty,
    required this.def,
    required this.onEdit,
    required this.onDelete,
    this.isLast = false,
  });

  final String itemName;
  final String filled;
  final String sv;
  final String tv;
  final String empty;
  final String def;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
            bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      padding: AppSpacing.tableRowPadding,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              itemName,
              style: AppTextStyles.tableRowItem,
            ),
          ),
          Expanded(
              flex: 1,
              child: _DataCell(filled)),
          Expanded(
              flex: 1,
              child: _DataCell(sv)),
          Expanded(
              flex: 1,
              child: _DataCell(tv)),
          Expanded(
              flex: 1,
              child: _DataCell(empty)),
          Expanded(
              flex: 1,
              child: _DataCell(def)),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: onEdit,
                  borderRadius: AppRadius.actionIcon,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: AppDecorations.editActionBtn,
                    child: Icon(Icons.edit_rounded,
                        size: 14, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: onDelete,
                  borderRadius: AppRadius.actionIcon,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: AppDecorations.deleteActionBtn,
                    child: Icon(Icons.delete_rounded,
                        size: 14, color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Cell in the data table
class _DataCell extends StatelessWidget {
  const _DataCell(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.tableDataCell,
    );
  }
}
class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: SizedBox(
        height: 40,
        width: 90,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shape: const StadiumBorder(),
            padding: EdgeInsets.zero,
            elevation: 0,
          ),
          child: Text(
            label,
            style: AppTextStyles.button,
          ),
        ),
      ),
    );
  }
}