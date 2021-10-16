import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/card_brand_controller.dart';
import '../models/route_argument.dart';

import '../elements/CardBrandsItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/card_brand.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SelectBrandWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  SelectBrandWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _SelectBrandWidgetState createState() => _SelectBrandWidgetState();
}

class _SelectBrandWidgetState extends StateMVC<SelectBrandWidget> {
  CardBrandController _con;
  _SelectBrandWidgetState() : super(CardBrandController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts();
    // _con.listenForCardBrands();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Bandeira do cartão',
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      /*: SizedBox(height: 0)*/
      body: RefreshIndicator(
        onRefresh: _con.refreshCardBrands,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.credit_card_outlined,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    'Selecione a bandeira do cartão',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              _con.card_brands.isEmpty
                  ? CircularLoadingWidget(height: 250)
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.card_brands.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemBuilder: (context, index) {
                        return CardBrandsItemWidget(
                          card_brand: _con.card_brands.elementAt(index),
                          onPressed: (CardBrand _card_brand) {
                            atualizaCardBrand(_card_brand.brand);
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void atualizaCardBrand(String value) async {
    print('atualiza card brand: ' + value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("card_brand", value);
    Navigator.of(context).pushNamed(widget.routeArgument.param);
  }
}
