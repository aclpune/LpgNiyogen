class TransactionModel {
  int? transId;
  int? distributorId;
  int? staffId;
  int? itemId;
  String? transactionCode;
  String? transTime;
  String? remark;
  DateTime? addedOn;
  String? action;
  int? addedBy;

  TransactionModel({
    this.transId,
    this.distributorId,
    this.staffId,
    this.itemId,
    this.transactionCode,
    this.transTime,
    this.remark,
    this.addedOn,
    this.action,
    this.addedBy,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transId: json['TransId'],
      distributorId: json['DistributorId'],
      staffId: json['StaffId'],
      itemId: json['ItemId'],
      transactionCode: json['TransactionCode'],
      transTime: json['TransTime'],
      remark: json['Remark'],
      addedOn: DateTime.parse(json['AddedOn']),
      action: json['Action'],
      addedBy: json['AddedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TransId': transId,
      'DistributorId': distributorId,
      'StaffId': staffId,
      'ItemId': itemId,
      'TransactionCode': transactionCode,
      'TransTime': transTime,
      'Remark': remark,
      'AddedOn': addedOn?.toIso8601String(),
      'Action': action,
      'AddedBy': addedBy,
    };
  }
}
