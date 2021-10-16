import '../helpers/custom_trace.dart';

class CardBrand {
  int id;
  String brand;
  int marketId;

  CardBrand();

  CardBrand.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'];
      brand = jsonMap['brand'] != null ? jsonMap['brand'] : null;
      marketId = jsonMap['market_id'] != null ? jsonMap['market_id'] : null;
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["brand"] = brand;
    map["market_id"] = marketId;
    return map;
  }
}
