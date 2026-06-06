/// DesignationId : 17
/// CategoryName : "PermissionFor"
/// MasterName : "Invoice Number"

class GetDesignationListModel {
  GetDesignationListModel({
    num? designationId,
    String? categoryName,
    String? masterName,}){
    _designationId = designationId;
    _categoryName = categoryName;
    _masterName = masterName;
  }

  GetDesignationListModel.fromJson(dynamic json) {
    _designationId = json['DesignationId'];
    _categoryName = json['CategoryName'];
    _masterName = json['MasterName'];
  }
  num? _designationId;
  String? _categoryName;
  String? _masterName;
  GetDesignationListModel copyWith({  num? designationId,
    String? categoryName,
    String? masterName,
  }) => GetDesignationListModel(  designationId: designationId ?? _designationId,
    categoryName: categoryName ?? _categoryName,
    masterName: masterName ?? _masterName,
  );
  num? get designationId => _designationId;
  String? get categoryName => _categoryName;
  String? get masterName => _masterName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DesignationId'] = _designationId;
    map['CategoryName'] = _categoryName;
    map['MasterName'] = _masterName;
    return map;
  }

}