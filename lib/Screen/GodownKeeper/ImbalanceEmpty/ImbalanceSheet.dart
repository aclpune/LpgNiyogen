import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/CustomeAlertDialog.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/styles/app_colors.dart';
import '../../Utils/styles/app_spacing.dart';
import '../../Utils/styles/app_text_styles.dart';
import '../DeliveryBoyModel/GetStockTransferListModel.dart';
import '../ItemReceipt/CylItemList/CylItemListModel.dart';
import 'ImabalanceEmptyListModel.dart';
import 'ImbalnceTransactionHistory.dart';

// ── Design system imports ─────────────────────────────────────────────────────


class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final hasStar = text.contains('*');

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: hasStar
          ? RichText(
        text: TextSpan(
          style: AppTextStyles.imbalanceSectionLabel,
          children: [
            TextSpan(
              text: text.replaceAll('*', '').trim(),
            ),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      )
          : Text(
        text,
        style: AppTextStyles.imbalanceSectionLabel,
      ),
    );
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    margin: AppSpacing.imbalanceFieldCardMargin,
    padding: AppSpacing.imbalanceFieldCardPadding,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: AppRadius.imbalanceFieldCard,
      border: Border.all(color: AppColors.border),
      boxShadow: const [
        BoxShadow(color: AppColors.shadowCard, blurRadius: 6, offset: Offset(0, 2)),
      ],
    ),
    child: child,
  );
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();
  @override
  Widget build(BuildContext context) => Container(
    padding: AppSpacing.imbalanceTableHeaderPadding,
    decoration: BoxDecoration(
      color: AppColors.primaryXLight,
      borderRadius: AppRadius.imbalanceTableTop,
    ),
    child: const Row(
      children: [
        Expanded(flex: 1, child: _ColHead('Cylinder')),
        Expanded(flex: 2, child: _ColHead('Consumer / Delivery Men')),
        Expanded(flex: 1, child: _ColHead('Imbalance Qty', align: TextAlign.center)),
      ],
    ),
  );
}

class _ColHead extends StatelessWidget {
  const _ColHead(this.text, {this.align = TextAlign.left});
  final String text;
  final TextAlign align;
  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: align,
    style: AppTextStyles.imbalanceColHeader,
  );
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.item, required this.isEven});
  final ImabalanceEmptyListModel item;
  final bool isEven;
  @override
  Widget build(BuildContext context) {
    final name = (item.staffName ?? item.customerName ?? '-').toString();
    final isDelivery = item.entryType == 'D';
    return Container(
      padding: AppSpacing.imbalanceTableRowPadding,
      color: isEven ? AppColors.background : AppColors.surface,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              item.itemName ?? '-',
              style: AppTextStyles.imbalanceTableItemName,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 6, height: 6,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: isDelivery ? AppColors.primaryLight : AppColors.teal,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    name,
                    style: AppTextStyles.imbalanceTablePersonName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item.balImbQty?.toString() ?? '0',
              textAlign: TextAlign.center,
              style: AppTextStyles.imbalanceQtyValue.copyWith(
                color: (item.balImbQty ?? 0) > 0 ? AppColors.red : AppColors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Main widget ───────────────────────────────────────────────────────────────

class ImbalanceSheet extends StatefulWidget {
  final ScrollController scrollController;

  const ImbalanceSheet({
    super.key,
    required this.scrollController,
  });

  @override
  _ImbalanceSheetState createState() => _ImbalanceSheetState();
}

class _ImbalanceSheetState extends State<ImbalanceSheet> {

  // ── State (UNCHANGED) ──────────────────────────────────────────────────────
  String selectedType = "D";
  CylItemListModel? _selectedItemModel;
  List<CylItemListModel> _items = [];
  String? _selectedItem;
  int? selectedItemId;
  final TextEditingController _totalImbalanceQty = TextEditingController();
  final TextEditingController _totalImbalanceQtyDMCustomer = TextEditingController();
  final TextEditingController _totalImbalanceQtyCustomer = TextEditingController();

  List<ImabalanceEmptyListModel> deliveryListFiltered = [];
  List<ImabalanceEmptyListModel> customerListFiltered = [];
  List<ImabalanceEmptyListModel> receiptList = [];
  ImabalanceEmptyListModel? selectedDeliveryModel;
  ImabalanceEmptyListModel? selectedCustomerModel;
  String? _selectedDeliveryMenName;
  int? selectedDeliveryMenId;
  String? _selectedCustomerName;
  int? selectedCustomerId;
  bool saveFlag = false;
  bool stockTransferFlag = false;
  List<GetStockTransferListModel> _stockTransferList = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
    _fetchImbalanceData();
    fetchTransactionList();
    checkAndSaveDayEndData();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final deliveryList = getUniqueDelivery();
    if (!deliveryList.any((e) => e.dMId == selectedDeliveryMenId)) {
      selectedDeliveryMenId = null;
    }
    final customerList = getUniqueCustomer();
    if (!customerList.any((e) => e.dMId == selectedCustomerId)) {
      selectedCustomerId = null;
    }

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: AppSpacing.imbalanceDragHandleMargin,
            width: AppSpacing.imbalanceDragHandleWidth,
            height: AppSpacing.imbalanceDragHandleHeight,
            decoration: BoxDecoration(
              color: AppColors.imbalanceDragHandle,
              borderRadius: AppRadius.imbalanceDragHandle,
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSheetHeader(context),
                  const SizedBox(height: 20),
                  _buildFormSection(context, deliveryList, customerList),
                  const SizedBox(height: 20),
                  _buildListSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Sheet header ───────────────────────────────────────────────────────────
  Widget _buildSheetHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.imbalanceAccentBarWidth,
          height: AppSpacing.imbalanceAccentBarHeight,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadius.imbalanceAccentBar,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Update Imbalance Stock',
            style: AppTextStyles.imbalanceSheetTitle,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ImbalnceTransactionHistory.screenName,
              arguments: {},
            );
          },
          child: Container(
            padding: AppSpacing.imbalanceHistoryBtnPadding,
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: AppRadius.imbalanceHistoryBtn,
            ),
            child: Row(
              children: [
                Text('History', style: AppTextStyles.imbalanceHistoryBtn),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primaryLight),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Form section ───────────────────────────────────────────────────────────
  Widget _buildFormSection(
      BuildContext context,
      List<ImabalanceEmptyListModel> deliveryList,
      List<ImabalanceEmptyListModel> customerList,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Select Item
        const _SectionLabel('SELECT ITEM *'),
        _FieldCard(
          child: DropdownButtonFormField<CylItemListModel>(
            decoration: const InputDecoration.collapsed(hintText: 'Select Item'),
            value: _selectedItemModel,
            isExpanded: true,
            hint: Text('Choose item', style: AppTextStyles.imbalanceDropdownHint),
            items: _items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item.itemName ?? 'Unknown', style: AppTextStyles.imbalanceDropdownItem),
            )).toList(),
            onChanged: (selectedItem) {
              if (selectedItem != null) {
                setState(() {
                  _selectedItem = selectedItem.itemName;
                  selectedItemId = selectedItem.itemId!.toInt();
                  _selectedItemModel = selectedItem;
                  selectedDeliveryModel = null;
                  selectedCustomerModel = null;
                  selectedDeliveryMenId = null;
                  _selectedDeliveryMenName = null;
                  _selectedCustomerName = null;
                  selectedCustomerId = null;
                  _totalImbalanceQtyDMCustomer.clear();
                  _totalImbalanceQty.clear();
                });
              }
            },
          ),
        ),

        // Total Sale
        const _SectionLabel('TOTAL SALE *'),
        _FieldCard(
          child: TextField(
            controller: _totalImbalanceQty,
            decoration: const InputDecoration.collapsed(hintText: 'Enter total sale qty'),
            style: AppTextStyles.imbalanceFieldInput,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            onChanged: (value) {
              setState(() {
                int.tryParse(value);
              });
            },
          ),
        ),

        // Type toggle
        const _SectionLabel('ASSIGN TO'),
        Container(
          margin: AppSpacing.imbalanceFieldCardMargin,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.imbalanceTypeToggle,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _TypeTab(
                label: 'Delivery Men',
                icon: Icons.delivery_dining_rounded,
                selected: selectedType == 'D',
                onTap: () {
                  setState(() {
                    selectedType = 'D';
                    selectedDeliveryModel = null;
                    selectedCustomerModel = null;
                    selectedDeliveryMenId = null;
                    _selectedDeliveryMenName = null;
                    _selectedCustomerName = null;
                    selectedCustomerId = null;
                    _totalImbalanceQtyDMCustomer.clear();
                  });
                },
              ),
              _TypeTab(
                label: 'Customer',
                icon: Icons.person_rounded,
                selected: selectedType == 'C',
                onTap: () {
                  setState(() {
                    selectedType = 'C';
                    selectedDeliveryModel = null;
                    selectedCustomerModel = null;
                    selectedDeliveryMenId = null;
                    _selectedDeliveryMenName = null;
                    _selectedCustomerName = null;
                    selectedCustomerId = null;
                    _totalImbalanceQtyDMCustomer.clear();
                  });
                },
              ),
            ],
          ),
        ),

        // Delivery / Customer dropdown
        if (selectedType == 'D') ...[
          const _SectionLabel('SELECT DELIVERY MEN *'),
          _FieldCard(
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration.collapsed(hintText: ''),
              value: selectedDeliveryMenId,
              isExpanded: true,
              hint: Text('Choose delivery man', style: AppTextStyles.imbalanceDropdownHint),
              items: deliveryList.map((e) => DropdownMenuItem<int>(
                value: e.dMId!.toInt(),
                child: Text(e.staffName.toString(), style: AppTextStyles.imbalanceDropdownItem),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDeliveryMenId = value;
                  final selectedObj = deliveryList.firstWhere((e) => e.dMId == value);
                  _selectedDeliveryMenName = selectedObj.staffName;
                  _setQtyForSelection(type: 'D', id: value);
                });
              },
            ),
          ),
        ],

        if (selectedType == 'C') ...[
          const _SectionLabel('SELECT CUSTOMER *'),
          _FieldCard(
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration.collapsed(hintText: ''),
              value: selectedCustomerId,
              isExpanded: true,
              hint: Text('Choose customer', style: AppTextStyles.imbalanceDropdownHint),
              items: customerList.map((e) => DropdownMenuItem<int>(
                value: e.dMId!.toInt(),
                child: Text(e.customerName.toString(), style: AppTextStyles.imbalanceDropdownItem),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCustomerId = value;
                  final selectedObj = customerList.firstWhere((e) => e.dMId == value);
                  _selectedCustomerName = selectedObj.customerName;
                  _setQtyForSelection(type: 'C', id: value);
                });
              },
            ),
          ),
        ],

        // DM Total Imbalance (read-only)
        const _SectionLabel('DM TOTAL IMBALANCE'),
        _FieldCard(
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _totalImbalanceQtyDMCustomer,
                  decoration: const InputDecoration.collapsed(hintText: '0'),
                  style: AppTextStyles.imbalanceFieldInputMuted,
                  keyboardType: TextInputType.number,
                  enabled: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  onChanged: (value) {
                    setState(() {
                      int.tryParse(value);
                    });
                  },
                ),
              ),
              Container(
                padding: AppSpacing.imbalanceAutoBadgePadding,
                decoration: BoxDecoration(
                  color: AppColors.primaryXXLight,
                  borderRadius: AppRadius.imbalanceAutoBadge,
                ),
                child: Text(
                  'AUTO',
                  style: AppTextStyles.imbalanceTypeBadge.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),

        // Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.imbalanceBtn),
                  minimumSize: const Size.fromHeight(48),
                ),
                child: Text('Close', style: AppTextStyles.button.copyWith(color: AppColors.textSecondary)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (saveFlag) {
                    showFlushBar(context, Constants.dayEndCompleted);
                  } else {
                    if (stockTransferFlag) {
                      addItemImbalanceQty();
                    } else {
                      CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.imbalanceBtn),
                  minimumSize: const Size.fromHeight(48),
                  elevation: 0,
                ),
                child: Text('Save', style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── List section ───────────────────────────────────────────────────────────
  Widget _buildListSection() {
    final combined = [...deliveryListFiltered, ...customerListFiltered];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: AppSizes.sectionDotSize,
              height: AppSizes.sectionDotSize,
              decoration: BoxDecoration(
                color: AppColors.teal,
                borderRadius: AppRadius.imbalanceSectionDot,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'CUSTOMER / DELIVERY MEN WISE LIST',
              style: AppTextStyles.imbalanceListSectionLabel,
            ),
          ],
        ),
        const SizedBox(height: 10),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.imbalanceTable,
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.tableBody,
          ),
          child: ClipRRect(
            borderRadius: AppRadius.imbalanceTable,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _TableHeader(),
                combined.isNotEmpty
                    ? SizedBox(
                  height: (combined.length * 44.0).clamp(60.0, 200.0),
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: combined.length,
                    itemBuilder: (context, index) => _TableRow(
                      item: combined[index],
                      isEven: index.isEven,
                    ),
                  ),
                )
                    : Padding(
                  padding: AppSpacing.imbalanceEmptyPadding,
                  child: Center(
                    child: Text(
                      'No data available',
                      style: AppTextStyles.imbalanceEmptyText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Business logic (UNCHANGED) ─────────────────────────────────────────────

  Future<void> fetchItems() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      if (bearerToken == null) throw Exception('Bearer token is missing');
      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );
        debugPrint("GetItemMasterList" + '${AppUrl.GetItemMasterList}/$distributorId/1/C');
        debugPrint("GetItemMasterList" + response.body);
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          setState(() {
            _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
            _items = _items.where((item) => !item.itemName!.toLowerCase().contains('regulator')).toList();
          });
        } else {
          throw Exception('Failed To Load Items');
        }
      } catch (e) {
        debugPrint("GetItemMasterList" + e.toString());
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> _fetchImbalanceData() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? token = prefs.getString('token');
      int dId = int.parse(distributorId!);
      try {
        final response = await http.get(
          Uri.parse('${AppUrl.ItemImbalanceList}/$dId/0/ALL'),
          headers: {'Authorization': 'Bearer $token'},
        );
        print("Total ImbQty for delManId response ${response.body}");
        print("Total ImbQty for delManId request ${response.request}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            receiptList = data.map((json) => ImabalanceEmptyListModel.fromJson(json)).toList();
            deliveryListFiltered = receiptList.where((e) => e.dMId != null && e.dMId != 0 && e.staffName != null && e.entryType == "D").toList();
            customerListFiltered = receiptList.where((e) => e.dMId != null && e.dMId != 0 && e.customerName != null && e.entryType == "C").toList();
          });
          var rawDelivery = receiptList.where((e) => e.dMId != null && e.dMId != 0 && e.staffName != null && e.entryType == "D").toList();
          deliveryListFiltered = groupAndSum(rawDelivery);
          var rawCustomer = receiptList.where((e) => e.dMId != null && e.dMId != 0 && e.customerName != null && e.entryType == "C").toList();
          customerListFiltered = groupAndSum(rawCustomer);
          deliveryListFiltered = groupAndSum(receiptList.where((e) => e.entryType == "D").toList());
          customerListFiltered = groupAndSum(receiptList.where((e) => e.entryType == "C").toList());
          deliveryListFiltered.sort((a, b) => (a.staffName ?? "").toString().toLowerCase().compareTo((b.staffName ?? "").toString().toLowerCase()));
          customerListFiltered.sort((a, b) => (a.customerName ?? "").toString().toLowerCase().compareTo((b.customerName ?? "").toString().toLowerCase()));
        } else {
          setState(() { showFlushBar(context, Constants.listGettingFail); });
        }
      } catch (e) {
        setState(() {});
        showFlushBar(context, Constants.listGettingFail);
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  List<ImabalanceEmptyListModel> getUniqueDelivery() {
    final Map<int, ImabalanceEmptyListModel> map = {};
    for (var item in deliveryListFiltered) {
      if (item.dMId != null) map[item.dMId!.toInt()] = item;
    }
    return map.values.toList();
  }

  List<ImabalanceEmptyListModel> getUniqueCustomer() {
    final Map<int, ImabalanceEmptyListModel> map = {};
    for (var item in customerListFiltered) {
      if (item.dMId != null) map[item.dMId!.toInt()] = item;
    }
    return map.values.toList();
  }

  void _setQtyForSelection({required String type, num? id}) {
    print("item $type id $id");
    if (_selectedItemModel == null || id == null) return;
    final filteredList = receiptList.where((e) => e.dMId == id && e.itemId == _selectedItemModel!.itemId).toList();
    int totalQty = 0;
    for (var item in filteredList) { totalQty += (item.balImbQty ?? 0).toInt(); }
    if (totalQty > 0) {
      _totalImbalanceQtyDMCustomer.text = totalQty.toString();
    } else {
      _totalImbalanceQtyDMCustomer.clear();
    }
  }

  Future<void> checkAndSaveDayEndData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? StaffId = prefs.getString('StaffId');
    int? staffIds = int.parse(StaffId!);
    int? distributorIds = int.parse(distributorId!);
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $bearerToken"},
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

  Future<void> fetchTransactionList() async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? bearerToken = prefs.getString('token');
      int dId = int.parse(distributorId!);
      int gId = int.parse(godownId!);
      if (bearerToken == null) throw Exception('Bearer token is missing');
      try {
        final response = await http.get(
          Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );
        debugPrint("GetStockTransferDtls" + '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
        debugPrint("GetStockTransferDtls" + response.body);
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          setState(() {
            _stockTransferList = data.map((json) => GetStockTransferListModel.fromJson(json)).toList();
            bool hasZeroStkTrans = false;
            for (int i = 0; i < _stockTransferList.length; i++) {
              if (_stockTransferList[i].isStkTrans == 0) { hasZeroStkTrans = true; break; }
            }
            stockTransferFlag = !hasZeroStkTrans;
          });
        } else {
          setState(() { showFlushBar(context, Constants.listGettingFail); });
        }
      } catch (e) {
        debugPrint("GetStockTransferDtls" + e.toString());
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> addItemImbalanceQty() async {
    EasyLoading.show(status: 'Sending Data...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token');
    int dId = int.parse(distributorId!);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    int? selectedDM;
    int? selectedCust;
    String selectedTypes = selectedType.toString();

    if (_selectedItem == null || _selectedItem == "null") {
      showFlushBar(context, Constants.selectValidItemReceipt);
      EasyLoading.dismiss();
      return;
    }
    if (selectedType == "D") {
      if (_selectedDeliveryMenName == null) {
        showFlushBar(context, "Select Delivery Boy");
        EasyLoading.dismiss();
        return;
      } else {
        selectedDM = selectedDeliveryMenId?.toInt();
        selectedCust = selectedDeliveryMenId?.toInt();
      }
    } else {
      if (_selectedCustomerName == null) {
        showFlushBar(context, "Select Customer");
        EasyLoading.dismiss();
        return;
      } else {
        selectedCust = selectedCustomerId?.toInt();
        selectedDM = selectedCustomerId?.toInt();
      }
    }

    int availableQty = int.tryParse(_totalImbalanceQtyDMCustomer.text) ?? 0;
    int enteredQty = int.tryParse(_totalImbalanceQty.text) ?? 0;

    if (enteredQty > 0) {
      if (enteredQty > availableQty) {
        showFlushBar(context, Constants.validCountEnter);
        EasyLoading.dismiss();
        return;
      }
    } else {
      showFlushBar(context, Constants.validCountEnter);
      EasyLoading.dismiss();
      return;
    }

    Map<String, dynamic> requestBody = {
      "ImbId": 0,
      "DistributorId": distributorId,
      "GodownId": godownId,
      "ImbDate": formattedDate,
      "ItemId": selectedItemId,
      "EntryType": selectedTypes ?? '',
      "ConsDMId": selectedCust,
      "ImbRecQty": enteredQty,
      "AddedBy": addedBy,
      "Action": "ADD"
    };

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.DailySaleByGKImbSettleAdd}'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );
      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");
      print("API Response request: ${response.request} ${requestBody}");

      if (response.statusCode == 200) {
        print("Imbalance quantity added successfully!");
        EasyLoading.showToast("Data Sent Successfully..", duration: const Duration(milliseconds: 3000));
        setState(() {
          _fetchImbalanceData();
          selectedDeliveryModel = null;
          selectedCustomerModel = null;
          selectedDeliveryMenId = null;
          _selectedDeliveryMenName = null;
          _selectedCustomerName = null;
          selectedCustomerId = null;
          _totalImbalanceQtyDMCustomer.clear();
          _totalImbalanceQty.clear();
          _selectedItemModel = null;
          _selectedItem = null;
          selectedItemId = null;
        });
        EasyLoading.dismiss();
      } else {
        print("Failed to add imbalance quantity: ${response.statusCode}");
        EasyLoading.dismiss();
      }
    } catch (e) {
      print("Error occurred: $e");
      EasyLoading.dismiss();
    }
  }

  List<ImabalanceEmptyListModel> groupAndSum(List<ImabalanceEmptyListModel> list) {
    Map<String, ImabalanceEmptyListModel> groupedMap = {};
    for (var item in list) {
      String displayName = item.staffName ?? item.customerName ?? "Unknown";
      String itemName = item.itemName ?? "Unknown Item";
      String key = "$displayName-$itemName";
      if (groupedMap.containsKey(key)) {
        double existingQty = double.tryParse(groupedMap[key]!.balImbQty.toString()) ?? 0;
        double newQty = double.tryParse(item.balImbQty.toString()) ?? 0;
        double totalQty = existingQty + newQty;
        groupedMap[key] = ImabalanceEmptyListModel(
          itemName: item.itemName,
          staffName: item.staffName,
          customerName: item.customerName,
          balImbQty: totalQty,
          entryType: item.entryType,
          dMId: item.dMId,
        );
      } else {
        groupedMap[key] = item;
      }
    }
    return groupedMap.values.toList();
  }

  Widget cell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: isHeader ? Colors.grey[300] : AppColors.surface,
      child: Text(text, style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal)),
    );
  }
}

// ── Type tab widget ───────────────────────────────────────────────────────────
class _TypeTab extends StatelessWidget {
  const _TypeTab({required this.label, required this.icon, required this.selected, required this.onTap});
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: AppRadius.imbalanceTypeTab,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: selected ? AppColors.surface : AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.imbalanceTypeTabLabel.copyWith(
                  color: selected ? AppColors.surface : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
