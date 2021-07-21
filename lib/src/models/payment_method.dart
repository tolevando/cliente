import 'package:flutter/widgets.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/l10n.dart';


class PaymentMethod {
  String id;
  String name;
  String description;
  String logo;
  String route;
  bool isDefault;
  bool selected;

  PaymentMethod(this.id, this.name, this.description, this.route, this.logo, {this.isDefault = false, this.selected = false});
}

class PaymentMethodList {
  List<PaymentMethod> _paymentsList;
  List<PaymentMethod> _paymentsListRetirada;
  List<PaymentMethod> _cashList = new List<PaymentMethod>();
  List<PaymentMethod> _cashListRetirada = new List<PaymentMethod>();
  List<PaymentMethod> _pickupList;

  PaymentMethodList(BuildContext _context) {
  
    this._paymentsList = [
      new PaymentMethod("visacard", S.of(_context).visa_card, S.of(_context).click_to_pay_with_your_visa_card, "/Checkout", "assets/img/visacard.png",
          isDefault: true),
      new PaymentMethod("mastercard", S.of(_context).mastercard, S.of(_context).click_to_pay_with_your_mastercard, "/Checkout", "assets/img/mastercard.png"),
      new PaymentMethod("razorpay", S.of(_context).razorpay, S.of(_context).clickToPayWithRazorpayMethod, "/RazorPay", "assets/img/razorpay.png"),
      new PaymentMethod("paypal", S.of(_context).paypal, S.of(_context).click_to_pay_with_your_paypal_account, "/PayPal", "assets/img/paypal.png"),
      new PaymentMethod("pagarme", "Cartão de Crédito", "Pagar no aplicativo", "/Pagarme", "assets/img/credit-card.png"),
    ];

    this._paymentsListRetirada = [
      new PaymentMethod("visacard", S.of(_context).visa_card, S.of(_context).click_to_pay_with_your_visa_card, "/Checkout", "assets/img/visacard.png",
          isDefault: true),
      new PaymentMethod("mastercard", S.of(_context).mastercard, S.of(_context).click_to_pay_with_your_mastercard, "/Checkout", "assets/img/mastercard.png"),
      new PaymentMethod("razorpay", S.of(_context).razorpay, S.of(_context).clickToPayWithRazorpayMethod, "/RazorPay", "assets/img/razorpay.png"),
      new PaymentMethod("paypal", S.of(_context).paypal, S.of(_context).click_to_pay_with_your_paypal_account, "/PayPal", "assets/img/paypal.png"),
      new PaymentMethod("pagarme", "Cartão de Crédito", "Pagar no aplicativo e retirar", "/PagarmeRetirada", "assets/img/credit-card.png"),
    ];

    this._cashList = [
      new PaymentMethod("cod", S.of(_context).cash_on_delivery, S.of(_context).click_to_pay_cash_on_delivery, "/CashOnDelivery", "assets/img/cash.png"),
      new PaymentMethod("ccod", "Cartão de Crédito na Entrega", "Pagar com Cartão de Crédito na Entrega", "/CreditCardOnDelivery", "assets/img/credit-card.png"),
      new PaymentMethod("cdod", "Cartão de Débito na Entrega", "Pagar com Cartão de Débito na Entrega", "/DebitCardOnDelivery", "assets/img/credit-card-payment.png"),
    ];
    this._cashListRetirada = [
      new PaymentMethod("codr", "Dinheiro na Retirada", "Cartão na Retirada", "/CashOnRetirada", "assets/img/cash.png"),
      new PaymentMethod("ccodr", "Cartão de Crédito na Retirada", "Pagar com Cartão de Crédito na Retirada", "/CreditCardOnRetirada", "assets/img/credit-card.png"),
      new PaymentMethod("cdodr", "Cartão de Débito na Retirada", "Pagar com Cartão de Débito na Retirada", "/DebitCardOnRetirada", "assets/img/credit-card-payment.png"),
    ];
    this._pickupList = [
      new PaymentMethod("pop", "Retirar no Estabelecimento", "Pague no app ou direto no estabelecimento", "/PayOnPickup", "assets/img/pay_pickup.png"),
      //new PaymentMethod("pop", S.of(_context).pay_on_pickup, S.of(_context).click_to_pay_on_pickup, "/PaymentMethod", "assets/img/pay_pickup.png"),
      new PaymentMethod("delivery", S.of(_context).delivery_address, S.of(_context).click_to_pay_on_pickup, "/PaymentMethod", "assets/img/pay_pickup.png"),
      new PaymentMethod("pagarme", "Cartão de Crédito", "Pagar no aplicativo", "/Pagarme", "assets/img/credit-card.png"),
    ];
  }

  List<PaymentMethod> get paymentsList => _paymentsList;
  List<PaymentMethod> get paymentsListRetirada => _paymentsListRetirada;
  List<PaymentMethod> get cashList => _cashList;
  List<PaymentMethod> get cashListRetirada => _cashListRetirada;
  List<PaymentMethod> get pickupList => _pickupList;
}
