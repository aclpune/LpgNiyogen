
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../newTheam/core/theme/app_typography.dart';
import '../../Utils/app_url.dart';
import '../../Utils/styles/app_colors.dart';
import '../ClickModelClass/ARBProfitDetailDataGetModel.dart';
import '../ClickModelClass/ChartData.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';


// ─────────────────────────────────────────────
// PREPAID BOOKING & SETTLEMENT GRAPH SCREEN
// Refactored to match Niyojan dashboard theme
// ─────────────────────────────────────────────

class PrepaidBookingAndSettlementGraphScreen extends StatefulWidget {
  static const screenName = '/prepaidBookingAndSettlementGraphScreen';
  const PrepaidBookingAndSettlementGraphScreen({super.key});

  @override
  State<PrepaidBookingAndSettlementGraphScreen> createState() =>
      _PrepaidBookingAndSettlementGraphScreenState();
}

class _PrepaidBookingAndSettlementGraphScreenState
    extends State<PrepaidBookingAndSettlementGraphScreen> {
  // ── State ──────────────────────────────────────────────────────────────────
  late List<ArbProfitDetailDataGetModel> arbProfitDetailDataGetModel = [];
  bool isLoading = true;
  List<String> xAxisDates = [];
  late List<ChartData> chartData = [];
  String currentFilter = 'THIS_MONTH';

  final Map<String, String> filterLabels = {
    'PREVIOUS_MONTH': 'Previous Month',
    'THIS_MONTH': 'This Month',
    'THIS_WEEK': 'This Week',
  };

  final GlobalKey _repaintKey = GlobalKey();
  late TooltipBehavior _tooltipBehavior;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    fetchChartData('THIS_MONTH');
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: true,
      format: 'point.x : point.y',
      builder: (dynamic data, dynamic point, dynamic series,
          int pointIndex, int seriesIndex) {
        if (series.name == 'Settlement %') {
          return _TooltipCard(amount: data.totalSettlAmt);
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // ── PDF helpers (unchanged) ────────────────────────────────────────────────
  Future<Uint8List> _captureChartToImage() async {
    final RenderRepaintBoundary boundary =
    _repaintKey.currentContext!.findRenderObject()
    as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    final imageBytes = await _captureChartToImage();
    final pdfImage = pw.MemoryImage(imageBytes);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Text('Daily Punch & Settlement Count',
                style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Image(pdfImage),
          ]);
        },
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/chart.pdf');
    await file.writeAsBytes(await pdf.save());
    _downloadPdf(file);
  }

  Future<void> _downloadPdf(File file) async {
    await Printing.sharePdf(
      bytes: await file.readAsBytes(),
      filename: 'PunchingStatus.pdf',
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    const double barWidth = 60;
    const double barSpacing = 10;
    const int minBarsToShow = 10;
    final int itemCount = chartData.length;
    final double chartWidth = (barWidth + barSpacing) *
        (itemCount < minBarsToShow ? minBarsToShow : itemCount);

    return Scaffold(
      // Matches dashboard scaffold background
      backgroundColor: AppColors.bg2,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildLegendRow(),
            Expanded(child: _buildChartArea(chartWidth)),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.gradPrimary,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),

          // Title
          Expanded(
            child: Text(
              'Daily Punch Vs Settlement Count',
              style: AppTypography.heroSubtitle.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Filter label + menu
          _FilterSelector(
            currentFilter: currentFilter,
            filterLabels: filterLabels,
            onSelected: (value) {
              setState(() => currentFilter = value);
              fetchChartData(currentFilter);
            },
          ),
        ],
      ),
    );
  }

  // ── Legend row ─────────────────────────────────────────────────────────────
  Widget _buildLegendRow() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _LegendDot(color: AppColors.orange, label: 'Daily Punch Count'),
          const SizedBox(width: 16),
          _LegendDot(color: AppColors.blueLight, label: 'Settlement Count'),
        ],
      ),
    );
  }

  // ── Chart area ─────────────────────────────────────────────────────────────
  Widget _buildChartArea(double chartWidth) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rotated Y-axis label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                'Punching & Settlement Count',
                style: AppTypography.sectionHeader.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ),
          ),

          // Scrollable chart
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: chartWidth,
                  child: RepaintBoundary(
                    key: _repaintKey,
                    child: _buildSfChart(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Syncfusion chart ───────────────────────────────────────────────────────
  Widget _buildSfChart() {
    return SfCartesianChart(
      tooltipBehavior: _tooltipBehavior,
      plotAreaBorderWidth: 0,
      backgroundColor: Colors.transparent,
      primaryXAxis: CategoryAxis(
        labelRotation: 45,
        interval: 1,
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: TextStyle(
          fontSize: 10,
          color: AppColors.textMuted,
          fontWeight: FontWeight.w500,
        ),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(
          width: 1,
          color: AppColors.border.withOpacity(0.6),
          dashArray: const [4, 4],
        ),
        axisLabelFormatter: (AxisLabelRenderDetails details) =>
            ChartAxisLabel('', const TextStyle(fontSize: 0)),
      ),
      series: <CartesianSeries>[
        ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData d, _) => d.date,
          yValueMapper: (ChartData d, _) => d.totalPunchCnt,
          name: 'Total Punch',
          // Matches AppColors.orange gradient feel
          color: AppColors.orange,
          width: 0.7,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.textMid,
            ),
          ),
        ),
        ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData d, _) => d.date,
          yValueMapper: (ChartData d, _) => d.totalSettlPer,
          name: 'Settlement %',
          color: AppColors.blueLight,
          width: 0.7,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.textMid,
            ),
          ),
        ),
      ],
    );
  }

  // ── API (unchanged) ────────────────────────────────────────────────────────
  Future<void> fetchChartData(String flag) async {
    try {
      EasyLoading.show();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      if (bearerToken == null) throw Exception('Bearer token is missing');

      final response = await http.get(
        Uri.parse(
            '${AppUrl.GetDashboardPrepaidPunchDtls_Mob}/$distributorId/$flag'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      debugPrint('GetDashboardPrepaidPunchDtls_Mob request'
          ' ${AppUrl.GetDashboardARBProfitDtls_Mob}/$distributorId/$flag');
      debugPrint(
          'GetDashboardPrepaidPunchDtls_Mob response ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<ChartData> fetchedData = [];
        final dates =
        data[0].keys.where((key) => key != 'CountFor').toList();
        for (var date in dates) {
          double totalPunchCnt = data[0][date] ?? 0.0;
          double totalSettlPer = data[1][date] ?? 0.0;
          double totalSettlAmt = data[2][date] ?? 0.0;
          fetchedData.add(
              ChartData.fromJson(date, totalPunchCnt, totalSettlPer, totalSettlAmt));
        }
        setState(() {
          chartData.clear();
          chartData.forEach((e) => print('Date: "${e.date}"'));
          chartData = fetchedData;
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.dismiss();
        throw Exception('Failed to load data');
      }
    } catch (error) {
      EasyLoading.dismiss();
      print('Error fetching data: $error');
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE REUSABLE SUB-WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

/// Filter selector button shown in the header.
class _FilterSelector extends StatelessWidget {
  const _FilterSelector({
    required this.currentFilter,
    required this.filterLabels,
    required this.onSelected,
  });

  final String currentFilter;
  final Map<String, String> filterLabels;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: PopupMenuButton<String>(
        onSelected: onSelected,
        color: AppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        itemBuilder: (context) => filterLabels.entries
            .map((e) => PopupMenuItem<String>(
          value: e.key,
          child: Text(
            e.value,
            style: AppTypography.labelMD.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ))
            .toList(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              filterLabels[currentFilter] ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}

/// Single coloured square + label used in the chart legend.
class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppTypography.miniLabel.copyWith(
            color: AppColors.textMid,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

/// Branded tooltip card shown when tapping a Settlement bar.
class _TooltipCard extends StatelessWidget {
  const _TooltipCard({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blueLight.withOpacity(0.3)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.currency_rupee_rounded,
              size: 12, color: AppColors.teal),
          Text(
            amount.toStringAsFixed(2),
            style: AppTypography.badgeText.copyWith(
              color: AppColors.teal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}