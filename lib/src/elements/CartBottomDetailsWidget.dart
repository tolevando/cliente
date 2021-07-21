import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../helpers/helper.dart';
import '../repository/user_repository.dart';
import 'package:markets/src/controllers/settings_controller.dart';


GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

class CartBottomDetailsWidget extends StatelessWidget {
  const CartBottomDetailsWidget({
    Key key,
    @required CartController con,
  })  : _con = con,
        super(key: key);

  final CartController _con;

  void updateDeliveryFee() async{
    //_con.deliveryFee = 
  }

  @override
  Widget build(BuildContext context) {
    return _con.carts.isEmpty
        ? SizedBox(height: 0)
        : Container(
            height: 200, 
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
                      Helper.getPrice(_con.subTotal, context, style: Theme.of(context).textTheme.subtitle1, zeroPlaceholder: '0')
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          S.of(context).delivery_fee,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      if (Helper.canDelivery(_con.carts[0].product.market, carts: _con.carts) && !_con.isRetirada)
                        Helper.getPrice(_con.carts[0].product.market.deliveryFee, context,
                            style: Theme.of(context).textTheme.subtitle1, zeroPlaceholder: 'Grátis')
                      else
                        Helper.getPrice(0, context, style: Theme.of(context).textTheme.subtitle1, zeroPlaceholder: 'Grátis')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${S.of(context).tax} (${_con.carts[0].product.market.defaultTax}%)',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Helper.getPrice(_con.taxAmount, context, style: Theme.of(context).textTheme.subtitle1)
                    ],
                  ),
                  SizedBox(height: 10),                                               
                  Stack(
                    fit: StackFit.loose,
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: FlatButton(
                          onPressed: () {                                
                            if(!currentUser.value.profileCompleted()) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                    titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                    title: Row(
                                      children: <Widget>[
                                        Icon(Icons.person),
                                        SizedBox(width: 10),
                                        Text(
                                          "Complete suas informações",
                                          style: Theme.of(context).textTheme.bodyText1,
                                        )
                                      ],
                                    ),
                                    children: <Widget>[
                                      Form(
                                        key: _profileSettingsFormKey,
                                        child: Column(
                                          children: <Widget>[
                                            new TextFormField(
                                              style: TextStyle(color: Theme.of(context).hintColor),
                                              keyboardType: TextInputType.text,
                                              decoration: getInputDecoration(hintText: S.of(context).john_doe, labelText: S.of(context).full_name,context:context),
                                              initialValue: currentUser.value.name,
                                              validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_full_name : null,
                                              onSaved: (input) => currentUser.value.name = input,
                                            ),
                                            new TextFormField(
                                              style: TextStyle(color: Theme.of(context).hintColor),
                                              keyboardType: TextInputType.emailAddress,
                                              decoration: getInputDecoration(hintText: 'nome@email.com.br', labelText: S.of(context).email_address,context:context),
                                              initialValue: currentUser.value.email,
                                              validator: (input) => (!input.contains('@') || !input.contains('.')) ? S.of(context).not_a_valid_email : null,
                                              onSaved: (input) => currentUser.value.email = input,
                                            ),
                                            new TextFormField(
                                              style: TextStyle(color: Theme.of(context).hintColor),
                                              keyboardType: TextInputType.text,
                                              decoration: getInputDecoration(hintText: '(00) 000000000', labelText: S.of(context).phone,context:context),
                                              initialValue: currentUser.value.phone,
                                              validator: (input) => input.trim().length < 6 ? "Digite o seu telefone corretamente" : null,
                                              onSaved: (input) => currentUser.value.phone = input,
                                            ),
                                            new TextFormField(
                                              style: TextStyle(color: Theme.of(context).hintColor),
                                              keyboardType: TextInputType.text,
                                              maxLines: 5,
                                              decoration: getInputDecoration(hintText: S.of(context).your_address, labelText: S.of(context).address,context:context),
                                              initialValue: currentUser.value.address,
                                              validator: (input) => input.trim().length < 3 ? S.of(context).not_a_valid_address : null,
                                              onSaved: (input) => currentUser.value.address = input,
                                            ),                                            
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        children: <Widget>[
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(S.of(context).cancel),
                                          ),
                                          MaterialButton(
                                            onPressed: (){
                                              if (_profileSettingsFormKey.currentState.validate()) {
                                                _profileSettingsFormKey.currentState.save();              
                                                SettingsController().update(currentUser.value);
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Text(
                                              S.of(context).save,
                                              style: TextStyle(color: Theme.of(context).accentColor),
                                            ),
                                          ),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.end,
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  );
                                });  
                            }else{                                                    
                              _con.goCheckout(context);
                            }
                          },
                          disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: !_con.carts[0].product.market.closed ? Theme.of(context).accentColor : Theme.of(context).focusColor.withOpacity(0.5),
                          shape: StadiumBorder(),
                          child: Text(
                            S.of(context).checkout,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Helper.getPrice(_con.getTotal(), context,
                            style: Theme.of(context).textTheme.headline4.merge(TextStyle(color: Theme.of(context).primaryColor)), zeroPlaceholder: 'Grátis'),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
  }

  InputDecoration getInputDecoration({String hintText, String labelText,BuildContext context}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }
}
