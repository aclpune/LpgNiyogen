import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../ClickModelClass/GetBankMappingDetailsListModel.dart';
import '../ClickModelClass/GetDashboardPostpaidVarifiPendCntLstForMobListModel.dart';
import 'DashboardPostPaidVerifPendDetails.dart';

class DashboardPostPaidVeriPendDetailsUI extends StatefulWidget {
  GetDashboardPostpaidVarifiPendCntLstForMobListModel postpaidverifipending;


  DashboardPostPaidVeriPendDetailsUI( this.postpaidverifipending,{super.key});

  @override
  State<StatefulWidget> createState() {
    return _DashboardPostPaidVeriPendDetailsUI();
  }
}

class _DashboardPostPaidVeriPendDetailsUI extends State<DashboardPostPaidVeriPendDetailsUI> {

  DateTime selectedDate = DateTime.now();
  bool isChecked = false;
  String? selectedAccountNo;
  bool isTodaysNiyoganPunchedListViewVisible = false;
  List<GetBankMappingDetailsListModel> bankmappingModel = [];
  List<String> getTransactionForList = ["All","Daily Sales","SV Sales","ARB Sales","Receipt"];
  String? selectedBankName,selectedBankId;
  Future<void> _selectDate(BuildContext context) async {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2002),
        lastDate: DateTime
            .now()).then((pickedDate) {
          if (pickedDate == null) {
              return;
      }
      setState(() {
        //for rebuilding the ui
        selectedDate = pickedDate;
      });
    });
  }
  @override
  void initState() {
    super.initState();
    //fetchBank();
  }
  @override
  Widget build(BuildContext context) {
    var sale = widget.postpaidverifipending;

    String nullToDash(String? value) {
      if (value == null || value.toLowerCase() == "null") {
        return "-";
      }
      return value;
    }
    return
      Column(
        children: [
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Trans Code:", nullToDash(sale.transCode))),
              // Expanded(
              //   flex: 1,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       DropdownButtonFormField<GetBankMappingDetailsListModel>(
              //         decoration: buildInputBorderUpdateStatus("Select Bank", context),
              //         style: Styling.textFormText,
              //         items: bankmappingModel.map((GetBankMappingDetailsListModel item) {
              //           return DropdownMenuItem<GetBankMappingDetailsListModel>(
              //             value: item,
              //             child: Text(
              //               '${item.bankName ?? 'Unknown Bank'} - ${item.accountNo ?? 'Unknown Account'}',
              //               style: Styling.textFormText,
              //             ),
              //           );
              //         }).toList(),
              //         onChanged: (GetBankMappingDetailsListModel? selectedItem) {
              //           if (selectedItem != null) {
              //             setState(() {
              //               selectedBankName = selectedItem.bankName;
              //               selectedBankId = selectedItem.accountNo;
              //               debugPrint("bank:${selectedBankName}no:${selectedBankId}");
              //             });
              //           }
              //         },
              //         hint: Text('Select Bank'),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Trans Time:", nullToDash(sale.transTime))),
              Expanded(flex:1,child: countTextWidgetText(context,"Amount:", nullToDash(formatCurrency((sale.amount ?? 0.0).toDouble())))),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Trans For:", nullToDash(sale.transFor))),
              Expanded(flex:1,child: countTextWidgetText(context,"Trans Date:", nullToDash(sale.transDate))),
            ],
          ),
          SizedBox(height: 2),

          Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(fontSize: 14),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                      iconSize: 24,
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child:
              //   CheckboxListTile(
              //     value: isChecked,
              //     onChanged: (bool? value) {
              //       setState(() {
              //         isChecked = value ?? false;
              //       });
              //     },
              //     controlAffinity: ListTileControlAffinity.leading,
              //     fillColor: MaterialStateProperty.resolveWith<Color>(
              //           (Set<MaterialState> states) {
              //         if (sale.selectedDate == null && sale.bankName ==null) {
              //           return Colors.grey.withOpacity(0.3); // Change to grey if `selectedDate` is `null`
              //         }
              //         if (states.contains(MaterialState.selected)) {
              //           return Colors.blue; // When checked, background is blue
              //         }
              //         return Colors.white; // When unchecked, background is white
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex:1,child: countTextWidgetText(context,"Staff Name:", nullToDash(sale.staffName))),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Expanded(flex: 1, child: countTextWidgetRemark(context,"Remark:", sale.remark ?? '')),
            ],
          ),
          Divider(),
        ],
      );
  }
  // Future<void> fetchBank() async {
  //   EasyLoading.show();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
  //
  //   if (bearerToken == null) {
  //     throw Exception('Bearer token is missing');
  //   }
  //
  //   Map<String, dynamic> requestBody = {
  //     "DistributorId": distributorId,
  //
  //   };
  //
  //   final response = await http.get(
  //     Uri.parse('${AppUrl.GetBankMappingDetailsList}/$distributorId/1'),
  //     headers: {
  //       'Authorization': 'Bearer $bearerToken', // Add Bearer token here
  //     },
  //   );
  //   debugPrint("GetBankMappingDetailsListModel : " + '${AppUrl.GetBankMappingDetailsList}/$distributorId/1');
  //   debugPrint("GetBankMappingDetailsListModel : " + '${response.body}');
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //
  //     setState(() {
  //       bankmappingModel = data.map((json) {
  //         return GetBankMappingDetailsListModel.fromJson(json);
  //       }).toList();
  //       EasyLoading.dismiss();
  //     });
  //   } else {
  //     EasyLoading.dismiss();
  //     throw Exception('Failed to load items');
  //   }
  // }
}
