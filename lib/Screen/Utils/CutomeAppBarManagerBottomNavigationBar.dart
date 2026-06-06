
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

  String? userName,role,distributorName,roleId;
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Constants.AppBarTitle,
                        textAlign: TextAlign.start,
                        style: Styling.appBarTitle,
                        textScaler: TextScaler.noScaling,
                      ),
                      Text(
                        distributorName == "null"?'':
                        distributorName ?? '',
                        textAlign: TextAlign.start,
                        style: Styling.hintTextVerySmall,
                        textScaler: TextScaler.noScaling,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                      Text(
                        userName ?? ' ',
                        style: Styling.hintTextSmall,
                        textAlign: TextAlign.right,
                        textScaler: TextScaler.noScaling,
                      ),
                  SizedBox(height: 2,),
                  Text(
                    role ?? '',
                    style: Styling.hintTextSmall,
                    textAlign: TextAlign.right,
                    textScaler: TextScaler.noScaling,
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
      String roles = preferences.getString("RoleName").toString();
      distributorName = preferences.getString("DistributorName").toString();
      roleId = preferences.getString("roleId").toString();
      debugPrint("User Name:- $userName");
      if(roleId == "0"){
        if(roles == "null" || roles.isEmpty){
          role = "Godown Keeper";
        }else{
          role = roles;
        }
      }else{
        if(roles == "null" || roles.isEmpty){
          role = "";
        }else{
          role = roles;
        }
      }

      // String? staffIdString = preferences.getString("UserId");
      // userId = staffIdString != null ? int.tryParse(staffIdString) : null;
      // debugPrint("User Name:- $userName");
      // debugPrint("user Id:- $userId");
    } catch (error) {
      rethrow;
    }
  }
}
