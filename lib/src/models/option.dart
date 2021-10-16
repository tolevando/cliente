import 'package:markets/src/models/coupon.dart';

import '../models/media.dart';

class Option {
  String id;
  String optionGroupId;
  String name;
  double price;
  Media image;
  String description;
  bool checked;
  double discountPrice;
  bool couponed = false;

  Option();

  Option.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      optionGroupId = jsonMap['option_group_id'] != null
          ? jsonMap['option_group_id'].toString()
          : '0';
      name = jsonMap['name'].toString();
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0;
      description = jsonMap['description'];
      checked = false;
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
    } catch (e) {
      id = '';
      optionGroupId = '0';
      name = '';
      price = 0.0;
      description = '';
      checked = false;
      image = new Media();
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["description"] = description;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;

  Coupon applyCoupon(Coupon coupon) {
    if (coupon.code != '') {
      if (coupon.valid == null) {
        coupon.valid = false;
      } else {
        coupon = _couponDiscountPrice(coupon);
      }
      /*coupon.discountables.forEach((element) {
        if (!coupon.valid) {
          if (element.discountableType == "App\\Models\\Product") {
            if (element.discountableId == id) {
              coupon = _couponDiscountPrice(coupon);
            }
          } else if (element.discountableType == "App\\Models\\Market") {
            if (element.discountableId == market.id) {
              coupon = _couponDiscountPrice(coupon);
            }
          } else if (element.discountableType == "App\\Models\\Category") {
            if (element.discountableId == category.id) {
              coupon = _couponDiscountPrice(coupon);
            }
          }
        }

      });*/
    }
    return coupon;
  }

  Coupon _couponDiscountPrice(Coupon coupon) {
    if (!couponed) {
      coupon.valid = true;
      discountPrice = price;
      if (coupon.discountType == 'fixed') {
        price -= coupon.discount;
      } else {
        price = price - (price * coupon.discount / 100);
        print(price);
      }
      if (price < 0) price = 0;

      couponed = true;
    }
    return coupon;
  }
}
