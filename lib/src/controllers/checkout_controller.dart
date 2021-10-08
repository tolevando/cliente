import 'package:flutter/material.dart';
import 'package:markets/src/models/address.dart';
import 'package:markets/src/models/credit_card_pagarme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../models/credit_card.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/product_order.dart';
import '../repository/order_repository.dart' as orderRepo;
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class CheckoutController extends CartController {
  Payment payment;
  CreditCard creditCard = new CreditCard();
  CreditCardPagarme creditCardPagarme = new CreditCardPagarme();
  bool loading = true;

  CheckoutController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCreditCard();
  }

  void listenForCreditCard() async {
    creditCard = await userRepo.getCreditCard();
    creditCardPagarme = await userRepo.getCreditCardPagarme();
    print("AQUI: " + creditCardPagarme.toMap().toString());
    setState(() {});
  }

  @override
  void onLoadingCartDone() {
    if (payment != null) addOrder(carts);
    super.onLoadingCartDone();
  }

  void addOrder(List<Cart> carts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("cartao_recusado", false);
    observacao = prefs.getString("observacao") ?? '';
    card_brand = prefs.getString("card_brand") ?? '';
    troco_para = prefs.getString("troco") ?? '';
    String bairro_id = '';

    Order _order = new Order();
    _order.productOrders = new List<ProductOrder>();
    _order.tax = carts[0].product.market.defaultTax;
    _order.deliveryFee = carts[0].product.market.deliveryFee;
    _order.deliveryAddress = settingRepo.deliveryAddress.value;
    if (isRetirada || payment.method == 'Pagar na Retirada') {
      _order.deliveryFee = 0;
      _order.deliveryAddress = new Address.fromJSON({});
    }
    OrderStatus _orderStatus = new OrderStatus();
    _orderStatus.id = '1'; // TODO default order status Id
    _order.orderStatus = _orderStatus;

    if (_order.deliveryAddress == null) {
      _order.deliveryFee = 0;
    }
    _order.hint = ' ';
    bool precisaDataHora = false;
    carts.forEach((_cart) {
      ProductOrder _productOrder = new ProductOrder();

      if (settingRepo.coupon.id != '') {
        _order.coupon_id = settingRepo.coupon.id;
        _cart.product.applyCoupon(settingRepo.coupon);
      }

      _productOrder.quantity = _cart.quantity;
      _productOrder.price = _cart.product.price;
      _productOrder.product = _cart.product;
      _productOrder.options = _cart.options;

      if (prefs.containsKey("last_market_bairro_selecionado") &&
          prefs.getString("last_market_bairro_selecionado") ==
              _cart.product.market.id) {
        bairro_id = prefs.getString("last_market_bairro_id");
      }

      _order.productOrders.add(_productOrder);
      if (_productOrder.product.market.exige_agendamento) {
        precisaDataHora = true;
      }
    });
    if (precisaDataHora) {
      _order.data_hora = prefs.getString("data_hora") ?? '';
    } else {
      _order.data_hora = "";
    }

    orderRepo
        .addOrder(
            _order, this.payment, observacao, card_brand, troco_para, bairro_id)
        .then((value) async {
      if (value['sucesso'] == 1) {
        settingRepo.coupon = new Coupon.fromJSON({});
        setState(() {
          prefs.remove("observacao");
          prefs.remove("troco");
          loading = false;
        });
      } else {
        prefs.setBool("cartao_recusado", true);
        Navigator.of(context)..popAndPushNamed('/CartaoRecusado');
      }

      return value;
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    userRepo.setCreditCard(creditCard).then((value) {
      setState(() {});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).payment_card_updated_successfully),
      ));
    });
  }

  void updateCreditCardPagarme(CreditCardPagarme creditCard) {
    userRepo.setCreditCardPagarme(creditCard).then((value) {
      setState(() {});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).payment_card_updated_successfully),
      ));
    });
  }
}
