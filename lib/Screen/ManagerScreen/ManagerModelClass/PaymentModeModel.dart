/// Payment mode : "Bank"

class PaymentModeModel {
  PaymentModeModel({
      String? paymentmode,}){
    _paymentmode = paymentmode;
}

  PaymentModeModel.fromJson(dynamic json) {
    _paymentmode = json['Payment mode'];
  }
  String? _paymentmode;
PaymentModeModel copyWith({  String? paymentmode,
}) => PaymentModeModel(  paymentmode: paymentmode ?? _paymentmode,
);
  String? get paymentmode => _paymentmode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Payment mode'] = _paymentmode;
    return map;
  }

}