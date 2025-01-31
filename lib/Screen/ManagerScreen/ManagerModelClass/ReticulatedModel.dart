class ReticulatedModel {
  int? retId;
  int? distributorId;
  int? staffId;
  int? itemId;
  String? paymentMode;
  int? quantity;
  int? amount;
  int? vendorId;
  String? vendorName;
  String? reticulatedRemark;
  DateTime? addedOn;
  String? action;
  int? addedBy;

  ReticulatedModel({
    this.retId,
    this.distributorId,
    this.staffId,
    this.itemId,
    this.paymentMode,
    this.quantity,
    this.amount,
    this.vendorId,
    this.vendorName,
    this.reticulatedRemark,
    this.addedOn,
    this.action,
    this.addedBy,
  });

  factory ReticulatedModel.fromJson(Map<String, dynamic> json) {
    return ReticulatedModel(
      retId: json['RetId'],
      distributorId: json['DistributorId'],
      staffId: json['StaffId'],
      itemId: json['ItemId'],
      paymentMode: json['PaymentMode'],
      quantity: json['Quantity'],
      amount: json['Amount'],
      vendorId: json['VendorId'],
      vendorName: json['VendorName'],
      reticulatedRemark: json['ReticulatedRemark'],
      addedOn: DateTime.parse(json['AddedOn']),
      action: json['Action'],
      addedBy: json['AddedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RetId': retId,
      'DistributorId': distributorId,
      'StaffId': staffId,
      'ItemId': itemId,
      'PaymentMode': paymentMode,
      'Quantity': quantity,
      'Amount': amount,
      'VendorId': vendorId,
      'VendorName': vendorName,
      'ReticulatedRemark': reticulatedRemark,
      'AddedOn': addedOn?.toIso8601String(),
      'Action': action,
      'AddedBy': addedBy,
    };
  }
}
