class ConsumerModel {
  int? consId;
  int? distributorId;
  int? staffId;
  int? itemId;
  String? consumerNo;
  String? action;
  int? addedBy;
  String? consumerName;
  String? orderDate;
  String? cashmemoDate;
  String? paymentStatus;
  String? remark;
  int? niyojanDel;
  int? cDCMSDel;
  int? InCorrectStatus;
  String? PayDate;
  String? DeliveryDate;
  String? SettDate;

  ConsumerModel({
    this.consId,
    this.distributorId,
    this.staffId,
    this.itemId,
    this.consumerNo,
    this.action,
    this.addedBy,
    this.consumerName,
    this.orderDate,
    this.cashmemoDate,
    this.paymentStatus,
    this.remark,
    this.niyojanDel,
    this.cDCMSDel,
    this.InCorrectStatus,
    this.PayDate,
    this.DeliveryDate,
    this.SettDate,
  });

  factory ConsumerModel.fromJson(Map<String, dynamic> json) {
    return ConsumerModel(
      consId: json['ConsId'],
      distributorId: json['DistributorId'],
      staffId: json['StaffId'],
      itemId: json['ItemId'],
      consumerNo: json['ConsumerNo'],
      action: json['Action'],
      addedBy: json['AddedBy'],
      consumerName: json['ConsumerName'],
      orderDate: json['OrderDate'],
      cashmemoDate: json['CashDate'],
      paymentStatus: json['PaymentStatus'],
      remark: json['ConsumerRemark'],
      niyojanDel: json['NiyojanDel'],
      cDCMSDel: json['cDCMSDel'],
      InCorrectStatus: json['InCorrectStatus'],
      PayDate: json['PayDate'],
      DeliveryDate: json['DeliveryDate'],
      SettDate: json['SettDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ConsId': consId,
      'DistributorId': distributorId,
      'StaffId': staffId,
      'ItemId': itemId,
      'ConsumerNo': consumerNo,
      'Action': action,
      'AddedBy': addedBy,
      'ConsumerName': consumerName,
      'OrderDate': orderDate, // <- safely convert to String
      'CashDate': cashmemoDate,
      'PaymentStatus': paymentStatus,
      'ConsumerRemark': remark,
      'NiyojanDel': niyojanDel,
      'cDCMSDel': cDCMSDel,
      'InCorrectStatus': InCorrectStatus,
      'PayDate': PayDate,
      'DeliveryDate': DeliveryDate,
      'SettDate': SettDate,
    };
  }
}
