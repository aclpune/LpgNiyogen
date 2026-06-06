import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lpgsalesandinventory/Screen/Utils/CustomAppBarManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../newTheam/core/theme/app_colors.dart';
import '../../newTheam/core/theme/app_typography.dart';
import '../../newTheam/features/delivery_boy_list/bloc/delivery_boy_list_cubit.dart';
import '../ConstantScreen/widgets.dart';
import '../Utils/CustomAppBar.dart';
import '../Utils/Styling.dart';
import '../Utils/Widget.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import '../Utils/size_config.dart';
import 'ManagerModelClass/DailySaleSaummaryListModel.dart';
import 'package:http/http.dart' as http;

import 'ManagerModelClass/GetLastUploadedFrileDifferenceModel.dart';
import 'ManagerSingleItemUI/DeliveryBoyWiseListItem.dart';
class DeliveryBoyWiseListShow extends StatefulWidget {
  static const screenName = '/deliveryBoyWiseListShow';
  final bool disableNetworkCallsForTest;

  const DeliveryBoyWiseListShow({super.key, this.disableNetworkCallsForTest = false});

  @override
  State<DeliveryBoyWiseListShow> createState() => _DeliveryBoyWiseListShowState();
}

class _DeliveryBoyWiseListShowState extends State<DeliveryBoyWiseListShow> {
  TextEditingController searchController = TextEditingController();
  List<DailySaleSaummaryListModel> dailySales = [];
  List<DailySaleSaummaryListModel> filteredSales = [];

  bool _isExpanded = false;
  bool isLoading = true;
  String staffName = '';
  String distributorName = '';
  String? roleId, isUserActive, userActivet;

  @override
  void initState() {
    super.initState();
    if (widget.disableNetworkCallsForTest) {
      return;
    }
    getUserDetail();
    fetchDailySales();
  }

  void getUserDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      staffName = preferences.getString('StaffName') ?? '';
      distributorName = preferences.getString('DistributorName') ?? '';
      roleId = preferences.getString('RoleId');
      isUserActive = preferences.getString('IsUserActive');
      userActivet = preferences.getString('userActivet');
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildHeroStrip() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.gradHero),
      child: Stack(
        children: [
          Positioned(
            top: -50, right: -70,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
            ),
          ),
          Positioned(
            bottom: -40, left: -30,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.tealLight.withOpacity(0.12)),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good ${_greeting()}, ${staffName.isNotEmpty ? staffName : 'Manager'} 👋',
                              style: AppTypography.heroSubtitle,
                            ),
                            const SizedBox(height: 4),
                            Text('Delivery Men', style: AppTypography.heroTitle),
                            const SizedBox(height: 5),
                            Text(
                              DateFormat('EEEE, dd MMM yyyy').format(DateTime.now()),
                              style: AppTypography.heroSubtitle.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: Colors.white.withOpacity(0.28), width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          () {
                            final parts = staffName.trim().split(RegExp(r'\s+'));
                            if (parts.length >= 2) {
                              return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
                            } else if (parts.isNotEmpty && parts[0].length >= 2) {
                              return parts[0].substring(0, 2).toUpperCase();
                            }
                            return 'M';
                          }(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.people_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Total: ${filteredSales.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.disableNetworkCallsForTest
          ? DeliveryBoyListCubit()
          : DeliveryBoyListCubit()..loadDeliveryBoyList(),
      child: Scaffold(
        backgroundColor: AppColors.bg2,
        body: isLoading
            ? RefreshIndicator(
                color: AppColors.blue,
                backgroundColor: AppColors.white,
                onRefresh: () async {
                  await fetchDailySales();
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeroStrip()),
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: CircularProgressIndicator(color: AppColors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                color: AppColors.blue,
                backgroundColor: AppColors.white,
                onRefresh: () async {
                  await fetchDailySales();
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeroStrip()),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 44,
                              child: TextField(
                                controller: searchController,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                                  hintText: 'Search delivery boy',
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'OpenSans',
                                    color: AppColors.textMuted,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.border),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.border),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.blue, width: 2),
                                  ),
                                  fillColor: AppColors.white,
                                  filled: true,
                                ),
                                onChanged: (value) {
                                  filterSearchResults(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (filteredSales.isNotEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: DeliveryBoyWiseListItem(filteredSales[index]),
                              );
                            },
                            childCount: filteredSales.length,
                          ),
                        ),
                      )
                    else
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppColors.blueXL,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(Icons.inbox_rounded, color: AppColors.blue, size: 40),
                                ),
                                const SizedBox(height: 16),
                                Text('No Data Available', style: AppTypography.cardTitle),
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your search criteria',
                                  style: AppTypography.cardSubtitle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
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
