import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../newTheam/core/theme/app_colors.dart';
import '../../newTheam/core/theme/app_typography.dart';
import '../ConstantScreen/widgets.dart';
import '../Utils/CustomAppBar.dart';
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
  final bool disableNetworkCallsForTest;

  const Configurationscreen({super.key, this.disableNetworkCallsForTest = false});

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
    if (widget.disableNetworkCallsForTest) {
      return;
    }
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

  // ── Themed Input Decoration ────────────────────────────────────────────
  InputDecoration _themedInputDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      label: Text.rich(
        TextSpan(
          text: label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.red),
            ),
          ],
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.blue, width: 1.8),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border.withOpacity(0.5), width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.bg2,
        // AppBar: CustomAppBar("Configuration");
          appBar: CustomAppBarManagerr(title: 'Configuration Settings'),
        body: RefreshIndicator(
          color: AppColors.blue,
          backgroundColor: AppColors.white,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            slivers: [
              // ── Hero Strip ────────────────────────────────────────────
           //   SliverToBoxAdapter(child: _buildConfigHeroStrip()),

              // ── Form Card ─────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: _buildFormCard(),
                ),
              ),

              // ── Section header ────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.teal,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'CONFIGURATION LIST',
                        style: AppTypography.sectionHeader,
                      ),
                    ],
                  ),
                ),
              ),

              // ── List ──────────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: itemDetailModel.isEmpty
                    ? SliverToBoxAdapter(
                        child: _buildEmptyState(),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final sale = itemDetailModel[index];
                            return _buildConfigCard(sale);
                          },
                          childCount: itemDetailModel.length,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero Strip ─────────────────────────────────────────────────────────────
  Widget _buildConfigHeroStrip() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradHero),
      child: Stack(
        children: [
          Positioned(
            top: -40, right: -60,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -30, left: -20,
            child: Container(
              width: 130, height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tealLight.withOpacity(0.10),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, '/bottomNavBarExample');
                    },
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.26), width: 1.2),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          modes == "EDIT"
                              ? 'Edit Configuration'
                              : 'Configuration',
                          style: AppTypography.heroTitle,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Manage system settings & permissions',
                          style: AppTypography.heroSubtitle,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.28), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.settings_rounded,
                            color: Colors.white70, size: 13),
                        const SizedBox(width: 5),
                        Text(
                          modes == "EDIT" ? 'EDIT' : 'ADD',
                          style: AppTypography.badgeText
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Form Card ──────────────────────────────────────────────────────────────
  Widget _buildFormCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D1E3A8A), blurRadius: 14, offset: Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.blueXL,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tune_rounded,
                      color: AppColors.blue, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  modes == "EDIT" ? 'Edit Permission' : 'Add Permission',
                  style: AppTypography.cardTitle,
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 18),

            // ── Permission For dropdown ────────────────────────────────
            DropdownButtonFormField<GetDesignationListModel>(
              key: formKey1,
              value: getdesignationListmodel.contains(selecteddesignation)
                  ? selecteddesignation
                  : null,
              isExpanded: true,
              decoration: _themedInputDecoration('Permission For'),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textMuted),
              items: getdesignationListmodel
                  .map((GetDesignationListModel staff) {
                return DropdownMenuItem<GetDesignationListModel>(
                  value: staff,
                  child: Text(staff.masterName ?? '-',
                      style: AppTypography.dataRowLabel),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selecteddesignation = value;
                  selectedItemName = value?.masterName ?? '';
                  if (selectedItemName != 'Invoice Number') {
                    selectedInvoiceType = null;
                  }
                  selectedRegulatorReceived = null;
                });
              },
            ),
            const SizedBox(height: 14),

            // ── Invoice Type ──────────────────────────────────────────
            if (selectedItemName == 'Invoice Number') ...[
              DropdownButtonFormField<String>(
                value: invoiceTypeOptions.contains(selectedInvoiceType)
                    ? selectedInvoiceType
                    : null,
                isExpanded: true,
                decoration: _themedInputDecoration('Invoice Type'),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textMuted),
                items: ['Auto', 'Manual'].map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(e, style: AppTypography.dataRowLabel),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    previousInvoiceType = selectedInvoiceType;
                    selectedInvoiceType = value;
                    if (!isEditMode) {
                      isInvoiceNumberEditable = true;
                      if (selectedInvoiceType == 'Manual') {
                        invoiceNumberController.clear();
                      }
                    } else {
                      if (selectedInvoiceType == 'Manual') {
                        isInvoiceNumberEditable = true;
                        if (previousInvoiceType == 'Auto') {
                          invoiceNumberController.clear();
                        }
                      } else {
                        if (originalInvoiceType == 'Auto') {
                          isInvoiceNumberEditable = false;
                          invoiceNumberController.text =
                              originalAutoInvoiceNo ?? '';
                        } else {
                          isInvoiceNumberEditable = true;
                        }
                      }
                    }
                  });
                },
              ),
              const SizedBox(height: 14),
            ],

            // ── Active/De-Active ──────────────────────────────────────
            if (selectedItemName != 'Invoice Number' &&
                selectedItemName != 'Customer Discount Limit' &&
                selectedItemName != null &&
                selectedItemName!.isNotEmpty) ...[
              DropdownButtonFormField<String>(
                key: formKey2,
                value: regulatorReceived.contains(selectedRegulatorReceived)
                    ? selectedRegulatorReceived
                    : null,
                isExpanded: true,
                decoration: _themedInputDecoration('Active / De-Active'),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textMuted),
                items: regulatorReceived.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: AppTypography.dataRowLabel),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRegulatorReceived = value;
                  });
                },
              ),
              const SizedBox(height: 14),
            ],

            // ── Customer Discount Limit — Item Name ───────────────────
            if (selectedItemName == 'Customer Discount Limit') ...[
              DropdownButtonFormField<GetRspDetailsListModel?>(
                key: formKey3,
                value: getrsplistmodel.contains(selectedItemNameForDiscount)
                    ? selectedItemNameForDiscount
                    : null,
                isExpanded: true,
                decoration: _themedInputDecoration('Item Name'),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textMuted),
                items: getrsplistmodel.map((item) {
                  return DropdownMenuItem<GetRspDetailsListModel>(
                    value: item,
                    child: Text(item.itemName ?? '',
                        style: AppTypography.dataRowLabel),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedItemNameForDiscount = value;
                    selectedItemIdForDiscount = value?.itemId?.toInt();
                    selectedItem = value?.itemName?.toString();
                  });
                },
              ),
              const SizedBox(height: 14),
            ],

            // ── From Invoice No ───────────────────────────────────────
            if (selectedItemName == 'Invoice Number' &&
                selectedInvoiceType == 'Auto') ...[
              TextFormField(
                controller: invoiceNumberController,
                enabled: isInvoiceNumberEditable,
                keyboardType: TextInputType.number,
                style: AppTypography.dataRowLabel
                    .copyWith(color: AppColors.text),
                decoration: _themedInputDecoration('From Invoice No'),
              ),
              const SizedBox(height: 14),
            ],

            // ── Discount Limit ────────────────────────────────────────
            if (selectedItemName == 'Customer Discount Limit') ...[
              TextFormField(
                controller: discountLimitController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: AppTypography.dataRowLabel
                    .copyWith(color: AppColors.text),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                decoration: _themedInputDecoration('Discount Limit'),
              ),
              const SizedBox(height: 6),
            ],

            const SizedBox(height: 8),
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 16),

            // ── Action Buttons ────────────────────────────────────────
            Row(
              children: [
                // Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed: cancelAction,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(
                          color: AppColors.border2, width: 1.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTypography.labelMD.copyWith(
                          color: AppColors.textMid,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Save / Update
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.gradPrimary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x331E3A8A),
                            blurRadius: 10,
                            offset: Offset(0, 3)),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (modes == 'EDIT') {
                          updateSVAddEditForMob(context, pkIdEdit!, 'EDIT');
                        } else {
                          updateSVAddEditForMob(context, 0, 'ADD');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        modes == 'EDIT' ? 'Update' : 'Save',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty State ────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: AppColors.blueXL,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.search_off_rounded,
                color: AppColors.blue, size: 32),
          ),
          const SizedBox(height: 16),
          Text('No Records Found',
              style: AppTypography.cardTitle
                  .copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Text('No configuration entries yet.',
              style: AppTypography.cardSubtitle),
        ],
      ),
    );
  }

  // ── Config List Card ───────────────────────────────────────────────────────
  Widget _buildConfigCard(CahsDenominationMandatoryFlagModel sale) {
    String nullToDash(dynamic value) {
      if (value == null) return '-';
      final str = value.toString();
      if (str.toLowerCase() == 'null' || str.isEmpty) return '-';
      return str;
    }

    final String displayValue = sale.invoiceType != null &&
            sale.invoiceType.toString().isNotEmpty
        ? (sale.invoiceType.toString() == 'Auto' &&
                sale.fromInvoiceNo != null &&
                sale.fromInvoiceNo.toString().isNotEmpty
            ? 'Auto (${sale.fromInvoiceNo})'
            : sale.invoiceType.toString())
        : (sale.itemName != null && sale.itemName.toString().isNotEmpty
            ? sale.itemName.toString()
            : (sale.isActive != null
                ? (sale.isActive == 1 ? 'Yes' : 'No')
                : 'N/A'));

    final String discountDisplay =
        (sale.discount == null || sale.discount == 0 || sale.discount == 0.0)
            ? 'N/A'
            : sale.discount!.toInt().toString();

    final String activeDateDisplay = sale.activeDate != null &&
            sale.activeDate!.isNotEmpty
        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(sale.activeDate!))
        : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D1E3A8A), blurRadius: 12, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: Active Date + Edit ─────────────────────────
            Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.tealXL,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.calendar_today_rounded,
                      color: AppColors.teal, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ACTIVE DATE', style: AppTypography.miniLabel),
                      const SizedBox(height: 2),
                      Text(activeDateDisplay,
                          style: AppTypography.cardTitle
                              .copyWith(color: AppColors.teal)),
                    ],
                  ),
                ),
                // Edit button
                GestureDetector(
                  onTap: () {
                    var pkid = sale.pkId.toString();
                    var permissionFor = sale.permissionFor.toString();
                    var isActive = sale.isActive.toString();
                    var invoiceType = sale.invoiceType.toString();
                    var fromInvoice = sale.fromInvoiceNo.toString();
                    var itemId = sale.itemId.toString();
                    var itemName = sale.itemName.toString();
                    var discountLimit = sale.discount?.toInt().toString();

                    if (saveFlag) {
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
                          'invoiceNumberV': fromInvoice,
                          'itemIdV': itemId,
                          'itemNameV': itemName,
                          'discountV': discountLimit,
                          'modeChange': 'EDIT',
                        },
                      );
                    }
                  },
                  child: Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.blueXL,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.edit_rounded,
                        color: AppColors.blue, size: 17),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 12),

            // ── Permission For ──────────────────────────────────────
            _cardDataRow(
              icon: Icons.lock_person_rounded,
              iconBg: AppColors.orangeXL,
              iconColor: AppColors.orange,
              label: 'Permission For',
              value: nullToDash(sale.permissionFor),
            ),
            const SizedBox(height: 10),

            // ── Active / Item / Invoice ────────────────────────────
            _cardDataRow(
              icon: Icons.toggle_on_rounded,
              iconBg: AppColors.tealXL,
              iconColor: AppColors.teal,
              label: 'Active / Item / Invoice Type',
              value: displayValue,
            ),
            const SizedBox(height: 10),

            // ── Discount Amount ────────────────────────────────────
            _cardDataRow(
              icon: Icons.percent_rounded,
              iconBg: AppColors.greenXL,
              iconColor: AppColors.green,
              label: 'Discount Limit Amount',
              value: discountDisplay,
              valueBadgeBg: discountDisplay == 'N/A'
                  ? AppColors.border
                  : AppColors.greenXXL,
              valueBadgeFg:
                  discountDisplay == 'N/A' ? AppColors.textMuted : AppColors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardDataRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
    Color? valueBadgeBg,
    Color? valueBadgeFg,
  }) {
    return Row(
      children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 14),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: AppTypography.labelMD),
        ),
        if (valueBadgeBg != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: valueBadgeBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: AppTypography.badgeText
                  .copyWith(color: valueBadgeFg ?? AppColors.textMid),
            ),
          )
        else
          Text(
            value,
            style: AppTypography.dataRowLabel
                .copyWith(color: AppColors.text, fontWeight: FontWeight.w700),
          ),
      ],
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

    if(selectedItemName == "Customer Discount Limit"){
      if (discountLimitController.text.isNotEmpty) {
        discountAmount = double.tryParse(discountLimitController.text);
      }else{
        showFlushBar(context, "Discount Limit Amount Should Be Greater Than Zero");
        return;
      }
    }else{
      discountAmount = 0.0;
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

    }else{
      selectedItemIdForDiscount = null;
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