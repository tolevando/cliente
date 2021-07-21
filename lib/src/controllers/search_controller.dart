import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/address.dart';
import '../models/market.dart';
import '../models/product.dart';
import '../repository/market_repository.dart';
import '../repository/product_repository.dart';
import '../repository/search_repository.dart';
import '../repository/settings_repository.dart';

class SearchController extends ControllerMVC {
  List<Market> markets = <Market>[];
  List<Product> products = <Product>[];
  bool searched = false;

  SearchController() {
    listenForMarkets();
    listenForProducts();
  }

  void listenForMarkets({String search}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    Address _address = deliveryAddress.value;
    final Stream<Market> stream = await searchMarkets(search, _address);
    stream.listen((Market _market) {
      setState(() => markets.add(_market));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForProducts({String search}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    Address _address = deliveryAddress.value;
    setState(() => searched = false);
    final Stream<Product> stream = await searchProducts(search, _address);
    setState(() => searched = true);
    stream.listen((Product _product) {
      setState(() => products.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForProductsOfMarket({String search,Market market}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    Address _address = deliveryAddress.value;
    setState(() => searched = false);
    final Stream<Product> stream = await searchProductsOfMarket(search, _address,market);
    setState(() => searched = true);
    stream.listen((Product _product) {
      setState(() => products.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshSearch(search) async {
    setState(() {
      markets = <Market>[];
      products = <Product>[];
    });
    listenForMarkets(search: search);
    listenForProducts(search: search);
  }

  Future<void> refreshSearchMarket(search,Market market) async {
    setState(() {
      markets = <Market>[];
      products = <Product>[];
    });
    //listenForMarkets(search: search);
    listenForProductsOfMarket(search: search,market:market);
  }

  void saveSearch(String search) {
    setRecentSearch(search);
  }

  void saveSearchMarket(String search) {
    setRecentSearch(search);
  }

}
