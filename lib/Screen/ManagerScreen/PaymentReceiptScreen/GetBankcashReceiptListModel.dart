/// CustomerId : 60
/// StaffId : 0
/// ReceiptId : 153
/// ReceiptNo : "RC/000042"
/// ReceiptFrom : 2
/// DistributorId : 8118
/// StaffName : "Aspiria"
/// Amount : 1000.00
/// Balance : 0.0
/// VendorName : null
/// ReceiptMode : "Bank"
/// ReceiptDate : "04-06-2025"
/// RemarkForVendor : ""
/// TransationCode : "vfkkdnhh"
/// TransTime : ""
/// TransRemark : ""
/// BankId : 13
/// MappingId : 20
/// AccountNo : "9822279799"

class GetBankcashReceiptListModel {
  GetBankcashReceiptListModel({
      num? customerId, 
      num? staffId, 
      num? receiptId, 
      String? receiptNo, 
      num? receiptFrom, 
      num? distributorId, 
      String? staffName, 
      num? amount, 
      num? balance, 
      dynamic vendorName, 
      String? receiptMode, 
      String? receiptDate, 
      String? remarkForVendor, 
      String? transationCode, 
      String? transTime, 
      String? transRemark, 
      num? bankId, 
      num? mappingId, 
      String? accountNo,}){
    _customerId = customerId;
    _staffId = staffId;
    _receiptId = receiptId;
    _receiptNo = receiptNo;
    _receiptFrom = receiptFrom;
    _distributorId = distributorId;
    _staffName = staffName;
    _amount = amount;
    _balance = balance;
    _vendorName = vendorName;
    _receiptMode = receiptMode;
    _receiptDate = receiptDate;
    _remarkForVendor = remarkForVendor;
    _transationCode = transationCode;
    _transTime = transTime;
    _transRemark = transRemark;
    _bankId = bankId;
    _mappingId = mappingId;
    _accountNo = accountNo;
}

  GetBankcashReceiptListModel.fromJson(dynamic json) {
    _customerId = json['CustomerId'];
    _staffId = json['StaffId'];
    _receiptId = json['ReceiptId'];
    _receiptNo = json['ReceiptNo'];
    _receiptFrom = json['ReceiptFrom'];
    _distributorId = json['DistributorId'];
    _staffName = json['StaffName'];
    _amount = json['Amount'];
    _balance = json['Balance'];
    _vendorName = json['VendorName'];
    _receiptMode = json['ReceiptMode'];
    _receiptDate = json['ReceiptDate'];
    _remarkForVendor = json['RemarkForVendor'];
    _transationCode = json['TransationCode'];
    _transTime = json['TransTime'];
    _transRemark = json['TransRemark'];
    _bankId = json['BankId'];
    _mappingId = json['MappingId'];
    _accountNo = json['AccountNo'];
  }
  num? _customerId;
  num? _staffId;
  num? _receiptId;
  String? _receiptNo;
  num? _receiptFrom;
  num? _distributorId;
  String? _staffName;
  num? _amount;
  num? _balance;
  dynamic _vendorName;
  String? _receiptMode;
  String? _receiptDate;
  String? _remarkForVendor;
  String? _transationCode;
  String? _transTime;
  String? _transRemark;
  num? _bankId;
  num? _mappingId;
  String? _accountNo;
GetBankcashReceiptListModel copyWith({  num? customerId,
  num? staffId,
  num? receiptId,
  String? receiptNo,
  num? receiptFrom,
  num? distributorId,
  String? staffName,
  num? amount,
  num? balance,
  dynamic vendorName,
  String? receiptMode,
  String? receiptDate,
  String? remarkForVendor,
  String? transationCode,
  String? transTime,
  String? transRemark,
  num? bankId,
  num? mappingId,
  String? accountNo,
}) => GetBankcashReceiptListModel(  customerId: customerId ?? _customerId,
  staffId: staffId ?? _staffId,
  receiptId: receiptId ?? _receiptId,
  receiptNo: receiptNo ?? _receiptNo,
  receiptFrom: receiptFrom ?? _receiptFrom,
  distributorId: distributorId ?? _distributorId,
  staffName: staffName ?? _staffName,
  amount: amount ?? _amount,
  balance: balance ?? _balance,
  vendorName: vendorName ?? _vendorName,
  receiptMode: receiptMode ?? _receiptMode,
  receiptDate: receiptDate ?? _receiptDate,
  remarkForVendor: remarkForVendor ?? _remarkForVendor,
  transationCode: transationCode ?? _transationCode,
  transTime: transTime ?? _transTime,
  transRemark: transRemark ?? _transRemark,
  bankId: bankId ?? _bankId,
  mappingId: mappingId ?? _mappingId,
  accountNo: accountNo ?? _accountNo,
);
  num? get customerId => _customerId;
  num? get staffId => _staffId;
  num? get receiptId => _receiptId;
  String? get receiptNo => _receiptNo;
  num? get receiptFrom => _receiptFrom;
  num? get distributorId => _distributorId;
  String? get staffName => _staffName;
  num? get amount => _amount;
  num? get balance => _balance;
  dynamic get vendorName => _vendorName;
  String? get receiptMode => _receiptMode;
  String? get receiptDate => _receiptDate;
  String? get remarkForVendor => _remarkForVendor;
  String? get transationCode => _transationCode;
  String? get transTime => _transTime;
  String? get transRemark => _transRemark;
  num? get bankId => _bankId;
  num? get mappingId => _mappingId;
  String? get accountNo => _accountNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CustomerId'] = _customerId;
    map['StaffId'] = _staffId;
    map['ReceiptId'] = _receiptId;
    map['ReceiptNo'] = _receiptNo;
    map['ReceiptFrom'] = _receiptFrom;
    map['DistributorId'] = _distributorId;
    map['StaffName'] = _staffName;
    map['Amount'] = _amount;
    map['Balance'] = _balance;
    map['VendorName'] = _vendorName;
    map['ReceiptMode'] = _receiptMode;
    map['ReceiptDate'] = _receiptDate;
    map['RemarkForVendor'] = _remarkForVendor;
    map['TransationCode'] = _transationCode;
    map['TransTime'] = _transTime;
    map['TransRemark'] = _transRemark;
    map['BankId'] = _bankId;
    map['MappingId'] = _mappingId;
    map['AccountNo'] = _accountNo;
    return map;
  }

}