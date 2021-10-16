import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/card_brand.dart' as model;
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/card_brand_repository.dart' as brandRepo;

class CardBrandController extends ControllerMVC with ChangeNotifier {
  List<model.CardBrand> card_brands = <model.CardBrand>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Cart> carts = [];

  CardBrandController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    // listenForCardBrands();
    listenForCarts();
  }

  void listenForCardBrands({String message}) async {
    final Stream<model.CardBrand> stream =
        await brandRepo.getMarketBrands(carts[0].product.market.id);
    stream.listen((model.CardBrand _card_brand) {
      setState(() {
        if (card_brands.isNotEmpty) {
          var insert = true;
          for (var t = 0; t < card_brands?.length; t++) {
            if (card_brands[t].id == _card_brand.id) {
              insert = false;
            }
          }

          if (insert) {
            card_brands.add(_card_brand);
          }
        } else {
          card_brands.add(_card_brand);
        }
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCarts() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
      if (_cart.product.market != null) {
        listenForCardBrands();
      }
    });
  }

  Future<void> refreshCardBrands() async {
    card_brands.clear();
    listenForCardBrands();
  }
}
