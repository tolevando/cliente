import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/models/bairro.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/CartItemWidget.dart';
import '../elements/EmptyCartWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class CartWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CartWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController _con;
  

  _CartWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts();
    _con.pickedDate = DateTime.now();
    _con.time = TimeOfDay.now();

    initializeDateHour();
    
    super.initState();
  }

  void initializeDateHour()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("data_hora", "${_con.pickedDate.day}/${_con.pickedDate.month}/${_con.pickedDate.year} ${_con.time.hour}:${_con.time.minute}");

  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(      
        key: _con.scaffoldKey,
        //bottomNavigationBar: CartBottomDetailsWidget(con: _con),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              if (widget.routeArgument != null) {
                Navigator.of(context).pushReplacementNamed(widget.routeArgument.param, arguments: RouteArgument(id: widget.routeArgument.id));
              } else {
                Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
              }
            },
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).hintColor,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).cart,
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshCarts,
          child: _con.carts.isEmpty
              ? EmptyCartWidget()
              : (_con.precisaSelecionarBairro && _con.carts.elementAt(0).product.market.possui_bairros_personalizados)? SingleChildScrollView(
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
              itemCount: _con.carts.elementAt(0).product.market.bairros.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                Bairro _bairro = _con.carts.elementAt(0).product.market.bairros.elementAt(index);                
                return InkWell(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('last_market_bairro_selecionado',_con.carts.elementAt(0).product.market.id);
                    await prefs.setString('last_market_bairro_id',_bairro.id);
                    await prefs.setString('last_market_bairro_name',_bairro.nome);
                    await prefs.setDouble('last_market_bairro_fee',double.parse(_bairro.valor));                    
                    setState(() => _con.precisaSelecionarBairro= false);         
                    setState(() => _con.deliveryFee = double.parse(_bairro.valor));    
                    setState(() => _con.carts[0].product.market.deliveryFee = double.parse(_bairro.valor));    
                    _con.calculateSubtotal();    
                    rebuildAllChildren(context);
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
                                "Taxa de Entrega: R\$ "+(_bairro.valor.toString()),
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
                padding: EdgeInsets.fromLTRB(0,0,0,5),
                child:Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.shopping_cart,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).shopping_cart,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              S.of(context).verify_your_quantity_and_click_checkout,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          primary: true,
                          itemCount: _con.carts.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 15);
                          },
                          itemBuilder: (context, index) {
                            return CartItemWidget(
                              cart: _con.carts.elementAt(index),
                              heroTag: 'cart',
                              increment: () {
                                _con.incrementQuantity(_con.carts.elementAt(index));
                              },
                              decrement: () {
                                _con.decrementQuantity(_con.carts.elementAt(index));
                              },
                              onDismissed: () {
                                _con.removeFromCart(_con.carts.elementAt(index));
                              },
                            );
                          },
                        ),
                        Container(
                            padding: const EdgeInsets.all(18),
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, 2), blurRadius: 5.0)]),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              onSubmitted: (String value) {
                                _con.doApplyCoupon(value);
                              },
                              cursorColor: Theme.of(context).accentColor,
                              controller: TextEditingController()..text = coupon?.code ?? '',
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintStyle: Theme.of(context).textTheme.bodyText1,
                                suffixText: coupon?.valid == null ? '' : (coupon.valid ? S.of(context).validCouponCode : S.of(context).invalidCouponCode),
                                suffixStyle: Theme.of(context).textTheme.caption.merge(TextStyle(color: _con.getCouponIconColor())),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Icon(
                                    Icons.confirmation_number,
                                    color: _con.getCouponIconColor(),
                                    size: 28,
                                  ),
                                ),
                                hintText: S.of(context).haveCouponCode,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                              ),
                            ),                      
                          ),  
                          ((_con.carts.isEmpty || (_con.carts.isNotEmpty && !_con.carts.elementAt(0).product.market.exige_agendamento))?
                            SizedBox(height:1)
                            :                          
                            Container(
                              padding: const EdgeInsets.all(18),
                              margin: EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, 2), blurRadius: 5.0)]
                              ),
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                              Text(
                                "Selecione a data e hora para ser atendido",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              ListTile(
                                title: Text("Data: ${_con.pickedDate.day}/${_con.pickedDate.month}/${_con.pickedDate.year}"),
                                trailing: Icon(Icons.keyboard_arrow_down),
                                onTap: _pickDate,
                              ),
                              ListTile(
                                title: Text("Hora: ${_con.time.hour}:${_con.time.minute}"),
                                trailing: Icon(Icons.keyboard_arrow_down),
                                onTap: _pickTime,
                              ),
                            ],
                          ),                   
                          )  
                          ),                 
                        CartBottomDetailsWidget(con: _con),
                        
                      ],
                    ),
                                        
                  ],
                ),
              ),
        ),
      ),
    );
  }

  _pickDate() async {
   DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year-5),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: _con.pickedDate,
    );
    if(date != null){      
      setState(() {
        _con.pickedDate = date;                
      });      
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("data_hora", "${_con.pickedDate.day}/${_con.pickedDate.month}/${_con.pickedDate.year} ${_con.time.hour}:${_con.time.minute}");
    }
  }

  _pickTime() async {
   TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: _con.time
    );
    if(t != null)
      setState(() {
        _con.time = t;
      });
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("data_hora", "${_con.pickedDate.day}/${_con.pickedDate.month}/${_con.pickedDate.year} ${_con.time.hour}:${_con.time.minute}");
  }
}
