import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../newTheam/core/theme/app_typography.dart';
import '../../ConstantScreen/widgets.dart';
import '../../ManagerScreen/GetDesignationListModel.dart';
import '../../ManagerScreen/SVSaleModel/GetRSPDetailsListModel.dart';
import '../../Utils/CustomAppBar.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/styles/app_colors.dart';
import '../../Utils/styles/app_spacing.dart';
import '../../Utils/styles/app_text_styles.dart';
import '../BottomNavigationForGodownKeeper.dart';
import '../ItemReceipt/CylItemList/CylItemListModel.dart';
import '../ItemReceipt/ItemReturn/ItenRetun.dart';
import 'GetSQCFilledCylListModel.dart';

const int maxFileSize = 5 * 1024 * 1024; // 5MB

// ─────────────────────────────────────────────
// DESIGN TOKENS — thin aliases → AppColors
// (all values match the originals pixel-for-pixel)
// ─────────────────────────────────────────────
abstract final class _C {
  static const Color blue      = AppColors.primary;
  static const Color blueLight = AppColors.primaryLight;
  static const Color blueDark  = AppColors.primaryDark;
  static const Color blueXL    = AppColors.primaryXLight;
  static const Color blueXXL   = AppColors.primaryXXLight;
  static const Color teal      = AppColors.teal;
  static const Color tealXL    = AppColors.tealXLight;
  static const Color orange    = AppColors.orange2;       // 0xFFF97316
  static const Color orangeXL  = AppColors.orange2XLight; // 0xFFFFF7ED
  static const Color red       = AppColors.red;
  static const Color redXL     = AppColors.redXLight;
  static const Color green     = AppColors.green;
  static const Color greenXL   = AppColors.greenXLight;
  static const Color white     = AppColors.surface;
  static const Color bg        = AppColors.background;
  static const Color bg2       = AppColors.background2;
  static const Color text      = AppColors.textPrimary;
  static const Color textMid   = AppColors.textSecondary;
  static const Color textMuted = AppColors.textMuted;
  static const Color border    = AppColors.border;

  static const LinearGradient gradHero = AppColors.gradHero;
}

// ─────────────────────────────────────────────
// TEXT STYLES — thin aliases → AppTextStyles
// ─────────────────────────────────────────────
abstract final class _T {
  static const TextStyle heroTitle  = AppTextStyles.sqcHeroTitle;
  static const TextStyle heroSub    = AppTextStyles.sqcHeroSub;
  static const TextStyle fieldLabel = AppTextStyles.sqcFieldLabel;
  static const TextStyle cardTitle  = AppTextStyles.cardTitle;
  static const TextStyle sectionHdr = AppTextStyles.sqcSectionHeader;
  static const TextStyle caption    = AppTextStyles.sqcUploadSubLabel;
  static const TextStyle badge      = AppTextStyles.xmiStatusBadge;
  static const TextStyle listLabel  = AppTextStyles.sqcQueueDptDate;
  static const TextStyle listValue  = AppTextStyles.sqcReceiptSerial;
}

class SQCRegisterScreen extends StatefulWidget {
  static const screenName = '/sqcregisterScreen';
  const SQCRegisterScreen({super.key});

  @override
  State<SQCRegisterScreen> createState() => _SQCRegisterScreenState();
}

class _SQCRegisterScreenState extends State<SQCRegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final tareController       = TextEditingController();
  final grossController      = TextEditingController();
  final observedController   = TextEditingController();
  final variationController  = TextEditingController();
  final serialNoController   = TextEditingController();
  final remarksController    = TextEditingController();
  final TextEditingController vehicleNoController = TextEditingController();
  late var prefixController  = TextEditingController();

  String? _selectedItem;
  int? selectedItemId;
  String? selectedItemNamee;
  bool _isinvoiceEmpty = false;
  String? selectedDptDate;
  List<String> regulatorReceived = ["Yes", "No"];
  String? selectedSealingCondition;
  List<String> leakReceived = ["Yes", "No"];
  String? selectedLeak;
  String? selectedLeaky;
  String? formattedDate;
  String? tareError;
  String? obsError;
  bool saveFlag = false;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String selectedWeight = "14.2KG";
  double _selectedItemWeight = 0.0;
  File? selectedFile;
  VideoPlayerController? _videoController;
  File? selectedZip;
  double grossWeight = 0.0;
  double observedWeight = 0.0;
  String? godownId;
  String? vehicleNo;
  List<GetDesignationListModel> getdesignationListmodel = [];
  GetDesignationListModel? selecteddesignation;
  int? selectedItemIdd;
  String? selectedItemName;
  List<GetSqcFilledCylListModel> receiptList = [];
  bool isLoading = true;
  var argValue;
  String? modes;
  int? SQCIdEdit;
  String? uploadedFileUrl;
  List<String> itemIds = [];
  List<String> itemNames = [];
  String? selectedItemNameee;
  int? selectedItemIddd;
  String? _selectedItemModel;
  List<Map<String, dynamic>> sqcItemList = [];
  late Map<String, dynamic> editItem;

  // ── Calculations (unchanged) ──────────────────
  void calculateObserved() {
    double gross = double.tryParse(grossController.text) ?? 0.0;
    double tar   = double.tryParse(tareController.text)  ?? 0.0;
    setState(() { observedController.text = (gross - tar).toStringAsFixed(3); });
  }

  void calculateVariation() {
    grossWeight    = double.tryParse(grossController.text)    ?? 0.0;
    observedWeight = double.tryParse(observedController.text) ?? 0.0;
    setState(() { variationController.text = (grossWeight - observedWeight).toStringAsFixed(3); });
  }

  void calculateGross() {
    double tareValue = double.tryParse(tareController.text) ?? 0.0;
    if (tareValue == 0.0) { grossController.clear(); return; }
    setState(() { grossController.text = (tareValue + _selectedItemWeight).toStringAsFixed(2); });
    calculateVariation();
  }

  final prefixFormatter = TextInputFormatter.withFunction((oldValue, newValue) {
    String text = newValue.text.toUpperCase();
    if (text.isEmpty) return TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));
    String firstChar = text[0];
    if (!RegExp(r'[A-D]').hasMatch(firstChar)) return oldValue;
    String digits = '';
    if (text.length > 1) {
      digits = text.substring(1).replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.length > 2) digits = digits.substring(0, 2);
    }
    String formatted = firstChar;
    if (digits.isNotEmpty) formatted += "-$digits";
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  });

  // ── Lifecycle (unchanged) ─────────────────────
  @override
  void initState() {
    super.initState();
    prefixController = TextEditingController();
    DateTime now = DateTime.now().toUtc();
    formattedDate = now.toIso8601String();
    print(formattedDate);
    print("wqdf$formattedDate");
    getDesignationList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(this.context)?.settings.arguments as Map?;
      fetchItemSQCAddEditList(this.context);
      loadUploadedVideo();
      checkAndSaveDayEndData();

      if (args != null) {
        vehicleNoController.text = args['vehicleNo']?.toString() ?? '';
        godownId  = args['godownId'] ?? '';
        itemIds   = List<String>.from(args['itemIds']   ?? []);
        itemNames = List<String>.from(args['itemNames'] ?? []);
        for (int i = 0; i < itemIds.length; i++) {
          print("ID: ${itemIds[i]}, Name: ${itemNames[i]}");
        }
      }
    });

    Future.delayed(Duration.zero, () async {
      argValue = ModalRoute.of(this.context)?.settings.arguments as Map?;
      modes    = argValue?["modeChange"] ?? '';
      print("modes value: $modes");
      if (argValue != null) {
        SQCIdEdit         = int.tryParse((argValue["sqcIDV"]       ?? "0").toString());
        String itemIdEdit     = (argValue["itemIdV"]     ?? "").toString();
        String itemNameEdit   = (argValue["itemNameV"]   ?? "").toString();
        String tareWtEdit     = (argValue["tareWtV"]     ?? "").toString();
        String grossWtEdit    = (argValue["grossWtV"]    ?? "").toString();
        String observedWtEdit = argValue["observedWtV"]?.toString() ?? '';
        String variationEdit  = (argValue["variationV"]  ?? 0).toString();
        String dptDateEdit    = (argValue["dptDateV"]    ?? "").toString();
        String sealingEdit    = (argValue["sealingV"]    ?? "").toString();
        String leakyEdit      = (argValue["laekyV"]      ?? "").toString();
        String leakTypeEdit   = (argValue["leakTypeV"]   ?? "").toString();
        String leaktTypeIdEdit= (argValue["leakTypeIdV"] ?? "").toString();
        String serialNoEdit   = (argValue["serialNoV"]   ?? "").toString();
        String remarkEdit     = (argValue["remarkV"]     ?? "").toString();
        String fileUploadEdit = (argValue["fileUploadV"] ?? "").toString();

        if (modes == "Edit") {
          if (mounted) {
            setState(() {
              selectedSealingCondition = sealingEdit == "Y" ? "Yes" : "No";
              selectedLeak = leakyEdit == "Y" ? "Yes" : "No";
              sqcItemList = [{
                "GodownId": godownId,
                "ReceiptDate": dptDateEdit,
                "VehicleNo": vehicleNo,
                "ItemId": itemIdEdit,
                "TareWt": tareWtEdit,
                "GrossWt": grossWtEdit,
                "ObservedWt": observedWtEdit,
                "Variation": variationEdit,
                "DPTDate": dptDateEdit,
                "SerialNo": serialNoEdit,
                "Remarks": remarkEdit,
                "SealingCond": sealingEdit == "Y" ? "Yes" : "No",
                "Leakage": leakyEdit == "Y" ? "Yes" : "No",
                "LeakyBdy": leaktTypeIdEdit,
                "file": fileUploadEdit,
              }];
            });
          }
        }

        if (modes == "Edit") {
          selectedSealingCondition = sealingEdit == "Y" ? "Yes" : "No";
          selectedLeak = leakyEdit == "Y" ? "Yes" : "No";
        } else {
          selectedSealingCondition = null;
          selectedLeak = null;
        }

        uploadedFileUrl = fileUploadEdit.isNotEmpty && fileUploadEdit != "0" ? fileUploadEdit : null;
        grossWeight    = grossWtEdit.isNotEmpty    ? double.tryParse(grossWtEdit.replaceAll(RegExp(r'[^0-9.]'), ''))    ?? 0.0 : 0.0;
        observedWeight = observedWtEdit.isNotEmpty ? double.tryParse(observedWtEdit.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0 : 0.0;

        if (argValue != null) {
          String vehicleNoEdit = argValue["vehicleNoV"]?.toString() ?? '';
          String godownIdEdit  = argValue["godownIdV"]?.toString()  ?? '';
          String itemIdEditL   = argValue["itemIdV"]?.toString()    ?? '';
          String itemNameEditL = argValue["itemNameV"]?.toString()  ?? '';

          if ((itemIds.isEmpty || itemNames.isEmpty)) {
            if (itemIdEditL.isNotEmpty && itemNameEditL.isNotEmpty) {
              itemIds   = [itemIdEditL];
              itemNames = [itemNameEditL];
            }
          }

          setState(() {
            if (vehicleNoEdit.isNotEmpty && vehicleNoEdit != "null") vehicleNoController.text = vehicleNoEdit;
            if (godownIdEdit.isNotEmpty  && godownIdEdit  != "null") godownId = godownIdEdit;

            if (modes == "Edit" && itemNames.isNotEmpty && itemIds.isNotEmpty) {
              int index = itemNames.indexWhere((e) => e == itemNameEditL);
              if (index != -1) {
                _selectedItemModel  = itemNames[index];
                selectedItemNameee  = itemNames[index];
                selectedItemIddd    = int.tryParse(itemIds[index]);
                RegExp regExp = RegExp(r'(\d+(\.\d+)?)');
                Match? match  = regExp.firstMatch(selectedItemNameee!);
                _selectedItemWeight = match != null ? double.tryParse(match.group(0)!) ?? 0.0 : 0.0;
                calculateGross();
              } else {
                _selectedItemModel = null; selectedItemNameee = null; selectedItemIddd = null;
              }
            } else {
              _selectedItemModel = null; selectedItemNameee = null; selectedItemIddd = null;
            }
          });
        }

        tareController.text      = tareWtEdit;
        grossController.text     = grossWtEdit;
        observedController.text  = observedWtEdit;
        variationController.text = variationEdit;
        serialNoController.text  = serialNoEdit;
        remarksController.text   = remarkEdit;
        prefixController.text    = dptDateEdit;

        await getDesignationList();
        await getDesignationList();
        debugPrint("leaktTypeIdEdit:$leaktTypeIdEdit");
        if (leaktTypeIdEdit != null && leaktTypeIdEdit.isNotEmpty && leaktTypeIdEdit != "null") {
          setState(() {
            selecteddesignation = getdesignationListmodel.firstWhere(
                  (item) => item.designationId.toString() == leaktTypeIdEdit.toString(),
              orElse: () => getdesignationListmodel.first,
            );
            selectedItemName = selecteddesignation?.masterName ?? "";
            selectedItemIdd  = selecteddesignation?.designationId?.toInt();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(context, BottomNavigationForGodownKeeper.screenName);
          return false;
        } else {
          Navigator.pushReplacementNamed(context, ItemReturnScreen.screenName, arguments: argLRAdd);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: _C.bg2,
        // appBar: CustomAppBar(
        //   title: 'SQC Register',
        // ),
        appBar: AppBar(
          backgroundColor: AppColors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,

          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.gradHero,
            ),
          ),

          titleSpacing: 0,

          title: Row(
            children: [

              // Back Button
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ItemReturnScreen(),
                    ),
                  );
                },
              ),

              // Logo
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/playstore.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Titles
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Constants.appName,
                      style: AppTypography.heroSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'SQC Register',
                      style: AppTypography.heroTitle.copyWith(
                        fontSize: 15,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // ── NO AppBar (as per STRICT RULE) ──
        body: Column(
          children: [
            // AppGradientHeader(
            //   title: 'SQC Register',
            //   subtitle: 'Daily SQC inspection tracker',
            //   icon: Icons.receipt_long_rounded,
            //   onBack: () => Navigator.pushReplacementNamed(
            //     context,
            //     BottomNavigationForGodownKeeper.screenName,
            //     arguments: "onBack",
            //   ),
            // ),
            // ── Scrollable body ──
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: AppSpacing.sqcRegisterBodyPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 16),
                      _SectionHeader(title: 'Cylinder Details', dotColor: _C.blueLight),
                      _FormCard(children: [
                        _ReadOnlyField(
                          label: 'SQC Vehicle No.',
                          controller: vehicleNoController,
                          icon: Icons.local_shipping_rounded,
                        ),
                        const SizedBox(height: 14),
                        _DropdownField<String>(
                          label: 'Select Item *',
                          icon: Icons.inventory_2_rounded,
                          value: itemNames.contains(_selectedItemModel) ? _selectedItemModel : null,
                          items: itemNames.map((name) => DropdownMenuItem<String>(
                            value: name,
                            child: Text(name, overflow: TextOverflow.ellipsis),
                          )).toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              setState(() {
                                _selectedItemModel = value;
                                int index = itemNames.indexOf(value);
                                selectedItemIddd   = int.tryParse(itemIds[index]);
                                selectedItemNameee = itemNames[index];
                                RegExp regExp = RegExp(r'(\d+(\.\d+)?)');
                                Match? match  = regExp.firstMatch(selectedItemNameee!);
                                _selectedItemWeight = match != null ? double.tryParse(match.group(0)!) ?? 0.0 : 0.0;
                                calculateGross();
                              });
                            }
                          },
                        ),
                      ]),

                      _SectionHeader(title: 'Weight Measurements', dotColor: _C.teal),
                      _FormCard(children: [
                        Row(children: [
                          Expanded(
                            child: _WeightField(
                              label: 'Tare Weight *',
                              controller: tareController,
                              readOnly: false,
                              errorText: tareError,
                              onChanged: (value) {
                                final n = double.tryParse(value);
                                setState(() {
                                  if (value.isEmpty)           tareError = "Please enter Tare value";
                                  else if (n == null || n <= 0) tareError = "Must be > 0";
                                  else                          tareError = null;
                                });
                                calculateGross();
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _WeightField(
                              label: 'Gross Weight',
                              controller: grossController,
                              readOnly: true,
                              onChanged: (_) => calculateVariation(),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 14),
                        Row(children: [
                          Expanded(
                            child: _WeightField(
                              label: 'Observed Weight *',
                              controller: observedController,
                              readOnly: false,
                              errorText: obsError,
                              onChanged: (value) {
                                final n = double.tryParse(value);
                                setState(() {
                                  if (value.isEmpty)           obsError = "Please enter observed value";
                                  else if (n == null || n <= 0) obsError = "Must be > 0";
                                  else                          obsError = null;
                                });
                                calculateVariation();
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _WeightField(
                              label: 'Variation',
                              controller: variationController,
                              readOnly: true,
                            ),
                          ),
                        ]),
                      ]),

                      // ── SECTION: Inspection Details ──
                      _SectionHeader(title: 'Inspection Details', dotColor: _C.orange),
                      _FormCard(children: [
                        _InlineField(
                          label: 'DPT Date *',
                          child: TextFormField(
                            controller: prefixController,
                            inputFormatters: [prefixFormatter],
                            style: AppTextStyles.sqcInputText,
                            decoration: _inputDecoration('e.g. A-24'),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(children: [
                          Expanded(
                            child: _DropdownField<String>(
                              label: 'Sealing *',
                              icon: Icons.verified_rounded,
                              value: regulatorReceived.contains(selectedSealingCondition) ? selectedSealingCondition : null,
                              items: regulatorReceived.map((v) => DropdownMenuItem<String>(value: v, child: Text(v))).toList(),
                              onChanged: (value) => setState(() => selectedSealingCondition = value),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DropdownField<String>(
                              label: 'Leaky *',
                              icon: Icons.water_drop_rounded,
                              value: leakReceived.contains(selectedLeak) ? selectedLeak : null,
                              items: leakReceived.map((v) => DropdownMenuItem<String>(value: v, child: Text(v))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedLeak = value;
                                  // if (value == "No") selectedLeaky = null;

                                  if (value == "No") {
                                    selecteddesignation = null;
                                    selectedItemName = "";
                                    selectedItemIdd = null;
                                  }
                                });
                              },
                            ),
                          ),
                        ]),

                        // Conditional leakage type dropdown
                        if (selectedLeak == "Yes") ...[
                          const SizedBox(height: 14),
                          _DropdownField<GetDesignationListModel>(
                            label: 'Leak Type *',
                            icon: Icons.category_rounded,
                            value: getdesignationListmodel.contains(selecteddesignation) ? selecteddesignation : null,
                            items: getdesignationListmodel.map((staff) => DropdownMenuItem<GetDesignationListModel>(
                              value: staff,
                              child: Text(staff.masterName ?? "-", overflow: TextOverflow.ellipsis),
                            )).toList(),
                            onChanged: (value) {
                              setState(() {
                                selecteddesignation = value;
                                selectedItemName    = value?.masterName ?? "";
                                selectedItemIdd     = value?.designationId?.toInt();
                              });
                            },
                            isExpanded: true,
                          ),
                        ],
                        const SizedBox(height: 14),
                        _InlineField(
                          label: 'Serial Number *',
                          child: TextField(
                            controller: serialNoController,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20),
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                            ],
                            style: AppTextStyles.sqcInputText,
                            decoration: _inputDecoration(
                              'Serial No',
                              errorText: _isinvoiceEmpty ? 'Serial No. is required' : null,
                            ),
                            onChanged: (value) => setState(() => _isinvoiceEmpty = value.isEmpty),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _InlineField(
                          label: 'Remark',
                          child: TextFormField(
                            controller: remarksController,
                            maxLength: 250,
                            maxLines: 2,
                            style: AppTextStyles.sqcInputText,
                            decoration: _inputDecoration('Optional remark'),
                          ),
                        ),
                      ]),

                      // ── SECTION: Defect Upload (conditional) ──
                      if (selectedLeak == "Yes" || observedWeight < grossWeight) ...[
                        _SectionHeader(title: 'Defect Evidence', dotColor: _C.red),
                        _FormCard(children: [
                          InkWell(
                            onTap: () => showCameraOptions(context),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _C.redXL,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: _C.red.withOpacity(AppOpacity.sqcRedBorder)),
                              ),
                              child: Row(children: [
                                Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(color: _C.red.withOpacity(AppOpacity.sqcRedIconBg), borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.upload_rounded, color: _C.red, size: 18),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text('Upload Defect File', style: AppTextStyles.sqcUploadLabel),
                                    SizedBox(height: 2),
                                    Text('Image, Video, or ZIP • Max 5MB', style: AppTextStyles.sqcUploadSubLabel),
                                  ]),
                                ),
                                const Icon(Icons.chevron_right_rounded, color: _C.red, size: 18),
                              ]),
                            ),
                          ),
                          // File preview
                          if (selectedFile != null || uploadedFileUrl != null) ...[
                            const SizedBox(height: 12),
                            _buildFilePreview(),
                          ],
                          // ZIP indicator
                          if (selectedZip != null || (uploadedFileUrl?.endsWith('.zip') ?? false)) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.sqcZipChipBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(children: [
                                const Icon(Icons.folder_zip_rounded, color: _C.orange, size: 20),
                                const SizedBox(width: 10),
                                Expanded(child: Text(
                                  selectedZip != null
                                      ? selectedZip!.path.split('/').last
                                      : uploadedFileUrl!.split('/').last,
                                  style: AppTextStyles.sqcZipFilename,
                                )),
                              ]),
                            ),
                          ],
                        ]),
                      ],

                      const SizedBox(height: 8),

                      // ── Add Item Button (Add mode only) ──
                      if (modes != "Edit") ...[
                        SizedBox(
                          width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => addItem(),
                                icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
                                label: const Text('Add to Queue'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _C.blueLight,
                                  foregroundColor: _C.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                  textStyle: AppTextStyles.sqcAddBtnLabel,
                                ),
                              ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // ── Queued Items List ──
                      if (sqcItemList.isNotEmpty && modes != "Edit") ...[
                        _SectionHeader(
                          title: 'Queued Items (${sqcItemList.length})',
                          dotColor: _C.teal,
                        ),
                        _QueuedItemsCard(
                          items: sqcItemList,
                          onEdit: (index) {
                            var item = sqcItemList[index];
                            setState(() {
                              serialNoController.text  = item["SerialNo"]  ?? '';
                              tareController.text      = item["TareWt"]    ?? '';
                              grossController.text     = item["GrossWt"]   ?? '';
                              observedController.text  = item["ObservedWt"]?? '';
                              variationController.text = item["Variation"] ?? '';
                              prefixController.text    = item["DPTDate"]   ?? '';
                              remarksController.text   = item["Remarks"]   ?? '';
                              selectedSealingCondition = item["SealingCond"] == "Y" ? "Yes" : "No";
                              selectedLeak = item["Leakage"] == "Y" ? "Yes" : "No";
                              _selectedItemModel = itemNames.firstWhere(
                                    (name) => itemIds[itemNames.indexOf(name)] == item["ItemId"],
                                orElse: () => '',
                              );
                              selectedItemIddd = int.tryParse(item["ItemId"].toString());
                              if (selectedLeak == "Yes" && item["LeakyBdy"] != null && item["LeakyBdy"] != '') {
                                try {
                                  selecteddesignation = getdesignationListmodel.firstWhere(
                                        (element) => element.designationId.toString() == item["LeakyBdy"].toString(),
                                  );
                                  selectedItemIdd  = selecteddesignation?.designationId?.toInt();
                                  selectedItemName = selecteddesignation?.masterName ?? "";
                                } catch (e) {
                                  debugPrint("Leakage Type not found: $e");
                                  selecteddesignation = null;
                                }
                              } else {
                                selecteddesignation = null;
                                selectedItemIdd = null;
                              }
                              var fileData = item["file"];
                              if (fileData is File)        { selectedFile = fileData; uploadedFileUrl = null; }
                              else if (fileData is String) { uploadedFileUrl = fileData; selectedFile = null; }
                              else                         { selectedFile = null; uploadedFileUrl = null; }
                              sqcItemList.removeAt(index);
                            });
                            showFlushBar(context, "Item moved to form for editing");
                          },
                          onDelete: (index) async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                title: const Text('Remove Item', style: AppTextStyles.sqcDialogTitle),
                                content: const Text('Remove this item from the queue?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Remove', style: TextStyle(color: AppColors.red)),
                                  ),
                                ],
                              ),
                            );
                            if (shouldDelete == true) setState(() => sqcItemList.removeAt(index));
                          },
                        ),
                        const SizedBox(height: 8),
                      ],

                      // ── Action Buttons ──
                      const SizedBox(height: 4),
                      Row(children: [
                        Expanded(
                            child: OutlinedButton(
                              onPressed: () => cancelAction(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _C.textMid,
                                side: const BorderSide(color: _C.border, width: 1.5),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Cancel', style: AppTextStyles.sqcCancelBtnLabel),
                            ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              if (saveFlag) showFlushBar(context, Constants.dayEndCompleted);
                            },
                            child: ElevatedButton(
                              onPressed: (saveFlag || (modes != "Edit" && sqcItemList.isEmpty))
                                  ? null
                                  : () async {
                                // Edit mode: build item from current form state
                                if (modes == "Edit") {
                                  String currentIsoDate = DateTime.now().toUtc().toIso8601String();
                                  Map<String, dynamic> directEditItem = {
                                    "GodownId"    : godownId.toString(),
                                    "ReceiptDate" : currentIsoDate,
                                    "VehicleNo"   : vehicleNoController.text,
                                    "ItemId"      : selectedItemIddd.toString(),
                                    "TareWt"      : tareController.text,
                                    "GrossWt"     : grossController.text,
                                    "ObservedWt"  : observedController.text,
                                    "Variation"   : variationController.text,
                                    "DPTDate"     : prefixController.text,
                                    "SerialNo"    : serialNoController.text.trim(),
                                    "Remarks"     : remarksController.text,
                                    "SealingCond" : selectedSealingCondition == "Yes" ? "Y" : "N",
                                    "Leakage"     : selectedLeak == "Yes" ? "Y" : "N",
                                    "LeakyBdy"    : (selectedLeak == "Yes") ? (selectedItemIdd?.toString() ?? '') : '',
                                    "file"        : selectedFile ?? selectedZip ?? uploadedFileUrl,
                                  };
                                  setState(() => sqcItemList = [directEditItem]);
                                }

                                if (sqcItemList.isEmpty) {
                                  showFlushBar(context, "Please add an item first");
                                  return;
                                }

                                EasyLoading.show(status: modes == "Edit" ? "Updating..." : "Saving...");
                                bool allSuccess = true;

                                for (var item in sqcItemList) {
                                  bool success = await SqcRegisterAddEditForMob(
                                    context, item,
                                    modes == "Edit" ? SQCIdEdit! : 0,
                                    modes == "Edit" ? "EDIT" : "ADD",
                                  );
                                  if (!success) {
                                    allSuccess = false;
                                    if (item['isDuplicate'] == true) {
                                      EasyLoading.dismiss();
                                      return;
                                    }
                                  }
                                }

                                EasyLoading.dismiss();

                                if (allSuccess) {
                                  EasyLoading.showToast(modes == "Edit" ? "Updated successfully" : "Saved successfully");
                                  setState(() => sqcItemList.clear());
                                  Navigator.pushNamed(context, ItemReturnScreen.screenName);
                                  fetchItemSQCAddEditList(context);
                                } else {
                                  EasyLoading.showToast("Update failed");
                                }
                              },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (saveFlag || (modes != "Edit" && sqcItemList.isEmpty))
                                      ? _C.textMuted
                                      : _C.blue,
                                  foregroundColor: _C.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                  textStyle: AppTextStyles.sqcSaveBtnLabel,
                                ),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(modes == "Edit" ? Icons.check_circle_rounded : Icons.cloud_upload_rounded, size: 18),
                                const SizedBox(width: 8),
                                Text(modes == "Edit" ? 'Update' : 'Save All'),
                              ]),
                            ),
                          ),
                        ),
                      ]),

                      const SizedBox(height: 24),

                      // ── SECTION: SQC Records for this Vehicle ──
                      _SectionHeader(title: "Today's SQC Records", dotColor: _C.green),
                      _ReceiptListCard(
                        receiptList: receiptList,
                        vehicleNo: vehicleNoController.text,
                        saveFlag: saveFlag,
                        itemIds: itemIds,
                        itemNames: itemNames,
                        onEditTap: (sale) {
                          var sqcID        = sale.sQCId.toString();
                          var sQCDate      = sale.receiptDate.toString();
                          var sqcVehicle   = sale.vehicleNo.toString();
                          var godownIdV    = sale.godownId.toString();
                          var itemId       = sale.itemId.toString();
                          var itemName     = sale.itemName.toString();
                          var tareWt       = sale.tareWt.toString();
                          var grossWt      = sale.grossWt.toString();
                          var observedWt   = sale.observedWt.toString();
                          var variation    = sale.variation.toString();
                          var dptDate      = sale.dPTDate.toString();
                          var sealing      = sale.sealingCond.toString();
                          var leaky        = sale.leakage.toString();
                          var leakBdy      = sale.leakyBdy.toString();
                          var leakBdyName  = sale.leakName.toString();
                          var serialNo     = sale.serialNo.toString();
                          var remark       = sale.remarks.toString();
                          var uploadFile   = sale.uploadFilePath.toString();

                          if (saveFlag) {
                            showFlushBar(context, Constants.dayEndCompleted);
                          } else {
                            Navigator.pushNamed(context, SQCRegisterScreen.screenName, arguments: {
                              'sqcIDV'      : sqcID,
                              'sqcDateV'    : sQCDate,
                              'vehicleNoV'  : sqcVehicle,
                              'godownIdV'   : godownIdV,
                              'itemIdV'     : itemId,
                              'itemNameV'   : itemName,
                              'itemIds'     : itemIds,
                              'itemNames'   : itemNames,
                              'tareWtV'     : tareWt,
                              'grossWtV'    : grossWt,
                              'observedWtV' : observedWt,
                              'variationV'  : variation,
                              'dptDateV'    : dptDate,
                              'sealingV'    : sealing,
                              'laekyV'      : leaky,
                              'leakTypeIdV' : leakBdy,
                              'leakTypeV'   : leakBdyName,
                              'serialNoV'   : serialNo,
                              'remarkV'     : remark,
                              'fileUploadV' : uploadFile,
                              'modeChange'  : "Edit",
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),
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

  // ── File preview builder ──────────────────────
  Widget _buildFilePreview() {
    if (selectedFile != null) {
      String ext = selectedFile!.path.split('.').last.toLowerCase();
      final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];
      if (videoExtensions.contains(ext)) {
        return (_videoController != null && _videoController!.value.isInitialized)
            ? _VideoPreview(controller: _videoController!, onToggle: () => setState(() {
          _videoController!.value.isPlaying ? _videoController!.pause() : _videoController!.play();
        }))
            : const _LoadingVideoBox();
      } else {
        return _ImagePreview(file: selectedFile!);
      }
    } else if (uploadedFileUrl != null) {
      String ext = uploadedFileUrl!.split('.').last.toLowerCase();
      final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];
      if (videoExtensions.contains(ext)) {
        return (_videoController != null && _videoController!.value.isInitialized)
            ? _VideoPreview(controller: _videoController!, onToggle: () => setState(() {
          _videoController!.value.isPlaying ? _videoController!.pause() : _videoController!.play();
        }))
            : const _LoadingVideoBox();
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            uploadedFileUrl!,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }

  // ── Helper: input decoration ──────────────────
  InputDecoration _inputDecoration(String hint, {String? errorText}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.sqcHintText,
      errorText: errorText,
      filled: true,
      fillColor: AppColors.sqcInputFill,
      contentPadding: AppSpacing.sqcInputContentPadding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _C.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _C.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _C.blueLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _C.red),
      ),
    );
  }

  // ── Video player builder ──────────────────────
  Widget buildVideoPlayer(VideoPlayerController controller) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller)),
          IconButton(
            iconSize: 50, color: Colors.white,
            icon: Icon(controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle),
            onPressed: () {
              controller.value.isPlaying ? controller.pause() : controller.play();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  // ── Media & file helpers (all logic unchanged) ─
  Future<bool> isFileValid(File file) async {
    int size = await file.length();
    if (size > maxFileSize) {
      ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text("File must be less than 5MB")));
      return false;
    }
    return true;
  }

  Future<void> captureMedia(String mediaType) async {
    try {
      XFile? file;
      if (mediaType == 'image')       file = await _picker.pickImage(source: ImageSource.camera);
      else if (mediaType == 'video')  file = await _picker.pickVideo(source: ImageSource.camera);

      if (file != null) {
        final File pickedFile = File(file.path);
        if (!await isFileValid(pickedFile)) return;
        String ext = pickedFile.path.split('.').last.toLowerCase();
        final videoExtensions  = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];
        final imageExtensions  = ['jpg', 'jpeg', 'png', 'heic', 'webp', 'bmp'];
        selectedZip = null;

        if (videoExtensions.contains(ext)) {
          _videoController?.dispose();
          _videoController = VideoPlayerController.file(pickedFile);
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await _videoController!.initialize();
            setState(() { selectedFile = pickedFile; });
            _videoController!.play();
          });
        } else if (imageExtensions.contains(ext)) {
          setState(() { selectedFile = pickedFile; });
        } else {
          ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text("Unsupported file type")));
        }
      }
    } catch (e) { print("Error picking media: $e"); }
  }

  Future<void> pickZipFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['zip']);
    if (result != null) {
      File file = File(result.files.single.path!);
      if (!await isFileValid(file)) return;
      setState(() {
        selectedZip = file;
        selectedFile = null;
        _videoController?.dispose();
        _videoController = null;
      });
    }
  }

  void showCameraOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: AppSpacing.sqcModalVerticalPadding,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: AppSpacing.sqcModalDragHandleW, height: AppSpacing.sqcModalDragHandleH, margin: AppSpacing.sqcModalDragHandleMargin, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
              ListTile(
                leading: Container(width: AppSpacing.sqcMediaIconBox, height: AppSpacing.sqcMediaIconBox, decoration: BoxDecoration(color: AppColors.primaryXLight, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.camera_alt_rounded, color: AppColors.primaryLight, size: 20)),
                title: const Text('Capture Image', style: AppTextStyles.sqcMediaOptionTitle),
                onTap: () async { Navigator.pop(context); await captureMedia('image'); },
              ),
              ListTile(
                leading: Container(width: AppSpacing.sqcMediaIconBox, height: AppSpacing.sqcMediaIconBox, decoration: BoxDecoration(color: AppColors.tealXLight, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.videocam_rounded, color: AppColors.teal, size: 20)),
                title: const Text('Capture Video', style: AppTextStyles.sqcMediaOptionTitle),
                onTap: () async { Navigator.pop(context); await captureMedia('video'); },
              ),
              ListTile(
                leading: Container(width: AppSpacing.sqcMediaIconBox, height: AppSpacing.sqcMediaIconBox, decoration: BoxDecoration(color: AppColors.orange2XLight, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.folder_zip_rounded, color: AppColors.orange2, size: 20)),
                title: const Text('Upload ZIP File', style: AppTextStyles.sqcMediaOptionTitle),
                onTap: () async { Navigator.pop(context); await pickZipFile(); },
              ),
              const SizedBox(height: 8),
            ]),
          ),
        );
      },
    );
  }

  void cancelAction(BuildContext context) {
    final currentVehicleNo  = vehicleNoController.text;
    final currentGodownId   = godownId;
    Navigator.pop(context);
    Navigator.pushNamed(context, SQCRegisterScreen.screenName, arguments: {
      'vehicleNo' : currentVehicleNo,
      'godownId'  : currentGodownId,
      'itemIds'   : itemIds,
      'itemNames' : itemNames,
    });
  }

  // ── Business logic (all unchanged) ────────────
  void addItem() {
    if (_selectedItemModel == null)                    { showFlushBar(this.context, "Please Select An Item");         return; }
    if (tareController.text.isEmpty)                   { showFlushBar(this.context, "Please Enter Tare Weight");      return; }
    if (observedController.text.isEmpty)               { showFlushBar(this.context, "Please Enter Observed Weight");  return; }
    if (prefixController.text.isEmpty)                 { showFlushBar(this.context, "Please Enter DPT Date");         return; }
    if (selectedSealingCondition == null || selectedSealingCondition!.isEmpty) { showFlushBar(this.context, "Please Select Sealing Condition"); return; }
    if (selectedLeak == null || selectedLeak!.isEmpty) { showFlushBar(this.context, "Please Select Leakage Option");  return; }
    if (selectedLeak == "Yes" && selecteddesignation == null) { showFlushBar(this.context, "Please Select Leakage Type"); return; }
    if (serialNoController.text.isEmpty)               { showFlushBar(this.context, "Please Enter Serial Number");    return; }

    bool isDuplicate = sqcItemList.any((item) => item["SerialNo"]?.toString().trim() == serialNoController.text.trim());
    if (isDuplicate) { showFlushBar(this.context, "Duplicate Serial Number. Cannot add item."); return; }
    if (sqcItemList.length >= 10) { ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text("Max 10 Items Allowed"))); return; }

    Map<String, dynamic> item = {
      "GodownId"    : godownId.toString(),
      "ReceiptDate" : formattedDate ?? '',
      "VehicleNo"   : vehicleNoController.text,
      "ItemId"      : selectedItemIddd.toString(),
      "TareWt"      : tareController.text,
      "GrossWt"     : grossController.text,
      "ObservedWt"  : observedController.text,
      "Variation"   : variationController.text,
      "DPTDate"     : prefixController.text,
      "SerialNo"    : serialNoController.text.trim(),
      "Remarks"     : remarksController.text,
      "SealingCond" : selectedSealingCondition == "Yes" ? "Y" : "N",
      "Leakage"     : selectedLeak == "Yes" ? "Y" : "N",
      "LeakyBdy"    : selectedItemIdd?.toString() ?? '',
      "file"        : selectedFile ?? selectedZip ?? (modes == "Edit" ? uploadedFileUrl : null),
    };

    setState(() {
      if (modes == "Edit") {
        sqcItemList = [item];
      } else {
        bool isDup2 = sqcItemList.any((e) => e["SerialNo"]?.toString().trim() == serialNoController.text.trim());
        if (isDup2) { showFlushBar(this.context, "Duplicate Serial Number in list."); return; }
        sqcItemList.add(item);
      }
    });
    clearForm();
    showFlushBar(this.context, modes == "Edit" ? "Item Updated" : "Item Added");
  }

  Future<void> sendAllSQCItems() async {
    if (sqcItemList.isEmpty) { showFlushBar(this.context, "No Items To Upload"); return; }
    EasyLoading.show(status: "Uploading Items...");
    bool allSuccess = true;
    for (var item in sqcItemList) {
      bool success = await SqcRegisterAddEditForMob(this.context, item, 0, "ADD");
      if (!success) allSuccess = false;
    }
    EasyLoading.dismiss();
    if (allSuccess) {
      EasyLoading.showToast("All Items Uploaded Successfully");
      setState(() => sqcItemList.clear());
    } else {
      EasyLoading.showToast("Items Failed To Upload");
    }
  }

  void clearForm() {
    tareController.clear();
    grossController.clear();
    observedController.clear();
    variationController.clear();
    prefixController.clear();
    serialNoController.clear();
    remarksController.clear();
    setState(() {
      _selectedItemModel       = null;
      selectedSealingCondition = null;
      selectedLeak             = null;
      selecteddesignation      = null;
      selectedFile             = null;
      uploadedFileUrl          = null;
      selectedZip              = null;
      if (_videoController != null) { _videoController!.dispose(); _videoController = null; }
    });
  }

  // ── API Methods (all unchanged) ───────────────
  Future<bool> SqcRegisterAddEditForMob(BuildContext context, Map<String, dynamic> item, int SQCId, String action) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken   = prefs.getString('token');
      String? staffId       = prefs.getString('StaffId');
      int addedBys = int.parse(staffId!);

      final request = http.MultipartRequest('POST', Uri.parse(AppUrl.SQCFilledCylAddEdit));
      request.headers['Authorization'] = 'Bearer $bearerToken';
      request.fields.addAll({
        "SQCId"        : SQCId.toString(),
        "DistributorId": distributorId ?? '',
        "GodownId"     : item["GodownId"]   ?? '',
        "ReceiptDate"  : item["ReceiptDate"] ?? '',
        "VehicleNo"    : item["VehicleNo"]  ?? '',
        "ItemId"       : item["ItemId"]     ?? '',
        "TareWt"       : item["TareWt"]     ?? '',
        "GrossWt"      : item["GrossWt"]    ?? '',
        "ObservedWt"   : item["ObservedWt"] ?? '',
        "Variation"    : item["Variation"]  ?? '',
        "DPTDate"      : item["DPTDate"]    ?? '',
        "SerialNo"     : item["SerialNo"]   ?? '',
        "Remarks"      : item["Remarks"]    ?? '',
        "SealingCond"  : item["SealingCond"]?? '',
        "Leakage"      : item["Leakage"]    ?? '',
        "LeakyBdy"     : item["LeakyBdy"]   ?? '',
        "UpdatedBy"    : addedBys.toString(),
        "AddedBy"      : addedBys.toString(),
        "Platform"     : "MOB",
        "Action"       : action,
      });

      var fileData = item["file"];
      if (fileData != null) {
        if (fileData is File) {
          debugPrint("Uploading NEW file from path: ${fileData.path}");
          final mimeTypeData = lookupMimeType(fileData.path)?.split('/') ?? ['application', 'octet-stream'];
          request.files.add(await http.MultipartFile.fromPath('UploadFile', fileData.path, contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
        } else if (fileData is String && fileData.isNotEmpty && fileData != "0" && fileData != "null") {
          debugPrint("Sending EXISTING file string: $fileData");
          request.fields['UploadFile'] = fileData;
        }
      }

      debugPrint("----- REQUEST BODY -----");
      request.fields.forEach((key, value) => debugPrint("$key : $value"));

      final response = await http.Response.fromStream(await request.send());
      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body == '-1') {
          item['isDuplicate'] = true;
          EasyLoading.showToast("${item["SerialNo"]} This serial number already exists");
          return false;
        } else if (response.body != '0') {
          debugPrint("Item uploaded successfully: ${item["ItemId"]}");
          item['isDuplicate'] = false;
          return true;
        } else {
          debugPrint("Failed to upload item: ${item["ItemId"]}");
          item['isDuplicate'] = false;
          return false;
        }
      } else {
        debugPrint("Server error: ${response.statusCode}");
        EasyLoading.showToast("Server error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Error uploading item: $e");
      return false;
    }
  }

  Future<void> getDesignationList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken   = prefs.getString('token');
    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse('${AppUrl.GetDesignationList}/1/LeakageType'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint("GetDesignationList: ${response.body}");
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

  Future<void> checkAndSaveDayEndData() async {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false
      ..userInteractions = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId  = prefs.getString('DistributorId');
    String? bearerToken    = prefs.getString('token');
    int? distributorIds    = int.parse(distributorId!);
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $bearerToken"},
      );
      debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> apiResponse = json.decode(response.body);
        if (apiResponse.isEmpty) { saveFlag = false; }
        else {
          saveFlag = true;
          var dayEndData = apiResponse[0];
          int DSRSaved      = dayEndData['DSRSaved']      ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved     = dayEndData['OpClSaved']     ?? 0;
        }
      }
    } catch (e) { print("Exception: $e"); }
  }

  Future<void> fetchItemSQCAddEditList(BuildContext context) async {
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) { showFlushBar(context, Constants.connectionMessage); return; }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId   = prefs.getString('DistributorId');
    String? token           = prefs.getString('token');
    if (distributorId == null || distributorId.isEmpty) { showFlushBar(context, "Distributor ID is missing."); return; }
    if (token         == null || token.isEmpty)         { showFlushBar(context, "Authentication token is missing."); return; }

    final String fmtDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      final Map<String, String> requestBody = {"DistributorId": distributorId, "FromDate": fmtDate, "ToDate": fmtDate};
      print("Request body: $requestBody");
      final response = await http.post(
        Uri.parse('${AppUrl.GetSQCFilledCylList}'),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
        body: json.encode(requestBody),
      );
      print("API Status: ${response.statusCode}");
      print("API Response GetSQCFilledCylList: ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() { receiptList = data.map((json) => GetSqcFilledCylListModel.fromJson(json)).toList(); isLoading = false; });
      } else {
        setState(() { isLoading = false; });
        showFlushBar(context, Constants.listGettingFail);
      }
    } catch (e) {
      setState(() { isLoading = false; });
      print("Error fetching SQC list: $e");
      showFlushBar(context, Constants.listGettingFail);
    }
  }

  Future<void> _initializeNetworkVideo(String url) async {
    print("Initializing video controller with URL: $url");
    try {
      _videoController?.dispose();
      _videoController = VideoPlayerController.network(url);
      await _videoController!.initialize();
      print("Video initialized");
      _videoController!.setLooping(true);
      _videoController!.play();
      setState(() {});
    } catch (e) { print("Error initializing video: $e"); }
  }

  Future<void> loadUploadedVideo() async {
    await fetchItemSQCAddEditList(this.context);
    if (uploadedFileUrl == null) return;
    final url = uploadedFileUrl!;
    print("Received URL: $url");
    if (_isVideo(url)) { print("Valid video → initializing player"); await _initializeNetworkVideo(url); }
    else { print("Not a video → skipping player init"); }
  }

  final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];

  bool _isVideo(String url) {
    final lowerUrl = url.toLowerCase();
    return videoExtensions.any((ext) => lowerUrl.endsWith('.$ext'));
  }

  Widget textWidgetBlueColorWithoutStar(String text) {
    return Text(text, style: const TextStyle(color: _C.blueLight, fontSize: 16));
  }

  Widget buildPreview() {
    if (selectedFile == null) return const Text("No file selected");
    if (_videoController != null && _videoController!.value.isInitialized) {
      return SizedBox(height: 200, child: VideoPlayer(_videoController!));
    } else {
      return Image.file(selectedFile!, height: 200, fit: BoxFit.cover);
    }
  }
}

// ══════════════════════════════════════════════════
// REUSABLE UI COMPONENTS
// ══════════════════════════════════════════════════

// ── Hero Strip ──────────────────────────────────
class _SqcHeroStrip extends StatelessWidget {
  const _SqcHeroStrip({required this.vehicleNo, required this.mode});
  final String vehicleNo;
  final String mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: _C.gradHero),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: AppSpacing.sqcHeroStripPadding,
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  mode == "Edit" ? 'Edit SQC Entry' : 'SQC Register',
                  style: _T.heroTitle,
                ),
                const SizedBox(height: 4),
                Text('Godown Keeper Module', style: _T.heroSub),
                if (vehicleNo.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: AppSpacing.sqcHeroVehicleBadge,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(AppOpacity.sqcHeroBadgeBg),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.local_shipping_rounded, color: Colors.white70, size: 14),
                      const SizedBox(width: 6),
                      Text(vehicleNo, style: AppTextStyles.sqcHeroVehicleText),
                    ]),
                  ),
                ],
              ]),
            ),
            Container(
              width: AppSpacing.heroIconContainerSize, height: AppSpacing.heroIconContainerSize,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(AppOpacity.sqcHeroIconBg),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: Colors.white.withOpacity(AppOpacity.sqcHeroIconBorder), width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(
                mode == "Edit" ? 'E' : 'SQC',
                style: AppTextStyles.sqcHeroIconLabel,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ── Section Header ───────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.dotColor});
  final String title;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // compacted section header spacing for high-density layout
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
      child: Row(children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(title.toUpperCase(), style: AppTextStyles.sqcSectionHeader),
      ]),
    );
  }
}

// ── Form Card ────────────────────────────────────
class _FormCard extends StatelessWidget {
  const _FormCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      // tighter card margins & padding for compactness
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _C.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.shadowCard, blurRadius: 8, offset: const Offset(0, 1))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

// ── Read-only display field ───────────────────────
class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.controller, required this.icon});
  final String label;
  final TextEditingController controller;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTextStyles.sqcFieldLabel),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.sqcInputFill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _C.border),
        ),
        child: Row(children: [
          Icon(icon, size: 16, color: _C.blueLight),
          const SizedBox(width: 8),
          Expanded(child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, val, __) => Text(
              val.text.isEmpty ? '—' : val.text,
              style: AppTextStyles.sqcReadOnlyValue.copyWith(color: val.text.isEmpty ? AppColors.textMuted : AppColors.textPrimary),
            ),
          )),
        ]),
      ),
    ]);
  }
}

// ── Generic dropdown field ───────────────────────
class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.label, required this.icon,
    required this.value, required this.items, required this.onChanged,
    this.isExpanded = true,
  });
  final String label;
  final IconData icon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Text(label, style: _T.fieldLabel),
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: label.replaceAll('*', ''),
              style: _T.fieldLabel,
            ),
            if (label.contains('*'))
              const TextSpan(
                text: ' *',
                style: AppTextStyles.sqcRequiredStar,
              ),
          ],
        ),
      ),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.sqcInputFill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _C.border),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isDense: true,
            isExpanded: isExpanded,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _C.textMuted, size: 20),
            hint: Text('Select...', style: AppTextStyles.sqcDropdownHint),
            items: items,
            onChanged: onChanged,
            style: AppTextStyles.sqcDropdownValue,
          ),
        ),
      ),
    ]);
  }
}

// ── Inline labelled text field ───────────────────
class _InlineField extends StatelessWidget {
  const _InlineField({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Text(label, style: _T.fieldLabel),
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: label.replaceAll('*', ''),
              style: _T.fieldLabel,
            ),
            if (label.contains('*'))
              const TextSpan(
                text: ' *',
                style: AppTextStyles.sqcRequiredStar,
              ),
          ],
        ),
      ),
      const SizedBox(height: 4),
      child,
    ]);
  }
}

// ── Compact weight entry field ───────────────────
class _WeightField extends StatelessWidget {
  const _WeightField({
    required this.label, required this.controller,
    required this.readOnly, this.errorText, this.onChanged,
  });
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Text(label, style: _T.fieldLabel),
      Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: label.replaceAll('*', ''),
              style: _T.fieldLabel,
            ),
            if (label.contains('*'))
              const TextSpan(
                text: ' *',
                style: AppTextStyles.sqcRequiredStar,
              ),
          ],
        ),
      ),
      const SizedBox(height: 4),
      TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}'))],
        style: AppTextStyles.sqcWeightValue,
        decoration: InputDecoration(
          hintText: '0.000',
          hintStyle: AppTextStyles.sqcHintText,
          errorText: errorText,
          filled: true,
          fillColor: readOnly ? AppColors.sqcInputFillReadOnly : AppColors.sqcInputFill,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          border:         OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.border)),
          enabledBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _C.border)),
          focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _C.blueLight, width: 2)),
          errorBorder:    OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _C.red)),
        ),
        onChanged: onChanged,
      ),
    ]);
  }
}

// ── Queued Items Card ────────────────────────────
class _QueuedItemsCard extends StatelessWidget {
  const _QueuedItemsCard({required this.items, required this.onEdit, required this.onDelete});
  final List<Map<String, dynamic>> items;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.shadowCard, blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: Column(children: [
        // Header row
        Container(
          padding: AppSpacing.sqcQueueHeaderPadding,
          decoration: const BoxDecoration(
            color: _C.blueXL,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Row(children: const [
            Expanded(flex: 3, child: Text('Serial No.', style: AppTextStyles.sqcQueueColHeader)),
            Expanded(flex: 2, child: Text('DPT Date',  style: AppTextStyles.sqcQueueColHeader, textAlign: TextAlign.center)),
            SizedBox(width: 70, child: Text('Actions',   style: AppTextStyles.sqcQueueColHeader, textAlign: TextAlign.center)),
          ]),
        ),
        // Data rows
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.divider),
          itemBuilder: (context, index) {
            final item = items[index];
            final leaky = item["Leakage"] == "Y" || item["Leakage"] == "Yes";
            return Padding(
              padding: AppSpacing.sqcQueueRowPadding,
              child: Row(children: [
                Expanded(
                  flex: 3,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item["SerialNo"] ?? '—', style: AppTextStyles.sqcQueueSerial),
                    const SizedBox(height: 2),
                    // Row(children: [
                    //   if (leaky)
                    //     Container(
                    //       margin: const EdgeInsets.only(right: 4),
                    //       padding: AppSpacing.sqcLeakyBadgePadding,
                    //       decoration: BoxDecoration(color: _C.redXL, borderRadius: BorderRadius.circular(6)),
                    //       child: const Text('Leaky', style: AppTextStyles.sqcLeakyBadge),
                    //     ),
                    //  // Text(item["ItemId"] != null ? 'Item #\${item["ItemId"]}' : '', style: AppTextStyles.sqcQueueItemInfo),
                    // ]),

                  ]),
                ),
                Expanded(
                  flex: 2,
                  child: leaky
                      ? Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: AppSpacing.sqcLeakyBadgePadding,
                    decoration: BoxDecoration(
                      color: _C.redXL,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Leaky',
                      style: AppTextStyles.sqcLeakyBadge,
                    ),
                  )
                      : const SizedBox(), // empty widget when false
                ),
                Expanded(
                  flex: 2,
                  child: Text(item["DPTDate"] ?? '—', textAlign: TextAlign.center, style: AppTextStyles.sqcQueueDptDate),
                ),
                SizedBox(
                  width: 70,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    InkWell(
                      onTap: () => onEdit(index),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(width: AppSpacing.sqcQueueActionIconBox, height: AppSpacing.sqcQueueActionIconBox, decoration: BoxDecoration(color: AppColors.primaryXLight, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.edit_rounded, color: AppColors.primaryLight, size: 16)),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => onDelete(index),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(width: AppSpacing.sqcQueueActionIconBox, height: AppSpacing.sqcQueueActionIconBox, decoration: BoxDecoration(color: AppColors.redXLight, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.delete_rounded, color: AppColors.red, size: 16)),
                    ),
                  ]),
                ),
              ]),
            );
          },
        ),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text('No pending items', style: AppTextStyles.sqcEmptyPlaceholder)),
          ),
      ]),
    );
  }
}

// ── Receipt List Card ────────────────────────────
class _ReceiptListCard extends StatelessWidget {
  const _ReceiptListCard({
    required this.receiptList, required this.vehicleNo,
    required this.saveFlag, required this.itemIds, required this.itemNames,
    required this.onEditTap,
  });
  final List<GetSqcFilledCylListModel> receiptList;
  final String vehicleNo;
  final bool saveFlag;
  final List<String> itemIds;
  final List<String> itemNames;
  final ValueChanged<GetSqcFilledCylListModel> onEditTap;

  @override
  Widget build(BuildContext context) {
    final filtered = receiptList.where((s) => s.vehicleNo.toString() == vehicleNo).toList();

    if (filtered.isEmpty) {
      return Container(
        padding: AppSpacing.sqcEmptyCardPadding,
        decoration: BoxDecoration(
          color: _C.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: AppColors.shadowCard, blurRadius: 12, offset: const Offset(0, 2))],
        ),
        child: const Center(
          child: Column(children: [
            Icon(Icons.inbox_rounded, color: _C.textMuted, size: 32),
            SizedBox(height: 8),
            Text('No records found', style: AppTextStyles.sqcNoRecordsLabel),
          ]),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: _C.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.shadowCard, blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.divider),
        itemBuilder: (context, index) {
          final sale = filtered[index];
          return Padding(
            padding: AppSpacing.sqcReceiptRowPadding,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Row(children: [
                    Container(
                      width: AppSpacing.sqcReceiptIconBox, height: AppSpacing.sqcReceiptIconBox,
                      decoration: BoxDecoration(color: AppColors.primaryXLight, borderRadius: AppSpacing.sqcIconBadgeRadius),
                      child: const Icon(Icons.qr_code_2_rounded, color: _C.blueLight, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Serial No: ${sale.serialNo ?? "—"}', style: AppTextStyles.sqcReceiptSerial),
                      Text(sale.itemName?.toString() ?? '—', style: AppTextStyles.sqcReceiptItemName),
                    ])),
                  ]),
                ),
                InkWell(
                  onTap: () => onEditTap(sale),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: AppSpacing.sqcEditBtnPadding,
                    decoration: BoxDecoration(
                      color: saveFlag ? AppColors.sqcInputFillReadOnly : AppColors.primaryXLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.edit_rounded, size: 14, color: saveFlag ? _C.textMuted : _C.blueLight),
                      const SizedBox(width: 4),
                      Text('Edit', style: AppTextStyles.sqcReceiptEditBtn.copyWith(color: saveFlag ? AppColors.textMuted : AppColors.primaryLight)),
                    ]),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _MetricPill(label: 'Tare Wt',  value: sale.tareWt?.toString()     ?? '—')),
                const SizedBox(width: AppSpacing.sqcMetricGap),
                Expanded(child: _MetricPill(label: 'Gross Wt', value: sale.grossWt?.toString()    ?? '—')),
                const SizedBox(width: 8),
                Expanded(child: _MetricPill(label: 'Obs. Wt',  value: sale.observedWt?.toString() ?? '—')),
                const SizedBox(width: 8),
                Expanded(child: _MetricPill(label: 'Variation', value: sale.variation?.toString() ?? '—')),
              ]),
            ]),
          );
        },
      ),
    );
  }
}

// ── Small metric pill for receipt rows ──────────
class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.sqcMetricPillPadding,
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text(value, style: AppTextStyles.sqcMetricValue),
        const SizedBox(height: 2),
        Text(label,  style: AppTextStyles.sqcMetricLabel),
      ]),
    );
  }
}

// ── Image preview wrapper ────────────────────────
class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.file});
  final File file;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(file, width: double.infinity, height: 200, fit: BoxFit.cover),
    );
  }
}

// ── Video preview wrapper ────────────────────────
class _VideoPreview extends StatelessWidget {
  const _VideoPreview({required this.controller, required this.onToggle});
  final VideoPlayerController controller;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: 200,
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
      child: Stack(alignment: Alignment.center, children: [
        AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller)),
        IconButton(
          iconSize: 44, color: Colors.white,
          icon: Icon(controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle),
          onPressed: onToggle,
        ),
      ]),
    );
  }
}

// ── Loading video placeholder ────────────────────
class _LoadingVideoBox extends StatelessWidget {
  const _LoadingVideoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)),
      child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularProgressIndicator(strokeWidth: 2),
        SizedBox(height: 8),
        Text('Loading video...', style: AppTextStyles.sqcLoadingVideoLabel),
      ])),
    );
  }
}
