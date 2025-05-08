import 'package:flutter/material.dart';

import 'Styling.dart';
import 'constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  // Size get preferredSize => Size.fromHeight(kToolbarHeight); // Default AppBar height
  Size get preferredSize => Size.fromHeight(60); // Default AppBar height

  @override
  Widget build(BuildContext context) {
    return
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
                      Navigator.pushReplacementNamed(context, '/bottomNavigationForGodownKeeper'); // Go back on click
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Vertically center the content in the row
                    crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally in the row
                    children: [
                      // First Column: Logo
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            color: Colors.white,
                            elevation: 5,
                            shadowColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Image.asset(
                              'assets/playstore.png', // Your logo image path
                              height: 40, // Adjust the height as needed
                              width: 40,  // Adjust the width as needed
                            ),
                          ),
                        ],
                      ),

                      // Second Column: App Name and Screen Name
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // First Row: App Name
                          Row(
                            children: [
                              SizedBox(width: 5), // Space between logo and app name
                              Text(
                                Constants.appName, // Replace with your app's name
                                style: Styling.appBarTitle,
                              ),
                            ],
                          ),
                        SizedBox(height: 5,),
                          // Second Row: Screen Name
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  title, // Replace with dynamic title or text input
                                  textAlign: TextAlign.start,
                                  style: Styling.appBarDesc, // Define this style as needed
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
  }
}
