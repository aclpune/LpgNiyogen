import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Default AppBar height

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue, // You can change the color as needed
      automaticallyImplyLeading: false, // Disable default back button
      title: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Row(
          children: [
            // Back Arrow Button
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/godownDashboard');
              },
            ),
            // Text Field
            SizedBox(width: 10,),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: title, // You can pass dynamic title here
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8.0),
                ),
                style: TextStyle(color: Colors.white,fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
