import 'package:flutter/material.dart';
import 'package:markets/src/elements/CreditCardsPagarmeWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../controllers/checkout_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/CreditCardsWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class PagarmeCartaoRecusadoRetiradaWidget extends StatefulWidget {
//  RouteArgument routeArgument;
//  PagarmeCartaoRecusadoRetiradaWidget({Key key, this.routeArgument}) : super(key: key);
  @override
  _PagarmeCartaoRecusadoRetiradaWidgetState createState() => _PagarmeCartaoRecusadoRetiradaWidgetState();
}

class _PagarmeCartaoRecusadoRetiradaWidgetState extends StateMVC<PagarmeCartaoRecusadoRetiradaWidget> {
  CheckoutController _con;

  _PagarmeCartaoRecusadoRetiradaWidgetState() : super(CheckoutController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts();
    _con.listenForCreditCard();

    _con.carts[0].product.market.deliveryFee = 0;
    
    super.initState();
  }

  /*void updateExibeErroCartao()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(await sharedPreferences.containsKey("cartao_recusado") && await sharedPreferences.getBool("cartao_recusado")){
      setState(() {
        print("ah to aqui");
        exibe_erro_cartao = true;        
      });      
    }else{
      setState(() {
        print("ah to aqui2");
        exibe_erro_cartao = false;        
      });      
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Pagamento Recusado",
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: _con.carts.isEmpty
          ? CircularLoadingWidget(height: 400)
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 255),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.lock,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              "Seu pagamento foi recusado. Favor atualizar as informações do cartão",
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              "Seus dados são armazenados de forma segura",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        new CreditCardsPagarmeWidget(
                            creditCard: _con.creditCardPagarme,
                            onChanged: (creditCardPagarme) {
                              _con.updateCreditCardPagarme(creditCardPagarme);
                            }),                        
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),                
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 255,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                        boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).subtotal,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Helper.getPrice(_con.subTotal, context, style: Theme.of(context).textTheme.subtitle1)
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).delivery_fee,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Helper.getPrice(_con.carts[0].product.market.deliveryFee, context, style: Theme.of(context).textTheme.subtitle1)
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "${S.of(context).tax} (${_con.carts[0].product.market.defaultTax}%)",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              Helper.getPrice(_con.taxAmount, context, style: Theme.of(context).textTheme.subtitle1)
                            ],
                          ),
                          Divider(height: 30),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  S.of(context).total,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              Helper.getPrice(_con.total, context, style: Theme.of(context).textTheme.headline6)
                            ],
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 40,
                            child: FlatButton(
                              onPressed: () {
                                if (_con.creditCardPagarme.validated()) {
                                  Navigator.of(context).pushNamed('/OrderSuccessRetirada', arguments: new RouteArgument(param: 'Credit Card (Pagarme Gateway)'));
                                } else {
                                  _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
                                    content: Text(S.of(context).your_credit_card_not_valid),
                                  ));
                                }
                              },
                              padding: EdgeInsets.symmetric(vertical: 14),
                              color: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                              child: Text(
                                S.of(context).confirm_payment,
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),                
              ],
            ),
    );
  }
}
