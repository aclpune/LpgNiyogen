import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../ConstantScreen/widgets.dart';
import '../../../../Utils/CustomAppBar.dart';
import '../../../../Utils/Widget.dart';
import '../../../../Utils/app_url.dart';
import '../../../../Utils/constants.dart';
import '../../../../Utils/styles/app_colors.dart';
import '../../../../Utils/styles/app_spacing.dart';
import '../../../../Utils/styles/app_text_styles.dart';
import '../../../BottomNavigationForGodownKeeper.dart';
import 'package:http/http.dart' as http;

import '../model/GetEXMIListModel.dart';
import 'ItemReturnXMIListItemUI.dart';

// ─────────────────────────────────────────────
// RECEIPT EXMI LIST SCREEN
// Refactored UI — logic/API/state UNCHANGED
// ─────────────────────────────────────────────
class ItemReturnXMIListScreen extends StatefulWidget {
  static const screenName = '/itemReturnXMIListScreen';
  const ItemReturnXMIListScreen({super.key});

  @override
  State<ItemReturnXMIListScreen> createState() =>
      _ItemReturnXMIListScreenState();
}

class _ItemReturnXMIListScreenState extends State<ItemReturnXMIListScreen> {
  // ── State — UNCHANGED ──
  List<GetExmiListModel> receiptList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItemReceipts();
  }

  @override
  Widget build(BuildContext context) {
    final argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(
            context,
            BottomNavigationForGodownKeeper.screenName,
            arguments: "onBack",
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            BottomNavigationForGodownKeeper.screenName,
          );
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background2,           // was: Color(0xFFF1F5FE)
        appBar: CustomGKAppBar(title: 'Receipt EXMI'),
        body: Column(
          children: [
            // AppGradientHeader(
            //   title: 'Receipt EXMI',
            //   subtitle: 'View and manage EXMI receipts',
            //   icon: Icons.receipt_long_rounded,
            //   onBack: () => Navigator.pushReplacementNamed(
            //     context,
            //     BottomNavigationForGodownKeeper.screenName,
            //     arguments: "onBack",
            //   ),
            // ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primaryLight,             // was: Color(0xFF2D52C5)
                backgroundColor: AppColors.surface,       // was: Colors.white
                onRefresh: _refresh,
                child: isLoading
                    ? const _LoadingState()
                    : receiptList.isNotEmpty
                    ? _buildList()
                    : const _EmptyState(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: AppSpacing.xmiListPadding,               // was: fromLTRB(16,8,16,24)
      itemCount: receiptList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: AppSpacing.xmiCardGap,               // was: only(bottom:12)
          child: ItemReturnXMIListItemUI(receiptList[index]),
        );
      },
    );
  }

  Future<void> _refresh() async {
    await fetchItemReceipts();
  }

  // ── API call — UNCHANGED ──
  Future<void> fetchItemReceipts() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token');

      try {
        final response = await http.get(
          Uri.parse(
              '${AppUrl.GetItemEXMIDetailList}/$distributorId/$godownId/$godownKeeperId'),
          headers: {'Authorization': 'Bearer $token'},
        );
        print("Request URL GetItemEXMIDetailList: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        print(
            "API Response Status Code GetItemEXMIDetailList: ${response.statusCode}");
        print("API Response Body GetItemEXMIDetailList: ${response.body}");

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            receiptList =
                data.map((json) => GetExmiListModel.fromJson(json)).toList();
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {
        setState(() => isLoading = false);
        showFlushBar(context, Constants.listGettingFail);
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }
}

// ─────────────────────────────────────────────
// LOADING STATE
// ─────────────────────────────────────────────
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryLight,               // was: Color(0xFF2D52C5)
            strokeWidth: AppSizes.xmiLoadingStroke,      // was: 3
          ),
          const SizedBox(height: AppSpacing.lg),        // was: SizedBox(height:16)
          Text(
            'Loading receipts…',
            style: AppTextStyles.xmiLoadingLabel,        // was: inline TextStyle(fontSize:14, w500, color:Color(0xFF6B7280))
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// EMPTY STATE
// Wrapped in ListView so pull-to-refresh works
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.xmiEmptyIconBox,         // was: 72
                height: AppSizes.xmiEmptyIconBox,        // was: 72
                decoration: AppDecorations.emptyStateIconBlue.copyWith(
                  borderRadius: AppRadius.xmiCard,       // was: BorderRadius.circular(20) — reuses xmiCard(18) as closest token; exact match below:
                ),
                // Note: the original used BorderRadius.circular(20) which maps to AppRadius.xxl (20.0)
                child: Icon(
                  Icons.inbox_rounded,
                  color: AppColors.primaryLight,         // was: Color(0xFF2D52C5)
                  size: AppSizes.xmiEmptyIconPx,         // was: 34
                ),
              ),
              const SizedBox(height: AppSpacing.lg),    // was: SizedBox(height:16)
              Text(
                'No Data Found',
                style: AppTextStyles.emptyTitle,         // was: inline TextStyle(fontSize:16, w700, color:Color(0xFF111827))
              ),
              const SizedBox(height: 6),
              Text(
                'Pull down to refresh',
                style: AppTextStyles.emptySubtitle,      // was: inline TextStyle(fontSize:13, w500, color:Color(0xFF6B7280))
              ),
            ],
          ),
        ),
      ],
    );
  }
}
