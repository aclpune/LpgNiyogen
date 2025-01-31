import 'package:flutter/material.dart';

import 'ImabalanceEmptyListModel.dart';
class ImblanceShowUi extends StatefulWidget {
  ImabalanceEmptyListModel listModel;
  ImblanceShowUi({required this.listModel,super.key});

  @override
  State<ImblanceShowUi> createState() => _ImblanceShowUiState();
}

class _ImblanceShowUiState extends State<ImblanceShowUi> {
  @override
  Widget build(BuildContext context) {
    var value = widget.listModel;
    return
      value != null && value != "" ?
      Card(
        child: SingleChildScrollView( // Make the Column scrollable
          child:
Container(),
        ),
      ) :
      Container(
        child: Text("No data found"),
      );
  }
}