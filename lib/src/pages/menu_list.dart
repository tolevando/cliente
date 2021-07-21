import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markets/src/elements/GalleryCarouselWidget.dart';
import 'package:markets/src/elements/ReviewsListWidget.dart';
import 'package:markets/src/elements/SearchBarMarketWidget.dart';
import 'package:markets/src/elements/ShoppingCartFloatButtonWidget.dart';
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _con.market == null
          ? CircularLoadingWidget(height: 500)
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CustomScrollView(
                  primary: true,
                  shrinkWrap: false,
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor:
                          Theme.of(context).accentColor.withOpacity(0.9),
                      expandedHeight: 300,
                      elevation: 0,
                      iconTheme:
                          IconThemeData(color: Theme.of(context).primaryColor),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: Hero(
                          tag: (widget?.routeArgument?.heroTag ?? '') +
                              _con.market.id,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: _con.market.image.url,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20, left: 20, bottom: 10, top: 25),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    _con.market?.name ?? '',
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    maxLines: 2,
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ),
                                SizedBox(
                                  height: 32,
                                  child: Chip(
                                    padding: EdgeInsets.all(0),
                                    label: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(_con.market.rate,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .merge(TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor))),
                                        Icon(
                                          Icons.star_border,
                                          color: Theme.of(context).primaryColor,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.9),
                                    shape: StadiumBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 20),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                    color: _con.market.closed
                                        ? Colors.grey
                                        : Colors.green,
                                    borderRadius: BorderRadius.circular(24)),
                                child: _con.market.closed
                                    ? Text(
                                        S.of(context).closed,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      )
                                    : Text(
                                        S.of(context).open,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Helper.canDelivery(_con.market)
                                        ? Colors.green
                                        : Colors.orange,
                                    borderRadius: BorderRadius.circular(24)),
                                child: Helper.canDelivery(_con.market)
                                    ? Text(
                                        S.of(context).delivery,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      )
                                    : Text(
                                        S.of(context).pickup,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .merge(TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                      ),
                              ),
                              Expanded(child: SizedBox(height: 0)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Helper.canDelivery(_con.market)
                                        ? Colors.green
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(24)),
                                child: Text(
                                  Helper.getDistance(
                                      _con.market.distance,
                                      Helper.of(context)
                                          .trans(setting.value.distanceUnit)),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 20),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(24)),
                                child: Text(
                                  'Delivery: ' +
                                          _con.market
                                              ?.estimated_time_delivery ??
                                      '-',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                              ),
                              Expanded(child: SizedBox(height: 0)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(24)),
                                child: Text(
                                  'Retirada: ' +
                                          _con.market
                                              ?.estimated_time_get_product ??
                                      '-',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .merge(TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                            child: Helper.applyCustomHtml(
                                context, _con.market.description),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: SearchBarMarketWidget(market: _con.market),
                          ),
                          ImageThumbCarouselWidget(
                              galleriesList: _con.galleries),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            leading: Icon(
                              Icons.bookmark,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).featured_products,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .clickOnTheProductToGetMoreDetailsAboutIt,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          ProductsCarouselWidget(
                              heroTag: 'menu_trending_product',
                              productsList: _con.trendingProducts),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            leading: Icon(
                              Icons.subject,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).products,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .clickOnTheProductToGetMoreDetailsAboutIt,
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
                                    children: List.generate(
                                        _con.categories.length, (index) {
                                      var _category =
                                          _con.categories.elementAt(index);
                                      var _selected = this
                                          .selectedCategories
                                          .contains(_category.id);
                                      return Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 20),
                                        child: RawChip(
                                          elevation: 0,
                                          label: Text(_category.name),
                                          labelStyle: _selected
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .merge(TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor))
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 15),
                                          backgroundColor: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.1),
                                          selectedColor:
                                              Theme.of(context).accentColor,
                                          selected: _selected,
                                          //shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.05))),
                                          showCheckmark: false,
                                          avatar: (_category.id == '0')
                                              ? null
                                              : (_category.image.url
                                                      .toLowerCase()
                                                      .endsWith('.svg')
                                                  ? SvgPicture.network(
                                                      _category.image.url,
                                                      color: _selected
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .accentColor,
                                                    )
                                                  : CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          _category.image.icon,
                                                      placeholder:
                                                          (context, url) =>
                                                              Image.asset(
                                                        'assets/img/loading.gif',
                                                        fit: BoxFit.cover,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    )),
                                          onSelected: (bool value) {
                                            setState(() {
                                              if (_category.id == '0') {
                                                this.selectedCategories = ['0'];
                                              } else {
                                                this
                                                    .selectedCategories
                                                    .removeWhere((element) =>
                                                        element == '0');
                                              }
                                              if (value) {
                                                this
                                                    .selectedCategories
                                                    .add(_category.id);
                                              } else {
                                                this
                                                    .selectedCategories
                                                    .removeWhere((element) =>
                                                        element ==
                                                        _category.id);
                                              }
                                              _con.selectCategory(
                                                  this.selectedCategories);
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
                          _con.reviews.isEmpty
                              ? SizedBox(height: 5)
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: ListTile(
                                    dense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 0),
                                    leading: Icon(
                                      Icons.recent_actors,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: Text(
                                      "Avaliações do Estabelecimento",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ),
                                ),
                          _con.reviews.isEmpty
                              ? SizedBox(height: 5)
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: ReviewsListWidget(
                                      reviewsList: _con.reviews),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 32,
                  right: 20,
                  child: ShoppingCartFloatButtonWidget(
                    iconColor: Theme.of(context).primaryColor,
                    labelColor: Theme.of(context).hintColor,
                    routeArgument: RouteArgument(
                        param: '/Menu', id: widget.routeArgument.id),
                  ),
                ),
              ],
            ),
    );
  }
}
