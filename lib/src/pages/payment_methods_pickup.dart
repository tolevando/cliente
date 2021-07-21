import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../generated/l10n.dart';
import '../elements/PaymentMethodListItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';
import '../controllers/cart_controller.dart';

class PaymentMethodsPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;  
  PaymentMethodsPickupWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _PaymentMethodsPickupWidgetState createState() => _PaymentMethodsPickupWidgetState();
}

class _PaymentMethodsPickupWidgetState extends State<PaymentMethodsPickupWidget> {
  PaymentMethodList list;
  

  _PaymentMethodsPickupWidgetState(): super() {
    
  }

  void updateTrocoPara(valor) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('troco', valor);  
  }

  @override
  Widget build(BuildContext context) {
    if(list == null){
      list = new PaymentMethodList(context);
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      print("to aqui");
      prefs.then((pref){
        if(!(pref.getBool("offline_payment_option_cash")??true)){
            print("to aqui2");
            list.cashListRetirada.removeWhere((element){
              return element.id=="codr";
            });
        }
        if(!(pref.getBool("offline_payment_option_credit")??true)){
            print("to aqui3");
            setState(() {
              list.cashListRetirada.removeWhere((element){                
                return element.id=="ccodr";
              });              
            });

        }
        if(!(pref.getBool("offline_payment_option_debit")??true)){
            print("to aqui4");
            setState(() {
              list.cashListRetirada.removeWhere((element){
                return element.id=="cdodr";
              });
            });
        }    
          
      });
    }

    

    if (!setting.value.payPalEnabled)
      list.paymentsListRetirada.removeWhere((element) {
        return element.id == "paypal";
      });
    if (!setting.value.razorPayEnabled)
      list.paymentsListRetirada.removeWhere((element) {
        return element.id == "razorpay";
      });
      print(setting.value.toMap());
    if (!setting.value.stripeEnabled)
      list.paymentsListRetirada.removeWhere((element) {
        return element.id == "visacard" || element.id == "mastercard";
      });       
    if (!setting.value.pagarmeEnabled)
      list.paymentsListRetirada.removeWhere((element) {
        return element.id == "pagarme";
      });       
    
    /*if(_con.carts.length == 0){      
      setState(() {
        print("To aqui");
        if(!_con.carts[0].product.market.offline_payment_option_cash){
          list.paymentsList.removeWhere((element) {
            return element.id == "cod";
          });
        }

        if(!_con.carts[0].product.market.offline_payment_option_credit){
          list.paymentsList.removeWhere((element) {
            return element.id == "ccod";
          });
        }
        if(!_con.carts[0].product.market.offline_payment_option_debit){
          list.paymentsList.removeWhere((element) {
            return element.id == "cdod";
          });
        }

      });

    }*/
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).payment_mode,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[            
            SizedBox(height: 15),
            list.paymentsListRetirada.length > 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.payment,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        S.of(context).payment_options,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(S.of(context).select_your_preferred_payment_mode),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            SizedBox(height: 10),
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: list.paymentsListRetirada.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return PaymentMethodListItemWidget(paymentMethod: list.paymentsListRetirada.elementAt(index));
              },
            ),
            list.cashListRetirada.length > 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.monetization_on,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        S.of(context).payment_options,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(S.of(context).select_your_preferred_payment_mode),
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            Container(
              padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
              color: Colors.white,
              child:TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (input) => updateTrocoPara(input), 
                  onSaved: (input) => updateTrocoPara(input),                                         
                  decoration: InputDecoration(
                    labelText: "Troco para (opcional)",
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'Informe o valor para troco',
                    hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                    prefixIcon: Icon(Icons.money, color: Theme.of(context).accentColor),                          
                    border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),                    
                    fillColor: Colors.white,
                    filled: true
                  ),
                ),
            ),                  
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: list.cashListRetirada.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return PaymentMethodListItemWidget(paymentMethod: list.cashListRetirada.elementAt(index));
              },
            ),
          ],
        ),
      ),
    );
  }
}
