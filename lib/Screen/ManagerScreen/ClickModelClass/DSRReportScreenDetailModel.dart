/// DistributorId : 8118
/// Date : null
/// ItemId : 1
/// ItemName : "14.2 KG SV Sale"
/// SaleAmt : 855.50
/// CashAmt : 855.50
/// BankAmt : 0.0
/// CreditAmt : 0.00
/// Category : null
/// TransCate : "DailySale"
/// QtyName : 0
/// CoustemerName : null
/// Flag : null
/// MerchantQR : 0.00
/// PrepaidAmt : 0.00

class DsrReportScreenDetailModel {
  DsrReportScreenDetailModel({
    num? distributorId,
    dynamic date,
    num? itemId,
    String? itemName,
    num? saleAmt,
    num? cashAmt,
    num? bankAmt,
    num? creditAmt,
    dynamic category,
    String? transCate,
    num? qtyName,
    dynamic coustemerName,
    dynamic flag,
    num? merchantQR,
    num? prepaidAmt,}){
    _distributorId = distributorId;
    _date = date;
    _itemId = itemId;
    _itemName = itemName;
    _saleAmt = saleAmt;
    _cashAmt = cashAmt;
    _bankAmt = bankAmt;
    _creditAmt = creditAmt;
    _category = category;
    _transCate = transCate;
    _qtyName = qtyName;
    _coustemerName = coustemerName;
    _flag = flag;
    _merchantQR = merchantQR;
    _prepaidAmt = prepaidAmt;
  }

  DsrReportScreenDetailModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _date = json['Date'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _saleAmt = json['SaleAmt'];
    _cashAmt = json['CashAmt'];
    _bankAmt = json['BankAmt'];
    _creditAmt = json['CreditAmt'];
    _category = json['Category'];
    _transCate = json['TransCate'];
    _qtyName = json['QtyName'];
    _coustemerName = json['CoustemerName'];
    _flag = json['Flag'];
    _merchantQR = json['MerchantQR'];
    _prepaidAmt = json['PrepaidAmt'];
  }
  num? _distributorId;
  dynamic _date;
  num? _itemId;
  String? _itemName;
  num? _saleAmt;
  num? _cashAmt;
  num? _bankAmt;
  num? _creditAmt;
  dynamic _category;
  String? _transCate;
  num? _qtyName;
  dynamic _coustemerName;
  dynamic _flag;
  num? _merchantQR;
  num? _prepaidAmt;
  DsrReportScreenDetailModel copyWith({  num? distributorId,
    dynamic date,
    num? itemId,
    String? itemName,
    num? saleAmt,
    num? cashAmt,
    num? bankAmt,
    num? creditAmt,
    dynamic category,
    String? transCate,
    num? qtyName,
    dynamic coustemerName,
    dynamic flag,
    num? merchantQR,
    num? prepaidAmt,
  }) => DsrReportScreenDetailModel(  distributorId: distributorId ?? _distributorId,
    date: date ?? _date,
    itemId: itemId ?? _itemId,
    itemName: itemName ?? _itemName,
    saleAmt: saleAmt ?? _saleAmt,
    cashAmt: cashAmt ?? _cashAmt,
    bankAmt: bankAmt ?? _bankAmt,
    creditAmt: creditAmt ?? _creditAmt,
    category: category ?? _category,
    transCate: transCate ?? _transCate,
    qtyName: qtyName ?? _qtyName,
    coustemerName: coustemerName ?? _coustemerName,
    flag: flag ?? _flag,
    merchantQR: merchantQR ?? _merchantQR,
    prepaidAmt: prepaidAmt ?? _prepaidAmt,
  );
  num? get distributorId => _distributorId;
  dynamic get date => _date;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get saleAmt => _saleAmt;
  num? get cashAmt => _cashAmt;
  num? get bankAmt => _bankAmt;
  num? get creditAmt => _creditAmt;
  dynamic get category => _category;
  String? get transCate => _transCate;
  num? get qtyName => _qtyName;
  dynamic get coustemerName => _coustemerName;
  dynamic get flag => _flag;
  num? get merchantQR => _merchantQR;
  num? get prepaidAmt => _prepaidAmt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['Date'] = _date;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['SaleAmt'] = _saleAmt;
    map['CashAmt'] = _cashAmt;
    map['BankAmt'] = _bankAmt;
    map['CreditAmt'] = _creditAmt;
    map['Category'] = _category;
    map['TransCate'] = _transCate;
    map['QtyName'] = _qtyName;
    map['CoustemerName'] = _coustemerName;
    map['Flag'] = _flag;
    map['MerchantQR'] = _merchantQR;
    map['PrepaidAmt'] = _prepaidAmt;
    return map;
  }

}