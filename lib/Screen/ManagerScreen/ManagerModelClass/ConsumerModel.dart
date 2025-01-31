class ConsumerModel {
  int? consId;
  int? distributorId;
  int? staffId;
  int? itemId;
  String? consumerNo;
  DateTime? addedOn;
  String? action;
  int? addedBy;

  ConsumerModel({
    this.consId,
    this.distributorId,
    this.staffId,
    this.itemId,
    this.consumerNo,
    this.addedOn,
    this.action,
    this.addedBy,
  });

  factory ConsumerModel.fromJson(Map<String, dynamic> json) {
    return ConsumerModel(
      consId: json['ConsId'],
      distributorId: json['DistributorId'],
      staffId: json['StaffId'],
      itemId: json['ItemId'],
      consumerNo: json['ConsumerNo'],
      addedOn: DateTime.parse(json['AddedOn']),
      action: json['Action'],
      addedBy: json['AddedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ConsId': consId,
      'DistributorId': distributorId,
      'StaffId': staffId,
      'ItemId': itemId,
      'ConsumerNo': consumerNo,
      'AddedOn': addedOn?.toIso8601String(),
      'Action': action,
      'AddedBy': addedBy,
    };
  }
}
