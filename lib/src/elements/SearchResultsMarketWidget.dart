import 'package:flutter/material.dart';
import 'package:markets/src/models/market.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/search_controller.dart';
import 'CardWidget.dart';
import 'CircularLoadingWidget.dart';
import 'ProductItemWidget.dart';
import '../models/route_argument.dart';

class SearchResultsMarketWidget extends StatefulWidget {
  final String heroTag;
  final Market market;

  SearchResultsMarketWidget({Key key, this.heroTag,this.market}) : super(key: key);

  @override
  _SearchResultMarketWidgetState createState() => _SearchResultMarketWidgetState();
}

class _SearchResultMarketWidgetState extends StateMVC<SearchResultsMarketWidget> {
  SearchController _con;

  _SearchResultMarketWidgetState() : super(SearchController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              trailing: IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).hintColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                S.of(context).search,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                S.of(context).ordered_by_nearby_first,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onSubmitted: (text) async {
                await _con.refreshSearchMarket(text,widget.market);
                //_con.saveSearchMarket(text);
              },
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: "Pesquise pelo produto desejado",
                hintStyle: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 14)),
                prefixIcon: Icon(Icons.search, color: Theme.of(context).accentColor),
                border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
              ),
            ),
          ),
          _con.products.isEmpty && !_con.searched
              ? CircularLoadingWidget(height: 288)
              : _con.products.isEmpty ? Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          title: Text(
                            "Nenhum resultado encontrado",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ) : Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          title: Text(
                            S.of(context).products_results,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                      ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.products.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          return ProductItemWidget(
                            heroTag: 'search_list',
                            product: _con.products.elementAt(index),
                          );
                        },
                      ),                      
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
