class ItemData {
  final String date;
  final String deliveryBoyName;
  final String delBoyId;
  final String vehicleNo;
  final String itemName;
  final String itemID;
  final String filled;
  final String sv;
  final String tv;
  final String empty;
  final String defective;
  final String lessEmpty;
  final String remark;
  final String svRemark;
  final String updateFlag;

  ItemData({
    required this.date,
    required this.deliveryBoyName,
    required this.delBoyId,
    required this.vehicleNo,
    required this.itemName,
    required this.itemID,
    required this.filled,
    required this.sv,
    required this.tv,
    required this.empty,
    required this.defective,
    required this.lessEmpty,
    required this.remark,
    required this.svRemark,
    required this.updateFlag,
  });

  // Convert Map to ItemData (from the database)
  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      date: json['date'],
      deliveryBoyName: json['deliveryBoyName'],
      delBoyId: json['delBoyId'],
      vehicleNo: json['vehicleNo'],
      itemName: json['itemName'],
      itemID: json['itemID'],
      filled: json['filled'],
      sv: json['sv'],
      tv: json['tv'],
      empty: json['empty'],
      defective: json['defective'],
      lessEmpty: json['lessEmpty'],
      remark: json['remark'],
      svRemark: json['svRemark'],
      updateFlag: json['updateFlag'],
    );
  }

  // Convert ItemData to Map (for insertion into the database)
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'deliveryBoyName': deliveryBoyName,
      'delBoyId': delBoyId,
      'vehicleNo': vehicleNo,
      'itemName': itemName,
      'itemID': itemID,
      'filled': filled,
      'sv': sv,
      'tv': tv,
      'empty': empty,
      'defective': defective,
      'lessEmpty': lessEmpty,
      'remark': remark,
      'svRemark': svRemark,
      'updateFlag': updateFlag,
    };
  }
}
