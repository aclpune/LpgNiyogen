
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class AppBarCustom extends StatefulWidget implements PreferredSizeWidget {
  const AppBarCustom({Key? key}) : super(key: key);

  @override
  State<AppBarCustom> createState() => _AppBarCustomState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _AppBarCustomState extends State<AppBarCustom> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSavedData().whenComplete(() {
      setState(() {});
    });
  }

  String? userName;
  //int? userId;
  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        title: Column(children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 7,
                    shadowColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Image.asset(
                      'assets/playstore.png', // Replace with the path to your logo image
                      height: 35, // Adjust the height as needed
                    ),
                  ),
                  SizedBox(width: 5,),
                  Column(
                    children: [
                      Text(
                        Constants.AppBarTitle,
                        textAlign: TextAlign.start,
                        style: Styling.appBarTitle,
                      ),
                      Text(
                        "",
                        textAlign: TextAlign.start,
                        style: Styling.appBarDesc,
                      ),
                    ],
                  ),
                ],
              ),
              Column(

                children: [
                      Text(
                        userName ?? ' ',
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.right,
                      ),
                  Text(
                    "" ?? ' ',
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.right,
                  ),
                ],
              )
            ],
          ),

        ]));
  }

  Future<void> fetchSavedData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      userName = preferences.getString("StaffName").toString();
      debugPrint("User Name:- $userName");
      // String? staffIdString = preferences.getString("UserId");
      // userId = staffIdString != null ? int.tryParse(staffIdString) : null;
      // debugPrint("User Name:- $userName");
      // debugPrint("user Id:- $userId");
    } catch (error) {
      rethrow;
    }
  }
}
