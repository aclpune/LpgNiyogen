import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DelBoyStockReturn/DeliveryMenListShowScreen.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/DeliveryBoyWiseListShow.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerDSRReportScreen.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerDashboard.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerUpdateSaleScreen.dart';

import '../Utils/CutomeAppBarManagerBottomNavigationBar.dart';
import '../Utils/constants.dart';
import 'ManagerMoreScreen.dart';

class BottomNavBarExample extends StatefulWidget {
  static const screenName = '/bottomNavBarExample';
  @override
  _BottomNavBarExampleState createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample> {
  // The selected index for the bottom navigation bar
  int _selectedIndex = 0;

  // List of pages for each option in the navigation bar
  final List<Widget> _pages = [
    ManagerDashboardScreen(),
    ManagerDSRReportScreen(),
    DeliveryBoyWiseListShow(),
    ManagerMoreScree(),
  ];

  // Method to handle item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBarCustom(),

      // PreferredSize(
      //   preferredSize: Size.fromHeight(120), // Custom height for the AppBar
      //   child: Container(
      //     color: Colors.blueAccent,
      //     // Custom background color
      //     padding: EdgeInsets.only(top: 40, left: 5, right: 16,bottom: 5),
      //     // Padding for top & sides
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       // Align items to the start
      //       children: [
      //         // IconButton(
      //         //   icon: Icon(Icons.menu, color: Colors.white),
      //         //   // Menu icon for Drawer
      //         //   onPressed: () {
      //         //     // Toggle the drawer open or closed
      //         //     if (_scaffoldKey.currentState!.isDrawerOpen) {
      //         //       _scaffoldKey.currentState!.closeDrawer();
      //         //     } else {
      //         //       _scaffoldKey.currentState!.openDrawer();
      //         //     }
      //         //   },
      //         // ),
      //         SizedBox(width: 20),
      //         // // Replacing the Text widget with the Row for Logo and App Name
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             // App Logo
      //             Image.asset(
      //               'assets/playstore.png', // Path to your logo image
      //               height: 40, // Adjust the height as needed
      //             ),
      //             SizedBox(width: 8),
      //             // Add some space between the logo and the app name
      //             // App Name (Replace 'App Name' with your constant or dynamic value)
      //             Text(
      //               Constants.AppBarTitle,
      //               // Your app name constant or dynamic value
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 20,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard,size: 18,),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment,size: 18,),
            label: 'DSR Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart,size: 18,),
            label: 'Refill Sale',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz,size: 18,),
            label: 'More',
          ),
        ],
        selectedItemColor: Colors.blue, // Set color for selected item
        unselectedItemColor: Colors.black, // Set color for unselected items
        type: BottomNavigationBarType.fixed, // Ensures the labels are displayed
      ),
    );
  }
}

