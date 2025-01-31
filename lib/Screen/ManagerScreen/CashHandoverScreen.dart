import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
import '../Utils/CustomAppBar.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import 'package:http/http.dart' as http;
class CashHandoverScreen extends StatefulWidget {
  static const screenName = '/cashHandoverScreen';
  const CashHandoverScreen({super.key});

  @override
  State<CashHandoverScreen> createState() => _CashHandoverScreenState();
}

class _CashHandoverScreenState extends State<CashHandoverScreen> {
  List<CylItemListModel> _items = [];
  Map<int, String?> _selectedItems = {};
  String? _selectedItemId; // To track the selected item's ID
  String? _selectedItemName;
  bool isCashDenominationListViewVisible = false;
  final TextEditingController quantity500Controller = TextEditingController();
  final TextEditingController quantity200Controller = TextEditingController();
  final TextEditingController quantity100Controller = TextEditingController();
  final TextEditingController quantity50Controller = TextEditingController();
  final TextEditingController quantity20Controller = TextEditingController();
  final TextEditingController quantity10Controller = TextEditingController();
  final TextEditingController quantity5Controller = TextEditingController();
  double result500 = 0.0;
  double result200 = 0.0;
  double result100 = 0.0;
  double result50 = 0.0;
  double result20 = 0.0;
  double result10 = 0.0;
  double result5 = 0.0;
  double total = 0.0;
  @override
  void initState() {
    super.initState();
    // Add the first item by default
    // Get today's date

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    fetchItems();
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
        default:
          break;
      }

      // Calculate the total of all results, treating null or 0.0 as 0
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0);

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
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0);
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
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0);

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
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0);

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
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0);

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
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0);

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
      total = (result500 ?? 0.0) + (result200 ?? 0.0) + (result100 ?? 0.0) +
          (result50 ?? 0.0) + (result20 ?? 0.0) + (result10 ?? 0.0) + (result5 ?? 0.0);

    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> cylinderData = [
      {
        'Date': '22/2/2024',
        'StaffName': 'Pradip gfjfhjh',
        'Cash': '10',
      },
      {
        'Date': '22/2/2024',
        'StaffName': 'Sanjay hnfhn',
        'Cash': '20',
      },
      {
        'Date': '22/2/2024',
        'StaffName': 'Rupesh hgdjgh',
        'Cash': '5',
      },
    ];

    return Scaffold(
      appBar:CustomAppBar(
        title: 'Cash Handover Screen', // Title or hint text for the text field
      ),
      body:
      Padding(
        padding: const EdgeInsets.only(left: 5.0,right: 5,top: 15,bottom: 15),
        child: SingleChildScrollView(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Data Table for Staff and Cash Details
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          verticalDividerSmall(),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Staff Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          verticalDividerSmall(),
                          Expanded(
                            child: Text(
                              'Cash',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cylinderData.length,
                      itemBuilder: (context, index) {
                        final entry = cylinderData[index];
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    entry['Date'] ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                verticalDividerVerySmall(),
                                Expanded(
                                  flex:2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      entry['StaffName'] ?? '',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                verticalDividerVerySmall(),
                                Expanded(
                                  child: Text(
                                    entry['Cash'] ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.black12,
                              height: 1,
                              width: double.infinity,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Total Amount Field
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Total Amount:',style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Cash Handover Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cash handover to:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                  SizedBox(
                    width: 200, // Set the desired width
                    height: 60,  // Set the desired height
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Item',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Adjust content padding as needed
                      ),
                      items: _items.map((CylItemListModel item) {
                        return DropdownMenuItem<String>(
                          value: item.itemId.toString(), // Use item ID as the value
                          child: Text(item.itemName ?? 'Unknown'),
                        );
                      }).toList(),
                      onChanged: (selectedId) {
                        setState(() {
                          // Find the selected item based on the ID
                          final selectedItem = _items.firstWhere((item) => item.itemId == selectedId);

                          // Store selected item's ID and name
                          _selectedItemId = selectedId!;
                          _selectedItemName = selectedItem.itemName ?? 'Unknown';

                          debugPrint('Selected ID: $_selectedItemId');
                          debugPrint('Selected Name: $_selectedItemName');
                        });
                      },
                      value: _selectedItemId, // Set the selected value based on ID
                    ),
                  )

                ],
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
                                                  total.toStringAsFixed(0),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                ),
              ),
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
      Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/0/C'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("item" + '${AppUrl.GetItemMasterList}/$distributorId/0/C');
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
}

