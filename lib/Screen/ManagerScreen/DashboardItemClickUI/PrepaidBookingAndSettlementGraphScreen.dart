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

import '../../Utils/app_url.dart';
import '../ClickModelClass/ARBProfitDetailDataGetModel.dart';
import '../ClickModelClass/ChartData.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
class PrepaidBookingAndSettlementGraphScreen extends StatefulWidget {
  static const screenName = '/prepaidBookingAndSettlementGraphScreen';
  const PrepaidBookingAndSettlementGraphScreen({super.key});

  @override
  State<PrepaidBookingAndSettlementGraphScreen> createState() => _PrepaidBookingAndSettlementGraphScreenState();
}

class _PrepaidBookingAndSettlementGraphScreenState extends State<PrepaidBookingAndSettlementGraphScreen> {
  late List<ArbProfitDetailDataGetModel> arbProfitDetailDataGetModel = [];
  bool isLoading = true;
  List<String> xAxisDates = []; // To store dynamic dates
  late List<ChartData> chartData = [];
  String currentFilter = 'THIS_MONTH';
  final Map<String, String> filterLabels = {
    'PREVIOUS_MONTH': 'Previous Month',
    'THIS_MONTH': 'This Month',
    'THIS_WEEK': 'This Week',
  };// default filter
  final GlobalKey _repaintKey = GlobalKey();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    fetchChartData("THIS_MONTH");
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: true,
      format: 'point.x : point.y',
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
        // You can customize this tooltip to show totalSettlAmt
        if (series.name == 'Settlement %') {
          return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '₹${data.totalSettlAmt.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 12),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
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

  double calculateLabelWidth(String label) {
    final textPainter = TextPainter(
      text: TextSpan(text: label, style: TextStyle(fontSize: 10)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.size.width;
  }

  double getBarWidth(String label) {
    double labelWidth = calculateLabelWidth(label);
    double baseWidth = 0.4;

    if (labelWidth > 50) {
      return 0.8;
    }
    return baseWidth;
  }

  Future<Uint8List> _captureChartToImage() async {
    final RenderRepaintBoundary boundary =
    _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final uint8List = byteData!.buffer.asUint8List();
    return uint8List;
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    final imageBytes = await _captureChartToImage();
    final pdfImage = pw.MemoryImage(imageBytes);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text("Daily Punch & Settlement Count", style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Image(pdfImage),
            ],
          );
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

  // Future<void> _generatePdf() async {
  //   final pdf = pw.Document();
  //
  //   // Generate the chart image
  //   final imageBytes = await _captureChartToImage();
  //   final pdfImage = pw.MemoryImage(imageBytes);
  //
  //   // Add a page to the PDF in landscape orientation
  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: PdfPageFormat(595.27, 841.89, marginAll: 10), // A4 landscape format
  //       build: (pw.Context context) {
  //         return pw.Column(
  //           children: [
  //             pw.Text("Dynamic Bar Width Chart", style: pw.TextStyle(fontSize: 24)),
  //             pw.SizedBox(height: 20),
  //             pw.Image(pdfImage), // Add the image of the chart
  //           ],
  //         );
  //       },
  //     ),
  //   );
  //
  //   // Get the app's document directory
  //   final output = await getApplicationDocumentsDirectory();
  //   final filePath = '${output.path}/chart.pdf';
  //   final file = File(filePath);
  //
  //   // Save the PDF file to the device
  //   await file.writeAsBytes(await pdf.save());
  //
  //   // Notify the user where the PDF was saved
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('PDF saved to: $filePath')),
  //   );
  //
  //   // Optional: Open the folder where the file was saved (if supported)
  //   // For Android, you might need a third-party package like 'open_file' to open the file
  // }

  @override
  Widget build(BuildContext context) {
    final double barWidth = 60;
    final double barSpacing = 10;
    final int itemCount = chartData.length;
    // final double chartWidth = (barWidth + barSpacing) * itemCount;
    print('Item count: $itemCount');

    const int minBarsToShow = 10;
    final double chartWidth = (barWidth + barSpacing) * (itemCount < minBarsToShow ? minBarsToShow : itemCount);
    return Scaffold(
      body: SafeArea(
        child:
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.black),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Expanded(
                              child: Text(
                                "Daily Punch Vs Settlement Count",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     _generatePdf();
                            //   },
                            //   child: Row(
                            //     children: [
                            //       Icon(
                            //         Icons.picture_as_pdf,
                            //         size: 15,
                            //         color: Colors.redAccent,
                            //       ),
                            //       SizedBox(width: 4),
                            //       Text(
                            //         "Share PDF",
                            //         style: TextStyle(
                            //           fontSize: 11,
                            //           color: Colors.black,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Row(
                    children: [
                      Text(
                        filterLabels[currentFilter] ?? '', // Show selected filter text
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            currentFilter = value;
                          });
                          fetchChartData(currentFilter); // Call API when filter changes
                        },
                        icon: Icon(Icons.filter_list),
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'PREVIOUS_MONTH', child: Text('Previous Month')),
                          PopupMenuItem(value: 'THIS_MONTH', child: Text('This Month')),
                          PopupMenuItem(value: 'THIS_WEEK', child: Text('This Week')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right:20.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.square,
                        size: 13,
                        color: Colors.orangeAccent,
                      ),
                      SizedBox(width: 4,),
                      Text(
                        "Daily Punch Count",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width:9,),
                  Row(
                    children: [
                      Icon(
                        Icons.square,
                        size: 13,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 4,),
                      Text(
                        "Settlement Count",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Punching & Settlement Count',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                      Container(
                        width: chartWidth,
                        child: RepaintBoundary(
                          key: _repaintKey,
                          child: SfCartesianChart(
                            tooltipBehavior: _tooltipBehavior,
                            primaryXAxis: CategoryAxis(
                              labelRotation: 45,
                              interval: 1,
                              majorGridLines: MajorGridLines(width: 0),
                            ),
                            primaryYAxis: NumericAxis(
                              axisLine: AxisLine(width: 1), // shows axis line
                              majorTickLines: MajorTickLines(size: 0), // hides ticks
                              axisLabelFormatter: (AxisLabelRenderDetails details) {
                                // Hide all Y-axis labels
                                return ChartAxisLabel('', TextStyle(fontSize: 0));
                              },
                            ),
                            series: <CartesianSeries>[
                              ColumnSeries<ChartData, String>(
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.date,
                                yValueMapper: (ChartData data, _) => data.totalPunchCnt,
                                name: 'Total Punch',
                                color: Colors.orangeAccent,
                                width: 0.7,
                                dataLabelSettings: DataLabelSettings(isVisible: true,textStyle: TextStyle(fontSize: 10),),
                              ),
                              ColumnSeries<ChartData, String>(
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.date,
                                yValueMapper: (ChartData data, _) => data.totalSettlPer,
                                name: 'Settlement %',
                                color: Colors.blue,
                                width: 0.7,
                                dataLabelSettings: DataLabelSettings(isVisible: true,
                                  textStyle: TextStyle(fontSize: 10,),

                                ),


                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> fetchChartData(String flag) async {
    try {
      EasyLoading.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');
        if (bearerToken == null) {
          throw Exception('Bearer token is missing');
        }
          final response = await http.get(
            Uri.parse('${AppUrl.GetDashboardPrepaidPunchDtls_Mob}/$distributorId/$flag'),
            headers: {
              'Authorization': 'Bearer $bearerToken',
            },
          );
          debugPrint("GetDashboardPrepaidPunchDtls_Mob request" + '${AppUrl.GetDashboardARBProfitDtls_Mob}/$distributorId/$flag');
          debugPrint("GetDashboardPrepaidPunchDtls_Mob resposnse" + '${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<ChartData> fetchedData = [];
        final dates = data[0].keys.where((key) => key != 'CountFor').toList();
        for (var date in dates) {
          double totalPunchCnt = data[0][date] ?? 0.0;
          double totalSettlPer = data[1][date] ?? 0.0;
          double totalSettlAmt = data[2][date] ?? 0.0;
          fetchedData.add(ChartData.fromJson(date, totalPunchCnt, totalSettlPer,totalSettlAmt));
        }
        setState(() {
          chartData.clear();
          chartData.forEach((e) => print('Date: "${e.date}"'));
          chartData = fetchedData;  // Update the chart data
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
