class OptionGroup {
  String id;
  String name;
  bool is_required;
  bool is_unique;

  OptionGroup();

  OptionGroup.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      is_required = jsonMap['is_required'];
      is_unique = jsonMap['is_unique'];
    } catch (e) {
      id = '';
      name = '';
      is_required = false;
      is_unique = false;
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["is_required"] = is_required;
    map["is_unique"] = is_unique;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
