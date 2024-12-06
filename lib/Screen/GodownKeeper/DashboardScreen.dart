import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/CustomeDrawer.dart';
import '../Utils/shared_preference.dart';

// class DashboardScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cylinder Godown Dashboard'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(  // Ensures the content is scrollable
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Key Metrics Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment. spaceEvenly,
//                 children: [
//                   SizedBox(
//                     width: 170,// Set a fixed width for both cards
//                     height: 120,  // Set a fixed height for both cards
//                     child: DashboardCard(
//                       title: 'Total Cylinders',
//                       value: '120',
//                       color: Colors.blueAccent,
//                     ),
//                   ),
//                   SizedBox(width: 5),  // Optional space between cards
//                   SizedBox(
//                       width: 170,// Same fixed width for the second card
//                     height: 120,  // Same fixed height for the second card
//                     child: DashboardCard(
//                       title: 'Available',
//                       value: '80',
//                       color: Colors.orange,
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   SizedBox(
//                     width: 170,  // Set a fixed width for both cards
//                     height: 120,  // Set a fixed height for both cards
//                     child: DashboardCard(
//                       title: 'Filled',
//                       value: '30',
//                       color: Colors.green,
//                     ),
//                   ),
//                   SizedBox(width: 5),  // Optional space between cards
//                   SizedBox(
//                     width: 170,  // Same fixed width for the second card
//                     height: 120,  // Same fixed height for the second card
//                     child: DashboardCard(
//                       title: 'Empty',
//                       value: '10',
//                       color: Colors.red,
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 30),
//               // Quick Actions Section
//               Text(
//                 'Quick Actions',
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//               SizedBox(height: 10),
//
//
//               Column(
//                 children: [
//                   // First Row of Cards
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       SizedBox(
//                         width: 170, // Fixed width for the first card
//                         height: 140, // Fixed height for the first card
//                         child: QuickActionCard(
//                           icon: Icons.add,
//                           label: 'Add Cylinder',
//                           onTap: () {
//                             // Action for Add Cylinder
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         width: 170, // Fixed width for the second card
//                         height: 140, // Fixed height for the second card
//                         child: QuickActionCard(
//                           icon: Icons.search,
//                           label: 'Search Cylinders',
//                           onTap: () {
//                             // Action for Search Cylinders
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   // Second Row of Cards
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       SizedBox(
//                         width: 170, // Fixed width for the third card
//                         height: 140, // Fixed height for the third card
//                         child: QuickActionCard(
//                           icon: Icons.list,
//                           label: 'View Details',
//                           onTap: () {
//                             // Action for View Details
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         width: 170, // Fixed width for the fourth card
//                         height: 140, // Fixed height for the fourth card
//                         child: QuickActionCard(
//                           icon: Icons.history,
//                           label: 'Activity Log',
//                           onTap: () {
//                             // Action for Activity Log
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 30),
//               // Recent Activity Section
//               Text(
//                 'Recent Activity',
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//               SizedBox(height: 10),
//               // ListView for recent activities
//               Container(
//                 height: 200,  // Provide fixed height to avoid overflow
//                 child: ListView.builder(
//                   shrinkWrap: true, // Ensures the ListView uses only as much space as it needs
//                   itemCount: 10,  // Dummy data count
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       leading: Icon(Icons.history),
//                       title: Text('Cylinder C${index + 1} Added'),
//                       subtitle: Text('Status: Available'),
//                       trailing: Icon(Icons.chevron_right),
//                       onTap: () {
//                         // Navigate to cylinder details
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class DashboardScreen extends StatelessWidget {
  static const screenName = '/godownDashboard';

  // GlobalKey for ScaffoldState
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    Map<String, Map<String, int>> cylinderData = {
      '14.2 kg': {
        'Filled': 30,
        'Empty': 10,
      },
      '19 kg': {
        'Filled': 50,
        'Empty': 20,
      },
      '5 kg': {
        'Filled': 20,
        'Empty': 5,
      },
    };
    Map<String, Map<String, int>> cylinderData1 = {
      'Invoice': {
        'Filled': 30,
        'Empty': 10,
      },
      'EMR': {
        'Filled': 50,
        'Empty': 20,
      },
      'TV': {
        'Filled': 20,
        'Empty': 5,
      },
      'Refill': {
        'Filled': 20,
        'Empty': 5,
      },
      'CRD': {
        'Filled': 20,
        'Empty': 5,
      },
      'NC': {
        'Filled': 20,
        'Empty': 5,
      },
      'DBC': {
        'Filled': 20,
        'Empty': 5,
      },
      'RC': {
        'Filled': 20,
        'Empty': 5,
      },
    };

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomeDrawer(),// Assign the scaffold key
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),  // Custom height for the AppBar
        child: Container(
          color: Colors.blueAccent,  // Custom background color
          padding: EdgeInsets.only(top: 40, left: 16, right: 16), // Padding for top & sides
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.menu, color: Colors.white),  // Menu icon for Drawer
                onPressed: () {
                  // Toggle the drawer open or closed
                  if (_scaffoldKey.currentState!.isDrawerOpen) {
                    _scaffoldKey.currentState!.closeDrawer();
                  } else {
                    _scaffoldKey.currentState!.openDrawer();
                  }
                },
              ),
              SizedBox(width: 20),
              Text(
                'Cylinder Godown',  // Godown Name
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),

      // Drawer to provide navigation options
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       // Drawer Header
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.blueAccent,
      //         ),
      //         child: Text(
      //           'Cylinder Godown',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 24,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
      //       // Drawer items (navigate to different screens)
      //       ListTile(
      //         leading: Icon(Icons.home),
      //         title: Text('Home'),
      //         onTap: () {
      //           Navigator.pop(context); // Close the drawer
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.settings),
      //         title: Text('Item Receipt'),
      //         onTap: () {
      //           Navigator.pushReplacementNamed(context, '/itemWiseReceipt'); // Close the drawer
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.exit_to_app),
      //         title: Text('Stock Return'),
      //         onTap: () {
      //           Navigator.pushReplacementNamed(context, '/stockReturnFromDelBoy');
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.exit_to_app),
      //         title: Text('Edit Item'),
      //         onTap: () {
      //           Navigator.pushReplacementNamed(context, '/editItemReceiptPage');
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.exit_to_app),
      //         title: Text('Item Return'),
      //         onTap: () {
      //           Navigator.pushReplacementNamed(context, '/itemReturnScreen');
      //         },
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.exit_to_app),
      //         title: Text('Logout'),
      //         onTap: () {
      //           logoutUser(context);
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      body: SingleChildScrollView(  // Ensures the content is scrollable
        child:
        Padding(
          padding: const EdgeInsets.only(left: 5.0,right: 5.0,bottom: 5.0,top: 20.0),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title for Cylinder Categories Table
                    Text(
                        'Cylinder size wise count',
                        style:TextStyle(fontSize: 16,color: Colors.black54)
                    ),
                    SizedBox(height: 10),
                    // Table with Borders (including vertical lines)
                    Table(
                      border: TableBorder.all(
                        color: Colors.grey, // Border color for both vertical and horizontal lines
                        width: 1, // Border thickness
                        borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                      ),
                      children: [
                        // Table Header
                        TableRow(
                          decoration: BoxDecoration(color: Colors.blue.shade100),
                          children: [
                            _buildTableCell('Cylinder', isHeader: true),
                            _buildTableCell('Empty', isHeader: true),
                            _buildTableCell('Filled', isHeader: true),
                          ],
                        ),
                        // Table Data Rows
                        ...cylinderData.entries.map((entry) {
                          String category = entry.key;
                          int emptyCount = entry.value['Empty'] ?? 0;
                          int filledCount = entry.value['Filled'] ?? 0;

                          return TableRow(
                            children: [
                              _buildTableCell(category),
                              _buildTableCell('$emptyCount'),
                              _buildTableCell('$filledCount'),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title for Cylinder Categories Table
                    Text(
                        'Categories wise count',
                        style:TextStyle(fontSize: 16,color: Colors.black54)
                    ),
                    SizedBox(height: 10),
                    // Table with Borders (including vertical lines)
                    Table(
                      border: TableBorder.all(
                        color: Colors.grey, // Border color for both vertical and horizontal lines
                        width: 1, // Border thickness
                        borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                      ),
                      children: [
                        // Table Header
                        TableRow(
                          decoration: BoxDecoration(color: Colors.blue.shade100),
                          children: [
                            _buildTableCell('Category', isHeader: true),
                            _buildTableCell('Empty', isHeader: true),
                            _buildTableCell('Filled', isHeader: true),
                          ],
                        ),
                        // Table Data Rows
                        ...cylinderData1.entries.map((entry) {
                          String category = entry.key;
                          int emptyCount = entry.value['Empty'] ?? 0;
                          int filledCount = entry.value['Filled'] ?? 0;

                          return TableRow(
                            children: [
                              _buildTableCell(category),
                              _buildTableCell('$emptyCount'),
                              _buildTableCell('$filledCount'),
                            ],
                          );
                        }).toList(),
                      ],
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
}
// Helper method to build table cells with styling
Widget _buildTableCell(String text, {bool isHeader = false}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: isHeader ? FontWeight.normal : FontWeight.normal,
        fontSize: 12,
        color: isHeader ? Colors.black : Colors.black87,
      ),
    ),
  );
}


