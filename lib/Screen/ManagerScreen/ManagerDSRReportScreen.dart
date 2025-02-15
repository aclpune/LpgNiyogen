import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';

import '../Utils/CustomAppBar.dart';
import '../Utils/Widget.dart';
class ManagerDSRReportScreen extends StatefulWidget {
  static const screenName = '/managerDSRReportScreen';
  const ManagerDSRReportScreen({super.key});

  @override
  State<ManagerDSRReportScreen> createState() => _ManagerDSRReportScreenState();
}

class _ManagerDSRReportScreenState extends State<ManagerDSRReportScreen> {
  int _selectedTabIndex = 0;
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //which date will display when user open the picker
        firstDate: DateTime(2002),
        //what will be the previous supported year in picker
        lastDate: DateTime
            .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        selectedDate = pickedDate;
      });
    });
  }

  final periodsSlots = 15;

  final double containerHeight = 5.0;

  final double containerWidth = 8;

  final days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  final subjects = [
    "Maths",
    "Hindi",
    "English",
    "Chemistry",
    "History",
    "Geography",
  ];

  late ScrollController mainController;

  late ScrollController secondController;

  @override
  void initState() {
    super.initState();
    secondController = ScrollController();

    mainController = ScrollController()
      ..addListener(() {
        if (mainController.hasClients && secondController.hasClients) {
          secondController.jumpTo(mainController.offset);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Daily Sale Report', // Title or hint text for the text field
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(0.0),
        child:
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[50], // Light blue background color
              ),
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Container(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             // First Column (Refill and TV)
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Row(
                    //                   children: [
                    //                     SizedBox(
                    //                         width: 60,
                    //                         child: Text('Refill:',
                    //                             style:
                    //                             Styling.itemGreyTextSmall)),
                    //                     Text("9",
                    //                         style: Styling.itemBlackTestSmall),
                    //                   ],
                    //                 ),
                    //                 const SizedBox(
                    //                   height: 5,
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     SizedBox(
                    //                         width: 60,
                    //                         child: Text('TV:',
                    //                             style:
                    //                             Styling.itemGreyTextSmall)),
                    //                     Text("9",
                    //                         style: Styling.itemBlackTestSmall),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //             // Second Column (SV and Amount)
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Row(
                    //                   children: [
                    //                     SizedBox(
                    //                         width: 70,
                    //                         child: Text('SV:',
                    //                             style:
                    //                             Styling.itemGreyTextSmall)),
                    //                     Text("9",
                    //                         style: Styling.itemBlackTestSmall),
                    //                   ],
                    //                 ),
                    //                 SizedBox(
                    //                   height: 5,
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     SizedBox(
                    //                         width: 70,
                    //                         child: Text('Amount:',
                    //                             style:
                    //                             Styling.itemGreyTextSmall)),
                    //                     Text("9",
                    //                         style: Styling.itemBlackTestSmall),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${selectedDate.toLocal()}".split(' ')[0],
                                      // Display date as "yyyy-MM-dd"
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.calendar_today),
                                      // Icon for the calendar
                                      onPressed: () => _selectDate(context),
                                      iconSize: 24,
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle submit logic here
                                    print("Date Submitted: ${selectedDate
                                        .toLocal()}");
                                  },
                                  child: Text('Show DSR',
                                    style: TextStyle(color: Colors.white),),
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xff1280b3)),
                                  ),
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
                        _buildTabText('Income', 0),
                        _buildTabText('Expense', 1),
                        _buildTabText('CDCMS Stock', 2),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Expanded(
              child: IndexedStack(
                index: _selectedTabIndex,
                children: [
                  _buildIncomeTab(),
                  _buildExpenseTab(),
                  _buildCDCMSStockTab(),
                ],
              ),
            ),

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
                fontSize: 14),
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

  Widget _buildIncomeTab() {
    return SingleChildScrollView(
      child:
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
        child:
        Container(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child:
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(alignment: Alignment.centerLeft,
                          child: Text("Sale", style: Styling.bodyTitleBig)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                        // Add a color to differentiate header row
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Item',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Qty',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Unsettled',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Settled',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Amt',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: 5, // Change this to the length of your data
                      itemBuilder: (context, index) {
                        // You can replace this with data from your source (e.g., getCurrentStockDetailManager[index])
                        String item = "14.2 Kg";
                        String qty = "5";
                        String amt = "25000";

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  item,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  qty,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  qty,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  qty,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "-",
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  amt,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Cash -',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '250000',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Bank -',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '250000',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(alignment: Alignment.centerLeft,
                          child: Text("ARB Sale", style: Styling.bodyTitleBig)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                      // Add a color to differentiate header row
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Item',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Qty',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Amt',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: 5, // Change this to the length of your data
                      itemBuilder: (context, index) {
                        // You can replace this with data from your source (e.g., getCurrentStockDetailManager[index])
                        String item = "1.5m Suraksha Hose";
                        String qty = "5";
                        String amt = "25000";

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  item,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  qty,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  amt,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Cash -',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '250000',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(alignment: Alignment.centerLeft,
                          child: Text("SV", style: Styling.bodyTitleBig,)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                         // Add a color to differentiate header row
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Category',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Qty',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Amt',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: 5, // Change this to the length of your data
                      itemBuilder: (context, index) {
                        // You can replace this with data from your source (e.g., getCurrentStockDetailManager[index])
                        String item = "Deposit";
                        String qty = "5";
                        String amt = "25000";

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  item,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  qty,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  amt,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Cash -',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '250000',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ),

      ),
    );
  }

  Widget _buildExpenseTab() {
    return
      SingleChildScrollView(
      child:
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
        child:
        Container(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(alignment: Alignment.centerLeft,
                          child: Text("HR Expense", style: Styling.bodyTitleBig)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                       // Add a color to differentiate header row
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Expense Head',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Amt',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: 5, // Change this to the length of your data
                      itemBuilder: (context, index) {
                        // You can replace this with data from your source (e.g., getCurrentStockDetailManager[index])
                        String item = "Miscellaneous";
                        String amt = "25000";

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  item,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  amt,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Cash -',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '250000',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(alignment: Alignment.centerLeft,
                          child: Text("Office Expense", style: Styling.bodyTitleBig)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                        // Add a color to differentiate header row
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Expense Head',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Amt',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: 5, // Change this to the length of your data
                      itemBuilder: (context, index) {
                        // You can replace this with data from your source (e.g., getCurrentStockDetailManager[index])
                        String item = "Miscellaneous";
                        String amt = "25000";

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  item,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  amt,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Cash -',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '250000',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(alignment: Alignment.centerLeft,
                          child: Text("Operational Expense", style: Styling.bodyTitleBig)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                        // Add a color to differentiate header row
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Expense Head',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Amt',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: 5, // Change this to the length of your data
                      itemBuilder: (context, index) {
                        // You can replace this with data from your source (e.g., getCurrentStockDetailManager[index])
                        String item = "Miscellaneous";
                        String amt = "25000";

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  item,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  amt,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Cash -',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '250000',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(alignment: Alignment.centerLeft,
                          child: Text("Other Expense", style: Styling.bodyTitleBig)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                        // Add a color to differentiate header row
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Expense Head',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Amt',
                                style: Styling.itemBlackTestBold,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: 5, // Change this to the length of your data
                      itemBuilder: (context, index) {
                        // You can replace this with data from your source (e.g., getCurrentStockDetailManager[index])
                        String item = "Miscellaneous";
                        String amt = "25000";

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  item,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  amt,
                                  style: Styling.itemBlackTestSmall,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Cash -',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '250000',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ),

      ),
    );
  }

  Widget _buildCDCMSStockTab() {
    return
      SingleChildScrollView(
        child:
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child:
          Container(
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Align(alignment: Alignment.centerLeft,
                                child: Text("Stock Updated On : ", style: Styling.bodyTitleBig)),
                            Text("13-02-2024", style: Styling.bodyTitleBig)
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: 5, // Change this to the length of your data
                        itemBuilder: (context, index) {
                          // You can replace this with data from your source (e.g., getCurrentStockDetailManager[index])
                          String item = "14.2 KG";
                          String amt = "25000";

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        item,
                                        style: Styling.itemBlackTestBold,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Filled",
                                        style: Styling.itemBlackTestBold,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Empty",
                                        style: Styling.itemBlackTestBold,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Def",
                                        style: Styling.itemBlackTestBold,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Current Stock",
                                        style: Styling.itemBlackTestSmall,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "23",
                                        style: Styling.itemBlackTestSmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "20",
                                        style: Styling.itemBlackTestSmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "26",
                                        style: Styling.itemBlackTestSmall,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "CDCMS",
                                        style: Styling.itemBlackTestSmall,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                        decoration: buildInputWithoutBorderUpdateStatus( context),
                                        style: Styling.itemBlackTestSmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(width: 7,),
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                        decoration: buildInputWithoutBorderUpdateStatus( context),
                                        style: Styling.itemBlackTestSmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(width: 7,),
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                        decoration: buildInputWithoutBorderUpdateStatus( context),
                                        style: Styling.itemBlackTestSmall,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Difference",
                                        style: Styling.itemBlackTestSmall,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "23",
                                        style: Styling.itemBlackTestSmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "20",
                                        style: Styling.itemBlackTestSmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "26",
                                        style: Styling.itemBlackTestSmall,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Total - ",
                                        style: Styling.itemBlackTestBold,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "2300",
                                        style: Styling.itemBlackTestBold,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),

                          );
                        },
                      ),
                    ],
                  ),
                ),

              ],
            ),

          ),

        ),
      );
  }

  // Widget _buildCDCMSStockTab() {
  //   return SingleChildScrollView(
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "Stock Updated On : 13/02/2025 17:42",
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 10),
  //           SizedBox( // Use SizedBox instead of Expanded
  //             child: SingleChildScrollView(
  //               scrollDirection: Axis.horizontal,
  //               child: DataTable(
  //                 columnSpacing: 12,
  //                 border: TableBorder.all(),
  //                 columns: [
  //                   DataColumn(label: Text('Item Name')),
  //                   DataColumn(label: Text('Filled')),
  //                   DataColumn(label: Text('Empty')),
  //                   DataColumn(label: Text('Defective')),
  //                   DataColumn(label: Text('CDCMS Filled')),
  //                   DataColumn(label: Text('CDCMS Empty')),
  //                   DataColumn(label: Text('CDCMS Defective')),
  //                   DataColumn(label: Text('Diff. Filled')),
  //                   DataColumn(label: Text('Diff. Empty')),
  //                   DataColumn(label: Text('Diff. Defective')),
  //                   DataColumn(label: Text('Total')),
  //                 ],
  //                 rows: stockData.map((item) {
  //                   return DataRow(cells: [
  //                     DataCell(Text(item['name'])),
  //                     DataCell(Text(item['filled'].toString())),
  //                     DataCell(Text(item['empty'].toString())),
  //                     DataCell(Text(item['defective'].toString())),
  //                     DataCell(TextField()), // CDCMS Filled Input
  //                     DataCell(TextField()), // CDCMS Empty Input
  //                     DataCell(TextField()), // CDCMS Defective Input
  //                     DataCell(Text(item['filledDiff'].toString())),
  //                     DataCell(Text(item['emptyDiff'].toString())),
  //                     DataCell(Text(item['defectiveDiff'].toString())),
  //                     DataCell(Text(item['total'].toString())),
  //                   ]);
  //                 }).toList(),
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           Center(
  //             child: ElevatedButton(
  //               onPressed: () {},
  //               child: Text("Save CDCMS Data"),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  final List<Map<String, dynamic>> stockData = [
    {
      'name': '14.2 KG',
      'filled': 1575,
      'empty': 2121,
      'defective': 3,
      'filledDiff': 1574,
      'emptyDiff': 2121,
      'defectiveDiff': 3,
      'total': 3698,
    },
    {
      'name': '19 KG',
      'filled': 549,
      'empty': 583,
      'defective': 0,
      'filledDiff': 549,
      'emptyDiff': 583,
      'defectiveDiff': 0,
      'total': 1132,
    },
    {
      'name': '5 KG',
      'filled': 404,
      'empty': 572,
      'defective': 0,
      'filledDiff': 404,
      'emptyDiff': 572,
      'defectiveDiff': 0,
      'total': 976,
    },
    {
      'name': 'Sc Regulator',
      'filled': 100,
      'empty': 0,
      'defective': 0,
      'filledDiff': 100,
      'emptyDiff': 0,
      'defectiveDiff': 0,
      'total': 100,
    },
    {
      'name': 'Regulator Surya',
      'filled': 110,
      'empty': 0,
      'defective': 0,
      'filledDiff': 110,
      'emptyDiff': 0,
      'defectiveDiff': 0,
      'total': 110,
    },
    {
      'name': 'Regulator Surya',
      'filled': 110,
      'empty': 0,
      'defective': 0,
      'filledDiff': 110,
      'emptyDiff': 0,
      'defectiveDiff': 0,
      'total': 110,
    },
    {
      'name': 'Regulator Surya',
      'filled': 110,
      'empty': 0,
      'defective': 0,
      'filledDiff': 110,
      'emptyDiff': 0,
      'defectiveDiff': 0,
      'total': 110,
    },
    {
      'name': 'Regulator Surya',
      'filled': 110,
      'empty': 0,
      'defective': 0,
      'filledDiff': 110,
      'emptyDiff': 0,
      'defectiveDiff': 0,
      'total': 110,
    },
    {
      'name': 'Regulator Surya',
      'filled': 110,
      'empty': 0,
      'defective': 0,
      'filledDiff': 110,
      'emptyDiff': 0,
      'defectiveDiff': 0,
      'total': 110,
    },
  ];
}
