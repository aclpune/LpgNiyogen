import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DashboardScreen.dart';

import '../Utils/CustomeAppBarManagerDashboard.dart';
import '../Utils/CutomeAppBarManagerBottomNavigationBar.dart';
import 'DelBoyStockReturn/DeliveryMenListShowScreen.dart';
import 'DelBoyStockSubmitToManager/StockSubmitToManager.dart';
import 'ItemReceipt/AddItem/ItemReceiptScreen.dart';
import 'MoreOptionScreenGodownKeeper.dart';
class BottomNavigationForGodownKeeper extends StatefulWidget {
  static const screenName = '/bottomNavigationForGodownKeeper';
  @override
  _BottomNavigationForGodownKeeperState createState() => _BottomNavigationForGodownKeeperState();
}

class _BottomNavigationForGodownKeeperState extends State<BottomNavigationForGodownKeeper> {
  // The selected index for the bottom navigation bar
  int _selectedIndex = 0;

  // List of pages for each option in the navigation bar
  final List<Widget> _pages = [
    DashboardScreen(),
    DeliveryMenListShowScreen(),
    StockSubmitToManager(),
    MoreOptionScreenGodownKeeper(),
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
      appBar:CustomeAppBarmanagerDashboard(),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard,size: 16,),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart,size: 16,),
            label: 'Daily Sale',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.summarize,size: 16,),
            label: "Today's Summary",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz,size: 16,),
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


