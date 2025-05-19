class ReticulatedModel {
  int? retId;
  int? distributorId;
  int? staffId;
  int? itemId;
  String? paymentMode;
  int? quantity;
  double? amount;
  int? CustomerId;
  String? customerName;
  String? reticulatedRemark;
  String? action;
  int? addedBy;
  double? discountAmount;

  ReticulatedModel({
    this.retId,
    this.distributorId,
    this.staffId,
    this.itemId,
    this.paymentMode,
    this.quantity,
    this.amount,
    this.CustomerId,
    this.customerName,
    this.reticulatedRemark,
    this.action,
    this.addedBy,
    this.discountAmount,
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
      CustomerId: json['CustomerId'],
      customerName: json['CustomerName'],
      reticulatedRemark: json['ReticulatedRemark'],
      action: json['Action'],
      addedBy: json['AddedBy'],
      discountAmount: json['discountAmount'],
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
      'CustomerId':CustomerId,
      'CustomerName': customerName,
      'ReticulatedRemark': reticulatedRemark,
      'Action': action,
      'AddedBy': addedBy,
      'discountAmount': discountAmount,
    };
  }
}
