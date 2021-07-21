import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../repository/cart_repository.dart';
import '../repository/coupon_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';
import '../repository/coupon_repository.dart' as couponRepo;

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double total = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey;
  bool isRetirada = false;
  String observacao = "";
  String troco_para = "";
  bool precisaSelecionarBairro = true;
  DateTime pickedDate;
  TimeOfDay time;

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }


  double getTotal({String met=null}){
    //print("isRetirada: "+isRetirada.toString());
    if(isRetirada || met=="Pagar na Retirada"){
      return total-deliveryFee;
    }else{
      return total;
    }
  }

  void listenForCarts({String message}) async {
    carts.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();    
    final Stream<Cart> stream = await getCart();    
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {                    
          if(prefs.containsKey("last_market_bairro_selecionado") 
            && prefs.getString("last_market_bairro_selecionado") == _cart.product.market.id){
              print(prefs.getString("last_market_bairro_selecionado"));
              deliveryFee = prefs.getDouble("last_market_bairro_fee");                
              _cart.product.market.deliveryFee = prefs.getDouble("last_market_bairro_fee");
            }          
          carts.add(_cart);          
          print("CREDIT: "+_cart.product.market.offline_payment_option_credit.toString());
          prefs.setBool("offline_payment_option_cash", _cart.product.market.offline_payment_option_cash);
          prefs.setBool("offline_payment_option_credit", _cart.product.market.offline_payment_option_credit);
          prefs.setBool("offline_payment_option_debit", _cart.product.market.offline_payment_option_debit);                              
        });
      }else{        
            if(prefs.containsKey("last_market_bairro_selecionado") 
              && prefs.getString("last_market_bairro_selecionado") == _cart.product.market.id){
                deliveryFee = prefs.getDouble("last_market_bairro_fee");                
                _cart.product.market.deliveryFee = prefs.getDouble("last_market_bairro_fee");
            }
        
      }

      print("RESPOSTA");
      print(_cart.product.market.possui_bairros_personalizados);
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {      
      if (carts.isNotEmpty) {
        calculateSubtotal();
      }
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
      onLoadingCartDone();
    });
  }

  void onLoadingCartDone() {
    calculateSubtotal();
  }

  void listenForCartsCount({String message}) async {
    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        this.cartCount = _count;
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    });
  }

  Future<void> refreshCarts() async {
    setState(() {
      carts = [];
    });
    listenForCarts(message: S.of(context).carts_refreshed_successfuly);
  }

  void removeFromCart(Cart _cart) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((value) {
      calculateSubtotal();
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).the_product_was_removed_from_your_cart(_cart.product.name)),
      ));
    });
  }

/*
  Coupon applyCoupon(Coupon coupon) {
    if (coupon.code != '') {
      if (coupon.valid == null) {
        coupon.valid = false;
      }
      coupon.discountables.forEach((element) {
        if (!coupon.valid) {
          if (element.discountableType == "App\\Models\\Product") {
            if (element.discountableId == ) {
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
      });
    }
    return coupon;
  }

  Coupon _couponDiscountPrice(Coupon coupon) {
    coupon.valid = true;
    discountPrice = price;
    if (coupon.discountType == 'fixed') {
      price -= coupon.discount;
    } else {
      price = price - (price * coupon.discount / 100);
    }
    if (price < 0) price = 0;
    return coupon;
  }*/

  void calculateSubtotal() async {    
    //coupon = await couponRepo.getCoupon();
    print(coupon.code);
    double cartPrice = 0;
    subTotal = 0;
    carts.forEach((cart) {
      print(cart.product.price);
      //coupon = cart.product.applyCoupon(coupon); 
      print(cart.product.price);
      cartPrice = cart.product.price;
      cart.options.forEach((element) {

        //apply the coupon on element
        element.applyCoupon(coupon);
        cartPrice += element.price;        
      });
      cartPrice *= cart.quantity;
      setState(() => subTotal += cartPrice);
      
    });
    
    //check the coupon and apply 
    //coupon = _cart.product.applyCoupon(coupon);                 


    if (Helper.canDelivery(carts[0].product.market, carts: carts)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();    
      if(prefs.containsKey("last_market_bairro_selecionado") 
              && prefs.getString("last_market_bairro_selecionado") == carts[0].product.market.id){
        deliveryFee = prefs.getDouble("last_market_bairro_fee");                
      }else{
        deliveryFee = carts[0].product.market.deliveryFee;
      }
      
    }
    taxAmount = (subTotal + deliveryFee) * carts[0].product.market.defaultTax / 100;
    total = subTotal + taxAmount + deliveryFee;
    print(total);
    setState(() {});
  }

  void doApplyCoupon(String code, {String message}) async {
    coupon = new Coupon.fromJSON({"code": code, "valid": null});
    final Stream<Coupon> stream = await verifyCoupon(code);
    stream.listen((Coupon _coupon) async {
      coupon = _coupon;
      //couponRepo.saveCoupon(coupon);
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      listenForCarts();      
    });
  }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      listenForCarts();
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      listenForCarts();
      calculateSubtotal();
    }
  }

  void goCheckout(BuildContext context) {
    if (!currentUser.value.profileCompleted()) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).completeYourProfileDetailsToContinue),
        action: SnackBarAction(
          label: S.of(context).settings,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pushNamed('/Settings');
          },
        ),
      )); 
    } else {
      if (carts[0].product.market.closed) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_market_is_closed_),
        ));
      } else {
        Navigator.of(context).pushNamed('/DeliveryPickup');
      }
    }
  }

  Color getCouponIconColor() {
    if (coupon?.valid == true) {
      return Colors.green;
    } else if (coupon?.valid == false) {
      return Colors.redAccent;
    }
    return Theme.of(context).focusColor.withOpacity(0.7);
  }
}
