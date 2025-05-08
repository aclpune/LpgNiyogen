import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ClickModelClass/GetexpensepopupListModel.dart';



class ManagerExpenseTabScreenUI extends StatefulWidget {

  GetexpensepopupListModel getExpenseModel;

  int serialNumber;
  String screenmode;
  // Constructor to receive the deliveryMenList
  //ManagerCashInHandScreenDetails({Key? key, required this.deliveryMenList}) : super(key: key);
  ManagerExpenseTabScreenUI(this.getExpenseModel,this.serialNumber, this.screenmode,{super.key});

  @override
  _ManagerExpenseTabScreenUI createState() =>
      _ManagerExpenseTabScreenUI();
}
class _ManagerExpenseTabScreenUI extends State<ManagerExpenseTabScreenUI>{
  @override
  Widget build(BuildContext context) {
     var sale = widget.getExpenseModel;
    var mode = widget.screenmode;
     var serialNumbers = widget.serialNumber;
     debugPrint("mode $mode");
    return
       Padding(
         padding: EdgeInsets.only(left:5.0,right: 5,top: 2,bottom: 2),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                        "$serialNumbers", // Dynamically display serial numbers (index + 1 or any other dynamic value)
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      sale.staffName.toString() ?? '',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      sale.cash!.toStringAsFixed(2),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Visibility(
                    visible: mode != 'On Account',
                    child: Expanded(
                      flex: 2,
                      child: Text(
                        sale.bank!.toStringAsFixed(2),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
            ],
          ),
       );
  }

}