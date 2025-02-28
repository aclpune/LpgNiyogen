import 'package:flutter/material.dart';

import 'Styling.dart';
import 'constants.dart';

class CustomAppBarManager extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBarManager({required this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Default AppBar height

  @override
  Widget build(BuildContext context) {
    return
      // AppBar(
      //   backgroundColor: Colors.blue, // You can change the color as needed
      //   automaticallyImplyLeading: false, // Disable default back button
      //   title: Padding(
      //     padding: const EdgeInsets.only(left: 0),
      //     child: Row(
      //       children: [
      //         // Back Arrow Button
      //         IconButton(
      //           icon: Icon(Icons.arrow_back, color: Colors.white),
      //           onPressed: () {
      //             Navigator.pushReplacementNamed(context, '/managerDashboardScreen');
      //           },
      //         ),
      //         // Text Field
      //         SizedBox(width: 10,),
      //         Expanded(
      //           child: TextField(
      //             decoration: InputDecoration(
      //               hintText: title, // You can pass dynamic title here
      //               hintStyle: TextStyle(color: Colors.white),
      //               border: InputBorder.none,
      //               contentPadding: EdgeInsets.all(8.0),
      //             ),
      //             style: TextStyle(color: Colors.white,fontSize: 20),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // );
    AppBar(
      backgroundColor: Colors.blue, // Set your desired background color
      automaticallyImplyLeading: false, // Disable default back button
      title: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center the column
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align back arrow to the left
              crossAxisAlignment: CrossAxisAlignment.center, // Vertically center
              children: [
                // Back Arrow Button on the left side
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/managerDashboardScreen'); // Go back on click
                  },
                ),
                // Second Column (Logo and App Name)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Vertically center the column
                  crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
                  children: [
                    // Logo
                    Row(
                      children: [
                        Image.asset(
                          'assets/playstore.png', // Your logo image path
                          height: 30, // Adjust the height as needed
                          width: 30,  // Adjust the width as needed
                        ),
                        // Space between logo and app name
                        // App Name
                        SizedBox(width: 5,),
                        Text(
                          Constants.appName, // Replace with your app's name
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                              title, // Replace with dynamic title or text input
                              textAlign: TextAlign.start,
                              style: Styling.appBarDesc
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }
}
