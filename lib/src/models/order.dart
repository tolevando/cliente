import '../models/address.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/product_order.dart';
import '../models/user.dart';

class Order {
  String id;
  List<ProductOrder> productOrders;
  OrderStatus orderStatus;
  double tax;
  double deliveryFee;
  String hint;
  bool active;
  DateTime dateTime;
  User user;
  Payment payment;
  Address deliveryAddress;
  String observacao = "";
  String card_brand = "";
  String troco_para = "";
  String bairro_id = "";
  String coupon_id = null;
  String data_hora = "";
  String reason_cancel = "";

  Order();

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0.0;
      deliveryFee = jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee'].toDouble()
          : 0.0;
      hint = jsonMap['hint'] != null ? jsonMap['hint'].toString() : '';
      active = jsonMap['active'] ?? false;
      orderStatus = jsonMap['order_status'] != null
          ? OrderStatus.fromJSON(jsonMap['order_status'])
          : OrderStatus.fromJSON({});
      dateTime = DateTime.parse(jsonMap['updated_at']);
      user = jsonMap['user'] != null
          ? User.fromJSON(jsonMap['user'])
          : User.fromJSON({});
      deliveryAddress = jsonMap['delivery_address'] != null
          ? Address.fromJSON(jsonMap['delivery_address'])
          : Address.fromJSON({});
      payment = jsonMap['payment'] != null
          ? Payment.fromJSON(jsonMap['payment'])
          : Payment.fromJSON({});
      productOrders = jsonMap['product_orders'] != null
          ? List.from(jsonMap['product_orders'])
              .map((element) => ProductOrder.fromJSON(element))
              .toList()
          : [];
      observacao =
          jsonMap['observacao'] != null ? jsonMap['observacao'].toString() : '';
      card_brand =
          jsonMap['card_brand'] != null ? jsonMap['card_brand'].toString() : '';
      troco_para =
          jsonMap['troco_para'] != null ? jsonMap['troco_para'].toString() : '';
      bairro_id =
          jsonMap['bairro_id'] != null ? jsonMap['bairro_id'].toString() : '';
      data_hora =
          jsonMap['data_hora'] != null ? jsonMap['data_hora'].toString() : '';
      reason_cancel = jsonMap['reason_cancel'] != null
          ? jsonMap['reason_cancel'].toString()
          : '';
    } catch (e) {
      id = '';
      tax = 0.0;
      deliveryFee = 0.0;
      hint = '';
      active = false;
      orderStatus = OrderStatus.fromJSON({});
      dateTime = DateTime(0);
      user = User.fromJSON({});
      payment = Payment.fromJSON({});
      deliveryAddress = Address.fromJSON({});
      productOrders = [];
      observacao = '';
      card_brand = '';
      troco_para = '';
      bairro_id = '';
      data_hora = '';
      reason_cancel = '';
      print(jsonMap);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user_id"] = user?.id;
    map["order_status_id"] = orderStatus?.id;
    map["tax"] = tax;
    map['hint'] = hint;
    map['observacao'] = observacao;
    map['card_brand'] = card_brand;
    map['troco_para'] = troco_para;
    map['coupon_id'] = coupon_id;
    map["delivery_fee"] = deliveryFee;
    map["products"] =
        productOrders?.map((element) => element.toMap())?.toList();
    map["payment"] = payment?.toMap();
    map["data_hora"] = data_hora;
    map["reason_cancel"] = reason_cancel;
    if (!deliveryAddress.isUnknown()) {
      map["delivery_address_id"] = deliveryAddress?.id;
    }
    return map;
  }

  Map deliveredMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["order_status_id"] = 5;
    if (deliveryAddress?.id != null && deliveryAddress?.id != 'null')
      map["delivery_address_id"] = deliveryAddress.id;
    return map;
  }

  Map cancelMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    if (orderStatus?.id != null && orderStatus?.id == '1')
      map["active"] = false;
    return map;
  }

  bool canCancelOrder() {
    return this.active == true &&
        this.orderStatus.id == '1'; // 1 for order received status
  }
}
