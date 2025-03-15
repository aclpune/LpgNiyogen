import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantScreen/widgets.dart';
import '../Utils/CustomAppBar.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import '../Utils/size_config.dart';
import 'ManagerModelClass/DailySaleSaummaryListModel.dart';
import 'package:http/http.dart' as http;

import 'ManagerSingleItemUI/DeliveryBoyWiseListItem.dart';
class DeliveryBoyWiseListShow extends StatefulWidget {
  static const screenName = '/deliveryBoyWiseListShow';
  const DeliveryBoyWiseListShow({super.key});

  @override
  State<DeliveryBoyWiseListShow> createState() => _DeliveryBoyWiseListShowState();
}

class _DeliveryBoyWiseListShowState extends State<DeliveryBoyWiseListShow> {
  TextEditingController searchController = TextEditingController();
  List<DailySaleSaummaryListModel> dailySales = [];
  List<DailySaleSaummaryListModel> filteredSales = []; // List for filtered results

  bool _isExpanded = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchDailySales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      CustomAppBar(
        title: 'Daily Sale Summary', // Title or hint text for the text field
      ),
      body:
      Scaffold(
        body:isLoading?Center(child: CircularProgressIndicator()):
        // SingleChildScrollView(
        //   padding: const EdgeInsets.all(8.0),
        //   child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              //   child: TextField(
              //     controller: searchController,
              //     decoration: InputDecoration(
              //       labelText: 'Search',
              //       border: OutlineInputBorder(),
              //       prefixIcon: Icon(Icons.search),
              //     ),
              //     onChanged: (value) => filterSearchResults(value),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: Colors.black,fontFamily: 'OpenSans',fontSize: 14),
                    autofocus: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search",
                      hintStyle: TextStyle(
                          fontSize:
                          14, // Size = 16-- [18/8.66] = 2.07
                          fontFamily: 'OpenSans'),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 18,),
                      /*enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade100, width: 0.0)),*/
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                    ),
                    onChanged: (value) {
                      filterSearchResults(value);
                      debugPrint("SearchVal: " + value.toString());
                    },
                  ),
                ),
              ),

              Expanded(
                child: filteredSales.isNotEmpty?
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredSales.length,
                  itemBuilder: (context, index) {
                    var sale = filteredSales[index]; // Access the current item
                    return DeliveryBoyWiseListItem(
                        filteredSales[index]);
                    //   Card(
                    //   elevation: 5,
                    //   margin: EdgeInsets.all(8),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 12.0, vertical: 12),
                    //     child: Column(
                    //       children: [
                    //         // Date and Weight Row with icons
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Row(
                    //               children: [
                    //                 Text(sale.staffName ?? '', style: TextStyle(
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.bold,color:  Color(0xff1280b3), fontFamily: 'OpenSans')),
                    //               ],
                    //             ),
                    //             Row(
                    //               children: [
                    //                 Icon(Icons.currency_rupee, size: 16,
                    //                     color: Colors.grey),
                    //                 SizedBox(width: 5),
                    //                 Text('${sale.totalAmt ?? 0}',
                    //                     style: TextStyle(fontSize: 14,
                    //                         fontFamily: 'OpenSans',color: Colors.black)),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(height: 5),
                    //         // Data values Row with icons
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Row(
                    //               children: [
                    //                 Text('Refill: ', style: TextStyle(
                    //                     fontSize: 14,fontFamily: 'OpenSans',color: Colors.grey[700])),
                    //                 Text('${sale.totalFilledQty ?? 0}',
                    //                     style: TextStyle(fontSize: 14,fontFamily: 'OpenSans')),
                    //               ],
                    //             ),
                    //             Row(
                    //               children: [
                    //                 Text('TV: ', style: TextStyle(fontSize: 14,fontFamily: 'OpenSans',color: Colors.grey[700])),
                    //                 Text('${sale.totalTVQty ?? 0}',
                    //                     style: TextStyle(fontSize: 14,fontFamily: 'OpenSans')),
                    //               ],
                    //             ),
                    //             Row(
                    //               children: [
                    //                 Text('SV: ', style: TextStyle(fontSize: 14,fontFamily: 'OpenSans',color: Colors.grey[700])),
                    //                 Text('${sale.totalSVQty ?? 0}',
                    //                     style: TextStyle(fontSize: 14,fontFamily: 'OpenSans')),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //         // Expandable section
                    //         Visibility(
                    //           visible: _isExpanded,
                    //           child: Column(
                    //             children: [
                    //               SizedBox(height: 10,),
                    //               // First Row: Cash and Prepaid
                    //               Row(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //                 children: [
                    //                   // Cash Section
                    //                   Expanded(
                    //                     child: Row(
                    //                       children: [
                    //                         SizedBox(width: 8),
                    //                         SizedBox(width: 70,
                    //                             child: Text('Cash :', style: TextStyle(fontSize: 12,color: Colors.grey[700],fontFamily: 'OpenSans'))),
                    //                         // Quantity Text
                    //                         Row(
                    //                           children: [
                    //                             Text('${sale.cashQty ?? 0}', style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                    //                             SizedBox(width: 5),
                    //                             // Amount Text
                    //                             Icon(Icons.currency_rupee,size: 12,),
                    //                             Text('${sale.cashAmt ?? 0}', style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                    //                           ],
                    //                         ),
                    //
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   SizedBox(width: 5),
                    //                   Container(
                    //                     width: 1.0, // Width of the vertical line
                    //                     height: 20.0, // Height of the vertical line
                    //                     color: Colors.black, // Color of the line
                    //                   ),
                    //                   // Prepaid Section
                    //                   Expanded(
                    //                     child: Row(
                    //                       children: [
                    //                         SizedBox(width: 8),
                    //                         SizedBox(width: 70,
                    //                             child: Text('Prepaid :', style: TextStyle(fontSize: 12,color: Colors.grey[700],fontFamily: 'OpenSans'))),
                    //                         // Quantity Text
                    //                         Row(
                    //                           children: [
                    //                             Text('${sale.prepaidQty ?? 0}',  style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                    //                             SizedBox(width: 5),
                    //                             Icon(Icons.currency_rupee,size: 12,),
                    //                             Text('${sale.prepaidAmt ?? 0}', style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                    //                           ],
                    //                         ),
                    //
                    //                         // Amount Text
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //
                    //               SizedBox(height: 5), // Space between rows
                    //               // Second Row: Post and Credit
                    //               Row(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   // Post Section
                    //                   Expanded(
                    //                     child: Row(
                    //                       children: [
                    //                         SizedBox(width: 8),
                    //                         SizedBox(width: 70,
                    //                             child: Text('Postpaid :', style: TextStyle(fontSize: 12,color: Colors.grey[700],fontFamily: 'OpenSans'))),
                    //                         // Quantity Text
                    //                         Row(
                    //                           children: [
                    //                             Text('${sale.postPaidQty ?? 0}', style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                    //                             SizedBox(width: 5),
                    //                             Icon(Icons.currency_rupee,size: 12,),
                    //                             Text('${sale.postPaidAmt ?? 0}',  style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                    //
                    //                           ],
                    //                         ),
                    //
                    //                         // Amount Text
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   SizedBox(width: 5),
                    //                   Container(
                    //                     width: 1.0, // Width of the vertical line
                    //                     height: 20.0, // Height of the vertical line
                    //                     color: Colors.black, // Color of the line
                    //                   ),
                    //                   // Credit Section
                    //                   Expanded(
                    //                     child: Row(
                    //                       children: [
                    //                         SizedBox(width: 8),
                    //                         SizedBox(width: 70,
                    //                             child: Text('Credit :', style: TextStyle(fontSize: 12,color: Colors.grey[700],fontFamily: 'OpenSans'))),
                    //                         // Quantity Text
                    //                         Row(
                    //                           children: [
                    //                             Text('${sale.retiCrQty ?? 0}',  style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                    //                             SizedBox(width: 5),
                    //                             Icon(Icons.currency_rupee,size: 12,),
                    //                             Text('${sale.retiCrAmt ?? 0}', style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'OpenSans')),
                    //                           ],
                    //                         ),
                    //
                    //                         // Amount Text
                    //
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         // Expand/Collapse row
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             GestureDetector(
                    //               onTap: () {
                    //                 setState(() {
                    //                   _isExpanded = !_isExpanded;
                    //                 });
                    //               },
                    //               child: Row(
                    //                 children: [
                    //                   Text(_isExpanded
                    //                       ? "View Less .."
                    //                       : "View More ..",style: TextStyle(color:Color(0xff1280b3),fontFamily: 'OpenSans',fontSize: 14),),
                    //                   Icon(
                    //                     _isExpanded ? Icons.arrow_drop_up : Icons
                    //                         .arrow_drop_down,
                    //                     color:Color(0xff1280b3),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             ElevatedButton(onPressed: (){
                    //               Navigator.pushReplacementNamed(
                    //                   context, '/managerUpdateSaleScreen');
                    //             }, child: Text("Update",style: TextStyle(
                    //               color: Colors.white,
                    //               fontFamily: 'OpenSans',
                    //               fontSize: 12, // Size = 14-- [14/8.66] = 1.6
                    //             )),
                    //               style: ButtonStyle(
                    //                 backgroundColor:
                    //                 MaterialStateProperty.all<Color>(const Color(0xff1280b3)),
                    //
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // );
                  },
                ):
                Center(child: Text("No Data Available")),
              ),
            ],
          ),
        ),
      // ),
    );
  }

  Future<void> fetchDailySales() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context,
          Constants.connectionMessage);
      isLoading = false;
    }else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse(
              '${AppUrl.GetDailySaleSummaryListDMWiseForMob}/$distributorId/0'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body GetDailySaleSummaryListDMWiseForMob: ${response.body}");
        debugPrint("request body GetDailySaleSummaryListDMWiseForMob: ${response.request}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          // return data
          //     .map((jsonItem) => DailySaleSaummaryListModel.fromJson(jsonItem))
          //     .toList();
          setState(() {
            dailySales = data.map((jsonItem) =>
                DailySaleSaummaryListModel.fromJson(jsonItem)).toList();
            filteredSales = dailySales;
            isLoading = false;
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredSales = dailySales;
      });
    } else {
      setState(() {
        filteredSales = dailySales
            .where((sale) =>
        sale.staffName!.toLowerCase().contains(query.toLowerCase()) ||
            sale.totalAmt.toString().contains(query) ||
            sale.totalFilledQty.toString().contains(query) ||
        sale.totalTVQty.toString().contains(query) ||
        sale.totalSVQty.toString().contains(query))
            .toList();
      });
    }
  }
}
