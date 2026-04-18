
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ConstantScreen/widgets.dart';
import '../Utils/CustomAppBarManager.dart';
import '../Utils/Styling.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import 'CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';
import 'GetDesignationListModel.dart';
import 'GetPageActionPermissionDtlsMob.dart';
import 'ReceiptRegulatorScreen/GetItemMasterListRegulatorListModel.dart';
import 'SVSaleModel/GetRSPDetailsListModel.dart';

class Configurationscreen extends StatefulWidget {
  static const screenName = '/configurationScreen';
  const Configurationscreen({super.key});

  @override
  State<Configurationscreen> createState() => _ConfigurationscreenState();
}

class _ConfigurationscreenState extends State<Configurationscreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool saveFlag = false;
  List<CahsDenominationMandatoryFlagModel> itemDetailModel = [];
  CahsDenominationMandatoryFlagModel? selectedRegulatorItemReceived;
  String? selectedPermossion;
  List<GetRspDetailsListModel> getrsplistmodel = [];
  GetRspDetailsListModel? selectedItemNameForDiscount;
  List<GetDesignationListModel> getdesignationListmodel = [];
  GetDesignationListModel? selecteddesignation;
  int? selectedItemIdForDiscount;
  String? selectedItem;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  TextEditingController invoiceNumberController = TextEditingController();
  TextEditingController discountLimitController = TextEditingController();
  int? selectedItemId;
  String? selectedItemName;
  List<String> regulatorReceived = ["Yes", "No"];
  String? selectedRegulatorReceived;
  var argValue;
  String? flag;
  bool isSearchActive = false;
  bool isEditMode = false;
  bool isLoading = true;
  List<String> invoiceTypeOptions = ["Auto", "Manual"];
  String? selectedInvoiceType;
  String? modes;
  int? pkIdEdit;
  bool isInvoiceNumberEditable = true; // flag to control TextField
  String? originalAutoInvoiceNo;
  String? previousInvoiceType;
  String? originalInvoiceType; // from backend / arguments





  @override
  void initState() {
    super.initState();
    GetItemMasterListRegulatorList();
    getRspDetailsListModel();
    getDesignationList();
    //checkAndSaveDayEndData();

    Future.delayed(Duration.zero, ()  async {
      argValue = ModalRoute.of(context)?.settings.arguments as Map?;
      modes = argValue?["modeChange"] ?? '';
      if (argValue != null) {
        final itemsToShow = argValue["itemsToShow"] ?? [];
        pkIdEdit = int.tryParse(argValue["pkIdV"] ?? '') ?? 0;
        String permissionforEdit = argValue["permissionforV"]?.toString() ?? '';
        String activeEdit = argValue["activeV"] ?? 0;
        String invoicetypeEdit = argValue["invoiceTypeV"] ?? 0;
        String invoiceNoEdit = argValue["invoiceNumberV"]?.toString() ?? '';
        String itemIdEdit = argValue["itemIdV"] ?? 0;
        String itemNameEdit = argValue["itemNameV"] ?? 0;
        String discountEdit = argValue["discountV"] ?? 0;


        discountLimitController.text = discountEdit;
        //
        // originalAutoInvoiceNo = invoiceNoEdit;
        //
        // selectedInvoiceType = invoicetypeEdit;
        //
        //
        // if (selectedInvoiceType == "Manual") {
        //   isInvoiceNumberEditable = true;
        //   invoiceNumberController.text = invoiceNoEdit ?? '';
        // } else {
        //   isInvoiceNumberEditable = false;
        //   invoiceNumberController.text = originalAutoInvoiceNo ?? '';
        // }


        setState(() {
          originalInvoiceType = invoicetypeEdit; // type from backend
          selectedInvoiceType = invoicetypeEdit;
          previousInvoiceType = selectedInvoiceType;

          originalAutoInvoiceNo = invoiceNoEdit;

          // INITIAL ENABLE/DISABLE BASED ON ORIGINAL TYPE
          if (originalInvoiceType == "Manual") {
            isInvoiceNumberEditable = true;
            invoiceNumberController.text = invoiceNoEdit ?? '';
          } else {
            // Auto → initially disabled
            isInvoiceNumberEditable = false;
            invoiceNumberController.text = originalAutoInvoiceNo ?? '';
          }
        });

        // selectedRegulatorReceived = activeEdit;

        selectedRegulatorReceived =
        // activeEdit == "Yes" ? 1 : 0;
        activeEdit == "1" ? "Yes" : "No";


        await getDesignationList();
        await getDesignationList().whenComplete((){
          debugPrint("permissionforEdit:$permissionforEdit");
          if(permissionforEdit != "null" && permissionforEdit.isNotEmpty && permissionforEdit != null){
            setState(() {
              selecteddesignation = getdesignationListmodel.firstWhere(
                    (item) => item.masterName == permissionforEdit,
                orElse: () => GetDesignationListModel(masterName: ''),
              );

              selectedItemName = permissionforEdit;



            }
            );
          }
        });

        await getRspDetailsListModel();
        await getRspDetailsListModel().whenComplete((){
          debugPrint("ItemIdEdit:$itemIdEdit");

          if (itemIdEdit != "null" && itemIdEdit.isNotEmpty && itemIdEdit != null) {
            setState(() {
              selectedItemNameForDiscount = getrsplistmodel.firstWhere(
                    (item) => item.itemId.toString() == itemIdEdit.toString(),
                orElse: () => GetRspDetailsListModel(itemName: ''), // dummy object
              );

              selectedItem = itemNameEdit;
              selectedItemIdForDiscount = selectedItemNameForDiscount?.itemId?.toInt();

            });
          }
        });
      }
    });

  }

  Future<void> _onRefresh() async {
    GetItemMasterListRegulatorList();
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
          key: _scaffoldKey,
          appBar: CustomAppBarManager(
            title: 'Configuration',
          ),
          body:
          RefreshIndicator(
            onRefresh: _onRefresh,
            child:
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5, top: 10, bottom: 15),
              child:
              Column(
                children: [
                  Row(
                    children: [
                      /// LEFT SIDE — Permission For
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // DropdownButtonFormField<GetPageActionPermissionDtlsMob>(
                            //   key: formKey1,
                            //   value: selectedRegulatorItemReceived,
                            //   isExpanded: true,
                            //   decoration: const InputDecoration(
                            //     // Remove labelText
                            //   ).copyWith(
                            //     label: RichText(
                            //       text: const TextSpan(
                            //         text: "Permission For ",
                            //         style: TextStyle(
                            //           color: Colors.black, // default label color
                            //           fontSize: 16,
                            //         ),
                            //         children: [
                            //           TextSpan(
                            //             text: "*",
                            //             style: TextStyle(
                            //               color: Colors.red,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            //   items: itemDetailModel.map((item) {
                            //     return DropdownMenuItem<GetPageActionPermissionDtlsMob>(
                            //       value: item,
                            //       child: Text(item.permissionFor ?? "-"),
                            //     );
                            //   }).toList(),
                            //   onChanged: (value) {
                            //     setState(() {
                            //       selectedRegulatorItemReceived = value;
                            //       selectedItemName = value?.permissionFor ?? "";
                            //       selectedPermossion = selectedRegulatorItemReceived
                            //
                            //
                            //       if (selectedItemName != "Invoice Number") {
                            //         selectedInvoiceType = null;
                            //       }
                            //     });
                            //   },
                            // ),
                            DropdownButtonFormField<GetDesignationListModel>(
                              key: formKey1,
                              value: getdesignationListmodel.contains(selecteddesignation) ? selecteddesignation : null,
                              decoration: const InputDecoration(
                                // Remove labelText
                              ).copyWith(
                                label: RichText(
                                  text: const TextSpan(
                                    text: "Permission For ",
                                    style: TextStyle(
                                      color: Colors.black, // default label color
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "*",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              items: getdesignationListmodel
                                  .map((GetDesignationListModel staff) {
                                return DropdownMenuItem<GetDesignationListModel>(
                                  value: staff,
                                  child: Text(staff.masterName ?? "-"),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selecteddesignation = value;
                                  selectedItemName = value?.masterName ?? "";
                                  // selectedPermossion = selecteddesignation

                                  if (selectedItemName != "Invoice Number") {
                                    selectedInvoiceType = null;
                                  }
                                  selectedRegulatorReceived = null;
                                });
                              },
                              isExpanded: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      ///  RIGHT SIDE — Dynamic (Invoice Type OR Active/De-Active)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // If Invoice Number → Show Invoice Type
                            if (selectedItemName == "Invoice Number") ...[
                              DropdownButtonFormField<String>(
                                // value: selectedInvoiceType,
                                  value: invoiceTypeOptions.contains(selectedInvoiceType) ? selectedInvoiceType : null,
                                  decoration: const InputDecoration().copyWith(
                                    label: RichText(
                                      text: const TextSpan(
                                        text: "Invoice Type",
                                        style: TextStyle(color: Colors.black, fontSize: 16),
                                        children: [
                                          TextSpan(
                                            text: "*",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  items: ["Auto", "Manual"].map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList(),
                                  // onChanged: (value) {
                                  //   setState(() {
                                  //     selectedInvoiceType = value;
                                  //   });
                                  // },
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       previousInvoiceType = selectedInvoiceType;
                                  //       selectedInvoiceType = value;
                                  //
                                  //       if (selectedInvoiceType == "Manual") {
                                  //         // Manual is always editable
                                  //         isInvoiceNumberEditable = true;
                                  //
                                  //         // Clear only if coming from Auto
                                  //         if (previousInvoiceType == "Auto") {
                                  //           invoiceNumberController.clear();
                                  //         }
                                  //       } else {
                                  //         // Auto selected
                                  //         // Editable if:
                                  //         // 1️⃣ originally was Auto, OR
                                  //         // 2️⃣ user switched back from Manual but hasn't saved yet
                                  //         if (originalInvoiceType == "Auto" || previousInvoiceType == "Manual") {
                                  //           isInvoiceNumberEditable = true;
                                  //           invoiceNumberController.text = originalAutoInvoiceNo ?? '';
                                  //         } else {
                                  //           isInvoiceNumberEditable = false;
                                  //         }
                                  //       }
                                  //     });
                                  //   }
                                  // onChanged: (value) {
                                  //   setState(() {
                                  //     previousInvoiceType = selectedInvoiceType;
                                  //     selectedInvoiceType = value;
                                  //
                                  //     if (selectedInvoiceType == "Manual") {
                                  //       isInvoiceNumberEditable = true;
                                  //       if (previousInvoiceType == "Auto") {
                                  //         invoiceNumberController.clear();
                                  //       }
                                  //     } else {
                                  //       // Auto selected
                                  //       // Enable if user switched from Manual or original type is Auto
                                  //       if (originalInvoiceType == "Auto" || previousInvoiceType == "Manual") {
                                  //         isInvoiceNumberEditable = true;
                                  //         // invoiceNumberController.text = originalAutoInvoiceNo ?? '';
                                  //         invoiceNumberController.clear();
                                  //       } else {
                                  //         isInvoiceNumberEditable = false;
                                  //       }
                                  //     }
                                  //   });
                                  // }
                                onChanged: (value) {
                                  setState(() {
                                    previousInvoiceType = selectedInvoiceType;
                                    selectedInvoiceType = value;

                                    if (!isEditMode) {
                                      // ADD MODE → always editable
                                      isInvoiceNumberEditable = true;

                                      if (selectedInvoiceType == "Manual") {
                                        invoiceNumberController.clear();
                                      }
                                    } else {
                                      // EDIT MODE
                                      if (selectedInvoiceType == "Manual") {
                                        isInvoiceNumberEditable = true;

                                        if (previousInvoiceType == "Auto") {
                                          invoiceNumberController.clear();
                                        }
                                      } else {
                                        if (originalInvoiceType == "Auto") {
                                          isInvoiceNumberEditable = false;
                                          invoiceNumberController.text =
                                              originalAutoInvoiceNo ?? '';
                                        } else {
                                          isInvoiceNumberEditable = true;
                                        }
                                      }
                                    }
                                  });
                                }),
                            // ),
                            ]
                            // Otherwise → Show Active/De-Active
                            else if (selectedItemName != "Invoice Number" && selectedItemName != "Customer Discount Limit") ...[
                              DropdownButtonFormField<String>(
                                key: formKey2,
                                // value: selectedRegulatorReceived,
                                value: regulatorReceived.contains(selectedRegulatorReceived) ? selectedRegulatorReceived : null,
                                decoration: const InputDecoration().copyWith(
                                  label: RichText(
                                    text: const TextSpan(
                                      text: "Active/De-Active",
                                      style: TextStyle(color: Colors.black, fontSize: 16),
                                      children: [
                                        TextSpan(
                                          text: "*",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                items: regulatorReceived.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedRegulatorReceived = value;
                                  });
                                },
                              ),
                            ],

                            // Dropdown for Customer Discount Limit
                            if (selectedItemName == "Customer Discount Limit") ...[
                              // DropdownButtonFormField<GetRspDetailsListModel?>(
                              //   key: formKey3,
                              //   value: selectedItemNameForDiscount,
                              //   decoration: const InputDecoration().copyWith(
                              //     label: RichText(
                              //       text: TextSpan(
                              //         text: "Item Name",
                              //         style: TextStyle(color: Colors.black, fontSize: 16),
                              //         children: [
                              //           TextSpan(
                              //             text: "*",
                              //             style: TextStyle(color: Colors.red),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              //   items: getrsplistmodel.map((item) {
                              //     return DropdownMenuItem<GetRspDetailsListModel>(
                              //       value: item,
                              //       child: Text(item.itemName ?? ""), // Bind item name safely
                              //     );
                              //   }).toList(),
                              //   onChanged: (value) {
                              //     setState(() {
                              //       selectedItemNameForDiscount = value;
                              //       selectedItemIdForDiscount = value?.itemId?.toInt();
                              //       selectedItem = value?.itemName?.toString();
                              //     });
                              //   },
                              // ),
                              DropdownButtonFormField<GetRspDetailsListModel?>(
                                key: formKey3,
                                // value: selectedItemNameForDiscount, // nullable
                                value: getrsplistmodel.contains(selectedItemNameForDiscount) ? selectedItemNameForDiscount : null,
                                decoration: const InputDecoration().copyWith(
                                  label: RichText(
                                    text: TextSpan(
                                      text: "Item Name",
                                      style: TextStyle(color: Colors.black, fontSize: 16),
                                      children: [
                                        TextSpan(
                                          text: "*",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                items: getrsplistmodel.map((item) {
                                  return DropdownMenuItem<GetRspDetailsListModel>(
                                    value: item,
                                    child: Text(item.itemName ?? ""),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedItemNameForDiscount = value;
                                    selectedItemIdForDiscount = value?.itemId?.toInt();
                                    selectedItem = value?.itemName?.toString();
                                  });
                                },
                              )
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (selectedItemName == "Invoice Number" && selectedInvoiceType == "Auto") ...[
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: invoiceNumberController,
                      enabled: isInvoiceNumberEditable,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: Text.rich(
                          const TextSpan(
                            text: "From Invoice No",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            children: [
                              TextSpan(
                                text: "*",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  // Customer Discount Limit input field
                  if (selectedItemName == "Customer Discount Limit") ...[
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: discountLimitController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // only numbers
                        FilteringTextInputFormatter.deny(RegExp(r'\s')), // no spaces
                      ],
                      decoration: InputDecoration(
                        label: Text.rich(
                          const TextSpan(
                            text: "Discount Limit ",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            children: [
                              TextSpan(
                                text: "*",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.grey,
                      //   ),
                      //   onPressed: () {
                      //     cancelAction();
                      //   },
                      //   child: const Text("Cancel"),
                      // ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle Cancel action
                          cancelAction();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical:
                              10), // Adjust padding to make button smaller
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // cancelAction();
                          // if (saveFlag) {
                          //   print('saveFlag $saveFlag');
                          //   showFlushBar(context, Constants.dayEndCompleted);
                          // } else {
                          if(modes == "EDIT"){
                            updateSVAddEditForMob(context,pkIdEdit!,"EDIT");
                          }else{
                            updateSVAddEditForMob(context,0,"ADD");
                          }
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical:
                              10), // Adjust padding to make button smaller
                        ),
                        child: Text(
                          modes == "EDIT"?'Update':'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: itemDetailModel.isEmpty
                        ? const Center(
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
                            ),
                          ],
                        ),
                      ),
                    )
                        : SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: itemDetailModel.length,
                            itemBuilder: (context, index) {
                              final sale = itemDetailModel[index];

                              String nullToDash(dynamic value) {
                                if (value == null) return "-";
                                final str = value.toString();
                                if (str.toLowerCase() == "null" || str.isEmpty) {
                                  return "-";
                                }
                                return str;
                              }

                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 12),
                                  // child: Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     itemSubLineWithBlackAndBlue(
                                  //       "Active Date",
                                  //       sale.activeDate != null &&
                                  //           sale.activeDate!.isNotEmpty
                                  //           ? DateFormat('dd-MM-yyyy').format(
                                  //           DateTime.parse(sale.activeDate!))
                                  //           : "-",
                                  //     ),
                                  //     itemSubLine(
                                  //       "Permission For",
                                  //       nullToDash(sale.permissionFor),
                                  //     ),
                                  //     itemSubLine(
                                  //       "From Invoice No",
                                  //       nullToDash(sale.fromInvoiceNo),
                                  //     ),
                                  //     itemSubLine(
                                  //       "To Date",
                                  //       sale.activeDate != null &&
                                  //           sale.activeDate!.isNotEmpty
                                  //           ? DateFormat('dd-MM-yyyy').format(
                                  //           DateTime.parse(sale.activeDate!))
                                  //           : "-",
                                  //     ),
                                  //     Align(
                                  //       alignment: Alignment.centerRight,
                                  //       child: IconButton(
                                  //         icon: const Icon(Icons.edit, color: Colors.blue),
                                  //         onPressed: () {},
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      // Row(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     Expanded(
                                      //       child: itemSubLineWithBlackAndBlue(
                                      //         "Active Date",
                                      //         sale.activeDate != null &&
                                      //             sale.activeDate!.isNotEmpty
                                      //             ? DateFormat('dd-MM-yyyy')
                                      //             .format(DateTime.parse(sale.activeDate!))
                                      //             : "-",
                                      //       ),
                                      //     ),
                                      //     IconButton(
                                      //       icon: const Icon(Icons.edit, color: Colors.blue),
                                      //       onPressed: () {},
                                      //     ),
                                      //   ],
                                      // ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(flex:1,child: countTextWidgetText(context,"Active Date",
                                            sale.activeDate != null &&
                                                sale.activeDate!.isNotEmpty
                                                ? DateFormat('dd/MM/yyyy')
                                                .format(DateTime.parse(sale.activeDate!))
                                                : "-",
                                          ),
                                          ),
                                          //sale.activeDate ?? '')),
                                          Expanded(
                                            flex: 0,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,  // Align the icons to the right
                                              children: [
                                                // Edit Icon
                                                // IconButton(
                                                //   icon: Icon(Icons.edit, color: Colors.blue),  // Icon for edit
                                                //   onPressed: () {
                                                //   },
                                                // ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {

                                                      var pkid= sale.pkId.toString();
                                                      var permissionFor= sale.permissionFor.toString();
                                                      var isActive = sale.isActive.toString();
                                                      var invoiceType = sale.invoiceType.toString();
                                                      var fromInvoice = sale.fromInvoiceNo.toString();
                                                      var itemId = sale.itemId.toString();
                                                      var itemName = sale.itemName.toString();
                                                      // var discountLimit = sale.discount.toString();
                                                      var discountLimit = sale.discount?.toInt().toString();

                                                      if (saveFlag) {
                                                        print('saveFlag $saveFlag');
                                                        showFlushBar(context, Constants.dayEndCompleted);
                                                      } else {
                                                        Navigator.pushNamed(
                                                          context,
                                                          Configurationscreen.screenName,
                                                          arguments: {
                                                            'pkIdV': pkid,
                                                            'permissionforV': permissionFor,
                                                            'activeV': isActive,
                                                            'invoiceTypeV': invoiceType,
                                                            'invoiceNumberV' : fromInvoice,
                                                            'itemIdV' : itemId,
                                                            'itemNameV': itemName,
                                                            'discountV': discountLimit,
                                                            'modeChange': "EDIT"
                                                          },
                                                        );
                                                      }
                                                    });
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(2), // small tap area
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Colors.blue,
                                                      size: 22,
                                                    ),
                                                  ),
                                                ),
                                                // IconButton(
                                                //   icon: const Icon(Icons.edit, color: Colors.blue),
                                                //   padding: EdgeInsets.zero,
                                                //   constraints: const BoxConstraints(),
                                                //   // icon: Icon(Icons.edit, color: Colors.blue),  // Icon for edit
                                                //   onPressed: () {
                                                //     setState(() {
                                                //
                                                //       var pkid= sale.pkId.toString();
                                                //       var permissionFor= sale.permissionFor.toString();
                                                //       var isActive = sale.isActive.toString();
                                                //       var invoiceType = sale.invoiceType.toString();
                                                //       var fromInvoice = sale.fromInvoiceNo.toString();
                                                //       var itemId = sale.itemId.toString();
                                                //       var itemName = sale.itemName.toString();
                                                //       // var discountLimit = sale.discount.toString();
                                                //       var discountLimit = sale.discount?.toInt().toString();
                                                //
                                                //       if (saveFlag) {
                                                //         print('saveFlag $saveFlag');
                                                //         showFlushBar(context, Constants.dayEndCompleted);
                                                //       } else {
                                                //         Navigator.pushNamed(
                                                //           context,
                                                //           Configurationscreen.screenName,
                                                //           arguments: {
                                                //             'pkIdV': pkid,
                                                //             'permissionforV': permissionFor,
                                                //             'activeV': isActive,
                                                //             'invoiceTypeV': invoiceType,
                                                //             'invoiceNumberV' : fromInvoice,
                                                //             'itemIdV' : itemId,
                                                //             'itemNameV': itemName,
                                                //             'discountV': discountLimit,
                                                //             'modeChange': "EDIT"
                                                //           },
                                                //         );
                                                //       }
                                                //     });
                                                //   },
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Expanded(flex:1,child: countTextWidgetText(context,"Permission For", sale.permissionFor ?? '')),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          // Expanded(flex:1,child: countTextWidgetText(context,"Active/Item Name/Invoice Type", sale.invoiceType ?? '')),
                                          Expanded(
                                            flex: 1,
                                            child: countTextWidgetText(
                                              context,
                                              "Active/Item Name/Invoice Type",
                                              // getDisplayValue(sale),
                                              sale.invoiceType != null && sale.invoiceType.toString().isNotEmpty
                                                  ? (sale.invoiceType.toString() == "Auto" &&
                                                  sale.fromInvoiceNo != null &&
                                                  sale.fromInvoiceNo.toString().isNotEmpty
                                                  ? "Auto(${sale.fromInvoiceNo})"
                                                  : sale.invoiceType.toString())
                                                  : (sale.itemName != null && sale.itemName.toString().isNotEmpty
                                                  ? sale.itemName.toString()
                                                  : (sale.isActive != null
                                                  ? (sale.isActive == 1 ? "Yes" : "No")
                                                  : "N/A")),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          // Expanded(flex:1,child: countTextWidgetText(context,"Discount limit amount", sale.discount.toString() ?? 'N/A')),
                                          Expanded(
                                            flex: 1,
                                            child: countTextWidgetText(
                                              context,
                                              "Discount Limit Amount",
                                              (sale.discount == null || sale.discount == 0 || sale.discount == 0.0)
                                                  ? "N/A"
                                              // : sale.discount.toString(),
                                                  : sale.discount!.toInt().toString(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  String getDisplayValue(dynamic sale) {
    //  Invoice Type
    if (sale.invoiceType != null &&
        sale.invoiceType.toString().isNotEmpty) {
      return sale.invoiceType.toString();
    }

    // if (sale.invoiceType?.toString().isNotEmpty ?? false) {
    //   String type = sale.invoiceType.toString();
    //
    //   if (type == "Auto" &&
    //       sale.invoiceNo?.toString().isNotEmpty == true) {
    //     return "$type - ${sale.invoiceNo}";
    //   }
    //
    //   return type;
    // }

    // Item Name
    if (sale.itemName != null &&
        sale.itemName.toString().isNotEmpty) {
      return sale.itemName.toString();
    }

    // Active Status
    if (sale.isActive != null) {
      return sale.isActive == 1 ? "Yes" : "No";
    }

    // Default
    return "N/A";
  }

  Future<void> GetItemMasterListRegulatorList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? itemSubType = prefs.getString('ItemSubType');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
      "ItemSubType": itemSubType,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetPageActionPermissionDtls}/$distributorId/ALL'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );

    debugPrint("Response GetPageActionPermissionDtls: ${response.body}");
    debugPrint("requesr GetPageActionPermissionDtls: ${response.request}");
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        itemDetailModel = data.map((json) {
          return CahsDenominationMandatoryFlagModel.fromJson(json);
        }).toList();

        // if (itemDetailModel.isNotEmpty) {
        //   selectedRegulatorItemReceived = itemDetailModel.first;
        //   selectedItemId = selectedRegulatorItemReceived?.itemId?.toInt();
        //   selectedItemName = selectedRegulatorItemReceived?.itemName ?? 'Unknown';
        // }
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> checkAndSaveDayEndData() async {
    EasyLoading.instance
      ..maskType =
          EasyLoadingMaskType.black // This creates a modal blocking interaction
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false // Disable dismissing the loader by tapping
      ..userInteractions = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    int? distributorIds = int.parse(distributorId!);
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
          // Pass bearer token in headers
        },
      );
      debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
      debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
      if (response.statusCode == 200) {
        List<dynamic> apiResponse = json.decode(response.body);
        if (apiResponse.isEmpty) {
          saveFlag = false;
          print("The list is empty, no data to save.");
        } else {
          saveFlag = true;
          var dayEndData = apiResponse[0];
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> getRspDetailsListModel() async {
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
      Uri.parse('${AppUrl.GetRSPDetailsList}/$distributorId/TODAY'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetARBItemMasterList : " +
        '${AppUrl.GetRSPDetailsList}/$distributorId/TODAY');
    debugPrint("GetARBItemMasterList : " + '${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        getrsplistmodel = data.map((json) => GetRspDetailsListModel.fromJson(json)).toList();

        EasyLoading.dismiss();
      });

    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getDesignationList() async {
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
      Uri.parse('${AppUrl.GetDesignationList}/1/PermissionFor'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetDesignationList : " +
        '${AppUrl.GetDesignationList}/1/PermissionFor');
    debugPrint("GetDesignationList : " + '${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        getdesignationListmodel = data.map((json) => GetDesignationListModel.fromJson(json)).toList();

        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> updateSVAddEditForMob(BuildContext context,int psvID, String actionMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? addedBy = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    int? addedBys = int.parse(addedBy!);
    int? distributorIds = int.parse(distributorId!);
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now); int scRegulators = 0;

    int? isActive;
    double? discountAmount;
    String? invoiceController;

    // active/de-Active
    // isActive = selectedRegulatorReceived == "Yes" ? 1 : 0;

    if (selectedItemName == "Invoice Number" ||
        selectedItemName == "Customer Discount Limit") {
      isActive = null; // Save as empty
    }  else {
      // For other items, first check if selectedRegulatorReceived is null or empty
      if (selectedRegulatorReceived == null || selectedRegulatorReceived!.isEmpty) {
        showFlushBar(context, "Please Select Active/Inactive");
        return;
      }

      // Then assign isActive
      isActive = selectedRegulatorReceived == "Yes" ? 1 : 0;
    }


    if (discountLimitController.text.isNotEmpty) {
      discountAmount = double.tryParse(discountLimitController.text);
    }

    // if (invoiceNumberController.text.isNotEmpty) {
    //   invoiceController = invoiceNumberController.text;
    // }

    if (selectedInvoiceType == "Manual") {
      invoiceController = null; // or ""
    } else {
      invoiceController = invoiceNumberController.text;
    }

    if (selectedItemName == null || selectedItemName!.isEmpty)
    {
      showFlushBar(context, "Please Select Permission for");
      return;
    }

    if (selectedItemName == "Customer Discount Limit") {

      if (selectedItem == null || selectedItem!.isEmpty) {
        showFlushBar(context, "Please Select Item");
        return;
      }

      if (discountLimitController.text.isEmpty) {
        showFlushBar(context, "Please Enter Discount Limit");
        return;
      }
      if (discountAmount == null || discountAmount <= 0) {
        showFlushBar(context, "Discount Limit Amount Should Be Greater Than Zero");
        return;
      }

    }

    if (selectedItemName == "Customer Discount Limit") {

      if (selectedItem == null || selectedItem!.isEmpty) {
        showFlushBar(context, "Please Select Item");
        return;
      }

      if (discountLimitController.text.isEmpty) {
        showFlushBar(context, "Please Enter Discount Limit");
        return;
      }
      if (discountAmount == null || discountAmount <= 0) {
        showFlushBar(context, "Discount Limit Amount Should Be Greater Than Zero");
        return;
      }

    }
    if (selectedItemName == "Invoice Number") {

      // Invoice type must be selected
      if (selectedInvoiceType == null || selectedInvoiceType!.isEmpty) {
        showFlushBar(context, "Please Select Invoice Type");
        return;
      }

      // If Auto → invoice number required
      if (selectedInvoiceType == "Auto" &&
          invoiceNumberController.text.isEmpty) {
        showFlushBar(context, "Please Enter From Invoice Number");
        return;
      }

    }

    // if (selectedItemName == "Customer Discount Limit"){
    //   if (!selectedItem!.isNotEmpty) {
    //     showFlushBar(context, "Please Select Item");
    //     return;
    //   }
    //   if (!discountLimitController.text.isNotEmpty) {
    //     showFlushBar(context, "Please Enter Discount Amount");
    //     return;
    //   }
    //   double? discountAmount = double.tryParse(discountLimitController.text);
    //
    //   if (discountAmount == null || discountAmount <= 0) {
    //     showFlushBar(context, "Discount Limit Amount Should Be Greater Than Zero");
    //     return;
    //   }
    // }

    final Map<String, dynamic> requestBody = {
      "pkId": psvID,
      "DistributorId": distributorIds,
      "PermissionFor": selectedItemName,
      "DescriptionText": selectedItemName,
      "IsActive": isActive ?? '',
      "ItemId": selectedItemIdForDiscount ?? 0,
      "Discount": discountAmount ?? 0.0,
      "InvoiceType": selectedInvoiceType ?? '',
      "FromInvoiceNo": invoiceController ?? '',
      "Action": actionMode
    };

    print("DepositCashAddEdit: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.PageActionPermissionAdd}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    // print("response UpdateSaleAddEditForMob: ${response.statusCode} - ${response.body}");
    print(
        "requestBody PageActionPermissionAdd: ${response.statusCode} - ${response.request}${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    print("Response PageActionPermissionAdd: ${response.body}");
    // Handling response
    if (response.statusCode == 200) {
      if(response == -1 || response.body == -1 || response == "-1" || response.body == "-1"){
        EasyLoading.showToast(Constants.expenseExistMgr,
            duration: const Duration(milliseconds: 3000));
      }else if(response == 0 || response.body == 0 || response == "0" || response.body == "0"){
        EasyLoading.showToast(Constants.failToInserRecord,
            duration: const Duration(milliseconds: 3000));
      }else{
        Future.delayed(Duration(milliseconds: 300), () {
          if(actionMode == "EDIT") {
            EasyLoading.showToast(
              Constants.expenseSendMgrEdit,
              duration: const Duration(milliseconds: 3000),
            );
          }else {
            EasyLoading.showToast(
              Constants.expenseSendMgr,
              duration: const Duration(milliseconds: 3000),
            );
          }
        });
        Navigator.pushNamed(
          context,
          Configurationscreen.screenName,
          //arguments: 3, // This opens the third tab
        );
        setState(() {
          GetItemMasterListRegulatorList();
        });
      }
    } else {
      // Error response
      print("Error PageActionPermissionAdd: ${response.statusCode} - ${response.body}");
    }
  }

  void cancelAction() {
    setState(() {
      Navigator.pop(context);
      Navigator.pushNamed(
          context,
          Configurationscreen.screenName // This opens the third tab
      );
    });
  }

// String formatCurrency(double amount) {
//   if (amount == 0) {
//     return '0.00'; // Return "0.00" if the amount is zero
//   }
//   final format = NumberFormat('#,##,###.00', 'en_IN'); // Indian locale with comma separator
//
//   // Ensure the result always shows a leading zero before the decimal point
//   String formattedAmount = format.format(amount);
//
//   // If there's no integer part, it ensures that a leading zero is added before decimal
//   if (amount < 1 && formattedAmount.startsWith('.')) {
//     formattedAmount = '0' + formattedAmount;
//   }
//
//   return formattedAmount;
// }
}