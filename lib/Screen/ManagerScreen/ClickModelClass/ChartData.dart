class ChartData {
  final String date;
  final double totalPunchCnt;
  final double totalSettlPer;
  final double totalSettlAmt;

  ChartData({
    required this.date,
    required this.totalPunchCnt,
    required this.totalSettlPer,
    required this.totalSettlAmt,
  });

  // Factory method to create a ChartData instance from JSON
  factory ChartData.fromJson(String date, double totalPunchCnt, double totalSettlPer, double totalSettlAmt) {
    return ChartData(
      date: date,
      totalPunchCnt: totalPunchCnt,
      totalSettlPer: totalSettlPer,
      totalSettlAmt: totalSettlAmt,
    );
  }
}
