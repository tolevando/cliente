import 'package:flutter/material.dart';
import 'package:markets/src/pages/bairrola.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../models/category.dart';
import '../models/gallery.dart';
import '../models/market.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../repository/category_repository.dart';
import '../repository/gallery_repository.dart';
import '../repository/market_repository.dart';
import '../repository/product_repository.dart';
import '../repository/settings_repository.dart';

class MarketController extends ControllerMVC {
  Market market;
  List<Gallery> galleries = <Gallery>[];
  List<Product> products = <Product>[];
  List<Category> categories = <Category>[];
  List<Product> trendingProducts = <Product>[];
  List<Product> featuredProducts = <Product>[];
  List<Review> reviews = <Review>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  bool selecionaBairro = false;

  MarketController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForMarket({String id, String message}) async {
    final Stream<Market> stream = await getMarket(id, deliveryAddress.value);
    stream.listen((Market _market) {
      setState(() => market = _market);
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
      /*else{        
        buscaBairroCliente();        
      }  */
    });
  }

  void buscaBairroCliente() async {
    if (market.possui_bairros_personalizados) {
      print("asdfasdf");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(prefs.getString("last_market_bairro_selecionado"));
      print(market.id);
      if (prefs.containsKey("last_market_bairro_selecionado") &&
          prefs.getString("last_market_bairro_selecionado") == market.id) {
        market.deliveryFee = prefs.getDouble("last_market_bairro_fee");
        setState(() => selecionaBairro = true);
      } else {
        setState(() => selecionaBairro = true);
      }
    } else {
      setState(() => selecionaBairro = false);
    }
  }

  void listenForGalleries(String idMarket) async {
    final Stream<Gallery> stream = await getGalleries(idMarket);
    stream.listen((Gallery _gallery) {
      setState(() => galleries.add(_gallery));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForMarketReviews({String id, String message}) async {
    final Stream<Review> stream = await getMarketReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForProducts(String idMarket, {List<String> categoriesId}) async {
    final Stream<Product> stream =
        await getProductsOfMarket(idMarket, categories: categoriesId);
    stream.listen((Product _product) {
      setState(() => products.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {
      market..name = products?.elementAt(0)?.market?.name;
    });
  }

  void listenForTrendingProducts(String idMarket) async {
    final Stream<Product> stream = await getTrendingProductsOfMarket(idMarket);
    stream.listen((Product _product) {
      setState(() => trendingProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForFeaturedProducts(String idMarket) async {
    final Stream<Product> stream = await getFeaturedProductsOfMarket(idMarket);
    stream.listen((Product _product) {
      setState(() => featuredProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForCategories(String marketId) async {
    final Stream<Category> stream = await getCategoriesOfMarket(marketId);
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {
      categories.insert(
          0, new Category.fromJSON({'id': '0', 'name': S.of(context).all}));
    });
  }

  Future<void> selectCategory(List<String> categoriesId) async {
    products.clear();
    listenForProducts(market.id, categoriesId: categoriesId);
  }

  Future<void> refreshMarket() async {
    var _id = market.id;
    market = new Market();
    galleries.clear();
    reviews.clear();
    featuredProducts.clear();
    listenForMarket(
        id: _id, message: S.of(context).market_refreshed_successfuly);
    listenForMarketReviews(id: _id);
    listenForGalleries(_id);
    listenForFeaturedProducts(_id);
  }
}