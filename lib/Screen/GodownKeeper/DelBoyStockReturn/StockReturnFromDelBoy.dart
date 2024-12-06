import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Utils/CustomAppBar.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
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
  // Map<int, String?> _selectedItems = {};

  List<ItemData> data = []; // List to hold rows for the DataTable

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
  final TextEditingController _defectiveRemarkController = TextEditingController();
  String? _selectedItem;
  bool isVisible = true;
  List<String> remarksList = [];
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
    {
      'itemName': '19 kg',
      'filled': '20',
      'empty': '10',
      'defective': '2',
      'remark': 'Average',
    },
    {
      'itemName': '5 kg',
      'filled': '30',
      'empty': '15',
      'defective': '3',
      'remark': 'Excellent',
    },
  ];
  void _addNewItem() {
    if (_emptyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Add Empty Cylinder Count..!"),
        duration: Duration(seconds: 2),
      ));
    }else{
      setState(() {
        data.add(ItemData(
          itemName: _selectedItem.toString(),
          filled: int.tryParse(_filledController.text) ?? 0,
          sv: int.tryParse(_svController.text) ?? 0,
          tv: int.tryParse(_tvController.text) ?? 0,
          empty: int.tryParse(_emptyController.text) ?? 0,
          defective: int.tryParse(_defectiveController.text) ?? 0,
          lessEmpty: int.tryParse(_lessEmptyController.text) ?? 0,
          remark: _remarkController.text,
          svRemark: _svRemarkController.text,
          tvRemark: _tvRemarkController.text,
          defectiveRemark: _defectiveRemarkController.text,
        ));

        // Clear the input fields after adding the item
        _itemController.clear();
        _filledController.clear();
        _svController.clear();
        _tvController.clear();
        _emptyController.clear();
        _defectiveController.clear();
        _lessEmptyController.clear();
        _remarkController.clear();
      });
    }
  }

  void _submitData() {
    List<ItemData> finalData = [];

    if (data.isEmpty) {
      // If the DataTable (data) is empty, use the values from controllers to create one item
      finalData.add(
        ItemData(
          itemName: _selectedItem ?? 'Unknown', // Use selected item or 'Unknown'
          filled: int.tryParse(_filledController.text) ?? 0,
          sv: int.tryParse(_svController.text) ?? 0,
          tv: int.tryParse(_tvController.text) ?? 0,
          empty: int.tryParse(_emptyController.text) ?? 0,
          defective: int.tryParse(_defectiveController.text) ?? 0,
          lessEmpty: int.tryParse(_lessEmptyController.text) ?? 0,
          remark: _remarkController.text,
          svRemark: _svRemarkController.text,
          tvRemark: _tvRemarkController.text,
          defectiveRemark: _defectiveRemarkController.text,
        ),
      );
    } else {
      // If the DataTable has data, include those as well
      finalData.addAll(data); // Add all rows from the DataTable

      // Optionally, you can add a new row from the controllers if values are present
      if (_filledController.text.isNotEmpty ||
          _svController.text.isNotEmpty ||
          _tvController.text.isNotEmpty ||
          _emptyController.text.isNotEmpty ||
          _defectiveController.text.isNotEmpty ||
          _lessEmptyController.text.isNotEmpty ||
          _remarkController.text.isNotEmpty) {
        finalData.add(
          ItemData(
            itemName: _selectedItem ?? 'Unknown', // Use selected item or 'Unknown'
            filled: int.tryParse(_filledController.text) ?? 0,
            sv: int.tryParse(_svController.text) ?? 0,
            tv: int.tryParse(_tvController.text) ?? 0,
            empty: int.tryParse(_emptyController.text) ?? 0,
            defective: int.tryParse(_defectiveController.text) ?? 0,
            lessEmpty: int.tryParse(_lessEmptyController.text) ?? 0,
            remark: _remarkController.text,
            svRemark: _svRemarkController.text,
            tvRemark: _tvRemarkController.text,
            defectiveRemark: _defectiveRemarkController.text,
          ),
        );
      }
    }

    // Print the parameters and their values to debug
    print("Submitting data: $finalData");
    for (var item in finalData) {
      print("Item Name: ${item.itemName}");
      print("Filled: ${item.filled}");
      print("SV+: ${item.sv}");
      print("TV-: ${item.tv}");
      print("Empty: ${item.empty}");
      print("Defective: ${item.defective}");
      print("Less Empty: ${item.lessEmpty}");
      print("Remark: ${item.remark}");
      print("svRemark: ${item.svRemark}");
      print("tvRemark: ${item.tvRemark}");
      print("defectiveRemark: ${item.defectiveRemark}");
    }

    // Here you would send the finalData to your API, for example:
    // ApiService.submitData(finalData);
  }
  void sendRemarksToApi() {
    // API call logic here, passing remarksList
    print('Sending remarks to API: $remarksList');
    // Example: api.submitRemarks(remarksList);
  }
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    deliveryDateController.text = formattedDate;
    fetchItems();
  }

  void _showPopupDialog(String title,TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add $title Remark"),
          content:
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter remark",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle addition logic here
                Navigator.pop(context);
              },
              child: const Text("ADD"),
            ),
          ],
        );
      },
    );
  }
  void _showPopupDialogs(String title, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add $title Remark(s)"),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Allows content to adjust based on size
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Enter remark",
                ),
                maxLines: 1, // Allow multiple lines for entering remarks
              ),
              const SizedBox(height: 10),
              Text("Press 'Add' to add another remark or 'Done' to finish."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog on cancel
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Save the remark to the list if it is not empty
                String remark = controller.text.trim();
                if (remark.isNotEmpty) {
                  setState(() {
                    remarksList.add(remark);
                    print('Added Remark: $remark');
                  });
                }

                controller.clear(); // Clear the text field for the next remark
              },
              child: const Text("ADD"),
            ),
            ElevatedButton(
              onPressed: () {
                // Finalize and close the dialog after the user finishes adding remarks
                Navigator.pop(context);
              },
              child: const Text("DONE"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Update Sale', // Title or hint text for the text field
      ),
      body:
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Del. Boy',
                      labelStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                    items: ['Ajay fdshhggjfhk gdjdgfjfgj', 'Sahil', 'Vikas']
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e,style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),),
                    ))
                        .toList(),
                    onChanged: (value) {},
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
                        onPressed: _addNewItem,
                        // onPressed: () {
                        //   _addNewItem,
                        //   _showPopupDialog("New Section");
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
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Item',
                      labelStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    ),
                    items: _items.map((CylItemListModel item) {
                      return DropdownMenuItem<String>(
                        value: item.itemName,
                        child: Text(item.itemName ?? 'Unknown',style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.normal),),

                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value;
                        print('Selected Item: $_selectedItem');
                      });
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
                    // onChanged: (value) {
                    //   setState(() {
                    //     // Get the current value of the empty quantity
                    //     int currentEmptyQty = int.tryParse(_emptyController.text) ?? 0;
                    //
                    //     // If the filled quantity field is not empty, update the empty quantity
                    //     if (value.isNotEmpty) {
                    //       // Update empty quantity to match the filled quantity by default
                    //       _emptyController.text = value;
                    //     } else {
                    //       // If the filled quantity is empty, reset the empty quantity to 0 or default
                    //       _emptyController.text = "0"; // or keep the previous value as needed
                    //     }
                    //
                    //     // Optional: Handle specific logic if you want to subtract from the empty quantity
                    //     // when the filled quantity is reduced by removing digits
                    //   });
                    // },
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
                      // IconButton for TV-
                      IconButton(
                        onPressed: () {
                          _showPopupDialogs("TV+",_tvRemarkController);
                        },
                        icon: const Icon(Icons.add_circle_outline_sharp),
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
                      // IconButton for Def.
                      IconButton(
                        onPressed: () {
                          _showPopupDialogs("Defective",_defectiveRemarkController);
                        },
                        icon: const Icon(Icons.add_circle_outline_sharp),
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
            Visibility(
              visible: data != null && data.isNotEmpty,
              child: _selectedItem != null && _selectedItem!.isNotEmpty?
              Container(
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child:
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 50.0, // Set width for the text
                          child: Center(child: Text("Item")),
                        ),
                        Container(
                          width: 1.0, // Width of the vertical line
                          height: 50.0, // Height of the vertical line
                          color: Colors.black, // Color of the line
                        ),
                        SizedBox(
                          width: 50.0, // Set width for the text
                          child: Center(child: Text("Filled")),
                        ),
                        Container(
                          width: 1.0, // Width of the vertical line
                          height: 50.0, // Height of the vertical line
                          color: Colors.black, // Color of the line
                        ),
                        SizedBox(
                          width: 40.0, // Set width for the text
                          child: Center(child: Text("SV-")),
                        ),
                        Container(
                          width: 1.0, // Width of the vertical line
                          height: 50.0, // Height of the vertical line
                          color: Colors.black, // Color of the line
                        ),
                        SizedBox(
                          width: 40.0, // Set width for the text
                          child: Center(child: Text("TV+")),
                        ),
                        Container(
                          width: 1.0, // Width of the vertical line
                          height: 50.0, // Height of the vertical line
                          color: Colors.black, // Color of the line
                        ),
                        SizedBox(
                          width: 40.0, // Set width for the text
                          child: Center(child: Text("Def.")),
                        ),
                        Container(
                          width: 1.0, // Width of the vertical line
                          height: 50.0, // Height of the vertical line
                          color: Colors.black, // Color of the line
                        ),
                        SizedBox(
                          width: 70.0, // Set width for the text
                          child: Center(child: Text("<Empty")),
                        ),
                        Container(
                          width: 1.0, // Width of the vertical line
                          height: 50.0, // Height of the vertical line
                          color: Colors.black, // Color of the line
                        ),
                        SizedBox(
                          width: 70.0, // Set width for the text
                          child: Center(child: Text("Remark")),
                        ),
                      ],
                    ),
                    Container(
                      color: const Color(0xff1280B3),
                      height: 1.5,
                      width:
                      MediaQuery.of(context).size.width,
                    ),
                    Container(
                        child: _selectedItem != null && _selectedItem!.isNotEmpty?
                        data != null && data.isNotEmpty
                            ? ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                            data
                                .length,
                            shrinkWrap: true,
                            itemBuilder:
                                (BuildContext context,
                                int index) {
                              String? itemName =
                                  data[index]
                                      .itemName;
                              String? filled =
                              data[index].filled.toString();
                              String? sv =
                              data[index].sv.toString();
                              String? tv =
                              data[index].tv.toString();
                              String? defective =
                              data[index].defective.toString();
                              String? empty =
                              data[index].empty.toString();
                              String? remark =
                              data[index].remark.toString();
                              debugPrint(
                                  '### strDelBoyName ' +
                                      itemName! +
                                      " " +
                                      filled +
                                      " " +
                                      sv);
                              // sawiseConsumerCount!.sort((a, b) => a.distributorName!.compareTo(b.distributorName!));
                              return Column(
                                children: [
                                  Container(
                                    child:
                                    Row(
                                      children: [
                                              SizedBox(
                                                width: 50.0,
                                                child: Text(
                                                  '$itemName',
                                                  textAlign:
                                                  TextAlign.left,
                                                  style:
                                                  const TextStyle(
                                                    fontSize:
                                                    14,
                                                    color:
                                                    Colors.black54,
                                                    // Optionally, set the underline color
                                                    decorationStyle:
                                                    TextDecorationStyle.solid,
                                                  ),
                                                ),
                                              ),
                                        verticalDividerSmall(),

                                          SizedBox(width: 50.0,
                                            child: Text(
                                              filled,
                                              style: const TextStyle(
                                                  fontSize:
                                                  14,
                                                  color: Colors
                                                      .black54),
                                              textAlign:
                                              TextAlign
                                                  .center,
                                            ),
                                          ),

                                        verticalDividerSmall(),
                                       SizedBox(width: 40.0,
                                         child: Text(
                                           sv,
                                              style: const TextStyle(
                                                  fontSize:
                                                  14,
                                                  color: Colors
                                                      .black54),
                                              textAlign:
                                              TextAlign
                                                  .center,
                                            ),
                                       ),
                                        verticalDividerSmall(),
                                        SizedBox(width: 40.0,
                                          child: Text(
                                            tv,
                                            style: const TextStyle(
                                                fontSize:
                                                14,
                                                color: Colors
                                                    .black54),
                                            textAlign:
                                            TextAlign
                                                .center,
                                          ),
                                        ),
                                        verticalDividerSmall(),
                                        SizedBox(width: 40.0,
                                          child: Text(
                                            defective,
                                            style: const TextStyle(
                                                fontSize:
                                                14,
                                                color: Colors
                                                    .black54),
                                            textAlign:
                                            TextAlign
                                                .center,
                                          ),
                                        ),
                                        verticalDividerSmall(),
                                        SizedBox(width: 70.0,
                                          child: Text(
                                            empty,
                                            style: const TextStyle(
                                                fontSize:
                                                14,
                                                color: Colors
                                                    .black54),
                                            textAlign:
                                            TextAlign
                                                .center,
                                          ),
                                        ),
                                        verticalDividerSmall(),
                                        SizedBox(width: 70.0,
                                          child: Text(
                                            remark,
                                            style: const TextStyle(
                                                fontSize:
                                                14,
                                                color: Colors
                                                    .black54),
                                            textAlign:
                                            TextAlign
                                                .center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey,
                                    height: 1,
                                  ),
                                ],
                              );
                            })
                            : Container(
                          padding: EdgeInsets.all(5),
                          child: const Center(
                              child: Text(
                                  "No Data Available..!")),
                        ):
                        Container(),
                    ),

                  ],
                ),

              ):
                  Container(),
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
                    ? ListView.builder(
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
                  // onPressed: _submitData,sendRemarksToApi(),
                  onPressed: sendRemarksToApi,
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

  // Fetch data from API
  Future<void> fetchItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('refNo');
    String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    final response = await http.get(
      Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("item"+'${AppUrl.GetItemMasterList}/$distributorId/1');
    debugPrint("item"+response.body);
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

}
class ItemData {
  final String itemName;
  final int filled;
  final int sv;
  final int tv;
  final int empty;
  final int defective;
  final int lessEmpty;
  final String remark;
  final String svRemark;
  final String tvRemark;
  final String defectiveRemark;

  ItemData({
    required this.itemName,
    required this.filled,
    required this.sv,
    required this.tv,
    required this.empty,
    required this.defective,
    required this.lessEmpty,
    required this.remark,
    required this.svRemark,
    required this.tvRemark,
    required this.defectiveRemark
  });
}
