import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markets/src/elements/GalleryCarouselWidget.dart';
import 'package:markets/src/elements/ReviewsListWidget.dart';
import 'package:markets/src/elements/SearchBarMarketWidget.dart';
import 'package:markets/src/helpers/helper.dart';
import 'package:markets/src/models/bairro.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../controllers/market_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/ProductItemWidget.dart';
import '../elements/ProductsCarouselWidget.dart';

import '../elements/ShoppingCartButtonWidget.dart';

import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
  final RouteArgument routeArgument;

  MenuWidget({Key key, this.routeArgument}) : super(key: key);
}

class _MenuWidgetState extends StateMVC<MenuWidget> {
  MarketController _con;
  
  List<String> selectedCategories;

  _MenuWidgetState() : super(MarketController()) {
    _con = controller;
  }

  @override
  void initState() {
    //_con.market = (new Market())..id = widget.routeArgument.id;
    _con.listenForMarket(id: widget.routeArgument.id);
    _con.listenForGalleries(widget.routeArgument.id);
    _con.listenForTrendingProducts(widget.routeArgument.id);
    _con.listenForCategories(widget.routeArgument.id);
    selectedCategories = ['0'];
    _con.listenForProducts(widget.routeArgument.id);
    _con.listenForMarketReviews(id: widget.routeArgument.id);

    //checaBairro();
    

    super.initState();
  }

  /*void checaBairro() async{
    if(_con.market.possui_bairros_personalizados){
      print("asdfasdf");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey("last_market_bairro_selecionado") 
        && prefs.getString("last_market_bairro_selecionado") == _con.market.id){
          _con.market.deliveryFee = prefs.getDouble("last_market_bairro_fee");
      }else{        
        Navigator.of(context).pushReplacementNamed('/Bairro',arguments: _con.market);        
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _con.market?.name ?? '',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _con.market == null
              ? CircularLoadingWidget(height: 500)
              : (_con.selecionaBairro)? SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: Text(               
                "Selecione o seu bairro",
                style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
                textAlign: TextAlign.center,            
              ),
            )
             ,
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              itemCount: _con.market.bairros.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                Bairro _bairro = _con.market.bairros.elementAt(index);                
                return InkWell(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('last_market_bairro_selecionado',_con.market.id);
                    await prefs.setString('last_market_bairro_id',_bairro.id);
                    await prefs.setString('last_market_bairro_name',_bairro.nome);
                    await prefs.setDouble('last_market_bairro_fee',double.parse(_bairro.valor));                    
                    setState(() => _con.selecionaBairro = false);                    
                    //Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);                    
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[   
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[                              
                              Text(
                                _bairro.nome,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),                              
                            ],
                          ),                          
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[  
                              Text(
                                "Taxa de Entrega: "+(_bairro.valor.toString()),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ]
              ))
              : SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(color: _con.market.closed ? Colors.grey : Colors.green, borderRadius: BorderRadius.circular(24)),
                  child: _con.market.closed
                      ? Text(
                          S.of(context).closed,
                          style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                        )
                      : Text(
                          S.of(context).open,
                          style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                      color: Helper.canDelivery(_con.market) ? Colors.green : Colors.orange, borderRadius: BorderRadius.circular(24)),
                  child: Helper.canDelivery(_con.market)
                      ? Text(
                          S.of(context).delivery,
                          style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                        )
                      : Text(
                          S.of(context).pickup,
                          style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                ),                
                Expanded(child: SizedBox(height: 0)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                      color: Helper.canDelivery(_con.market) ? Colors.green : Colors.grey, borderRadius: BorderRadius.circular(24)),
                  child: Text(
                    Helper.getDistance(_con.market.distance, Helper.of(context).trans(setting.value.distanceUnit)),
                    style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20,20,20,0),
              child: SearchBarMarketWidget(market:_con.market),
            ),             
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.bookmark,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).featured_products,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                S.of(context).clickOnTheProductToGetMoreDetailsAboutIt,
                maxLines: 2,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            ProductsCarouselWidget(heroTag: 'menu_trending_product', productsList: _con.trendingProducts),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.subject,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).products,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                S.of(context).clickOnTheProductToGetMoreDetailsAboutIt,
                maxLines: 2,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            _con.categories.isEmpty
                ? SizedBox(height: 90)
                : Container(
                    height: 90,
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(_con.categories.length, (index) {
                        var _category = _con.categories.elementAt(index);
                        var _selected = this.selectedCategories.contains(_category.id);
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(start: 20),
                          child: RawChip(
                            elevation: 0,
                            label: Text(_category.name),
                            labelStyle: _selected
                                ? Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).primaryColor))
                                : Theme.of(context).textTheme.bodyText2,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                            backgroundColor: Theme.of(context).focusColor.withOpacity(0.1),
                            selectedColor: Theme.of(context).accentColor,
                            selected: _selected,
                            //shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.05))),
                            showCheckmark: false,
                            avatar: (_category.id == '0')
                                ? null
                                : (_category.image.url.toLowerCase().endsWith('.svg')
                                    ? SvgPicture.network(
                                        _category.image.url,
                                        color: _selected ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                                      )
                                    : CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: _category.image.icon,
                                        placeholder: (context, url) => Image.asset(
                                          'assets/img/loading.gif',
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      )),
                            onSelected: (bool value) {
                              setState(() {
                                if (_category.id == '0') {
                                  this.selectedCategories = ['0'];
                                } else {
                                  this.selectedCategories.removeWhere((element) => element == '0');
                                }
                                if (value) {
                                  this.selectedCategories.add(_category.id);
                                } else {
                                  this.selectedCategories.removeWhere((element) => element == _category.id);
                                }
                                _con.selectCategory(this.selectedCategories);
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),
            _con.products.isEmpty
                ? CircularLoadingWidget(height: 250)
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.products.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      return ProductItemWidget(
                        heroTag: 'menu_list',
                        product: _con.products.elementAt(index),
                      );
                    },
                  ),
                  ImageThumbCarouselWidget(galleriesList: _con.galleries),
                  _con.reviews.isEmpty
                      ? SizedBox(height: 5)
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.recent_actors,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text( 
                              "Avaliações do Estabelecimento",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ),                  
                  _con.reviews.isEmpty
                      ? SizedBox(height: 5)
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: ReviewsListWidget(reviewsList: _con.reviews),
                        ),                  
            
          ],
        ),
      ),
    );
  }
}
