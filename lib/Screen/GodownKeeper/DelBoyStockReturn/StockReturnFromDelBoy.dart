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
import '../../User/Login/provider/LoginProvider.dart';
import '../../User/splashscreen/page/splash_screen.dart';
import '../../Utils/CustomAppBar.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/shared_preference.dart';
import '../DashboardScreen.dart';
import '../DeliveryBoyModel/DeliveryBoyInfoModel.dart';
import '../DeliveryBoyModel/ItemData.dart';
import '../DeliveryBoyModel/StockSubmitToManagerListModel.dart';
import '../DeliveryBoyModel/VehicleNumberGetModel.dart';
import '../ImbalanceEmpty/ImabalanceEmptyListModel.dart';
import '../ItemReceipt/CylItemList/CylItemListModel.dart';

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
  bool isListViewVisible = false;

  // Map<int, String?> _selectedItems = {};
  List<ImabalanceEmptyListModel> receiptList = [];
  bool isLoading = true;
  List<ItemData> data = []; // List to hold rows for the DataTable
  List<ItemData> newList = [];
  late Future<List<ItemData>> itemList;
  int? _editingItemId;
  CylItemListModel? _selectedItemModel;
  bool isPhysicalStockListViewVisible = false;
  int? imbalaceSum = 0;

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

  String? _selectedItem;
  int? selectedItemId;
  String? selectedDelBoyName;
  int? selectedDelBoyId;
  bool isVisible = true;
  List<String> remarksList = [];
  UpdateRefillSale? updateRefillSale;
  List<ItemData> itemDetailDelBoy = [];

  List<Map<String, Object?>> _dataGetFromDBDelBoy = [];
  String? mobileNo;
  List<ItemImbDtls>? imabalanceEmptyListModel;
  List<ItemImbDtls> itemImbDtlsList = []; // List to store fetched data
  String? flagEditMode;
  late Future<List<StockSubmitToManagerListModel>> stockDataFuture;
  List<Map<String, Object?>> _datastockDataFuture = [];

  //
  // void _addNewItem() async {
  //   // Validate input for the empty cylinder count
  //   if (_emptyController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("Add Empty Cylinder Count..!"),
  //       duration: Duration(seconds: 2),
  //     ));
  //
  //   } else {
  //     setState(() {
  //       String remarksString = remarksList.isEmpty ? '' : remarksList.join(', ');
  //       print('Sending remarks to API: $remarksString');
  //       // Create an ItemData object from the input fields
  //       ItemData newItem = ItemData(
  //         date: deliveryDateController.text,
  //         deliveryBoyName: selectedDelBoyName.toString(),
  //         delBoyId: selectedDelBoyId.toString(),
  //         vehicleNo: vehicleNoController.text,
  //         itemName: _selectedItem.toString(),
  //         itemID: selectedItemId.toString(),
  //         filled: _filledController.text ?? '',
  //         sv: _svController.text ?? '',
  //         tv: _tvController.text ?? '',
  //         empty: _emptyController.text ?? '',
  //         defective: _defectiveController.text ?? '',
  //         lessEmpty: _lessEmptyController.text ?? '',
  //         remark: _remarkController.text,
  //         svRemark: remarksString,
  //         updateFlag: 'pending',
  //       );
  //
  //       // Insert the ItemData object into the database
  //       updateRefillSale?.insertUpdateRefillSale([newItem]);
  //       setState(() {
  //         fetchData(selectedDelBoyId.toString(),deliveryDateController.text);
  //       });
  //
  //       // Clear the input fields after adding the item
  //       _filledController.clear();
  //       _svController.clear();
  //       _tvController.clear();
  //       _emptyController.clear();
  //       _defectiveController.clear();
  //       _lessEmptyController.clear();
  //       _remarkController.clear();
  //       _svRemarkController.clear();
  //       remarksList.clear();
  //     });
  //   }
  // }

  void _addNewItem() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    // Validate input for the empty cylinder count
    if (_emptyController.text.isEmpty) {

      showFlushBar(context, "Consumer Count",
          'Add Empty Cylinder Count!');
    } else {
      // Parse all input values to integers (default to 0 if empty)
      int filledValue = int.tryParse(_filledController.text) ?? 0;
      int svValue = int.tryParse(_svController.text) ?? 0;
      int tvValue = int.tryParse(_tvController.text) ?? 0;
      int emptyValue = int.tryParse(_emptyController.text) ?? 0;
      int defectiveValue = int.tryParse(_defectiveController.text) ?? 0;
      int lessEmptyValue = int.tryParse(_lessEmptyController.text) ?? 0;

      if (filledValue > lessEmptyValue) {
        if (filledValue > svValue) {
          if (filledValue > tvValue) {
            if (filledValue > defectiveValue) {
              if (filledValue >= emptyValue && emptyValue > 0) {
                // Check if the item already exists for the given deliveryBoyId
                bool itemExists = await updateRefillSale!.checkIfItemExists(
                    selectedItemId.toString(),
                    selectedDelBoyId.toString(),
                    formattedDate);
                if (itemExists) {

                  showFlushBar(context, "Already Exists",
                      'The Entered Item Already Exists For The Selected Delivery Men!');
                } else {
                  setState(() {
                    String remarksString =
                        remarksList.isEmpty ? '' : remarksList.join(', ');
                    print('Sending remarks to API: $remarksString');

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
                    String lessEmptyValue = _lessEmptyController.text.isEmpty
                        ? ''
                        : _lessEmptyController.text;
                    String remarkValue = _remarkController.text.isEmpty
                        ? ''
                        : _remarkController.text;

                    // Create an ItemData object from the input fields
                    ItemData newItem = ItemData(
                      date: deliveryDateController.text,
                      deliveryBoyName: selectedDelBoyName.toString(),
                      delBoyId: selectedDelBoyId.toString(),
                      vehicleNo: vehicleNoController.text.isEmpty
                          ? ''
                          : vehicleNoController.text,
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
                      updateFlag: 'pending',
                      itemAddedDate: formattedDate,
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
                  });
                }
              } else {
                showFlushBar(context, "Invalid Count",
                    'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
              }
            } else {
              showFlushBar(context, "Invalid Count",
                  'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
            }
          } else {
            showFlushBar(context, "Invalid Count",
                'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
          }
        } else {
          showFlushBar(context, "Invalid Count",
              'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
        }
      } else {
        showFlushBar(context, "Invalid Count",
            'The Total Cylinder Count Must Be Greater Than All Other Quantities!');

      }
    }
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    deliveryDateController.text = formattedDate;

    updateRefillSale = UpdateRefillSale();
    fetchItems();
    fetchDeliveryBoyInfo();
    itemList = updateRefillSale!.getUpdateRefillSaleData();
    updateRefillSale!.deleteCompletedRefillSales();
    debugPrint("itemList" + itemList.toString());

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
          vehicleNoController.text = widget.sale?.vehicleNo ?? '';
        });
      } else {
        debugPrint("Empty");
      }
    } else {
      debugPrint("Empty flag");
    }
  }

  void _onEditItem(ItemList item, StockSubmitToManagerListModel v) {
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
      vehicleNoController.text = v.vehicleNo.toString();
      // Ensure selectedDelBoyName is not null and handles empty value gracefully
      selectedDelBoyName =
          v.staffName?.isNotEmpty == true ? v.staffName : 'Unknown';
      selectedDelBoyId = v.dMId?.toInt();

      String? svRemark = item.sVConsStr?.toString();
      if (svRemark != null &&
          svRemark.isNotEmpty &&
          !remarksList.contains(svRemark)) {
        remarksList.add(svRemark);
      }
      debugPrint("svRemark $svRemark");

      _selectedItemModel =
          _items.firstWhere((itemModel) => itemModel.itemId == selectedItemId);

      // Save the ID of the row being edited (optional for database update)
      _editingItemId = int.parse(item.itemId.toString());
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

  // void _updateItem() async {
  //   // Perform asynchronous operations
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //
  //   // Debug prints
  //   print("Item updated: $selectedItemId");
  //   print("Item selectedItemName: $_selectedItem");
  //   print("Filled Sale Qty: ${_filledController.text}");
  //   print("SV Qty: ${_svController.text}");
  //   print("TV Qty: ${_tvController.text}");
  //   print("Empty Ret Qty: ${_emptyController.text}");
  //   print("Def Qty: ${_defectiveController.text}");
  //   print("Less Empty Qty: ${_lessEmptyController.text}");
  //
  //   await updateRefillSale!.updateItemInDatabase(
  //     itemId: selectedItemId!.toInt() ?? 0,
  //     saleGKId: widget.saleGKId?.toInt() ?? 0,
  //     distributorId: int.parse(distributorId!) ?? 0,
  //     itemName: _selectedItem.toString() ?? '',
  //     filled: int.parse(_filledController.text),
  //     sv: int.parse(_svController.text) ?? 0,
  //     tv: int.parse(_tvController.text) ?? 0,
  //     wmpty: int.parse(_emptyController.text) ?? 0,
  //     defective: int.parse(_defectiveController.text) ?? 0,
  //     lessEmpty: int.parse(_lessEmptyController.text) ?? 0,
  //     remark: _remarkController.text.toString()??'',
  //     svList: remarksList.join(', ') ?? '',
  //   );
  //
  //   // Update state after async operation
  //   setState(() {
  //     stockDataFuture = updateRefillSale!.getDeliveryMenDataForEdit(
  //       widget.saleGKId?.toInt() ?? 0,
  //       widget.dMId?.toInt() ?? 0,
  //     );
  //
  //     _editingItemId = null;
  //     _filledController.clear();
  //     _svController.clear();
  //     _tvController.clear();
  //     _emptyController.clear();
  //     _defectiveController.clear();
  //     _lessEmptyController.clear();
  //     _remarkController.clear();
  //     remarksList.clear();
  //     _selectedItemModel = null;
  //     _selectedItem = '';
  //   });
  // }
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
      svList: remarksList.join(', ') ?? '',
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
      _selectedItemModel = null;
      _selectedItem = '';
    });
  }

  // void _showPopupDialogs(String title, TextEditingController controller) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         // Allows rebuilding the dialog to update UI with added items
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: Text("Add $title Consumer(s)"),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               // Allows content to adjust based on size
  //               children: [
  //                 // Text field for input
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: TextField(
  //                         controller: controller,
  //                         decoration: const InputDecoration(
  //                           hintText: "Enter Consumer",
  //                         ),
  //                         maxLines: 1,
  //                         keyboardType: TextInputType.number,
  //                         // Set keyboard type to numeric
  //                         inputFormatters: <TextInputFormatter>[
  //                           FilteringTextInputFormatter.digitsOnly,
  //                           LengthLimitingTextInputFormatter(6),
  //                           // Allow only digits
  //                         ],
  //                       ),
  //                     ),
  //                     IconButton(
  //                       icon: Icon(Icons.add), // "Add More" button
  //                       onPressed: () {
  //                         String input = controller.text.trim();
  //                         if (input.isNotEmpty) {
  //                           if (!remarksList.contains(input)) {
  //                             setState(() {
  //                               remarksList.add(input); // Add input to the list
  //                               controller.clear();
  //                               // Clear the input field for the next entry
  //                             });
  //                           } else {
  //                             ScaffoldMessenger.of(context).showSnackBar(
  //                               SnackBar(
  //                                 content: Text('Consumer already added!'),
  //                               ),
  //                             );
  //                           }
  //                         }
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 10),
  //
  //                 // Display the list of added remarks (Consumers)
  //                 if (remarksList.isNotEmpty)
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: remarksList
  //                         .map((remark) => Text('- $remark'))
  //                         .toList(),
  //                   ),
  //               ],
  //             ),
  //             actions: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     "Press 'Done' to finish.",
  //                     style: TextStyle(fontSize: 12),
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       // Finalize and close the dialog after the user finishes adding remarks
  //                       String remark = controller.text.trim();
  //                       if (remark.isNotEmpty) {
  //                         setState(() {
  //                           remarksList
  //                               .add(remark); // Add last remark if not empty
  //                         });
  //                       }
  //                       Navigator.pop(context);
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.blue,
  //                       // Button expands to fill available width// Text color of the button
  //                       shape: RoundedRectangleBorder(
  //                         // Optional: Set rounded corners
  //                         borderRadius: BorderRadius.circular(50),
  //                       ),
  //                     ),
  //                     child: const Text(
  //                       "DONE",
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  ///validation
//   void _showPopupDialogs(String title, TextEditingController controller, int svQty) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           // Allows rebuilding the dialog to update UI with added items
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text("Add $title Consumer(s)"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 // Allows content to adjust based on size
//                 children: [
//                   // Text field for input
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: controller,
//                           decoration: const InputDecoration(
//                             hintText: "Enter Consumer",
//                           ),
//                           maxLines: 1,
//                           keyboardType: TextInputType.number,
//                           // Set keyboard type to numeric
//                           inputFormatters: <TextInputFormatter>[
//                             FilteringTextInputFormatter.digitsOnly,
//                             LengthLimitingTextInputFormatter(6),
//                             // Allow only digits
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.add), // "Add More" button
//                         onPressed: () {
//                           String input = controller.text.trim();
//                           if (input.isNotEmpty) {
//                             if (remarksList.length >= svQty) {
//                               // Prevent adding more than allowed consumers
//                               controller.clear();
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                       'Cannot add more than $svQty consumers!'),
//                                 ),
//                               );
//                             } else if (!remarksList.contains(input)) {
//                               // Add a new consumer
//                               setState(() {
//                                 remarksList.add(input); // Add input to the list
//                                 controller.clear(); // Clear the input field
//                               });
//                             } else {
//                               controller.clear();
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text('Consumer already added!'),
//                                 ),
//                               );
//                             }
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//
//                   // Display the list of added remarks (Consumers)
//                   if (remarksList.isNotEmpty)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: remarksList.asMap().entries.map((entry) {
//                         int index = entry.key;
//                         String remark = entry.value;
//
//                         return Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('- $remark'),
//                             IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () {
//                                 setState(() {
//                                   remarksList.removeAt(index); // Delete the item
//                                 });
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text('Consumer removed!'),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                 ],
//               ),
//               actions: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Press 'Done' to finish.",
//                       style: const TextStyle(fontSize: 12),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Finalize and close the dialog
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                       ),
//                       child: const Text(
//                         "DONE",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

  ///hw
//   void _showPopupDialogs(String title, TextEditingController controller, int svQty) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               // Custom dialog box with width and height
//               child: Container(
//                 width: 300, // Set the width of the dialog
//                 height: 400, // Set the height of the dialog
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Title of the dialog
//                     Text(
//                       "Add $title Consumer(s)",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//
//                     // Text field for input
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: controller,
//                             decoration: const InputDecoration(
//                               hintText: "Enter Consumer(s)",
//                             ),
//                             maxLines: 1,
//                             keyboardType: TextInputType.text,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.add), // "Add More" button
//                           onPressed: () {
//                             String input = controller.text.trim();
//                             if (input.isNotEmpty) {
//                               if (remarksList.length >= svQty) {
//                                 // Prevent adding more than allowed consumers
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                         'Cannot add more than $svQty consumers!'),
//                                   ),
//                                 );
//                               } else {
//                                 // Add the input as a string in the remarksList
//                                 setState(() {
//                                   remarksList.add(input); // Add the input string to the list
//                                   controller.clear(); // Clear the input field
//                                 });
//                               }
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//
//                     // Display the list of added remarks (Consumers)
//                     if (remarksList.isNotEmpty)
//                       Expanded( // Use Expanded to make ListView take available space
//                         child: ListView.builder(
//                           itemCount: remarksList.length,
//                           itemBuilder: (context, index) {
//                             String remark = remarksList[index];
//                             // Split the remark string into individual values (if separated by commas)
//                             List<String> remarkList = remark.split(',').map((e) => e.trim()).toList();
//
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Display each value from the split remark
//                                 ...remarkList.map((individualRemark) {
//                                   return Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text('- $individualRemark'),
//                                       IconButton(
//                                         icon: const Icon(Icons.delete),
//                                         onPressed: () {
//                                           setState(() {
//                                             // Remove the specific remark item
//                                             remarkList.remove(individualRemark);
//                                             if (remarkList.isEmpty) {
//                                               remarksList.removeAt(index); // Remove the remark completely if empty
//                                             } else {
//                                               // Update the list with the modified remark
//                                               remarksList[index] = remarkList.join(', ');
//                                             }
//                                           });
//                                           ScaffoldMessenger.of(context).showSnackBar(
//                                             SnackBar(
//                                               content: Text('Consumer removed!'),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   );
//                                 }).toList(),
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16), // Rounded corners for the dialog
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//   void _showPopupDialogs(String title, TextEditingController controller, int svQty) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               // Custom dialog box with width and height
//               child:
//               Container(
//                 width: 300, // Set the width of the dialog
//                 height: 400, // Set the height of the dialog
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Title of the dialog
//                     Text(
//                       "Add $title Consumer(s)",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//
//                     // Text field for input
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: controller,
//                             decoration: const InputDecoration(
//                               hintText: "Enter Consumer(s)",
//                             ),
//                             maxLines: 1,
//                             keyboardType: TextInputType.text,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.add), // "Add More" button
//                           onPressed: () {
//                             String input = controller.text.trim();
//                             if (input.isNotEmpty) {
//                               if (remarksList.length >= svQty) {
//                                 // Prevent adding more than allowed consumers
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                         'Cannot add more than $svQty consumers!'),
//                                   ),
//                                 );
//                               } else {
//                                 // Add the input as a string in the remarksList
//                                 setState(() {
//                                   remarksList.add(input); // Add the input string to the list
//                                   controller.clear(); // Clear the input field
//                                 });
//                               }
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//
//                     // Display the list of added remarks (Consumers)
//                     if (remarksList.isNotEmpty)
//                       Expanded( // Use Expanded to make ListView take available space
//                         child: ListView.builder(
//                           itemCount: remarksList.length,
//                           itemBuilder: (context, index) {
//                             String remark = remarksList[index];
//                             // Split the remark string into individual values (if separated by commas)
//                             List<String> remarkList = remark.split(',').map((e) => e.trim()).toList();
//
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Display each value from the split remark
//                                 ...remarkList.map((individualRemark) {
//                                   return Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text('- $individualRemark'),
//                                       IconButton(
//                                         icon: const Icon(Icons.delete),
//                                         onPressed: () {
//                                           setState(() {
//                                             // Remove the specific remark item
//                                             remarkList.remove(individualRemark);
//                                             if (remarkList.isEmpty) {
//                                               remarksList.removeAt(index); // Remove the remark completely if empty
//                                             } else {
//                                               // Update the list with the modified remark
//                                               remarksList[index] = remarkList.join(', ');
//                                             }
//                                           });
//                                           ScaffoldMessenger.of(context).showSnackBar(
//                                             SnackBar(
//                                               content: Text('Consumer removed!'),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   );
//                                 }).toList(),
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16), // Rounded corners for the dialog
//               ),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Cancel Button
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context); // Close the dialog
//                       },
//                       child: const Text(
//                         "CANCEL",
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ),
//                     // Done Button
//                     ElevatedButton(
//                       onPressed: () {
//                         // Check if the number of consumers in the list is greater than or equal to svQty
//                         if (remarksList.length < svQty) {
//                           // Show an error message if the list size is less than svQty
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                   'You must add at least $svQty consumers!'),
//                             ),
//                           );
//                         } else {
//                           // Otherwise, proceed to close the dialog
//                           Navigator.pop(context);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                       ),
//                       child: const Text(
//                         "DONE",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//
//             );
//           },
//         );
//       },
//     );
//   }
  ///num
  void _showPopupDialogs(
      String title, TextEditingController controller, int svQty) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(16), // Add padding to the content
              content: Container(
                width: 300, // Set the width of the dialog
                height: 500, // Set the height of the dialog
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title of the dialog
                    Text(
                      "$title Consumers",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // Text field for input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: "Enter Consumer",
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add), // "Add More" button
                          onPressed: () {
                            String input = controller.text.trim();
                            if (input.isNotEmpty) {
                              // Count how many individual values are in the remarks list
                              int currentCount = remarksList
                                  .map((remark) => remark.split(',').length)
                                  .fold(0, (a, b) => a + b);

                              // Check if we can add more consumers
                              if (currentCount >= svQty) {
                                controller.clear();
                                showFlushBar(context, "Consumer Count Exceed",
                                    'Consumer Details Count Should Not Exceed The SV Count!');
                              } else {
                                // Add the input as a string in the remarksList
                                // setState(() {
                                //   String input = controller.text.trim();
                                //   if (input.isNotEmpty) {
                                //     int currentCount = remarksList
                                //         .map((remark) => remark.split(',').length)
                                //         .reduce((a, b) => a + b);
                                //     if (!remarksList.contains(input)) {
                                //       setState(() {
                                //         remarksList.add(
                                //             input); // Add input to the list
                                //         controller.clear();
                                //         // Clear the input field for the next entry
                                //       });
                                //     } else {
                                //       ScaffoldMessenger.of(context)
                                //           .showSnackBar(
                                //         SnackBar(
                                //           content:
                                //               Text('Consumer already added!'),
                                //         ),
                                //       );
                                //     }
                                //   }
                                //   // remarksList.add(input);
                                //   // controller.clear(); // Clear the input field
                                // });
                                setState(() {
                                  String input = controller.text.trim();

                                  if (input.isNotEmpty) {
                                    // Count how many individual values are in the remarks list
                                    int currentCount = remarksList
                                        .map((remark) =>
                                            remark.split(',').length)
                                        .fold(0, (a, b) => a + b);

                                    // Check if the input value already exists in the remarksList or in currentCount (split values)
                                    bool alreadyExists =
                                        remarksList.any((remark) {
                                      // Check if any remark contains the input (case sensitive or case insensitive)
                                      List<String> remarkList = remark
                                          .split(',')
                                          .map((e) => e.trim())
                                          .toList();
                                      return remarkList.contains(input);
                                    });

                                    if (alreadyExists) {
                                      // Show a SnackBar if the input value already exists
                                      showFlushBar(context, "Consumer Exist",
                                          'This Consumer Already Exist!');
                                    } else {
                                      // Add input to the list if it's not already present
                                      setState(() {
                                        remarksList.add(
                                            input); // Add input to the list
                                        controller
                                            .clear(); // Clear the input field for the next entry
                                      });
                                    }
                                  }
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Display the list of added remarks (Consumers)
                    if (remarksList.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: remarksList.length,
                          itemBuilder: (context, index) {
                            String remark = remarksList[index];
                            // Split the remark string into individual values (if separated by commas)
                            List<String> remarkList =
                                remark.split(',').map((e) => e.trim()).toList();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Display each value from the split remark
                                ...remarkList.map((individualRemark) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('- $individualRemark'),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            // Remove the specific remark item
                                            remarkList.remove(individualRemark);
                                            if (remarkList.isEmpty) {
                                              remarksList.removeAt(
                                                  index); // Remove the remark completely if empty
                                            } else {
                                              // Update the list with the modified remark
                                              remarksList[index] =
                                                  remarkList.join(', ');
                                            }
                                          });

                                          EasyLoading.showToast("Data Deleted Successfully.",
                                              duration: const Duration(milliseconds: 3000));
                                        },
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            );
                          },
                        ),
                      ),

                    // Display the warning message if the currentCount exceeds svQty
                    Builder(
                      builder: (context) {
                        // Count how many individual values are in the remarks list

                        int currentCount = remarksList
                            .map((remark) => remark.split(',').length)
                            .fold(0, (a, b) => a + b);

                        if (currentCount > svQty) {
                          return Row(
                            children: [
                              Text(
                                'Consumer Details Count Should\n Not Exceed The SV Count!.',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          );
                        } else {
                          return SizedBox
                              .shrink(); // Empty space if condition not met
                        }
                      },
                    ),
                  ],
                ),
              ),

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16), // Rounded corners for the dialog
              ),

              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel Button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: const Text(
                        "CANCEL",
                        style:TextStyle(fontWeight:FontWeight.bold,fontSize: 14),
                      ),
                    ),
                    // Done Button
                    ElevatedButton(
                      onPressed: () {
                        // Count the total number of values (split by commas)
                        int currentCount = remarksList
                            .map((remark) => remark.split(',').length)
                            .fold(0, (a, b) => a + b);

                        // Check if the number of consumers is less than the allowed quantity (svQty)
                        if (currentCount > svQty) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text(
                          //         'You can add only $svQty consumers !'),
                          //   ),
                          // );

                          showFlushBar(context, "Invalid Count",
                              'Consumer Details Count Should Not Exceed The SV Count!');
                          Navigator.pop(context);
                          // showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return AlertDialog(
                          //       title: Text('Limit Exceeded'),
                          //       content: Text(
                          //         'You can add only $svQty consumers !.',
                          //       ),
                          //       actions: [
                          //         TextButton(
                          //           onPressed: () {
                          //             Navigator.pop(context); // Close the alert
                          //           },
                          //           child: Text('Cancel'),
                          //         ),
                          //         ElevatedButton(
                          //           onPressed: () {
                          //             Navigator.pop(context);
                          //             Navigator.pop(
                          //                 context); // Close the main dialog// Close the alert
                          //           },
                          //           child: Text('OK'),
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );
                        } else {
                          // Otherwise, proceed to close the dialog
                          String remark = controller.text.trim();
                          if (remark.isNotEmpty) {
                            // Count how many individual values are in the remarks list
                            int currentCount = remarksList
                                .map((remark) => remark.split(',').length)
                                .fold(0, (a, b) => a + b);

                            // Check if adding the new remark will exceed svQty
                            if (currentCount >= svQty) {
                              // If the number of items exceeds svQty, show a message to the user
                              showFlushBar(context, "Invalid Count",
                                  'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                            } else {
                              // If the current count is within the limit, add the new remark
                              setState(() {
                                remarksList.add(
                                    remark); // Add the new remark to the list
                                controller.clear(); // Clear the input field
                              });
                            }
                          }
                          controller.clear();
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        "DONE",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  //
  // void _showPopupDialogs(String title, TextEditingController controller) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Add $title Consumer(s)"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min, // Allows content to adjust based on size
  //           children: [
  //             TextField(
  //               controller: controller,
  //               decoration: const InputDecoration(
  //                 hintText: "Enter Consumer",
  //               ),
  //               maxLines: 1, // Allow multiple lines for entering remarks
  //             ),
  //             const SizedBox(height: 10),
  //             Text("Press 'Add' to add another remark or 'Done' to finish."),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Close the dialog on cancel
  //             },
  //             child: const Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               // Save the remark to the list if it is not empty
  //               String remark = controller.text.trim();
  //               if (remark.isNotEmpty) {
  //                 setState(() {
  //                   remarksList.add(remark);
  //                   print('Added Remark: $remark');
  //                 });
  //               }
  //
  //               controller.clear(); // Clear the text field for the next remark
  //             },
  //             child: const Text("ADD"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               // Finalize and close the dialog after the user finishes adding remarks
  //               Navigator.pop(context);
  //             },
  //             child: const Text("DONE"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  // Method to create a new list from loaded data

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(context, DashboardScreen.screenName,
              arguments: "onBack");
          return false;
        } else {
          Navigator.pushReplacementNamed(context, DashboardScreen.screenName);
          return false;
        } // In case `null` is returned, return `false`
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Daily Sale', // Title or hint text for the text field
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Date
              TextField(
                controller: deliveryDateController,
                decoration: const InputDecoration(
                  labelText: 'Delivery Date',
                  labelStyle: TextStyle(fontSize: 12),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                ),
                style: TextStyle(
                  fontSize: 14.0, // Adjust the text size here
                ),
                keyboardType: TextInputType.datetime,
                enabled: false,
              ),
              const SizedBox(height: 20),
              // Select Del Boy and Vehicle No
              Row(
                children: [
                  // Expanded(
                  //   flex: 2,
                  //   child:
                  //   DropdownButtonFormField<DeliveryBoyInfoModel>(
                  //     decoration: const InputDecoration(
                  //       labelText: 'Select Delivery Men',
                  //       labelStyle: TextStyle(fontSize: 12),
                  //       border: OutlineInputBorder(),
                  //       contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  //     ),
                  //     items: _delBoyInfo.map((DeliveryBoyInfoModel item) {
                  //       return DropdownMenuItem<DeliveryBoyInfoModel>(
                  //         value: item,
                  //         child: Text(item.staffName ?? 'Unknown',
                  //           style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.normal),),
                  //
                  //       );
                  //     }).toList(),
                  //     onChanged: (DeliveryBoyInfoModel? selectedItem) {
                  //       if (selectedItem != null) {
                  //         setState(() {
                  //           selectedDelBoyName = selectedItem.staffName;
                  //            selectedDelBoyId = selectedItem.staffId!.toInt();
                  //           int delManId = selectedDelBoyId ?? 0;  // Use directly, since it's already an int
                  //
                  //           fetchVehicleDetail(selectedDelBoyId!);
                  //           fetchData(selectedDelBoyId.toString(),deliveryDateController.text);
                  //           _fetchImbalanceData(delManId!);
                  //           print('Selected Del Boy Item: ${selectedDelBoyName}, ID: ${selectedDelBoyId}');
                  //         });
                  //       }
                  //     },
                  //   ),
                  // ),

                  ///work
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<DeliveryBoyInfoModel>(
                      decoration: const InputDecoration(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Select Delivery Men',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            // Add some space between the text and the icon
                            Icon(
                              Icons.star, // Use a star or any other icon
                              color: Colors.red, // Set the icon color to red
                              size: 10, // Adjust the size of the icon
                            ),
                          ],
                        ),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                      ),
                      // value: selectedDelBoyId != null
                      //     ? _delBoyInfo.firstWhere(
                      //         (item) => item.staffId == selectedDelBoyId)
                      //     : null,
                      value:
                          (_delBoyInfo.isNotEmpty && selectedDelBoyId != null)
                              ? _delBoyInfo.firstWhere(
                                  (item) => item.staffId == selectedDelBoyId,
                                  orElse: () => DeliveryBoyInfoModel(
                                    staffId: 0, // Default or dummy ID
                                    staffName: 'Unknown', // Default name
                                  ),
                                )
                              : null,

                      // Ensure that when the selectedDelBoyId is null, the value is null, showing the default hint
                      hint: Text(
                        'Select Delivery Men',
                        style: TextStyle(fontSize: 12),
                      ),
                      // Default hint when no item is selected
                      items: _delBoyInfo.map((DeliveryBoyInfoModel item) {
                        return DropdownMenuItem<DeliveryBoyInfoModel>(
                          value: item,
                          child: Text(
                            item.staffName ?? 'Unknown',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.normal),
                          ),
                        );
                      }).toList(),
                      onChanged: (flagEditMode == "editMode") ? null:(DeliveryBoyInfoModel? selectedItem) {
                        if (selectedItem != null) {
                          setState(() {
                            selectedDelBoyName = selectedItem.staffName;
                            selectedDelBoyId = selectedItem.staffId!.toInt();
                            int delManId = selectedDelBoyId ?? 0;
                            fetchVehicleDetail(selectedDelBoyId!);
                            fetchData(selectedDelBoyId.toString(),
                                deliveryDateController.text);
                            _fetchImbalanceData(delManId!);
                            print(
                                'Selected Del Boy Item: ${selectedDelBoyName}, ID: ${selectedDelBoyId}');
                          });
                        }
                      },
                    ),
                  ),

                  // Expanded(
                  //   flex: 2,
                  //   child: DropdownButtonFormField<DeliveryBoyInfoModel>(
                  //     decoration: const InputDecoration(
                  //       label: Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Text(
                  //             'Select Delivery Men',
                  //             style: TextStyle(fontSize: 12),
                  //           ),
                  //           SizedBox(width: 4),
                  //           // Add some space between the text and the icon
                  //           Icon(
                  //             Icons.star, // Use a star or any other icon
                  //             color: Colors.red, // Set the icon color to red
                  //             size: 10, // Adjust the size of the icon
                  //           ),
                  //         ],
                  //       ),
                  //       border: OutlineInputBorder(),
                  //       contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  //     ),
                  //     // Ensure the correct delivery boy is pre-selected if in edit mode
                  //     value: selectedDelBoyId != null
                  //         ? _delBoyInfo.firstWhere(
                  //           (item) => item.staffId == selectedDelBoyId,
                  //       // Fallback in case no match is found
                  //     )
                  //         : null,
                  //     hint: Text(
                  //       'Select Delivery Men',
                  //       style: TextStyle(fontSize: 12),
                  //     ),
                  //     items: _delBoyInfo.map((DeliveryBoyInfoModel item) {
                  //       return DropdownMenuItem<DeliveryBoyInfoModel>(
                  //         value: item,
                  //         child: Text(
                  //           item.staffName ?? 'Unknown',
                  //           style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                  //         ),
                  //       );
                  //     }).toList(),
                  //     onChanged: (DeliveryBoyInfoModel? selectedItem) {
                  //       if (selectedItem != null && flagEditMode != "editMode") {
                  //         setState(() {
                  //           selectedDelBoyName = selectedItem.staffName;
                  //           selectedDelBoyId = selectedItem.staffId!.toInt();
                  //           int delManId = selectedDelBoyId ?? 0;
                  //           fetchVehicleDetail(selectedDelBoyId!);
                  //           fetchData(selectedDelBoyId.toString(), deliveryDateController.text);
                  //           _fetchImbalanceData(delManId!);
                  //           print(
                  //               'Selected Del Boy Item: ${selectedDelBoyName}, ID: ${selectedDelBoyId}');
                  //         });
                  //       }
                  //     },
                  //     // Disable dropdown when in edit mode
                  //     disabledHint: Text(
                  //       selectedDelBoyName ?? 'Delivery Man',
                  //       style: TextStyle(fontSize: 12),
                  //     ),
                  //     onSaved: (value) {
                  //       // Optionally save the value when needed
                  //     },
                  //     // If in edit mode, disable interaction with the dropdown
                  //
                  //   ),
                  // ),

                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: vehicleNoController,
                      decoration: const InputDecoration(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Vehicle No.',
                              style: TextStyle(fontSize: 12),
                            ),
                            // SizedBox(width: 4), // Add some space between the text and the icon
                            // Icon(
                            //   Icons.star, // Use a star or any other icon
                            //   color: Colors.red, // Set the icon color to red
                            //   size: 10, // Adjust the size of the icon
                            // ),
                          ],
                        ),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                      ),
                      style: TextStyle(
                        fontSize: 14.0, // Adjust the text size here
                      ),
                      enabled: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Add New Section
              // receiptList.isNotEmpty
              //     ? Container(
              //         child: Row(
              //           children: [
              //             Expanded(
              //               flex: 1,
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   // Title for Cylinder Categories Table
              //                   GestureDetector(
              //                     onTap: () {
              //                       setState(() {
              //                         isPhysicalStockListViewVisible =
              //                             !isPhysicalStockListViewVisible; // Toggle ListView visibility
              //                       });
              //                     },
              //                     child: Card(
              //                       child: Padding(
              //                         padding: const EdgeInsets.all(5.0),
              //                         child: Column(
              //                           children: [
              //                             Padding(
              //                               padding: const EdgeInsets.all(5.0),
              //                               child: Row(
              //                                 mainAxisAlignment:
              //                                     MainAxisAlignment.spaceBetween,
              //                                 children: [
              //                                   Row(
              //                                     mainAxisAlignment:
              //                                         MainAxisAlignment.start,
              //                                     children: [
              //                                       Text(
              //                                         'Balance Empty : ',
              //                                         style: TextStyle(
              //                                           fontSize: 15,
              //                                           color: Colors.black,
              //                                           fontWeight:
              //                                               FontWeight.bold,
              //                                         ),
              //                                       ),
              //                                       Text(
              //                                         "$imbalaceSum",
              //                                         style: TextStyle(
              //                                           fontSize: 15,
              //                                           color: Colors.black,
              //                                           fontWeight:
              //                                               FontWeight.bold,
              //                                         ),
              //                                       ),
              //                                     ],
              //                                   ),
              //                                   Icon(
              //                                     isPhysicalStockListViewVisible
              //                                         ? Icons.arrow_drop_up
              //                                         : Icons.arrow_drop_down,
              //                                     size: 30,
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //
              //                             // Visibility(
              //                             //   visible: isPhysicalStockListViewVisible,
              //                             //   child:
              //                             //   Container(
              //                             //     decoration: BoxDecoration(
              //                             //       // Background color of the box
              //                             //       borderRadius: BorderRadius.circular(8),
              //                             //       border: Border.all(
              //                             //           width:
              //                             //               0.5), // Optional: Add rounded corners
              //                             //     ),
              //                             //     child: Column(
              //                             //       crossAxisAlignment:
              //                             //           CrossAxisAlignment.start,
              //                             //       children: [
              //                             //         // Header Row
              //                             //         Container(
              //                             //           decoration: BoxDecoration(
              //                             //             // Background color of the box
              //                             //             borderRadius: BorderRadius.only(topLeft:Radius.circular(8),topRight: Radius.circular(8)),
              //                             //             color: Colors.blue.shade100,
              //                             //             // Optional: Add rounded corners
              //                             //           ),
              //                             //           child: Row(
              //                             //             mainAxisAlignment:
              //                             //                 MainAxisAlignment.center,
              //                             //             children: [
              //                             //               Expanded(
              //                             //                   child: Text('Cylinder',
              //                             //                       style: TextStyle(
              //                             //                           fontWeight: FontWeight
              //                             //                               .bold,),textAlign: TextAlign.center,)),
              //                             //               verticalDividerSmall(),
              //                             //               Expanded(
              //                             //                   child: Text('Imbalance Qty',
              //                             //                       style: TextStyle(
              //                             //                           fontWeight: FontWeight
              //                             //                               .bold),textAlign: TextAlign.center)),
              //                             //
              //                             //             ],
              //                             //           ),
              //                             //         ),
              //                             //
              //                             //         Container(
              //                             //           color: Colors.black12,
              //                             //           height: 1,
              //                             //           width: MediaQuery.of(context)
              //                             //               .size
              //                             //               .width,
              //                             //         ),
              //                             //         // Adds a divider below the header for separation
              //                             //         // List of Entries
              //                             //         ListView.builder(
              //                             //           shrinkWrap: true,
              //                             //           // To make the ListView occupy only the space it needs
              //                             //           physics:
              //                             //               NeverScrollableScrollPhysics(),
              //                             //           // Prevents scrolling inside the ListView
              //                             //           itemCount:
              //                             //               cylinderData.entries.length,
              //                             //           itemBuilder: (context, index) {
              //                             //             var entry = cylinderData.entries
              //                             //                 .elementAt(index);
              //                             //             String category = entry.key;
              //                             //             int emptyCount =
              //                             //                 entry.value['Empty'] ?? 0;
              //                             //             int filledCount = entry.value['Filled'] ?? 0;
              //                             //             int defectiveCount = entry.value['Defective'] ?? 0;
              //                             //
              //                             //             return Column(
              //                             //               children: [
              //                             //                 Row(
              //                             //                   mainAxisAlignment: MainAxisAlignment.center,
              //                             //                   children: [
              //                             //                     Expanded(
              //                             //                       child:Text(
              //                             //                           category,
              //                             //                           textAlign: TextAlign.center,
              //                             //                         ),
              //                             //
              //                             //                     ),
              //                             //                     verticalDividerVerySmall(),
              //                             //                     Expanded(
              //                             //                       child: GestureDetector(
              //                             //                         onTap: () {
              //                             //                           // Handle the tap on the 'emptyCount' text
              //                             //                           setState(() {
              //                             //                             // Perform any action when clicked (e.g., toggle underline state)
              //                             //                           });
              //                             //                         },
              //                             //                         child: Text(
              //                             //                           '$emptyCount',
              //                             //                           textAlign: TextAlign.center,
              //                             //                           style: TextStyle(
              //                             //                             decoration: TextDecoration.underline, // Add blue underline
              //                             //                             decorationColor: Colors.blue, // Set the underline color
              //                             //                           ),
              //                             //                         ),
              //                             //                       ),
              //                             //                     ),
              //                             //                   ],
              //                             //                 ),
              //                             //
              //                             //                 Container(
              //                             //                   color: Colors.black12,
              //                             //                   height: 1,
              //                             //                   width:
              //                             //                       MediaQuery.of(context)
              //                             //                           .size
              //                             //                           .width,
              //                             //                 ),
              //                             //               ],
              //                             //             );
              //                             //           },
              //                             //         ),
              //                             //
              //                             //       ],
              //                             //     ),
              //                             //   ),
              //                             // ),
              //                             Visibility(
              //                               visible:
              //                                   isPhysicalStockListViewVisible &&
              //                                       receiptList.isNotEmpty,
              //                               child: Container(
              //                                 margin: EdgeInsets.symmetric(
              //                                     horizontal: 5),
              //                                 decoration: BoxDecoration(
              //                                   borderRadius:
              //                                       BorderRadius.circular(12),
              //                                   border: Border.all(),
              //                                 ),
              //                                 child: Column(
              //                                   children: [
              //                                     // Header Row for Cylinder Categories
              //                                     Container(
              //                                       padding:
              //                                           const EdgeInsets.all(8),
              //                                       child: Row(
              //                                         mainAxisAlignment:
              //                                             MainAxisAlignment
              //                                                 .center,
              //                                         children: [
              //                                           Expanded(
              //                                             child: Text(
              //                                               'Cylinder',
              //                                               style: TextStyle(
              //                                                 fontWeight:
              //                                                     FontWeight.bold,
              //                                                 color: Colors.black,
              //                                                 fontSize: 14,
              //                                               ),
              //                                               textAlign:
              //                                                   TextAlign.center,
              //                                             ),
              //                                           ),
              //                                           VerticalDivider(
              //                                               thickness: 1,
              //                                               color: Colors.grey),
              //                                           Expanded(
              //                                             child: Text(
              //                                               'Imbalance Qty',
              //                                               style: TextStyle(
              //                                                 fontWeight:
              //                                                     FontWeight.bold,
              //                                                 color: Colors.black,
              //                                                 fontSize: 14,
              //                                               ),
              //                                               textAlign:
              //                                                   TextAlign.center,
              //                                             ),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //
              //                                     // ListView for displaying cylinder categories and imbalance quantities
              //                                     // Container(
              //                                     //   height: 100,
              //                                     //   child: ListView.builder(
              //                                     //     shrinkWrap: true,
              //                                     //     itemCount: receiptList.length, // Use the length of the fetched list
              //                                     //     itemBuilder: (context, index) {
              //                                     //       var receipt = receiptList[index]; // Get the current receipt
              //                                     //       var item = receipt.itemImbDtls?.first; // Get the first item from the list (you can modify this if needed)
              //                                     //
              //                                     //       return Padding(
              //                                     //         padding: const EdgeInsets.all(10.0),
              //                                     //         child: Row(
              //                                     //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                                     //           children: [
              //                                     //             // Cylinder Category Text (Item Name)
              //                                     //             Expanded(
              //                                     //               child: Text(
              //                                     //                 item?.itemName ?? "Unknown Item",  // Display Item Name
              //                                     //                 style: TextStyle(
              //                                     //                   fontWeight: FontWeight.bold,
              //                                     //                   fontSize: 14,
              //                                     //                   color: Colors.black,
              //                                     //                 ),
              //                                     //                 textAlign: TextAlign.center,
              //                                     //               ),
              //                                     //             ),
              //                                     //             // Divider between Texts
              //                                     //             VerticalDivider(thickness: 1, color: Colors.grey),
              //                                     //             // Imbalance Quantity with Tap Gesture
              //                                     //             Expanded(
              //                                     //               child: GestureDetector(
              //                                     //                 onTap: () {
              //                                     //                   int qty = item?.balance?.toInt() ?? 0;
              //                                     //                   int dmId = receipt.dMId?.toInt() ?? 0;  // Get DMId from the receipt
              //                                     //                   int itemId = item?.itemId?.toInt() ?? 0;  // Safely access balance and convert it to int, defaulting to 0 if null
              //                                     //                   _showPopup(qty,dmId,itemId); // Call the popup with the imbalance quantity
              //                                     //                 },
              //                                     //                 child: Text(
              //                                     //                   '${item?.imbQty}',  // Display Imbalance Quantity
              //                                     //                   textAlign: TextAlign.center,
              //                                     //                   style: TextStyle(
              //                                     //                     decoration: TextDecoration.underline,
              //                                     //                     decorationColor: Colors.blue,
              //                                     //                     fontWeight: FontWeight.bold,
              //                                     //                     color: Colors.blue.shade700,
              //                                     //                   ),
              //                                     //                 ),
              //                                     //               ),
              //                                     //             ),
              //                                     //           ],
              //                                     //         ),
              //                                     //       );
              //                                     //     },
              //                                     //   ),
              //                                     // )
              //                                     Container(
              //                                       color:
              //                                           const Color(0xff1280B3),
              //                                       height: 1,
              //                                       width: MediaQuery.of(context)
              //                                           .size
              //                                           .width,
              //                                     ),
              //                                     Container(
              //                                       child: ListView.builder(
              //                                         shrinkWrap: true,
              //                                         itemCount:
              //                                             receiptList.length,
              //                                         // Use the length of the fetched list
              //                                         itemBuilder:
              //                                             (context, index) {
              //                                           var receipt = receiptList[
              //                                               index]; // Get the current receipt
              //
              //                                           return Padding(
              //                                             padding:
              //                                                 const EdgeInsets
              //                                                     .all(10.0),
              //                                             child: Column(
              //                                               crossAxisAlignment:
              //                                                   CrossAxisAlignment
              //                                                       .start,
              //                                               children: [
              //                                                 // Optionally display receipt info here, e.g., receipt.title or date
              //
              //                                                 // For each receipt, loop through all items in itemImbDtls
              //                                                 for (var item in receipt
              //                                                         .itemImbDtls ??
              //                                                     []) ...[
              //                                                   Padding(
              //                                                     padding: const EdgeInsets
              //                                                         .symmetric(
              //                                                         vertical:
              //                                                             5.0),
              //                                                     child: Row(
              //                                                       mainAxisAlignment:
              //                                                           MainAxisAlignment
              //                                                               .spaceBetween,
              //                                                       children: [
              //                                                         // Cylinder Category Text (Item Name)
              //                                                         Expanded(
              //                                                           child:
              //                                                               Text(
              //                                                             item.itemName ??
              //                                                                 "Unknown Item",
              //                                                             // Display Item Name
              //                                                             style:
              //                                                                 TextStyle(
              //                                                               fontWeight:
              //                                                                   FontWeight.bold,
              //                                                               fontSize:
              //                                                                   16,
              //                                                               color:
              //                                                                   Colors.black,
              //                                                             ),
              //                                                             textAlign:
              //                                                                 TextAlign.center,
              //                                                           ),
              //                                                         ),
              //                                                         // Divider between Texts
              //                                                         VerticalDivider(
              //                                                             thickness:
              //                                                                 1,
              //                                                             color: Colors
              //                                                                 .grey),
              //                                                         // Imbalance Quantity with Tap Gesture
              //                                                         Expanded(
              //                                                           child:
              //                                                               GestureDetector(
              //                                                             onTap:
              //                                                                 () {
              //                                                               int qty =
              //                                                                   item.balance?.toInt() ?? 0;
              //                                                               int dmId =
              //                                                                   receipt.dMId?.toInt() ?? 0; // Get DMId from the receipt
              //                                                               int itemId =
              //                                                                   item.itemId?.toInt() ?? 0; // Safely access balance and convert it to int
              //                                                               _showPopup(
              //                                                                   qty,
              //                                                                   dmId,
              //                                                                   itemId); // Call the popup with the imbalance quantity
              //                                                             },
              //                                                             child:
              //                                                                 Text(
              //                                                               '${item.lessEmptyQty}',
              //                                                               // Display Imbalance Quantity
              //                                                               textAlign:
              //                                                                   TextAlign.center,
              //                                                               style: TextStyle(
              //                                                                   decoration: TextDecoration.underline,
              //                                                                   decorationColor: Colors.blue,
              //                                                                   fontWeight: FontWeight.bold,
              //                                                                   color: Colors.blue.shade700,
              //                                                                   fontSize: 16),
              //                                                             ),
              //                                                           ),
              //                                                         ),
              //                                                       ],
              //                                                     ),
              //                                                   ),
              //                                                 ],
              //                                               ],
              //                                             ),
              //                                           );
              //                                         },
              //                                       ),
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                   SizedBox(height: 10),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       )
              //     : Container(),

              // Item Details
              Row(
                children: [
                  // SV+ Field (DropdownButton)
                  Flexible(
                    flex: 2,
                    child:
                        // DropdownButtonFormField<CylItemListModel>(
                        //   decoration: const InputDecoration(
                        //     labelText: 'Select Item',
                        //     labelStyle: TextStyle(fontSize: 12),
                        //     border: OutlineInputBorder(),
                        //     contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        //   ),
                        //   items: _items.map((CylItemListModel item) {
                        //     return DropdownMenuItem<CylItemListModel>(
                        //       value: item,
                        //       child: Text(item.itemName ?? 'Unknown',
                        //         style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.normal),),
                        //
                        //     );
                        //   }).toList(),
                        //   onChanged: (CylItemListModel? selectedItem) {
                        //     if (selectedItem != null) {
                        //       setState(() {
                        //         _selectedItem = selectedItem.itemName;
                        //         selectedItemId = selectedItem.itemId!.toInt();
                        //
                        //         print('Selected Item: ${_selectedItem}, ID: ${selectedItemId}');
                        //       });
                        //     }
                        //   },
                        // ),

                        DropdownButtonFormField<CylItemListModel>(
                      decoration: const InputDecoration(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Select Item',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            // Add some space between the text and the icon
                            Icon(
                              Icons.star, // Use a star or any other icon
                              color: Colors.red, // Set the icon color to red
                              size: 10, // Adjust the size of the icon
                            ),
                          ],
                        ),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                      ),
                      value: _selectedItemModel,
                      // Bind the value to the selected item model
                      items: _items.map((CylItemListModel item) {
                        return DropdownMenuItem<CylItemListModel>(
                          value: item,
                          child: Text(
                            item.itemName ?? 'Unknown',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.normal),
                          ),
                        );
                      }).toList(),
                      onChanged: (flagEditMode == "editMode") ? null:(CylItemListModel? selectedItem) {
                        if (selectedItem != null) {
                          setState(() {
                            _selectedItem = selectedItem.itemName;
                            selectedItemId = selectedItem.itemId!.toInt();

                            // Update the selectedItemModel when the selection changes
                            _selectedItemModel = selectedItem;

                            print(
                                'Selected Item: ${_selectedItem}, ID: ${selectedItemId}');
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 10), // Spacing between SV+ and TV-

                  // TV- Field (TextField)
                  Flexible(
                    flex: 1,
                    child: TextField(
                      controller: _filledController,
                      decoration: const InputDecoration(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Total\nSale',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            // Add some space between the text and the icon
                            Icon(
                              Icons.star, // Use a star or any other icon
                              color: Colors.red, // Set the icon color to red
                              size: 10, // Adjust the size of the icon
                            ),
                          ],
                        ),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                      ),
                      style: TextStyle(
                        fontSize: 14.0, // Adjust the text size here
                      ),
                      keyboardType: TextInputType.number,
                      // Set keyboard type to numeric
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                        // Allow only digits
                      ],
                      onChanged: (value) {
                        setState(() {
                          // Get the current value of the filled quantity
                          int filledQty = int.tryParse(value) ?? 0;

                          // Recalculate the empty quantity based on other fields
                          int svQty = int.tryParse(_svController.text) ?? 0;
                          int tvQty = int.tryParse(_tvController.text) ?? 0;
                          int defQty =
                              int.tryParse(_defectiveController.text) ?? 0;
                          int lessEmptyQty =
                              int.tryParse(_lessEmptyController.text) ?? 0;

                          // Calculate the new empty quantity
                          int emptyQty =
                              filledQty - svQty + tvQty - defQty - lessEmptyQty;

                          // Update the empty field
                          _emptyController.text = emptyQty.toString();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    child: TextField(
                      controller: _lessEmptyController,
                      keyboardType: TextInputType.number,
                      // Set keyboard type to numeric
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                        // Allow only digits
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Less\nEmpty',
                        labelStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                      ),
                      style: TextStyle(
                        fontSize: 14.0, // Adjust the text size here
                      ),
                      onChanged: (value) {
                        setState(() {
                          // Recalculate empty quantity
                          int lessEmpty = int.tryParse(value) ?? 0;
                          int filledQty =
                              int.tryParse(_filledController.text) ?? 0;
                          int svQty = int.tryParse(_svController.text) ?? 0;
                          int tvQty = int.tryParse(_tvController.text) ?? 0;
                          int defQty =
                              int.tryParse(_defectiveController.text) ?? 0;
                          if (lessEmpty > filledQty) {
                            showFlushBar(context, "Invalid Count",
                                'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                          } else {
                            // Calculate the new empty quantity
                            int emptyQty =
                                filledQty - svQty + tvQty - defQty - lessEmpty;
                            _emptyController.text = emptyQty.toString();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // SV+ Field and Button
                  Flexible(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // Align widgets in the center vertically
                      children: [
                        // TextField for SV+
                        Expanded(
                          child: TextField(
                            controller: _svController,
                            keyboardType: TextInputType.number,
                            // Set keyboard type to numeric
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                              // Allow only digits
                            ],
                            decoration: const InputDecoration(
                              labelText: 'SV-',
                              labelStyle: TextStyle(fontSize: 12),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                            ),
                            style: TextStyle(
                              fontSize: 14.0, // Adjust the text size here
                            ),
                            onChanged: (value) {
                              setState(() {
                                // Recalculate empty quantity
                                int svQty = int.tryParse(value) ?? 0;
                                int filledQty =
                                    int.tryParse(_filledController.text) ?? 0;
                                int tvQty =
                                    int.tryParse(_tvController.text) ?? 0;
                                int defQty =
                                    int.tryParse(_defectiveController.text) ??
                                        0;
                                int lessEmptyQty =
                                    int.tryParse(_lessEmptyController.text) ??
                                        0;
                                if (svQty > filledQty) {
                                  showFlushBar(context, "Invalid Count",
                                      'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                } else {
                                  // Calculate the new empty quantity
                                  int emptyQty = filledQty -
                                      svQty +
                                      tvQty -
                                      defQty -
                                      lessEmptyQty;
                                  _emptyController.text = emptyQty.toString();
                                }
                              });
                            },
                          ),
                        ),
                        // IconButton for SV+
                        IconButton(
                          iconSize: 35,
                          onPressed: () {
                            int svQty = int.tryParse(_svController.text) ?? 0;
                            _showPopupDialogs(
                                "SV", _svRemarkController, svQty);
                          },
                          icon: const Icon(Icons.add_circle_outline_sharp),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10), // Spacing between SV+ and TV-
                  // TV- Field and Button
                  Flexible(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // Align widgets in the center vertically
                      children: [
                        // TextField for TV-
                        Expanded(
                          child: TextField(
                            controller: _tvController,
                            keyboardType: TextInputType.number,
                            // Set keyboard type to numeric
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                              // Allow only digits
                            ],
                            decoration: const InputDecoration(
                              labelText: 'TV+',
                              labelStyle: TextStyle(fontSize: 12),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                            ),
                            style: TextStyle(
                              fontSize: 14.0, // Adjust the text size here
                            ),
                            onChanged: (value) {
                              setState(() {
                                // Recalculate empty quantity
                                int tvQty = int.tryParse(value) ?? 0;
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
                                // Validate TV value
                                if (tvQty > filledQty) {
                                  showFlushBar(context, "Invalid Count",
                                      'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                } else {
                                  // Calculate the new empty quantity
                                  int emptyQty = filledQty -
                                      svQty +
                                      tvQty -
                                      defQty -
                                      lessEmptyQty;
                                  _emptyController.text = emptyQty.toString();
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // Align vertically to the center
                      children: [
                        // TextField for Def.
                        Expanded(
                          child: TextField(
                            controller: _defectiveController,
                            keyboardType: TextInputType.number,
                            // Set keyboard type to numeric
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                              // Allow only digits
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Def.-',
                              labelStyle: TextStyle(fontSize: 12),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                            ),
                            style: TextStyle(
                              fontSize: 14.0, // Adjust the text size here
                            ),
                            onChanged: (value) {
                              setState(() {
                                // Recalculate empty quantity
                                int defQty = int.tryParse(value) ?? 0;
                                int filledQty =
                                    int.tryParse(_filledController.text) ?? 0;
                                int svQty =
                                    int.tryParse(_svController.text) ?? 0;
                                int tvQty =
                                    int.tryParse(_tvController.text) ?? 0;
                                int lessEmptyQty =
                                    int.tryParse(_lessEmptyController.text) ??
                                        0;
                                if (defQty > filledQty) {
                                  showFlushBar(context, "Invalid Count",
                                      'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                } else {
                                  // Calculate the new empty quantity
                                  int emptyQty = filledQty -
                                      svQty +
                                      tvQty -
                                      defQty -
                                      lessEmptyQty;
                                  _emptyController.text = emptyQty.toString();
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  // Empty Field and Button
                  Flexible(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // Align vertically to the center
                      children: [
                        // TextField for Empty
                        Expanded(
                          child: TextField(
                            controller: _emptyController,
                            keyboardType: TextInputType.number,
                            // Set keyboard type to numeric
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                              // Allow only digits
                            ],
                            decoration: const InputDecoration(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'Empty',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(width: 4),
                                  // Add some space between the text and the icon
                                  Icon(
                                    Icons.star,
                                    // Use a star or any other icon
                                    color: Colors.red,
                                    // Set the icon color to red
                                    size: 10, // Adjust the size of the icon
                                  ),
                                ],
                              ),
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                            ),
                            enabled: false,
                            style: TextStyle(
                              fontSize: 14.0, // Adjust the text size here
                            ),
                            onChanged: (value) {
                              setState(() {
                                // Get the value of Sale and Empty (make sure they are integers)
                                int filledQty =
                                    int.tryParse(_filledController.text) ?? 0;
                                int emptyQty = int.tryParse(value) ?? 0;

                                // If the empty quantity exceeds the filled (sale) quantity, show an error
                                if (emptyQty > filledQty) {
                                  // Show an error message
                                  showFlushBar(context, "Invalid Count",
                                      'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                  // Update the empty quantity to be equal to the sale quantity
                                  _emptyController.text = filledQty.toString();
                                  // Optionally, move the cursor to the end of the input field after setting the value
                                  _emptyController.selection =
                                      TextSelection.collapsed(
                                          offset: _emptyController.text.length);
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40), // Spacing between Empty and Def.
                  Flexible(
                    flex: 1,
                    child: TextField(
                      controller: _remarkController,
                      maxLength: 250,
                      decoration: const InputDecoration(
                        labelText: 'Remark',
                        labelStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                      ),

                      style: TextStyle(
                        fontSize: 14.0, // Adjust the text size here
                      ),
                    ),
                  ),
                ],
              ),

              // Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child:
              //             // ElevatedButton(
              //             //     onPressed:_addNewItem,
              //             // child: Text("Add New Item",style: TextStyle(color: Colors.white,fontSize: 14),),
              //             //   style: ElevatedButton.styleFrom(
              //             //         backgroundColor: Colors.blue, // Button expands to fill available width// Text color of the button
              //             //         shape: RoundedRectangleBorder( // Optional: Set rounded corners
              //             //           borderRadius: BorderRadius.circular(50),
              //             //         ),
              //             //       ),),
              //
              //             Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             ElevatedButton(
              //               // onPressed: () async {
              //               //   if (_editingItemId != null) {
              //               //     // Update the existing item in the database
              //               //     await updateRefillSale?.updateRowByColID(
              //               //       _editingItemId!,
              //               //       ItemData(
              //               //         date: deliveryDateController.text,
              //               //         deliveryBoyName:
              //               //             selectedDelBoyName.toString(),
              //               //         delBoyId: selectedDelBoyId.toString(),
              //               //         vehicleNo: vehicleNoController.text,
              //               //         itemName: _selectedItem.toString(),
              //               //         itemID: selectedItemId.toString(),
              //               //         filled: _filledController.text,
              //               //         sv: _svController.text,
              //               //         tv: _tvController.text,
              //               //         empty: _emptyController.text,
              //               //         defective: _defectiveController.text,
              //               //         lessEmpty: _lessEmptyController.text,
              //               //         remark: _remarkController.text,
              //               //         svRemark: remarksList.join(', '),
              //               //         updateFlag: 'pending',
              //               //       ),
              //               //     );
              //               //     ScaffoldMessenger.of(context).showSnackBar(
              //               //       SnackBar(
              //               //           content: Text('Item updated successfully')),
              //               //     );
              //               //     fetchData(selectedDelBoyId.toString(),
              //               //         deliveryDateController.text);
              //               //     debugPrint(
              //               //         "update"); // Call your existing add function
              //               //     // Clear the editing state and text fields
              //               //     setState(() {
              //               //       _editingItemId = null;
              //               //       _filledController.clear();
              //               //       _svController.clear();
              //               //       _tvController.clear();
              //               //       _emptyController.clear();
              //               //       _defectiveController.clear();
              //               //       _lessEmptyController.clear();
              //               //       _remarkController.clear();
              //               //       remarksList.clear();
              //               //       _selectedItemModel =
              //               //       null; // Clear the selected item in the dropdown
              //               //       _selectedItem = '';
              //               //     });
              //               //   } else {
              //               //     _addNewItem();
              //               //     debugPrint(
              //               //         "Add"); // Call your existing add function
              //               //   }
              //               // },
              //
              //               onPressed: () async {
              //                 int filledValue =
              //                     int.tryParse(_filledController.text) ?? 0;
              //                 int svValue = int.tryParse(_svController.text) ?? 0;
              //                 int tvValue = int.tryParse(_tvController.text) ?? 0;
              //                 int emptyValue =
              //                     int.tryParse(_emptyController.text) ?? 0;
              //                 int defectiveValue =
              //                     int.tryParse(_defectiveController.text) ?? 0;
              //                 int lessEmptyValue =
              //                     int.tryParse(_lessEmptyController.text) ?? 0;
              //
              //                 if (_editingItemId != null) {
              //                   if (filledValue > lessEmptyValue) {
              //                     if (filledValue > svValue) {
              //                       if (filledValue > tvValue) {
              //                         if (filledValue > defectiveValue) {
              //                           if (filledValue >= emptyValue && emptyValue > 0) {
              //                             // Attempt to update the existing item in the database
              //                             final isUpdated =
              //                             await updateRefillSale?.updateRowByColID(
              //                               _editingItemId!,
              //                               ItemData(
              //                                 date: deliveryDateController.text,
              //                                 deliveryBoyName:
              //                                 selectedDelBoyName.toString(),
              //                                 delBoyId: selectedDelBoyId.toString(),
              //                                 vehicleNo: vehicleNoController.text,
              //                                 itemName: _selectedItem.toString(),
              //                                 itemID: selectedItemId.toString(),
              //                                 filled: _filledController.text,
              //                                 sv: _svController.text,
              //                                 tv: _tvController.text,
              //                                 empty: _emptyController.text,
              //                                 defective: _defectiveController.text,
              //                                 lessEmpty: _lessEmptyController.text,
              //                                 remark: _remarkController.text,
              //                                 svRemark: remarksList.join(', '),
              //                                 updateFlag: 'pending',
              //                               ),
              //                             );
              //
              //                             if (isUpdated == true) {
              //                               // Success: Show success message and refresh data
              //                               ScaffoldMessenger.of(context).showSnackBar(
              //                                 SnackBar(
              //                                     content:
              //                                     Text('Item updated successfully')),
              //                               );
              //                               fetchData(selectedDelBoyId.toString(),
              //                                   deliveryDateController.text);
              //
              //                               // Clear the editing state and text fields
              //                               setState(() {
              //                                 _editingItemId = null;
              //                                 _filledController.clear();
              //                                 _svController.clear();
              //                                 _tvController.clear();
              //                                 _emptyController.clear();
              //                                 _defectiveController.clear();
              //                                 _lessEmptyController.clear();
              //                                 _remarkController.clear();
              //                                 remarksList.clear();
              //                                 _selectedItemModel =
              //                                 null; // Clear the selected item in the dropdown
              //                                 _selectedItem = '';
              //                               });
              //                             } else {
              //                               // Failure: Show error message
              //                               ScaffoldMessenger.of(context).showSnackBar(
              //                                 SnackBar(
              //                                     content: Text(
              //                                         'Item update failed. Duplicate or invalid entry.')),
              //                               );
              //                             }
              //                           }else{
              //                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //                               content: Text(
              //                                   "Empty cylinder counts must be less than the Sale cylinder count..!"),
              //                               duration: Duration(seconds: 2),
              //                             ));
              //                           }
              //                         }else{
              //                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //                             content: Text(
              //                                 "Defective cylinder counts must be less than the Sale cylinder count..!"),
              //                             duration: Duration(seconds: 2),
              //                           ));
              //                         }
              //                       }else{
              //                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //                           content: Text(
              //                               "TV cylinder counts must be less than the Sale cylinder count..!"),
              //                           duration: Duration(seconds: 2),
              //                         ));
              //                       }
              //                     }else{
              //                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //                         content: Text(
              //                             "SV cylinder counts must be less than the Sale cylinder count..!"),
              //                         duration: Duration(seconds: 2),
              //                       ));
              //                     }
              //                   }else{
              //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //                       content: Text(
              //                           "Less Empty cylinder counts must be less than the Sale cylinder count..!"),
              //                       duration: Duration(seconds: 2),
              //                     ));
              //                   }
              //                 } else {
              //                   // Add new item
              //                   _addNewItem();
              //                   debugPrint(
              //                       "Add"); // Call your existing add function
              //                 }
              //               },
              //
              //               child: Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Text(
              //                   _editingItemId != null ? 'Update' : 'Add',
              //                   style:
              //                       TextStyle(color: Colors.white, fontSize: 14),
              //                 ),
              //               ),
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: Colors.blue,
              //                 // Button expands to fill available width// Text color of the button
              //                 shape: RoundedRectangleBorder(
              //                   // Optional: Set rounded corners
              //                   borderRadius: BorderRadius.circular(50),
              //                 ),
              //               ), // Change button label
              //             ),
              //           ],
              //         ),
              //       ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: (_filledController.text.isNotEmpty &&
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
                                  if (filledValue > lessEmptyValue) {
                                    if (filledValue > svValue) {
                                      if (filledValue > tvValue) {
                                        if (filledValue > defectiveValue) {
                                          if (filledValue >= emptyValue && emptyValue > 0) {
                                            int currentCount = remarksList
                                                .map((remark) => remark.split(',').length)
                                                .fold(0, (a, b) => a + b);
                                            int svQty = int.parse(_svController.text);
                                            // Check if we can add more consumers
                                            if (currentCount > svQty) {
                                              showFlushBar(context, "No Of Consumer",
                                                  'Consumer Details Count Should Not Exceed The SV Count!');
                                            }else {
                                              _updateItem();
                                            }
                                          } else {
                                            showFlushBar(context, "Cylinder Count",
                                                'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                          }
                                        } else {
                                          showFlushBar(context, "Cylinder Count",
                                              'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                        }
                                      } else {
                                        showFlushBar(context, "Cylinder Count",
                                            'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                      }
                                    } else {
                                      showFlushBar(context, "Cylinder Count",
                                          'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                    }
                                  } else {
                                    showFlushBar(context, "Cylinder Count",
                                        'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                  }
                                }else{
                                  if(_dataGetFromDBDelBoy.isNotEmpty) {
                                    if(filledValue > 0) {
                                      if (filledValue > lessEmptyValue) {
                                        if (filledValue > svValue) {
                                          if (filledValue > tvValue) {
                                            if (filledValue > defectiveValue) {
                                              if (filledValue >= emptyValue &&
                                                  emptyValue > 0) {
                                                int currentCount = remarksList
                                                    .map((remark) =>
                                                remark
                                                    .split(',')
                                                    .length)
                                                    .fold(0, (a, b) => a + b);
                                                int svQty = int.parse(
                                                    _svController.text);
                                                // Check if we can add more consumers
                                                if (currentCount > svQty) {
                                                  showFlushBar(context, "Consumer Count Exceed",
                                                      'Consumer Details Count Should Not Exceed The SV Count!');
                                                } else {
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
                                                      vehicleNoController.text,
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
                                                      svRemark:
                                                      remarksList.join(', '),
                                                      updateFlag: 'pending',
                                                      itemAddedDate: formattedDate,
                                                    ),
                                                  );

                                                  if (isUpdated == true) {
                                                    EasyLoading.showToast("Data Updated Successfully",
                                                        duration: const Duration(milliseconds: 3000));

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
                                                      _selectedItemModel = null;
                                                      _selectedItem = '';
                                                    });
                                                  } else {
                                                    showFlushBar(context, "Item Exists",
                                                        'This Item Already Exists!');
                                                  }
                                                }
                                              } else {
                                                showFlushBar(context, "Cylinder Count",
                                                    'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                              }
                                            } else {
                                              showFlushBar(context, "Cylinder Count",
                                                  'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                            }
                                          } else {
                                            showFlushBar(context, "Cylinder Count",
                                                'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                          }
                                        } else {
                                          showFlushBar(context, "Cylinder Count",
                                              'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                        }
                                      } else {
                                        showFlushBar(context, "Cylinder Count",
                                            'The Total Cylinder Count Must Be Greater Than All Other Quantities!');
                                      }
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
                      // Disable the button when the condition is false
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: flagEditMode == "editMode"?
                        Text(
                          _editingItemId != null ? 'Update' : 'Update',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ):
                        Text(
                          _editingItemId != null && _dataGetFromDBDelBoy.isNotEmpty ? 'Update' : 'Add',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _filledController.text.isNotEmpty &&
                                selectedDelBoyName != null &&
                                (_selectedItem != null )
                            ? Colors.blue
                            : Colors.grey,
                        // Change color based on enabled state
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          flagEditMode == "editMode"?
                          setState(() {
                            // _editingItemId = null;
                            _filledController.clear();
                            _svController.clear();
                            _tvController.clear();
                            _emptyController.clear();
                            _defectiveController.clear();
                            _lessEmptyController.clear();
                            _remarkController.clear();
                            remarksList.clear();
                            // _selectedItemModel = null;
                            // _selectedItem = '';
                            // selectedDelBoyName =''; // Clear the delivery boy name
                            // selectedDelBoyId = null; // Clear delivery boy ID
                            // _selectedItemModel = null; // Clear the selected item in the dropdown
                            // selectedItemId = null; // Clear the selected item text
                            // vehicleNoController.clear();
                            // stockDataFuture = updateRefillSale!.getDeliveryMenDataForEdit(
                            //      0,  0);
                            // flagEditMode = null;
                          }):
                          setState(() {
                            // _editingItemId = null;
                            _filledController.clear();
                            _svController.clear();
                            _tvController.clear();
                            _emptyController.clear();
                            _defectiveController.clear();
                            _lessEmptyController.clear();
                            _remarkController.clear();
                            remarksList.clear();
                            // _selectedItemModel = null;
                            // _selectedItem = '';
                            // selectedDelBoyName = ''; // Clear the delivery boy name
                            // selectedDelBoyId = null; // Clear delivery boy ID
                            // _selectedItemModel = null; // Clear the selected item in the dropdown
                            // selectedItemId = null; // Clear the selected item text
                            // vehicleNoController.clear();
                            // fetchData("0", deliveryDateController.text);
                          });
                        },
                        child: Text("Clear"))
                  ],
                ),
              ),

              Visibility(
                visible: _dataGetFromDBDelBoy.isNotEmpty || flagEditMode == "editMode",
                child:
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 15),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Column(
                    children: [
                      // Header Row with equal width for all columns using Expanded
                      Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Center(
                                  child: Text(
                                "Item",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                          verticalDividerVerySmall(),
                          Expanded(
                              flex: 1,
                              child: Center(
                                  child: Text(
                                "Sale",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                          verticalDividerVerySmall(),
                          Expanded(
                              flex: 1,
                              child: Center(
                                  child: Text(
                                "SV",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                          verticalDividerVerySmall(),
                          Expanded(
                              flex: 1,
                              child: Center(
                                  child: Text(
                                "TV",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                          verticalDividerVerySmall(),
                          Expanded(
                              flex: 2,
                              child: Center(
                                  child: Text(
                                "Empty",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                          verticalDividerVerySmall(),
                          Expanded(
                              flex: 1,
                              child: Center(
                                  child: Text(
                                "Def.",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                          verticalDividerVerySmall(),
                          Expanded(
                              flex: 2,
                              child: Center(
                                  child: Text(
                                "Less\nEmpty",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))),
                          verticalDividerVerySmall(),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // Vertically center the content
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // Horizontally center the content
                              children: [
                                Text(
                                  "Action",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      // Divider between header and data rows
                      Container(
                        color: const Color(0xff1280B3),
                        height: 1.5,
                        width: MediaQuery.of(context).size.width,
                      ),

                      // ListView to display the data
                      flagEditMode != null || flagEditMode == "editMode"
                          ? Container(
                              child: FutureBuilder<
                                  List<StockSubmitToManagerListModel>>(
                                future: stockDataFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text("Error: ${snapshot.error}"));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text("No Data Available."));
                                  } else {
                                    List<StockSubmitToManagerListModel>
                                        stockList = snapshot.data!;
                                    return Column(
                                      children: stockList.map((stock) {
                                        return Column(
                                          children: [
                                            ...stock.itemList!.map((item) {
                                              return Container(
                                                child: Row(
                                                  children: [
                                                    // Column 1: Item Name
                                                    Expanded(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 5.0),
                                                        child: Text(
                                                          item.itemName
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54),
                                                        ),
                                                      ),
                                                    ),
                                                    verticalDividerBig(),
                                                    // Column 2: Filled
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        item.filledSaleQty
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black54),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    verticalDividerBig(),
                                                    // Column 3: Empty
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        item.sVQty.toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black54),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    verticalDividerBig(),
                                                    // Column 4: Defective
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        item.tVQty.toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black54),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    verticalDividerBig(),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        item.emptyRetQty
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black54),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    verticalDividerBig(),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        item.deffQty.toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black54),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    verticalDividerBig(),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        item.lessEmptyQty
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black54),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    verticalDividerBig(),
                                                    Expanded(
                                                      child: IconButton(
                                                        icon: Icon(Icons.edit),
                                                        onPressed: () {
                                                          _onEditItem(item,
                                                              stock); // Populate fields with this item's data
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: IconButton(
                                                        icon:
                                                            Icon(Icons.delete),
                                                        onPressed: () async {
                                                          // Show the alert dialog before proceeding with deletion
                                                          bool? confirmDelete =
                                                              await showDialog<
                                                                  bool>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return
                                                                AlertDialog(
                                                                title: Text(
                                                                    "Confirm Deletion"),
                                                                content: Text(
                                                                    "Are You Sure You Want To Delete Record?"),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              false); // Cancel deletion
                                                                    },
                                                                    child: Text(
                                                                        "No"),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              true);
                                                                    },
                                                                    child: Text(
                                                                        "Yes"),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                          if (confirmDelete ==
                                                              true) {
                                                            try {
                                                              // Ensure that 'item' contains the correct ID field
                                                              _onDeleteItem(
                                                                  int.parse(item
                                                                      .itemId
                                                                      .toString())); // Confirm deletion
                                                              stockDataFuture = updateRefillSale!
                                                                  .getDeliveryMenDataForEdit(
                                                                      widget.saleGKId
                                                                              ?.toInt() ??
                                                                          0,
                                                                      widget.dMId
                                                                              ?.toInt() ??
                                                                          0);
                                                              EasyLoading.showToast("Data Deleted Successfully.",
                                                                  duration: const Duration(milliseconds: 3000));

                                                            } catch (e) {
                                                              debugPrint(
                                                                  "Error deleting row: $e");
                                                              showFlushBar(context, "Fail",
                                                                  'Fail To Deleted Record.!');
                                                            }
                                                          }
                                                          // If the user confirms, proceed with deletion
                                                          // You can proceed with your delete logic here.
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ],
                                        );
                                      }).toList(),
                                    );
                                  }
                                },
                              ),
                            )
                          : Container(
                              child: _dataGetFromDBDelBoy.isNotEmpty
                                  ? ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: _dataGetFromDBDelBoy.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Map<String, Object?> item =
                                            _dataGetFromDBDelBoy[
                                                index]; // Get the item at the current index
                                        // You can access the columns in your database result like this:
                                        String itemId =
                                            item['itemID'].toString();
                                        String itemName =
                                            item['itemName'].toString();
                                        String filledSaleQty =
                                            item['filled'].toString();
                                        String svQty = item['sv'].toString();
                                        String tvQty = item['tv'].toString();
                                        String emptyRetQty =
                                            item['empty'].toString();
                                        String deffQty =
                                            item['defective'].toString();
                                        String lessEmptyQty =
                                            item['lessEmpty'].toString();
                                        String remark =
                                            item['remark']?.toString() ??
                                                "No remark";
                                        return Column(
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  // Column 1: Item Name
                                                  Expanded(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 5.0),
                                                        child: Text(itemName,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black54)),
                                                      )),
                                                  verticalDividerBig(),
                                                  // Column 2: Filled
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(filledSaleQty,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54),
                                                          textAlign: TextAlign
                                                              .center)),
                                                  verticalDividerBig(),
                                                  // Column 3: Empty
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(svQty,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54),
                                                          textAlign: TextAlign
                                                              .center)),
                                                  verticalDividerBig(),
                                                  // Column 4: Defective
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(tvQty,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54),
                                                          textAlign: TextAlign
                                                              .center)),
                                                  verticalDividerBig(),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Text(emptyRetQty,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54),
                                                          textAlign: TextAlign
                                                              .center)),
                                                  verticalDividerBig(),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(deffQty,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54),
                                                          textAlign: TextAlign
                                                              .center)),
                                                  verticalDividerBig(),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Text(lessEmptyQty,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54),
                                                          textAlign: TextAlign
                                                              .center)),
                                                  verticalDividerBig(),
                                                  Expanded(
                                                    child: IconButton(
                                                      icon: Icon(Icons.edit),
                                                      onPressed: () {
                                                        _populateFieldsForEdit(
                                                            item); // Populate fields with this item's data
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: IconButton(
                                                      icon: Icon(Icons.delete),
                                                      onPressed: () async {
                                                        // Show the alert dialog before proceeding with deletion
                                                        bool? confirmDelete =
                                                            await showDialog<
                                                                bool>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Confirm Deletion"),
                                                              content: Text(
                                                                  "Are You Sure You Want To Delete Record?"),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            false); // Cancel deletion
                                                                  },
                                                                  child: Text(
                                                                      "No"),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            true); // Confirm deletion
                                                                  },
                                                                  child: Text(
                                                                      "Yes"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );

                                                        // If the user confirms, proceed with deletion
                                                        if (confirmDelete ==
                                                            true) {
                                                          try {
                                                            // Ensure that 'item' contains the correct ID field
                                                            if (item
                                                                .containsKey(
                                                                    'itemID')) {
                                                              String itemId =
                                                                  item['itemID']
                                                                      .toString();
                                                              String delBoyId =
                                                                  item['delBoyId']
                                                                      .toString();

                                                              // Call the delete method with the cast value
                                                              await updateRefillSale
                                                                  ?.deleteRowByDelBoyIdAndItemId(
                                                                      delBoyId,
                                                                      itemId);

                                                              // Refresh the UI after deletion by fetching updated data
                                                              fetchData(
                                                                selectedDelBoyId
                                                                    .toString(),
                                                                deliveryDateController
                                                                    .text,
                                                              );

                                                              // Optionally show a confirmation message (snack bar, dialog, etc.)
                                                              EasyLoading.showToast("Data Deleted Successfully.",
                                                                  duration: const Duration(milliseconds: 3000));
                                                            } else {
                                                              debugPrint(
                                                                  "Item ID not found in the current item.");
                                                            }
                                                          } catch (e) {
                                                            debugPrint(
                                                                "Error deleting row: $e");
                                                            showFlushBar(context, "Fail",
                                                                'Fail To Deleted Record.');
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Container(
                                            //   color: Colors.grey,
                                            //   height: 1,
                                            // ),
                                          ],
                                        );
                                      },
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(5),
                                      child: const Center(
                                          child: Text("No Pending Data..!")),
                                    ),
                            ),
                    ],
                  ),
                ),
              ),
              ),
              // Closing Stock
              //     Padding(
              //       padding: const EdgeInsets.all(5.0),
              //       child: Text("Closing Stock",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              //     ),
              // Container(
              //   decoration: BoxDecoration(border: Border.all(width: 1)),
              //   child: Column(
              //     children: [
              //       // Header Row with equal width for all columns using Expanded
              //       Row(
              //         children: [
              //           Expanded(child: Center(child: Text("Item",style: TextStyle(fontWeight: FontWeight.bold),))),
              //           verticalDividerVerySmall(),
              //           Expanded(child: Center(child: Text("Filled",style: TextStyle(fontWeight: FontWeight.bold),))),
              //           verticalDividerVerySmall(),
              //           Expanded(child: Center(child: Text("Empty",style: TextStyle(fontWeight: FontWeight.bold),))),
              //           verticalDividerVerySmall(),
              //           Expanded(child: Center(child: Text("Defective",style: TextStyle(fontWeight: FontWeight.bold),))),
              //         ],
              //       ),
              //
              //       // Divider between header and data rows
              //       Container(
              //         color: const Color(0xff1280B3),
              //         height: 1.5,
              //         width: MediaQuery.of(context).size.width,
              //       ),
              //
              //       // ListView to display the data
              //       Container(
              //         child: closingStock.isNotEmpty
              //             ?
              //         ListView.builder(
              //           physics: const BouncingScrollPhysics(),
              //           itemCount: closingStock.length,
              //           shrinkWrap: true,
              //           itemBuilder: (BuildContext context, int index) {
              //             var item = closingStock[index];
              //             String itemName = item['itemName']!;
              //             String filled = item['filled']!;
              //             String empty = item['empty']!;
              //             String defective = item['defective']!;
              //             return Column(
              //               children: [
              //                 Container(
              //                   child: Row(
              //                     children: [
              //                       // Column 1: Item Name
              //                       Expanded(child:
              //                       Padding(
              //                         padding: const EdgeInsets.only(left: 5.0),
              //                         child: Text(itemName,style: TextStyle(fontSize: 14, color: Colors.black54)),
              //                       )),
              //                       verticalDividerVerySmall(),
              //                       // Column 2: Filled
              //                       Expanded(child: Text(filled, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
              //                       verticalDividerVerySmall(),
              //                       // Column 3: Empty
              //                       Expanded(child: Text(empty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
              //                       verticalDividerVerySmall(),
              //                       // Column 4: Defective
              //                       Expanded(child: Text(defective, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
              //                     ],
              //                   ),
              //                 ),
              //                 Container(
              //                   color: Colors.grey,
              //                   height: 1,
              //                 ),
              //               ],
              //             );
              //           },
              //         )
              //             : Container(
              //           padding: EdgeInsets.all(5),
              //           child: const Center(child: Text("No Data Available..!")),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 20),
              // Submit Button
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  // Add 10px margin on left and right
                  child: ElevatedButton(
                    onPressed: () {
                      if (flagEditMode == "editMode") {
                        ((stockDataFuture != null))
                            ? sendEditedDataToApi(context)
                            : null;
                      } else {
                        ((_dataGetFromDBDelBoy.isNotEmpty) &&
                                (selectedDelBoyName != null &&
                                    selectedDelBoyName!.isNotEmpty))
                            ? sendDataToApi(selectedDelBoyId.toString()!,
                                deliveryDateController.text)
                            : null;
                      }

                      // if (selectedDelBoyName != null &&
                      //     selectedDelBoyName!.isNotEmpty) {
                      //
                      // } else {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //         content: Text(
                      //             'Select delivery boy whose data want to submit..!')),
                      //   );
                      // }
                      // } else {
                      //   showAlertDialog(context);
                      // }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0,right: 25,top: 12,bottom: 12),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ), // Set text color directly if needed
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor(),
                      // ((flagEditMode == "editMode") && _dataGetFromDBDelBoy.isNotEmpty &&
                      //         (_filledController.text == null ||
                      //             _filledController.text.isEmpty) &&
                      //         (_svController.text == null ||
                      //             _svController.text.isEmpty) &&
                      //         (_tvController.text == null ||
                      //             _tvController.text.isEmpty) &&
                      //         (_emptyController.text == null ||
                      //             _emptyController.text.isEmpty ||
                      //             _emptyController.text == "0") &&
                      //         (_defectiveController.text == null ||
                      //             _defectiveController.text.isEmpty) &&
                      //         (_lessEmptyController.text == null ||
                      //             _lessEmptyController.text.isEmpty) &&
                      //         (_remarkController.text == null ||
                      //             _remarkController.text.isEmpty) &&
                      //         (selectedDelBoyName != null &&
                      //             selectedDelBoyName!.isNotEmpty))
                      //     ? Colors.blue
                      //     : Colors.grey,
                      // Button expands to fill available width// Text color of the button
                      shape: RoundedRectangleBorder(
                        // Optional: Set rounded corners
                        borderRadius: BorderRadius.circular(50),
                      ),
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

      final response = await http.get(
        Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/0/C'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );
      debugPrint("GetItemMasterList" +
          '${AppUrl.GetItemMasterList}/$distributorId/0/C');
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
    } else {
      showFlushBar(
          context, Constants.connectionTitle, Constants.connectionMessage);
    }
  }

  // Fetch data from API Del boy
  Future<void> fetchDeliveryBoyInfo() async {
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
        throw Exception('Failed To Load Items');
      }
    } else {
      showFlushBar(
          context, Constants.connectionTitle, Constants.connectionMessage);
    }
  }

//vehicle info
  Future<void> fetchVehicleDetail(int staffId) async {
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
        Uri.parse(
            '${AppUrl.GetVehicleDetailsByStaffId}/$distributorId/$staffId'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );

      debugPrint("GetVehicleDetailsByStaffId" +
          '${AppUrl.GetVehicleDetailsByStaffId}/$distributorId/$staffId');
      debugPrint("Response body: " + response.body);

      if (response.statusCode == 200) {
        // Parse the response body and map it to VehicleNumberGetModel
        List<dynamic> responseData = json.decode(response.body);
        List<VehicleNumberGetModel> data = responseData
            .map((item) => VehicleNumberGetModel.fromJson(item))
            .toList();

        // Assuming we want to set the vehicle number from the first vehicle in the list
        if (data.isNotEmpty) {
          setState(() {
            vehicleNoController.text = data[0].vehicleNo ?? '';
            vehicleNo = data[0].vehicleNo ?? '';
            vehicleId =
                data[0].vehicleId ?? 0; // Set the vehicle number (if available)
          });
        } else {
          vehicleNoController.text = " " ?? '';
        }
      } else {
        // Optionally handle token refresh here or show an error
        throw Exception('Failed To Load Items');
      }
    } else {
      showFlushBar(
          context, Constants.connectionTitle, Constants.connectionMessage);
    }
  }

  Future<Map<String, dynamic>> getFormattedDataForApi(
      String deliveryBoyId, String delDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    // Fetch the filtered data from the database

    var getUpdateRefillSale = await updateRefillSale?.getUpdateRefillSaleData2(
        deliveryBoyId.toString(), delDate.toString());
    List<ItemData> itemList = [];

    debugPrint("areaWiseEKYCDetailResult" + getUpdateRefillSale.toString());
    // Convert each item into ItemData object
    for (var item in getUpdateRefillSale!) {
      itemList.add(ItemData.fromJson(item));
    }

    // Format the data into the structure needed for the API
    List<Map<String, dynamic>> apiItemList = itemList.map((item) {
      return {
        "ItemId": item.itemID.toString(),
        // Assuming itemID is the column for Item ID
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
        "DailySaleStatus": " ",
        "SVConsStr": item.svRemark ?? ""
        // Assuming svRemark is a list of remarks
      };
    }).toList();
    debugPrint("apiItemList" + apiItemList.toString());
    // Format the entire data structure for the API
    return {
      "SaleGKId": "0", // Assuming this is always 0 for the new sale
      "DistributorId": distributorId,
      "DeliveryDate": deliveryDateController.text.toString(),
      "DMId": deliveryBoyId.toString(),
      "VehicleId": vehicleId, // Use your actual vehicle ID if needed
      "AddedBy": "4", // Use the actual user ID
      "Action": "ADD", // Assuming you're adding new data
      "ItemList": apiItemList
    };
  }

  Future<void> sendDataToApi(String deliveryBoyId, String delDate) async {
    Constants.isNetworkAvailable =
        await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      try {
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
          print('response ${response.body}');
          print('response ${response}');
          // Check response status
          if (response.statusCode == 200) {
            print('Data sent successfully');
            EasyLoading.showToast("Data Sent Successfully.",
                duration: const Duration(milliseconds: 3000));
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
              vehicleNoController.clear();
            });
          } else {
            print('Failed to send data: ${response.statusCode}');
            EasyLoading.showToast("Failed To Send Data.",
                duration: const Duration(milliseconds: 3000));
          }
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Enter record for that delivery boy..!')),
          // );
        }
      } catch (e) {
        print('Error sending data to API: $e');
      }
    } else {
      showFlushBar(
          context, Constants.connectionTitle, Constants.connectionMessage);
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
              '_dataGetFromDBDelBoy: $_dataGetFromDBDelBoy'); // Store the fetched data in _data
        });
      } else {
        // Handle the case when no data is returned
        setState(() {
          _dataGetFromDBDelBoy = [];
          print(
              '_dataGetFromDBDelBoy: $_dataGetFromDBDelBoy'); // Store the fetched data in _data
// Empty the list if no data is found
        });
      }
    } catch (e) {
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

  // void _populateFieldsForEdit(Map<String, Object?> item) {
  //   setState(() {
  //     // Populate text fields with data from the item
  //     _filledController.text = item['filled'].toString();
  //     _svController.text = item['sv'].toString();
  //     _tvController.text = item['tv'].toString();
  //     _emptyController.text = item['empty'].toString();
  //     _defectiveController.text = item['defective'].toString();
  //     _lessEmptyController.text = item['lessEmpty'].toString();
  //     _remarkController.text = item['remark']?.toString() ?? '';
  //
  //     // Set the selected item in the dropdown
  //     _selectedItem = item['itemName'].toString();
  //     selectedItemId = int.parse(item['itemID'].toString());
  //
  //     // Save the ID of the row being edited (optional for database update)
  //     _editingItemId = int.parse(item['ID'].toString());
  //   });
  // }
  void _populateFieldsForEdit(Map<String, Object?> item) {
    setState(() {
      // Populate text fields with data from the item
      _filledController.text = item['filled'].toString();
      _svController.text = item['sv'].toString();
      _tvController.text = item['tv'].toString();
      _emptyController.text = item['empty'].toString();
      _defectiveController.text = item['defective'].toString();
      _lessEmptyController.text = item['lessEmpty'].toString();
      _remarkController.text = item['remark']?.toString() ?? '';

      // Set the selected item in the dropdown by finding the item in the list
      _selectedItem = item['itemName'].toString();
      selectedItemId = int.parse(item['itemID'].toString());

      String? svRemark = item['svRemark']?.toString();
      if (svRemark != null &&
          svRemark.isNotEmpty &&
          !remarksList.contains(svRemark)) {
        remarksList.add(svRemark);
      }

      // Find the selected item in the list and update _selectedItem
      _selectedItemModel =
          _items.firstWhere((itemModel) => itemModel.itemId == selectedItemId);

      // Save the ID of the row being edited (optional for database update)
      _editingItemId = int.parse(item['ID'].toString());
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
                            showFlushBar(context, " Invalid Count",
                                'Input count must me smaller than empty!');
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
                      // Prepare the item details to send to the API
                      List<ItemImbDtls> itemDetails = [
                        ItemImbDtls(
                          itemId: itemId,
                          imbQty: inputCount,
                          balance: 0,
                        ),
                      ];
                      // Call API with the request body
                      addItemImbalanceQty(delMenId, itemDetails);
                      Navigator.of(context).pop(); // Close the popup
                    } else {
                      showFlushBar(context, "Invalid Count",
                          'Enter a Valid Count!');
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

  // ImbalanceList(int delManId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? bearerToken = prefs.getString('token');
  //
  //   try {
  //     final response = await http.get(
  //       Uri.parse('${AppUrl.ItemImbalanceList}/$distributorId/$delManId'),
  //       headers: {
  //         'Authorization': 'Bearer $bearerToken',
  //       },
  //     );
  //
  //     // var response = await http.get(Uri.parse(requestUrl));
  //     debugPrint('### ItemImbalanceList${response.body}');
  //     debugPrint('### ItemImbalanceListRequest${'${AppUrl.ItemImbalanceList}/$distributorId/$delManId'}');
  //
  //     if (response.statusCode == 200) {
  //       try {
  //         var data = json.decode(response.body);
  //         ImabalanceEmptyListModel result = ImabalanceEmptyListModel.fromJson(data);
  //         var itemImbDtlsList = result.itemImbDtls;
  //         imabalanceEmptyListModel = itemImbDtlsList;
  //         print('result $result');
  //       } catch (e) {
  //         e.toString();
  //       }
  //     }else{
  //       print('error for getting response');
  //     }
  //   } catch (e) {
  //     e.toString();
  //     print('### exce' + e.toString());
  //   }finally{
  //     setState(() {
  //       EasyLoading.dismiss();
  //     });
  //   }
  // }

  // Future<void> _fetchImbalanceData(int delManId) async {
  //   EasyLoading.show(status: 'Loading...');  // Show loading indicator (optional)
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? bearerToken = prefs.getString('token');
  //
  //   if (distributorId == null) {
  //     // Handle case where distributorId is not available
  //     print('Error: DistributorId is null');
  //     EasyLoading.dismiss();
  //     return;  // Exit the function if distributorId is null
  //   }
  //
  //   // try {
  //     int dId = int.parse(distributorId);  // Parse the distributorId to int
  //     final response = await http.get(
  //       Uri.parse('${AppUrl.ItemImbalanceList}/$dId/$delManId'),
  //       headers: {
  //         'Authorization': 'Bearer $bearerToken',
  //       },
  //     );
  //   print('response.body: ${response.body}');
  //   print('request.body: ${'${AppUrl.ItemImbalanceList}/$dId/$delManId'}');
  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.body);
  //       print('request.body: ${'$data'}');
  //
  //       List<ImabalanceEmptyListModel> result = (data as List)
  //           .map((item) => ImabalanceEmptyListModel.fromJson(item))
  //           .toList();
  //       print('request.body: ${'$result'}');
  //
  //       // Convert response data into a list of ItemImbDtls
  //       // itemImbDtlsList = (data as List)
  //       //     .map((item) => ItemImbDtls.fromJson(item))
  //       //     .toList();
  //       // print('request.bodysss: ${'$itemImbDtlsList'}');
  //       // Parse the JSON response and set the itemImbDtlsList
  //       itemImbDtlsList = (data as List)
  //           .map((item) => ImabalanceEmptyListModel.fromJson(item))
  //           .expand((element) => element.itemImbDtls ?? [])
  //           .toList();
  //       // setState(() {
  //       //   itemImbDtlsList = result; // Update the list with the fetched data
  //       // });
  //       EasyLoading.dismiss();
  //     } else {
  //       print('Failed to load data: ${response.statusCode}');
  //       EasyLoading.dismiss();
  //     }
  //   EasyLoading.dismiss();
  //   // } catch (e) {
  //   //   print('Error: $e');
  //   // } finally {
  //   //   EasyLoading.dismiss();  // Dismiss loading indicator
  //   // }
  // }

  // Future<void> _fetchImbalanceData(int delManId) async {
  //   Constants.isNetworkAvailable =
  //   await InternetConnectionChecker().hasConnection;
  //   if(Constants.isNetworkAvailable){
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? godownId = prefs.getString('godownId');
  //     String? addedBy = prefs.getString('StaffId');
  //     String? godownKeeperId = prefs.getString('godownKeeperId');
  //     String? token = prefs.getString('token'); // This is your bearer token
  //     int dId = int.parse(distributorId!);
  //     try {
  //       final response = await http.get(
  //         // Uri.parse('${AppUrl.GetItemReceiptList}/$distributorId/$godownId/1'),
  //         Uri.parse('${AppUrl.ItemImbalanceList}/$dId/$delManId'),
  //         headers: {
  //           'Authorization': 'Bearer $token',  // Add the Bearer token here
  //           // Any other headers you need can go here
  //         },
  //       );
  //       // Print the URL and the headers (including the Bearer token)
  //       print("Request URL: ${response.request}");
  //       print("Request Headers: {'Authorization': 'Bearer $token'}");
  //       // Print the raw response for debugging
  //       print("API Response Status Code: ${response.statusCode}");
  //       print("API Response Body: ${response.body}");
  //       if (response.statusCode == 200) {
  //         final List<dynamic> data = json.decode(response.body);
  //         setState(() {
  //           receiptList = data.map((json) => ImabalanceEmptyListModel.fromJson(json)).toList();
  //           isLoading = false;
  //
  //           num? totalImbQty = 0;
  //
  //           // Loop through each receipt and each item inside itemImbDtls to sum ImbQty
  //           for (var receipt in receiptList) {
  //             for (var item in receipt.itemImbDtls ?? []) {
  //               // Add imbQty to totalImbQty, treating null as 0
  //               totalImbQty = item.imbQty ?? 0;  // Null-safe addition
  //             }
  //           }
  //
  //           // Log the total imbalance quantity
  //           print("Total ImbQty for delManId $delManId: $totalImbQty");
  //         });
  //       } else {
  //         // Handle non-200 responses
  //         setState(() {
  //           isLoading = false;
  //         });
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Failed to fetch data: ${response.statusCode}')),
  //         );
  //       }
  //     } catch (e) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: $e')),
  //       );
  //     }
  //   }else{
  //     showFlushBar(context,Constants.connectionTitle,
  //         Constants.connectionMessage);
  //   }
  //
  // }
  Future<void> _fetchImbalanceData(int delManId) async {
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

            // Initialize totalImbQty
            num totalImbQty = 0;

            // Loop through each receipt and each item inside itemImbDtls to sum ImbQty
            for (var receipt in receiptList) {
              for (var item in receipt.itemImbDtls ?? []) {
                // Add imbQty to totalImbQty, treating null as 0
                totalImbQty +=
                    item.lessEmptyQty ?? 0; // Corrected summing of imbQty
              }
            }

            // Log the total imbalance quantity
            print("Total ImbQty for delManId $delManId: $totalImbQty");
            imbalaceSum = totalImbQty.toInt();
            // Optionally, you can store this in a variable or use it in the UI
          });
        } else {
          // Handle non-200 responses
          setState(() {
            isLoading = false;
          });
          showFlushBar(context, "Please Try Again",
              'Unable To Load Data At This Time. Please Try Again');
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error: $e')),
        // );
        showFlushBar(context, "Please Try Again",
            'Unable To Load Data At This Time. Please Try Again');
      }
    } else {
      showFlushBar(
          context, Constants.connectionTitle, Constants.connectionMessage);
    }
  }

  Future<void> addItemImbalanceQty(
      int dmId, List<ItemImbDtls> itemDetails) async {
    // Construct the request payload
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
      "ImbId": "0", // Default value
      "DistributorId": distributorId,
      "GodownId": godownId,
      "DMId": dmId,
      "ImbDate": formattedDate,
      "Action": "ADD", // Action to be added
      "ItemDetails": itemDetails.map((item) {
        return {
          "ItemId": item.itemId,
          "ImbQty": item.imbQty,
          "BalanceQty": item.balance ?? 0 // Use balance if available
        };
      }).toList()
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
      } else {
        // Handle error response
        print("Failed to add imbalance quantity: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred: $e");
    }
  }

  void sendEditedDataToApi(BuildContext context) async {
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
              });
            }
          }
        }

        if (apiItemList.isEmpty) {
          showFlushBar(context, "No Records",
              'No Records Available To Send!!');
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
        print('jsonEncode(apiData): ${jsonEncode(apiData)}');
        print('jsonEncode(apiData): ${jsonEncode(apiItemList)}');
        if (response.statusCode == 200) {
          print('Data sent successfully: ${response.body}');
          EasyLoading.showToast("Data Sent Successfully..",
              duration: const Duration(milliseconds: 3000));
          Navigator.pushReplacementNamed(context, '/godownDashboard');
        } else {
          print('Failed to send data: ${response.statusCode}');
          showFlushBar(context, "Fail",
              'Failed To Send Data. Please Try Again Later!');
        }
      } catch (e) {
        print('Error in sending data: $e');
      }
    } else {
      showFlushBar(
          context, Constants.connectionTitle, Constants.connectionMessage);
    }
  }
}
