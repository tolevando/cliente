import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/favorite.dart';
import '../models/option.dart';
import '../models/product.dart';
import '../repository/cart_repository.dart';
import '../repository/product_repository.dart';

class ProductController extends ControllerMVC {
  Product product;
  double quantity = 1;
  double total = 0;
  List<Cart> carts = [];
  Favorite favorite;
  bool loadCart = false;
  GlobalKey<ScaffoldState> scaffoldKey;
  List optionsSelect = [];
  List optionsSelectUnique = [];
  String requiredOption = "";
  String uniqueOption = "";

  ProductController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForProduct({String productId, String message}) async {
    final Stream<Product> stream = await getProduct(productId);
    stream.listen((Product _product) {
      setState(() => product = _product);
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      calculateTotal();
      if (message != null) {
        scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForFavorite({String productId}) async {
    final Stream<Favorite> stream = await isFavoriteProduct(productId);
    stream.listen((Favorite _favorite) {
      setState(() => favorite = _favorite);
    }, onError: (a) {
      print(a);
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    });
  }

  bool isSameMarkets(Product product) {
    if (carts.isNotEmpty) {
      return carts[0].product?.market?.id == product.market?.id;
    }
    return true;
  }

  bool isRequiredOptions(options) {
    var is_required = false;
    for (var i = 0; i < options.length; i++) {
      if (options[i].is_required && !optionsSelect.contains(options[i].id)) {
        requiredOption = options[i].name;
        is_required = true;
        break;
      }
    }

    print("isRequiredOptions: " + is_required.toString());
    setState(() {});
    return is_required;
  }

  bool isUniqueOption(options) {
    var is_unique = false;

    for (var i = 0; i < options.length; i++) {
      if (options[i].is_unique && optionsSelectUnique.contains(options[i].id)) {
        int counter = 0;
        for (var t = 0; t < optionsSelectUnique.length; t++) {
          if (options[i].id == optionsSelectUnique[t]) {
            counter += 1;
          }
        }

        if (counter > 1) {
          uniqueOption = options[i].name;
          is_unique = true;
          break;
        }
      }
    }

    print("isUniqueOption: " + is_unique.toString());
    setState(() {});
    return is_unique;
  }

  void addToCart(Product product, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _newCart = new Cart();
    _newCart.product = product;
    _newCart.options =
        product.options.where((element) => element.checked).toList();
    _newCart.quantity = this.quantity;
    // if product exist in the cart then increment quantity
    var _oldCart = isExistInCart(_newCart);
    if (_oldCart != null) {
      _oldCart.quantity += this.quantity;
      updateCart(_oldCart).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_product_was_added_to_cart),
        ));
      });
    } else {
      // the product doesnt exist in the cart add new one
      addCart(_newCart, reset).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_product_was_added_to_cart),
        ));
      });
    }
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => null);
  }

  void addToFavorite(Product product) async {
    var _favorite = new Favorite();
    _favorite.product = product;
    _favorite.options = product.options.where((Option _option) {
      return _option.checked;
    }).toList();
    addFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = value;
      });
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).thisProductWasAddedToFavorite),
      ));
    });
  }

  void removeFromFavorite(Favorite _favorite) async {
    removeFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = new Favorite();
      });
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).thisProductWasRemovedFromFavorites),
      ));
    });
  }

  Future<void> refreshProduct() async {
    var _id = product.id;
    product = new Product();
    listenForFavorite(productId: _id);
    listenForProduct(
        productId: _id, message: S.of(context).productRefreshedSuccessfuly);
  }

  void calculateTotal() {
    total = product?.price ?? 0;

    switch (product.option_mid_pizza) {
      case '0': //NÃO OFERECE OPÇÃO PIZZA MEIO A MEIO
        print("NÃO OFERECE OPÇÃO PIZZA MEIO A MEIO");
        product?.options?.forEach((option) {
          total += option.checked ? option.price : 0;
        });
        break;
      case '1': //COBRA VALOR MEDIO OPÇÃO PIZZA MEIO A MEIO
        print("COBRAR VALOR MÉDIO OPÇÃO PIZZA MEIO A MEIO");
        var counter = 0;
        for (var t = 0; t < product?.options?.length; t++) {
          if (product?.options[t].checked) {
            counter += 1;
            if (counter < 3) {
              total += (product?.options[t].price / 2);
            } else {
              total += product?.options[t].price;
            }
          } else {
            total += 0;
          }
        }
        break;
      case '2': //COBRA VALOR MAIOR OPÇÃO PIZZA MEIO A MEIO
        print("COBRAR VALOR MAIOR OPÇÃO PIZZA MEIO A MEIO");
        var counter = 0;
        var firstPrice = 0.0;
        for (var t = 0; t < product?.options?.length; t++) {
          if (product?.options[t].checked) {
            print("COUNTER: " + counter.toString());
            if (counter == 0) {
              print("ENTROU NO COUNTER ZERO");
              firstPrice = product?.options[t].price;
            }
            counter += 1;
            if (counter < 3) {
              print("FIRST PRICE: " + firstPrice.toString());
              print("OPTION PRICE: " + product?.options[t].price.toString());
              total = (firstPrice > product?.options[t].price
                  ? firstPrice
                  : product?.options[t].price);
            } else {
              total += product?.options[t].price;
            }
          } else {
            total += 0;
          }
        }
        break;
      default:
        print("COBRAR VALOR DEFAULT");
        product?.options?.forEach((option) {
          total += option.checked ? option.price : 0;
        });
        break;
    }

    total *= quantity;
    setState(() {});
  }

  void setOptionSelect() {
    optionsSelect = [];
    optionsSelectUnique = [];

    product?.options?.forEach((option) {
      if (option.checked) {
        optionsSelectUnique.add(option.optionGroupId);
        if (!optionsSelect.contains(option.optionGroupId)) {
          optionsSelect.add(option.optionGroupId);
        }
      }
    });

    setState(() {});
  }

  incrementQuantity() {
    if (this.quantity <= 99) {
      ++this.quantity;
      calculateTotal();
    }
  }

  decrementQuantity() {
    if (this.quantity > 1) {
      --this.quantity;
      calculateTotal();
    }
  }
}
