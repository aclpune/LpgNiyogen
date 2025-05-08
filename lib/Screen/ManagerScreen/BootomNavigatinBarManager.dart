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
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if arguments are passed to set the initial index
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is int) {
      setState(() {
        _selectedIndex = args; // Set the passed index
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBarCustom(),
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
            label: 'Cash Collection',
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

