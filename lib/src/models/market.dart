import 'package:markets/src/models/bairro.dart';
import 'package:markets/src/models/field.dart';

import '../models/media.dart';

class Market {
  String id;
  String name;
  Media image;
  String rate;
  String address;
  String description;
  String phone;
  String mobile;
  String information;
  double deliveryFee;
  double adminCommission;
  double defaultTax;
  String latitude;
  String longitude;
  bool closed;
  bool availableForDelivery;
  double deliveryRange;
  double distance;
  bool offline_payment_option_cash;
  bool offline_payment_option_credit;
  bool offline_payment_option_debit;
  bool exige_agendamento;
  String estimated_time_delivery;
  String estimated_time_get_product;
  int cidade_id;

  bool possui_bairros_personalizados;
  List<Bairro> bairros;
  List<Field> fields;
  Market();

  Market.fromJSON(Map<String, dynamic> jsonMap) {
    print('MODEL MARKET');
    print(jsonMap);
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      rate = jsonMap['rate'] ?? '0';
      deliveryFee = jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee'].toDouble()
          : 0.0;
      adminCommission = jsonMap['admin_commission'] != null
          ? jsonMap['admin_commission'].toDouble()
          : 0.0;
      deliveryRange = jsonMap['delivery_range'] != null
          ? jsonMap['delivery_range'].toDouble()
          : 0.0;
      address = jsonMap['address'];
      description = jsonMap['description'];
      phone = jsonMap['phone'];
      mobile = jsonMap['mobile'];
      defaultTax = jsonMap['default_tax'] != null
          ? jsonMap['default_tax'].toDouble()
          : 0.0;
      information = jsonMap['information'];
      latitude = jsonMap['latitude'];
      longitude = jsonMap['longitude'];
      closed = jsonMap['closed'] ?? false;
      availableForDelivery = jsonMap['available_for_delivery'] ?? false;

      offline_payment_option_cash =
          jsonMap['offline_payment_option_cash'] ?? true;
      offline_payment_option_credit =
          jsonMap['offline_payment_option_credit'] ?? true;
      offline_payment_option_debit =
          jsonMap['offline_payment_option_debit'] ?? true;

      distance = jsonMap['distance'] != null
          ? double.parse(jsonMap['distance'].toString())
          : 0.0;

      possui_bairros_personalizados =
          jsonMap['possui_bairros_personalizados'] ?? false;
      exige_agendamento = jsonMap['exige_agendamento'] ?? false;
      estimated_time_delivery = jsonMap['estimated_time_delivery'] ?? null;
      estimated_time_get_product =
          jsonMap['estimated_time_get_product'] ?? null;
      cidade_id = jsonMap['cidade_id'] ?? null;

      //print(possui_bairros_personalizados);

      if (possui_bairros_personalizados) {
        bairros = List<Bairro>.from(
            jsonMap['bairros'].map((bairro) => Bairro.fromJSON(bairro)));
      }

      fields = jsonMap['fields'] != null
          ? List<Field>.from(
              jsonMap["fields"].map((field) => Field.fromJSON(field)))
          : new List<Field>();
    } catch (e) {
      id = '';
      name = '';
      image = new Media();
      rate = '0';
      deliveryFee = 0.0;
      adminCommission = 0.0;
      deliveryRange = 0.0;
      address = '';
      description = '';
      phone = '';
      mobile = '';
      defaultTax = 0.0;
      information = '';
      latitude = '0';
      longitude = '0';
      closed = false;
      availableForDelivery = false;
      distance = 0.0;
      offline_payment_option_cash = true;
      offline_payment_option_credit = true;
      offline_payment_option_debit = true;
      possui_bairros_personalizados = false;
      exige_agendamento = false;
      estimated_time_delivery = '';
      estimated_time_get_product = '';
      cidade_id = null;
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'delivery_fee': deliveryFee,
      'distance': distance,
    };
  }
}
