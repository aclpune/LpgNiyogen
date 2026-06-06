class TransactionModel {
  int? transId;
  int? distributorId;
  int? staffId;
  int? itemId;
  String? transactionCode;
  String? transTime;
  String? remark;
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
      'Action': action,
      'AddedBy': addedBy,
    };
  }
}
