/// Id : 1
/// NoteType : 500
/// isActive : 1

class GetNoteTypeAndIdFroDenominationListModel {
  GetNoteTypeAndIdFroDenominationListModel({
      num? id, 
      num? noteType, 
      num? isActive,}){
    _id = id;
    _noteType = noteType;
    _isActive = isActive;
}

  GetNoteTypeAndIdFroDenominationListModel.fromJson(dynamic json) {
    _id = json['Id'];
    _noteType = json['NoteType'];
    _isActive = json['isActive'];
  }
  num? _id;
  num? _noteType;
  num? _isActive;
GetNoteTypeAndIdFroDenominationListModel copyWith({  num? id,
  num? noteType,
  num? isActive,
}) => GetNoteTypeAndIdFroDenominationListModel(  id: id ?? _id,
  noteType: noteType ?? _noteType,
  isActive: isActive ?? _isActive,
);
  num? get id => _id;
  num? get noteType => _noteType;
  num? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['NoteType'] = _noteType;
    map['isActive'] = _isActive;
    return map;
  }

}