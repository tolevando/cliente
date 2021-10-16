import 'package:location/location.dart';

import '../helpers/custom_trace.dart';

class Address {
  String id;
  String description;
  String address;
  double latitude;
  double longitude;
  bool isDefault;
  bool selected;
  String userId;
  String number;
  String bairro;
  String complement;

  Address();

  Address.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      description = jsonMap['description'] != null
          ? jsonMap['description'].toString()
          : null;
      address = jsonMap['address'] != null ? jsonMap['address'] : null;
      latitude = jsonMap['latitude'] != null ? jsonMap['latitude'] : null;
      longitude = jsonMap['longitude'] != null ? jsonMap['longitude'] : null;
      isDefault = jsonMap['is_default'] ?? false;
      number = jsonMap['number'] != null ? jsonMap['number'] : null;
      bairro = jsonMap['bairro'] != null ? jsonMap['bairro'] : null;
      complement = jsonMap['complement'] != null ? jsonMap['complement'] : null;
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  bool isUnknown() {
    return latitude == null ||
        longitude == null /* || id == null || id == 'null'*/;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["description"] = description;
    map["address"] = address;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["is_default"] = isDefault;
    map["user_id"] = userId;
    map["number"] = number;
    map["bairro"] = bairro;
    map["complement"] = complement;
    return map;
  }

  LocationData toLocationData() {
    return LocationData.fromMap({
      "latitude": latitude,
      "longitude": longitude,
    });
  }
}
