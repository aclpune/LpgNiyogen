import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../Database/GodownKeeperDB/UpdateRefillSaleDB.dart';
import '../../Utils/CustomAppBar.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../DeliveryBoyModel/DeliveryBoyInfoModel.dart';
import '../DeliveryBoyModel/ItemData.dart';
import '../DeliveryBoyModel/VehicleNumberGetModel.dart';
import '../ItemReceipt/CylItemList/CylItemListModel.dart';

class DailyRefillSalePage extends StatefulWidget {
  static const screenName = '/stockReturnFromDelBoy';
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
  // Map<int, String?> _selectedItems = {};

  List<ItemData> data = []; // List to hold rows for the DataTable
  List<ItemData> newList = [];
  late Future<List<ItemData>> itemList;
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
  bool isLoading = true;
  List<Map<String, Object?>> _dataGetFromDBDelBoy = [];
  // Function to add a new row to the DataTable
// Dummy data
  final List<Map<String, String>> closingStock = [
    {
      'itemName': '14.2 kg',
      'filled': '10',
      'empty': '5',
      'defective': '1',
      'remark': 'Good',
    },
  ];
  // void _addNewItem() {
  //   if (_emptyController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("Add Empty Cylinder Count..!"),
  //       duration: Duration(seconds: 2),
  //     ));
  //   }else{
  //     setState(() {
  //       data.add(ItemData(
  //         itemName: _selectedItem.toString(),
  //         filled: int.tryParse(_filledController.text) ?? 0,
  //         sv: int.tryParse(_svController.text) ?? 0,
  //         tv: int.tryParse(_tvController.text) ?? 0,
  //         empty: int.tryParse(_emptyController.text) ?? 0,
  //         defective: int.tryParse(_defectiveController.text) ?? 0,
  //         lessEmpty: int.tryParse(_lessEmptyController.text) ?? 0,
  //         remark: _remarkController.text,
  //         svRemark: _svRemarkController.text,
  //       ));
  //
  //       // Clear the input fields after adding the item
  //       _itemController.clear();
  //       _filledController.clear();
  //       _svController.clear();
  //       _tvController.clear();
  //       _emptyController.clear();
  //       _defectiveController.clear();
  //       _lessEmptyController.clear();
  //       _remarkController.clear();
  //     });
  //   }
  // }
  void _addNewItem() async {
    // Validate input for the empty cylinder count
    if (_emptyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Add Empty Cylinder Count..!"),
        duration: Duration(seconds: 2),
      ));
    } else {
      setState(() {
        String remarksString = remarksList.isEmpty ? '' : remarksList.join(', ');
        print('Sending remarks to API: $remarksString');
        // Create an ItemData object from the input fields
        ItemData newItem = ItemData(
          date: deliveryDateController.text,
          deliveryBoyName: selectedDelBoyName.toString(),
          delBoyId: selectedDelBoyId.toString(),
          vehicleNo: vehicleNoController.text,
          itemName: _selectedItem.toString(),
          itemID: selectedItemId.toString(),
          filled: _filledController.text ?? '',
          sv: _svController.text ?? '',
          tv: _tvController.text ?? '',
          empty: _emptyController.text ?? '',
          defective: _defectiveController.text ?? '',
          lessEmpty: _lessEmptyController.text ?? '',
          remark: _remarkController.text,
          svRemark: remarksString,
          updateFlag: 'pending',
        );

        // Insert the ItemData object into the database
        updateRefillSale?.insertUpdateRefillSale([newItem]);
        fetchData(selectedDelBoyId.toString(),deliveryDateController.text);

        // Clear the input fields after adding the item
        _filledController.clear();
        _svController.clear();
        _tvController.clear();
        _emptyController.clear();
        _defectiveController.clear();
        _lessEmptyController.clear();
        _remarkController.clear();
        _svRemarkController.clear();
      });
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
    debugPrint("itemList"+itemList.toString());

  }
  void _showPopupDialogs(String title, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Allows rebuilding the dialog to update UI with added items
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Add $title Consumer(s)"),
              content: Column(
                mainAxisSize: MainAxisSize.min, // Allows content to adjust based on size
                children: [
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
                          keyboardType: TextInputType.number, // Set keyboard type to numeric
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),// Allow only digits
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add), // "Add More" button
                        onPressed: () {
                          String input = controller.text.trim();
                          if (input.isNotEmpty) {
                            setState(() {
                              remarksList.add(input); // Add input to the list
                              controller.clear();
                              // Clear the input field for the next entry
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Display the list of added remarks (Consumers)
                  if (remarksList.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: remarksList
                          .map((remark) => Text('- $remark'))
                          .toList(),
                    ),
                ],
              ),
              actions: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Press 'Done' to finish.",style: TextStyle(fontSize: 12),),
                    ElevatedButton(
                      onPressed: () {
                        // Finalize and close the dialog after the user finishes adding remarks
                        String remark = controller.text.trim();
                        if (remark.isNotEmpty) {
                          setState(() {
                            remarksList.add(remark); // Add last remark if not empty
                          });
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,// Button expands to fill available width// Text color of the button
                        shape: RoundedRectangleBorder( // Optional: Set rounded corners
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text("DONE",style: TextStyle(color: Colors.white),),
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
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Update Sale', // Title or hint text for the text field
      ),
      body:
      SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Date
            TextField(
              controller: deliveryDateController,
              decoration: const InputDecoration(
                labelText: 'Delivery Date',
                labelStyle: TextStyle(fontSize: 12),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
                Expanded(
                  flex: 2,
                  child:DropdownButtonFormField<DeliveryBoyInfoModel>(
                    decoration: const InputDecoration(
                      labelText: 'Select Delivery Men',
                      labelStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                    items: _delBoyInfo.map((DeliveryBoyInfoModel item) {
                      return DropdownMenuItem<DeliveryBoyInfoModel>(
                        value: item,
                        child: Text(item.staffName ?? 'Unknown',
                          style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.normal),),

                      );
                    }).toList(),
                    onChanged: (DeliveryBoyInfoModel? selectedItem) {
                      if (selectedItem != null) {
                        setState(() {
                          selectedDelBoyName = selectedItem.staffName;
                           selectedDelBoyId = selectedItem.staffId!.toInt();
                          fetchVehicleDetail(selectedDelBoyId!);
                          fetchData(selectedDelBoyId.toString(),deliveryDateController.text);
                          print('Selected Del Boy Item: ${selectedDelBoyName}, ID: ${selectedDelBoyId}');
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Add New Section
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: vehicleNoController,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle No.',
                      labelStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                    style: TextStyle(
                      fontSize: 14.0, // Adjust the text size here
                    ),
                    enabled: false,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Add New Item",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        iconSize: 35,
                        onPressed: _addNewItem,
                        // onPressed: () {
                        //   // _addNewItem,
                        //   // _showPopupDialog("New Section");
                        // },
                        icon: const Icon(Icons.add_circle_outline_sharp),
                      ),
                    ],
                  ),

                ),

              ],
            ),
            const SizedBox(height: 20),
          // Item Details
            Row(
              children: [
                // SV+ Field (DropdownButton)
                Flexible(
                  flex: 1,
                  child:
                  DropdownButtonFormField<CylItemListModel>(
                    decoration: const InputDecoration(
                      labelText: 'Select Item',
                      labelStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                    items: _items.map((CylItemListModel item) {
                      return DropdownMenuItem<CylItemListModel>(
                        value: item,
                        child: Text(item.itemName ?? 'Unknown',
                          style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.normal),),

                      );
                    }).toList(),
                    onChanged: (CylItemListModel? selectedItem) {
                      if (selectedItem != null) {
                        setState(() {
                          _selectedItem = selectedItem.itemName;
                          selectedItemId = selectedItem.itemId!.toInt();

                          print('Selected Item: ${_selectedItem}, ID: ${selectedItemId}');
                        });
                      }
                    },
                  ),
                ),

                const SizedBox(width: 40), // Spacing between SV+ and TV-

                // TV- Field (TextField)
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _filledController,
                    decoration: const InputDecoration(
                      labelText: 'Filled Sale',
                      labelStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                    style: TextStyle(
                      fontSize: 14.0, // Adjust the text size here
                    ),
                    keyboardType: TextInputType.number, // Set keyboard type to numeric
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    ],
                    onChanged: (value) {
                      setState(() {
                        // Get the current value of the filled quantity
                        int filledQty = int.tryParse(value) ?? 0;

                        // Recalculate the empty quantity based on other fields
                        int svQty = int.tryParse(_svController.text) ?? 0;
                        int tvQty = int.tryParse(_tvController.text) ?? 0;
                        int defQty = int.tryParse(_defectiveController.text) ?? 0;
                        int lessEmptyQty = int.tryParse(_lessEmptyController.text) ?? 0;

                        // Calculate the new empty quantity
                        int emptyQty = filledQty - svQty + tvQty - defQty - lessEmptyQty;

                        // Update the empty field
                        _emptyController.text = emptyQty.toString();
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
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // Align widgets in the center vertically
                    children: [
                      // TextField for SV+
                      Expanded(
                        child: TextField(
                          controller: _svController,
                          keyboardType: TextInputType.number, // Set keyboard type to numeric
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly, // Allow only digits
                          ],
                          decoration: const InputDecoration(
                            labelText: 'SV-',
                            labelStyle: TextStyle(fontSize: 12),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                          ),
                          style: TextStyle(
                            fontSize: 14.0, // Adjust the text size here
                          ),
                          onChanged: (value) {
                            setState(() {
                              // Recalculate empty quantity
                              int svQty = int.tryParse(value) ?? 0;
                              int filledQty = int.tryParse(_filledController.text) ?? 0;
                              int tvQty = int.tryParse(_tvController.text) ?? 0;
                              int defQty = int.tryParse(_defectiveController.text) ?? 0;
                              int lessEmptyQty = int.tryParse(_lessEmptyController.text) ?? 0;

                              // Calculate the new empty quantity
                              int emptyQty = filledQty - svQty + tvQty - defQty - lessEmptyQty;
                              _emptyController.text = emptyQty.toString();
                            });
                          },
                        ),
                      ),
                      // IconButton for SV+
                      IconButton(
                        iconSize: 35,
                        onPressed: () {
                          _showPopupDialogs("SV-",_svRemarkController);
                        },
                        icon: const Icon(Icons.add_circle_outline_sharp),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40), // Spacing between SV+ and TV-
                // TV- Field and Button
                Flexible(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // Align widgets in the center vertically
                    children: [
                      // TextField for TV-
                      Expanded(
                        child: TextField(
                          controller: _tvController,
                          keyboardType: TextInputType.number, // Set keyboard type to numeric
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly, // Allow only digits
                          ],
                          decoration: const InputDecoration(
                            labelText: 'TV+',
                            labelStyle: TextStyle(fontSize: 12),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                          ),
                          style: TextStyle(
                            fontSize: 14.0, // Adjust the text size here
                          ),
                          onChanged: (value) {
                            setState(() {
                              // Recalculate empty quantity
                              int tvQty = int.tryParse(value) ?? 0;
                              int filledQty = int.tryParse(_filledController.text) ?? 0;
                              int svQty = int.tryParse(_svController.text) ?? 0;
                              int defQty = int.tryParse(_defectiveController.text) ?? 0;
                              int lessEmptyQty = int.tryParse(_lessEmptyController.text) ?? 0;

                              // Calculate the new empty quantity
                              int emptyQty = filledQty - svQty + tvQty - defQty - lessEmptyQty;
                              _emptyController.text = emptyQty.toString();
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
                    crossAxisAlignment: CrossAxisAlignment.center, // Align vertically to the center
                    children: [
                      // TextField for Empty
                      Expanded(
                        child: TextField(
                          controller: _emptyController,
                          keyboardType: TextInputType.number, // Set keyboard type to numeric
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly, // Allow only digits
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Empty',
                            labelStyle: TextStyle(fontSize: 12),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                          ),
                          style: TextStyle(
                            fontSize: 14.0, // Adjust the text size here
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40), // Spacing between Empty and Def.

                // Def. Field and Button
                Flexible(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center, // Align vertically to the center
                    children: [
                      // TextField for Def.
                      Expanded(
                        child: TextField(
                          controller: _defectiveController,
                          keyboardType: TextInputType.number, // Set keyboard type to numeric
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly, // Allow only digits
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Def.-',
                            labelStyle: TextStyle(fontSize: 12),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                          ),
                          style: TextStyle(
                            fontSize: 14.0, // Adjust the text size here
                          ),
                          onChanged: (value) {
                            setState(() {
                              // Recalculate empty quantity
                              int defQty = int.tryParse(value) ?? 0;
                              int filledQty = int.tryParse(_filledController.text) ?? 0;
                              int svQty = int.tryParse(_svController.text) ?? 0;
                              int tvQty = int.tryParse(_tvController.text) ?? 0;
                              int lessEmptyQty = int.tryParse(_lessEmptyController.text) ?? 0;

                              // Calculate the new empty quantity
                              int emptyQty = filledQty - svQty + tvQty - defQty - lessEmptyQty;
                              _emptyController.text = emptyQty.toString();
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
                // Less Empty Field
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _lessEmptyController,
                    keyboardType: TextInputType.number, // Set keyboard type to numeric
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Less Empty-',
                      labelStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                    style: TextStyle(
                      fontSize: 14.0, // Adjust the text size here
                    ),
                    onChanged: (value) {
                      setState(() {
                        // Recalculate empty quantity
                        int lessEmpty = int.tryParse(value) ?? 0;
                        int filledQty = int.tryParse(_filledController.text) ?? 0;
                        int svQty = int.tryParse(_svController.text) ?? 0;
                        int tvQty = int.tryParse(_tvController.text) ?? 0;
                        int defQty = int.tryParse(_defectiveController.text) ?? 0;

                        // Calculate the new empty quantity
                        int emptyQty = filledQty - svQty + tvQty - defQty - lessEmpty;
                        _emptyController.text = emptyQty.toString();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 40), // Spacing between Less Empty and Remark
                // Remark Field
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: _remarkController,
                    decoration: const InputDecoration(
                      labelText: 'Remark',
                      labelStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                    style: TextStyle(
                      fontSize: 14.0, // Adjust the text size here
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            // Visibility
            Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Column(
                children: [
                  // Header Row with equal width for all columns using Expanded
                  Row(
                    children: [
                      Expanded(child: Center(child: Text("Item",style: TextStyle(fontWeight: FontWeight.bold),))),
                      verticalDividerVerySmall(),
                      Expanded(child: Center(child: Text("Filled",style: TextStyle(fontWeight: FontWeight.bold),))),
                      verticalDividerVerySmall(),
                      Expanded(child: Center(child: Text("SV",style: TextStyle(fontWeight: FontWeight.bold),))),
                      verticalDividerVerySmall(),
                      Expanded(child: Center(child: Text("TV",style: TextStyle(fontWeight: FontWeight.bold),))),
                      verticalDividerVerySmall(),
                      Expanded(child: Center(child: Text("Empty",style: TextStyle(fontWeight: FontWeight.bold),))),
                      verticalDividerVerySmall(),
                      Expanded(child: Center(child: Text("Def.",style: TextStyle(fontWeight: FontWeight.bold),))),
                      verticalDividerVerySmall(),
                      Expanded(child: Center(child: Text("<Empty",style: TextStyle(fontWeight: FontWeight.bold),))),
                    ],
                  ),

                  // Divider between header and data rows
                  Container(
                    color: const Color(0xff1280B3),
                    height: 1.5,
                    width: MediaQuery.of(context).size.width,
                  ),

                  // ListView to display the data
                  Container(
                    child: _dataGetFromDBDelBoy.isNotEmpty
                        ?
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _dataGetFromDBDelBoy.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, Object?> item = _dataGetFromDBDelBoy[index]; // Get the item at the current index
                        // You can access the columns in your database result like this:
                        String itemId = item['itemID'].toString();
                        String itemName = item['itemName'].toString();
                        String filledSaleQty = item['filled'].toString();
                        String svQty = item['sv'].toString();
                        String tvQty = item['tv'].toString();
                        String emptyRetQty = item['empty'].toString();
                        String deffQty = item['defective'].toString();
                        String lessEmptyQty = item['lessEmpty'].toString();
                        String remark = item['remark']?.toString() ?? "No remark";
                        return Column(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  // Column 1: Item Name
                                  Expanded(
                                      child:
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(itemName,style: TextStyle(fontSize: 14, color: Colors.black54)),
                                  )),
                                  verticalDividerVerySmall(),
                                  // Column 2: Filled
                                  Expanded(child: Text(filledSaleQty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
                                  verticalDividerVerySmall(),
                                  // Column 3: Empty
                                  Expanded(child: Text(svQty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
                                  verticalDividerVerySmall(),
                                  // Column 4: Defective
                                  Expanded(child: Text(tvQty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
                                  verticalDividerVerySmall(),
                                  Expanded(child: Text(emptyRetQty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
                                  verticalDividerVerySmall(),
                                  Expanded(child: Text(deffQty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
                                  verticalDividerVerySmall(),
                                  Expanded(child: Text(lessEmptyQty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.grey,
                              height: 1,
                            ),
                          ],
                        );
                      },
                    )
                        : Container(
                      padding: EdgeInsets.all(5),
                      child: const Center(child: Text("No pending data..!")),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Closing Stock
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("Closing Stock",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            ),
        Container(
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Column(
            children: [
              // Header Row with equal width for all columns using Expanded
              Row(
                children: [
                  Expanded(child: Center(child: Text("Item",style: TextStyle(fontWeight: FontWeight.bold),))),
                  verticalDividerVerySmall(),
                  Expanded(child: Center(child: Text("Filled",style: TextStyle(fontWeight: FontWeight.bold),))),
                  verticalDividerVerySmall(),
                  Expanded(child: Center(child: Text("Empty",style: TextStyle(fontWeight: FontWeight.bold),))),
                  verticalDividerVerySmall(),
                  Expanded(child: Center(child: Text("Defective",style: TextStyle(fontWeight: FontWeight.bold),))),
                ],
              ),

              // Divider between header and data rows
              Container(
                color: const Color(0xff1280B3),
                height: 1.5,
                width: MediaQuery.of(context).size.width,
              ),

              // ListView to display the data
              Container(
                child: closingStock.isNotEmpty
                    ?
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: closingStock.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var item = closingStock[index];
                    String itemName = item['itemName']!;
                    String filled = item['filled']!;
                    String empty = item['empty']!;
                    String defective = item['defective']!;
                    return Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              // Column 1: Item Name
                              Expanded(child:
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(itemName,style: TextStyle(fontSize: 14, color: Colors.black54)),
                              )),
                              verticalDividerVerySmall(),
                              // Column 2: Filled
                              Expanded(child: Text(filled, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
                              verticalDividerVerySmall(),
                              // Column 3: Empty
                              Expanded(child: Text(empty, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
                              verticalDividerVerySmall(),
                              // Column 4: Defective
                              Expanded(child: Text(defective, style: TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center)),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.grey,
                          height: 1,
                        ),
                      ],
                    );
                  },
                )
                    : Container(
                  padding: EdgeInsets.all(5),
                  child: const Center(child: Text("No Data Available..!")),
                ),
              ),
            ],
          ),
        ),
            const SizedBox(height: 20),
            // Submit Button
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10), // Add 10px margin on left and right
                child: ElevatedButton(
                  onPressed:(){
                    if((_filledController.text == null || _filledController.text.isEmpty) &&
                        (_svController.text == null || _svController.text.isEmpty)&&
                        (_tvController.text == null || _tvController.text.isEmpty)&&
                        (_emptyController.text == null || _emptyController.text.isEmpty || _emptyController.text == "0")&&
                        (_defectiveController.text == null || _defectiveController.text.isEmpty)&&
                        (_lessEmptyController.text == null || _lessEmptyController.text.isEmpty)&&
                        (_remarkController.text == null || _remarkController.text.isEmpty)) {
                      if(selectedDelBoyName != null && selectedDelBoyName!.isNotEmpty) {
                        sendDataToApi(selectedDelBoyId.toString()!,
                            deliveryDateController.text);
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Select delivery boy whose data want to submit..!')),
                        );
                      }
                    }else{
                      showAlertDialog(context);
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white), // Set text color directly if needed
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.blue,// Button expands to fill available width// Text color of the button
                    shape: RoundedRectangleBorder( // Optional: Set rounded corners
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fetch data from API Item
  Future<void> fetchItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/0/C'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetItemMasterList"+'${AppUrl.GetItemMasterList}/$distributorId/0/C');
    debugPrint("GetItemMasterList"+response.body);
    if (response.statusCode == 200) {
      // Parse the response
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
      });
    } else {
      // refreshTokens();
      throw Exception('Failed to load items');
    }
  }

  // Fetch data from API Del boy
  Future<void> fetchDeliveryBoyInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetStaffDetailsList}/$distributorId/1/2'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("_delBoyInfo"+'${AppUrl.GetStaffDetailsList}/$distributorId/1/2');
    debugPrint("_delBoyInfo"+response.body);
    if (response.statusCode == 200) {
      // Parse the response
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _delBoyInfo = data.map((json) => DeliveryBoyInfoModel.fromJson(json)).toList();
      });
    } else {
      // refreshTokens();
      throw Exception('Failed to load items');
    }
  }
//vehicle info
  Future<void> fetchVehicleDetail(int staffId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetVehicleDetailsByStaffId}/$distributorId/$staffId'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );

    debugPrint("GetVehicleDetailsByStaffId" + '${AppUrl.GetVehicleDetailsByStaffId}/$distributorId/$staffId');
    debugPrint("Response body: " + response.body);

    if (response.statusCode == 200) {
      // Parse the response body and map it to VehicleNumberGetModel
      List<dynamic> responseData = json.decode(response.body);
      List<VehicleNumberGetModel> data = responseData.map((item) => VehicleNumberGetModel.fromJson(item)).toList();

      // Assuming we want to set the vehicle number from the first vehicle in the list
      if (data.isNotEmpty) {
        setState(() {
          vehicleNoController.text = data[0].vehicleNo ?? '';
          vehicleNo = data[0].vehicleNo ?? '';
          vehicleId = data[0].vehicleId ?? 0;// Set the vehicle number (if available)
        });
      }
    } else {
      // Optionally handle token refresh here or show an error
      throw Exception('Failed to load items');
    }
  }

  Future<Map<String, dynamic>> getFormattedDataForApi(String deliveryBoyId,String delDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    // Fetch the filtered data from the database

    var getUpdateRefillSale = await updateRefillSale?.getUpdateRefillSaleData2(deliveryBoyId.toString(),delDate.toString());
    List<ItemData> itemList = [];

    debugPrint("areaWiseEKYCDetailResult"+getUpdateRefillSale.toString());
    // Convert each item into ItemData object
    for (var item in getUpdateRefillSale!) {
      itemList.add(ItemData.fromJson(item));
    }

    // Format the data into the structure needed for the API
    List<Map<String, dynamic>> apiItemList = itemList.map((item) {
      return {
        "ItemId": item.itemID.toString(),  // Assuming itemID is the column for Item ID
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
        "SVConsStr": item.svRemark ?? "" // Assuming svRemark is a list of remarks
      };
    }).toList();
    debugPrint("apiItemList"+apiItemList.toString());
    // Format the entire data structure for the API
    return {
      "SaleGKId": "0", // Assuming this is always 0 for the new sale
      "DistributorId": distributorId,
      "DeliveryDate": deliveryDateController.text.toString(),
      "DMId": deliveryBoyId.toString(),
      "VehicleId":vehicleId,  // Use your actual vehicle ID if needed
      "AddedBy": "4",  // Use the actual user ID
      "Action": "ADD", // Assuming you're adding new data
      "ItemList": apiItemList
    };

  }

  // void sendToApi(String deliveryBoyId) async {
  //   try {
  //     Map<String, dynamic> apiData = await getFormattedDataForApi(deliveryBoyId.toString());
  //     List<int> itemIds = apiData["ItemList"].map<int>((item) => item["ItemId"]).toList();
  //     print('apiData $apiData');
  //     print('itemIds $itemIds');
  //     // Send the data to your API (use your preferred HTTP package, e.g., Dio, HTTP)
  //     var response = await sendPostRequestToApi(apiData,itemIds);
  //     print('Data sent successfully $response');
  //     if (response.statusCode == 200) {
  //       print('Data sent successfully');
  //       await UpdateRefillSale().updateRefillSaleFlagToComplete(itemIds,deliveryBoyId);
  //     } else {
  //       print('Failed to send data');
  //     }
  //   } catch (e) {
  //     print('Error sending data to API: $e');
  //   }
  // }
  //
  // Future<dynamic> sendPostRequestToApi(Map<String, dynamic> data, List<int> itemIds) async {
  //   // Example using the HTTP package
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? bearerToken = prefs.getString('token');
  //   String jsonRequestBody = jsonEncode(data);
  //   debugPrint(jsonRequestBody);
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${AppUrl.GetVehicleDetailsByStaffId}'), // Your actual API URL
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $bearerToken',  // Adding Authorization header with Bearer token
  //       },
  //       body: jsonRequestBody, // The body of the request
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // After successfully sending the data, update the flag to 'complete'
  //
  //       return response;
  //     } else {
  //       // Handle failure if needed (e.g., log the response status or show an error message)
  //       debugPrint('API request failed. Status code: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     debugPrint('Error in sending request: $e');
  //     return null;
  //   }
  // }

  Future<void> sendDataToApi(String deliveryBoyId ,String delDate) async {
    try {
      // Get shared preferences for distributorId and bearerToken
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      String? godownKeeperID = prefs.getString('godownKeeperId');
      String? addedBy = prefs.getString('StaffId');

      if (distributorId == null || bearerToken == null) {
        print('DistributorId or BearerToken is missing');
        return;
      }

      // Fetch the data for the deliveryBoyId
      var getUpdateRefillSale = await updateRefillSale?.getUpdateRefillSaleData2(deliveryBoyId.toString(),delDate.toString());

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
          "ItemId": item.itemID.toString(),  // Ensure ItemId is a string for the API request
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
          "SVConsStr": item.svRemark ?? "",
        };
      }).toList();

      // Prepare the entire data structure for the API
      Map<String, dynamic> apiData = {
        "SaleGKId": "0", // Assuming this is always 0 for the new sale
        "DistributorId": distributorId,
        "DeliveryDate": deliveryDateController.text.toString(),
        "DMId": deliveryBoyId.toString(),
        "VehicleId":vehicleId,  // Use your actual vehicle ID if needed
        "AddedBy":addedBy,  // Use the actual user ID
        "Action": "ADD", // Assuming you're adding new data
        "ItemList": apiItemList,
      };

      // Convert data to JSON and send it to the API
      String jsonRequestBody = jsonEncode(apiData);
      debugPrint("jsonRequestBody$jsonRequestBody");
      if(apiItemList != null && apiItemList.isNotEmpty) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data sent successfully..!')),
          );
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
              itemIds, deliveryBoyId,delDate);
          fetchData(selectedDelBoyId.toString(),deliveryDateController.text);
        } else {
          print('Failed to send data: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send data..!')),
          );
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter record for that delivery boy..!')),
        );
      }
    } catch (e) {
      print('Error sending data to API: $e');
    }
  }

  Future<void> fetchData(String deliveryBoyId ,String delDate) async {
    try {
      // Fetch data for the given deliveryBoyId
      List<Map<String, Object?>>? fetchedData = await updateRefillSale?.getUpdateRefillSaleData2(deliveryBoyId,delDate.toString());

      if (fetchedData != null && fetchedData.isNotEmpty) {
        setState(() {
          _dataGetFromDBDelBoy = fetchedData;
          print('_dataGetFromDBDelBoy: $_dataGetFromDBDelBoy');// Store the fetched data in _data
        });
      } else {
        // Handle the case when no data is returned
        setState(() {
          _dataGetFromDBDelBoy = [];
          print('_dataGetFromDBDelBoy: $_dataGetFromDBDelBoy');// Store the fetched data in _data
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
      content: Text("Some data in your text box that you not added for submit plese add that data before submit"),
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
}
