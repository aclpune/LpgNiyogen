import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../ManagerModelClass/DailySaleSaummaryListModel.dart';
import '../ManagerUpdateSaleScreen.dart';

class DeliveryBoyWiseListItem extends StatefulWidget {
  DailySaleSaummaryListModel filteredSales;


  DeliveryBoyWiseListItem(this.filteredSales,{Key? key}) : super(key: key);

  @override
  State<DeliveryBoyWiseListItem> createState() => _DeliveryBoyWiseListItemState();
}

class _DeliveryBoyWiseListItemState extends State<DeliveryBoyWiseListItem> {
  bool isListViewVisible = false; // Tracks if ListView is visible
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    var sale = widget.filteredSales;
    return
      Card(
                    elevation: 5,
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12),
                      child: Column(
                        children: [
                          // Date and Weight Row with icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(sale.staffName ?? '', style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,color:  Color(0xff1280b3), fontFamily: 'OpenSans')),
                                ],
                              ),
                              Row(
                                children: [
                                  // Icon(Icons.currency_rupee, size: 16,
                                  //     color: Colors.grey),
                                  Text('Status :', style: TextStyle(
                                      fontSize: 14,fontFamily: 'OpenSans',color:  Color(0xff1280b3))),
                                  SizedBox(width: 5),
                                  Text('${sale.statusStr ?? 0}',
                                      style: TextStyle(fontSize: 14,
                                          fontFamily: 'OpenSans',color: Colors.black)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          // Data values Row with icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('Refill: ', style: TextStyle(
                                      fontSize: 14,fontFamily: 'OpenSans',color: Colors.grey[700])),
                                  Text('${sale.totalFilledQty ?? 0}',
                                      style: TextStyle(fontSize: 14,fontFamily: 'OpenSans')),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('TV: ', style: TextStyle(fontSize: 14,fontFamily: 'OpenSans',color: Colors.grey[700])),
                                  Text('${sale.totalTVQty ?? 0}',
                                      style: TextStyle(fontSize: 14,fontFamily: 'OpenSans')),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('SV: ', style: TextStyle(fontSize: 14,fontFamily: 'OpenSans',color: Colors.grey[700])),
                                  Text('${sale.totalSVQty ?? 0}',
                                      style: TextStyle(fontSize: 14,fontFamily: 'OpenSans')),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('Total Amt.: ', style: TextStyle(
                                      fontSize: 14,fontFamily: 'OpenSans',color: Colors.grey[700])),
                                  Text('${sale.totalAmt ?? 0}',
                                      style: TextStyle(fontSize: 14,fontFamily: 'OpenSans')),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Recieved Amt.', style: TextStyle(fontSize: 14,fontFamily: 'OpenSans',color: Colors.grey[700])),
                                  Text('${sale.totalAmt ?? 0}',
                                      style: TextStyle(fontSize: 14,fontFamily: 'OpenSans')),
                                ],
                              ),

                            ],
                          ),
                          // Expandable section
                          Visibility(
                            visible: _isExpanded,
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                // First Row: Cash and Prepaid
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Cash Section
                                    Expanded(
                                      child: Row(
                                        children: [
                                          SizedBox(width: 8),
                                          SizedBox(width: 70,
                                              child: Text('Cash :', style: TextStyle(fontSize: 12,color: Colors.grey[700],fontFamily: 'OpenSans'))),
                                          // Quantity Text
                                          Row(
                                            children: [
                                              Text('${sale.cashQty ?? 0}', style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                                              SizedBox(width: 5),
                                              // Amount Text
                                              Icon(Icons.currency_rupee,size: 12,),
                                              Text('${sale.cashAmt ?? 0}', style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      width: 1.0, // Width of the vertical line
                                      height: 20.0, // Height of the vertical line
                                      color: Colors.black, // Color of the line
                                    ),
                                    // Prepaid Section
                                    Expanded(
                                      child: Row(
                                        children: [
                                          SizedBox(width: 8),
                                          SizedBox(width: 70,
                                              child: Text('Prepaid :', style: TextStyle(fontSize: 12,color: Colors.grey[700],fontFamily: 'OpenSans'))),
                                          // Quantity Text
                                          Row(
                                            children: [
                                              Text('${sale.prepaidQty ?? 0}',  style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                                              SizedBox(width: 5),
                                              Icon(Icons.currency_rupee,size: 12,),
                                              Text('${sale.prepaidAmt ?? 0}', style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                                            ],
                                          ),

                                          // Amount Text
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 5), // Space between rows
                                // Second Row: Post and Credit
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Post Section
                                    Expanded(
                                      child: Row(
                                        children: [
                                          SizedBox(width: 8),
                                          SizedBox(width: 70,
                                              child: Text('Postpaid :', style: TextStyle(fontSize: 12,color: Colors.grey[700],fontFamily: 'OpenSans'))),
                                          // Quantity Text
                                          Row(
                                            children: [
                                              Text('${sale.postPaidQty ?? 0}', style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                                              SizedBox(width: 5),
                                              Icon(Icons.currency_rupee,size: 12,),
                                              Text('${sale.postPaidAmt ?? 0}',  style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),

                                            ],
                                          ),

                                          // Amount Text
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      width: 1.0, // Width of the vertical line
                                      height: 20.0, // Height of the vertical line
                                      color: Colors.black, // Color of the line
                                    ),
                                    // Credit Section
                                    Expanded(
                                      child: Row(
                                        children: [
                                          SizedBox(width: 8),
                                          SizedBox(width: 70,
                                              child: Text('Credit :', style: TextStyle(fontSize: 12,color: Colors.grey[700],fontFamily: 'OpenSans'))),
                                          // Quantity Text
                                          Row(
                                            children: [
                                              Text('${sale.retiCrQty ?? 0}',  style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                                              SizedBox(width: 5),
                                              Icon(Icons.currency_rupee,size: 12,),
                                              Text('${sale.retiCrAmt ?? 0}', style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                                            ],
                                          ),

                                          // Amount Text

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Expand/Collapse row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(_isExpanded
                                        ? "View Less .."
                                        : "View More ..",style: TextStyle(color:Color(0xff1280b3),fontFamily: 'OpenSans',fontSize: 14),),
                                    Icon(
                                      _isExpanded ? Icons.arrow_drop_up : Icons
                                          .arrow_drop_down,
                                      color:Color(0xff1280b3),
                                    ),
                                  ],
                                ),
                              ),
                              // ElevatedButton(onPressed: (){
                              //   // Navigator.pushReplacementNamed(context, '/managerUpdateSaleScreen');
                              //
                              //   Navigator.pushNamed(
                              //       context,
                              //       ManagerUpdateSaleScreen
                              //           .screenName,
                              //       arguments: {
                              //         "delBoyName": sale.staffName,
                              //         "receiptNo": "",
                              //         "receiptDate" : sale.delDate,
                              //         "delBoyId" : sale.dMId,
                              //          "saledgkID" : sale.saleGKId,
                              //         "vehicleNo": sale.vehicleNo,
                              //         "vehicleID" : sale.vehicleId,
                              //       });
                              //
                              // }, child: Text("Update",style: TextStyle(
                              //   color: Colors.white,
                              //   fontFamily: 'OpenSans',
                              //   fontSize: 12, // Size = 14-- [14/8.66] = 1.6
                              // )),
                              //   style: ButtonStyle(
                              //     backgroundColor:
                              //     MaterialStateProperty.all<Color>(const Color(0xff1280b3)),
                              //
                              //   ),
                              // ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap:() {
                                        Navigator.pushNamed(
                                            context,
                                            ManagerUpdateSaleScreen
                                                .screenName,
                                            arguments: {
                                              "delBoyName": sale.staffName,
                                              "receiptNo": "",
                                              "receiptDate" : sale.delDate,
                                              "delBoyId" : sale.dMId,
                                               "saledgkID" : sale.saleGKId,
                                              "vehicleNo": sale.vehicleNo,
                                              "vehicleID" : sale.vehicleId,
                                            });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text("Update",style: Styling.blueClrTextWithUnderline
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  GestureDetector(
                                    onTap:() {
                                      // Navigator.pushNamed(
                                      //     context,
                                      //     ManagerUpdateSaleScreen
                                      //         .screenName,
                                      //     arguments: {
                                      //       "delBoyName": sale.staffName,
                                      //       "receiptNo": "",
                                      //       "receiptDate" : sale.delDate,
                                      //       "delBoyId" : sale.dMId,
                                      //       "saledgkID" : sale.saleGKId,
                                      //       "vehicleNo": sale.vehicleNo,
                                      //       "vehicleID" : sale.vehicleId,
                                      //     });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text("Correction",style: Styling.blueClrTextWithUnderline
                                      ),
                                    ),
                                  ),
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
