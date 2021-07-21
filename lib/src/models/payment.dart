import 'dart:ffi';

class Payment {
  String id;
  String status;
  String method;
  dynamic price;
  

  Payment.init();

  Payment(this.method);
  
  
  double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value.toDouble;
    }
  }



  Payment.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      status = jsonMap['status'] ?? '';
      method = jsonMap['method'] ?? '';
      jsonMap['price'] = double.parse(jsonMap['price'].toString());
      price = (jsonMap['price']??0.00);
    } catch (e) {
      id = '';
      status = '';
      method = '';
      price = 0.00;
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'method': method,
      'price': price,
    };
  }
}
