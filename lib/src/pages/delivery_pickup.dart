import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:markets/src/models/coupon.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/NotDeliverableAddressesItemWidget.dart';
import '../elements/PickUpMethodItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class DeliveryPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryPickupWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  DeliveryPickupController _con;

  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller;

    checaDesconto();
  }

  void checaDesconto() async {
    _con.doApplyCouponConstructor(coupon.code);
  }

  void atualizaObservacao(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("observacao", value);
  }

  @override
  Widget build(BuildContext context) {
    if (_con.list == null) {
      _con.list = new PaymentMethodList(context);
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then((pref) {
        setState() {
          print("to aqui");
          if (!(pref.getBool("offline_payment_option_cash") ?? true)) {
            print("to aqui2");
            _con.list.cashList.removeWhere((element) {
              return element.id == "cod";
            });
          }
          if (!(pref.getBool("offline_payment_option_credit") ?? true)) {
            print("to aqui3");
            _con.list.cashList.removeWhere((element) {
              return element.id == "ccod";
            });
          }
          if (!(pref.getBool("offline_payment_option_debit") ?? true)) {
            print("to aqui4");
            _con.list.cashList.removeWhere((element) {
              return element.id == "cdod";
            });
          }
        }
      });
    }
    return Scaffold(
      key: _con.scaffoldKey,
      bottomNavigationBar: CartBottomDetailsWidget(con: _con),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).delivery_or_pickup,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.domain,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  "Retirar no Estabelecimento",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: Text(
                  "Clique para retirar e/ou pagar no estabelecimento",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            PickUpMethodItem(
                paymentMethod: _con.getPickUpMethod(),
                onPressed: (paymentMethod) {
                  _con.togglePickUp();
                }),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 10, left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.map,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      "Delivery",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    subtitle: _con.carts.isNotEmpty &&
                            Helper.canDelivery(_con.carts[0].product.market,
                                carts: _con.carts)
                        ? Text(
                            S
                                .of(context)
                                .click_to_confirm_your_address_and_pay_or_long_press,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          )
                        : Text(
                            S.of(context).deliveryMethodNotAllowed,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                  ),
                ),
                _con.carts.isNotEmpty &&
                        Helper.canDelivery(_con.carts[0].product.market,
                            carts: _con.carts)
                    ? _con.addresses.length > 0
                        ? ListView.separated(
                            padding: EdgeInsets.symmetric(vertical: 25),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _con.addresses.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 10);
                            },
                            itemBuilder: (context, index) {
                              return DeliveryAddressesItemWidget(
                                paymentMethod: _con.getDeliveryMethod(),
                                // address: _con.deliveryAddress,
                                address: _con.addresses.elementAt(index),
                                onPressed: (Address _address) {
                                  if (_con.addresses.elementAt(index).id ==
                                          null ||
                                      _con.addresses.elementAt(index).id ==
                                          'null' ||
                                      _con.addresses.elementAt(index).address ==
                                          'null' ||
                                      _con.addresses.elementAt(index).address ==
                                          null) {
                                    DeliveryAddressDialog(
                                      context: context,
                                      address: _address,
                                      onChanged: (Address _address) {
                                        _con.addAddress(_address);
                                      },
                                    );
                                  } else {
                                    _con.setSelectItem(
                                        _con.addresses.elementAt(index).id);
                                    _con.toggleDelivery(false);
                                  }
                                },
                                onLongPress: (Address _address) {
                                  DeliveryAddressDialog(
                                    context: context,
                                    address: _address,
                                    onChanged: (Address _address) {
                                      _con.updateAddress(_address);
                                    },
                                  );
                                },
                              );
                            },
                          )
                        : DeliveryAddressesItemWidget(
                            paymentMethod: _con.getDeliveryMethod(),
                            address: _con.deliveryAddress,
                            onPressed: (Address _address) {
                              if (_con.deliveryAddress.id == null ||
                                  _con.deliveryAddress.id == 'null') {
                                DeliveryAddressDialog(
                                  context: context,
                                  address: _address,
                                  onChanged: (Address _address) {
                                    _con.addAddress(_address);
                                  },
                                );
                              } else {
                                // print('ENDERECO CLICK ' +
                                // _con.addresses[0].description);
                                // print('ENDERECO ID ' + _con.addresses[0].id);
                                print('DELIVERY ADDRESS ID ' +
                                    _con.deliveryAddress.id);
                                _con.setSelectItem(_con.deliveryAddress.id);
                                _con.toggleDelivery(true);
                              }
                            },
                            onLongPress: (Address _address) {
                              DeliveryAddressDialog(
                                context: context,
                                address: _address,
                                onChanged: (Address _address) {
                                  _con.addAddress(_address);
                                },
                              );
                            },
                          )
                    : NotDeliverableAddressesItemWidget()
              ],
            ),
            SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(18),
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.15),
                        offset: Offset(0, 2),
                        blurRadius: 5.0)
                  ]),
              child: TextField(
                maxLines: 3,
                keyboardType: TextInputType.text,
                onSubmitted: (String value) {
                  atualizaObservacao(value);
                },
                onChanged: (String value) {
                  atualizaObservacao(value);
                },
                cursorColor: Theme.of(context).accentColor,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintStyle: Theme.of(context).textTheme.bodyText1,
                  suffixStyle: Theme.of(context)
                      .textTheme
                      .caption
                      .merge(TextStyle(color: _con.getCouponIconColor())),
                  hintText:
                      "Adicione uma observação para acompanhar o pedido\n",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.3))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.5))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.3))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
