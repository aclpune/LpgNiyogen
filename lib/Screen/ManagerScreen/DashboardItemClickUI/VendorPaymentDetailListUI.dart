import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../ClickModelClass/GetVendorDetailListModel.dart';
import '../UpdatePaymentsScreen/GetVendorMasterListModel.dart';

class VendorPaymentDetailListUI extends StatefulWidget {
  static const screenName = '/vendorPaymentDetailListUI';
  const VendorPaymentDetailListUI({super.key});

  @override
  State<VendorPaymentDetailListUI> createState() => _VendorPaymentDetailListUIState();
}

class _VendorPaymentDetailListUIState extends State<VendorPaymentDetailListUI> {
  List<GetVendorMasterListModel> vendorModel = [];
  final GetVendorMasterListModel allItem = GetVendorMasterListModel(vendorId: 0, vendorName: "ALL");
  GetVendorMasterListModel? _selectVendor;
  String? _selectedVendor;
  int? vendorId;
  late List<GetVendorDetailListModel> getVendorDetailListModel = [];
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  bool isLoading = true;
  double totalPendingAmount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectVendor = allItem;
    fetchVendorDetailList(0);
    getVendorMasterList();
  }
  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return
      WillPopScope(
        onWillPop: () async {
          if (argLRAdd == "fromDrawer") {
            Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
            return false;
          } else {
            Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
            return false;
          }
        },
        child:
        Scaffold(
          appBar:
          PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child:
            AppBar(
              automaticallyImplyLeading: false,
              surfaceTintColor: Color(0xFFECEFFF),
              backgroundColor: Color(0xFFECEFFF),
              flexibleSpace: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          // Navigator.pushNamed(context, BottomNavBarExample.screenName);
                          Navigator.pop(context);

                        },
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vendor Due Payment',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              textScaler: TextScaler.noScaling,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Total Pending Amt.-${formatCurrency(totalPendingAmount.toDouble())}',
                                    style: TextStyle(fontSize: 12, color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                    textScaler: TextScaler.noScaling,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body:
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: textWidgetBlueColorWithStar(
                        'Vendor Name',
                        "*",
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child:
                        // DropdownButtonFormField<GetVendorMasterListModel>(
                        //   isExpanded: true,
                        //   key: formKey1,
                        //   decoration: InputDecoration(
                        //     contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        //   ),
                        //   value: vendorModel.contains(_selectVendor)?_selectVendor:null ,
                        //   items: vendorModel.map((item) {
                        //     return DropdownMenuItem<GetVendorMasterListModel>(
                        //       value: item,
                        //       child: Text(
                        //         item.vendorName ?? '',
                        //         style: Styling.itemBlackTest,
                        //       ),
                        //     );
                        //   }).toList(),
                        //   onChanged: (selectedItem) {
                        //     setState(() {
                        //       _selectVendor = selectedItem;
                        //       _selectedVendor = selectedItem?.vendorName ?? '';
                        //       vendorId = selectedItem?.vendorId?.toInt();
                        //       fetchVendorDetailList(vendorId!);
                        //     });
                        //     validator: (value) {
                        //       if (value == null) {
                        //         return 'Please select a vendor';
                        //       }
                        //       return null;
                        //     };
                        //   },
                        //   hint: Text("Vendor Name",
                        //     style: Styling.hintTextSmall,),
                        // ),
                        DropdownButtonFormField<GetVendorMasterListModel>(
                          isExpanded: true,
                          decoration: buildInputBorderUpdateStatus("ALL", context),
                          value: _selectVendor,
                          items: [
                            DropdownMenuItem<GetVendorMasterListModel>(
                              value: allItem,
                              child: Text(
                                "ALL",
                                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                                textScaler: TextScaler.noScaling,
                              ),
                            ),

                            ...vendorModel.map((GetVendorMasterListModel item) {
                              return DropdownMenuItem<GetVendorMasterListModel>(
                                value: item,
                                child: Text(
                                  item.vendorName ?? '',
                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                                  textScaler: TextScaler.noScaling,
                                ),
                              );
                            }).toList(),
                          ],
                          onChanged: (GetVendorMasterListModel? selectedItem) {
                            if (selectedItem != null) {
                              setState(() {
                                _selectVendor = selectedItem;

                                if (selectedItem.vendorId == 0) {
                                  _selectedVendor = 'ALL';
                                  vendorId = 0;
                                  fetchVendorDetailList(vendorId!);
                                  // Fetch all data
                                } else {
                                  _selectVendor = selectedItem;
                                  _selectedVendor = selectedItem.vendorName ?? '';
                                  vendorId = selectedItem.vendorId?.toInt();
                                  fetchVendorDetailList(vendorId!); // Fetch for selected customer
                                }
                              });
                            }
                          },
                          hint: Text(
                            'ALL',
                            textScaler: TextScaler.noScaling,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                isLoading
                    ? const Center(child: CircularProgressIndicator()):
                getVendorDetailListModel.isNotEmpty?

                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: getVendorDetailListModel.length,
                            itemBuilder: (context, index) {
                              GetVendorDetailListModel? vendor = getVendorDetailListModel[index];
                              return
                                Card(
                                  elevation: 2,
                                  margin: EdgeInsets.all(8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child:
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        itemSubLineWithBlackAndBlue("Invoice Date",DateFormat('dd-MM-yyyy').format(DateTime.parse(vendor.invoiceDate.toString() ?? ''))),
                                        itemSubLine("Vendor Name",vendor.vendorName.toString()),
                                        itemSubLine("Purchase Amount",formatCurrency(vendor.purchaseAmount?.toDouble() ?? 0)),
                                        itemSubLine("Pending Amount",formatCurrency(vendor.pendingAmount?.toDouble() ?? 0)),
                                      ],),
                                  ),
                                );


                            },
                          )
                        ],
                      ),
                    )
                :

                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'No Records Found',
                          style: TextStyle(color: Colors.grey),
                          textScaler: TextScaler.noScaling,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  String formatCurrency(double amount) {
    if (amount == 0) {
      return '0.00';
    }
    final format = NumberFormat('#,##,###.00', 'en_IN');

    String formattedAmount = format.format(amount);

    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0' + formattedAmount;
    }
    return formattedAmount;
  }

  Future<void> getVendorMasterList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetVendorMasterList}/$distributorId/1'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetVendorMasterList : " +
        '${AppUrl.GetVendorMasterList}/$distributorId/1');
    debugPrint("GetVendorMasterList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        vendorModel = data.map((json) {
          return GetVendorMasterListModel.fromJson(json);
        }).toList();

        // Sort alphabetically by vendorName (case-insensitive)
        vendorModel.sort((a, b) {
          final nameA = a.vendorName?.toLowerCase() ?? '';
          final nameB = b.vendorName?.toLowerCase() ?? '';
          return nameA.compareTo(nameB);
        });

        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> fetchVendorDetailList(int id) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    try{
      final response = await http.get(
        Uri.parse('${AppUrl.GetVendorDuePaymentList}/$distributorId/$id'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      debugPrint("GetVendorDuePaymentList request" + '${AppUrl.GetVendorDuePaymentList}/$distributorId/$id');
      debugPrint("GetVendorDuePaymentList resposnse" + '${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        debugPrint("GetVendorDuePaymentList" + '$data');
        setState(() {
          getVendorDetailListModel = data
              .map((json) => GetVendorDetailListModel.fromJson(json))
              .toList();


          // Calculate total pending amount
           totalPendingAmount = getVendorDetailListModel.fold(0.0, (sum, item) {
            return sum + (item.pendingAmount ?? 0.0);
          });

          print("Total Pending Amount: $totalPendingAmount");
          isLoading = false;
          EasyLoading.dismiss();
        });

      } else {
        EasyLoading.dismiss();
        throw Exception('Failed to load items');
      }
    }catch(e){
      EasyLoading.dismiss();
      debugPrint("Exceptin $e");
    }

  }
}
