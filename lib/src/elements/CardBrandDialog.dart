import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/payment_method.dart';
import '../models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CardBrandDialog {
  BuildContext context;
  PaymentMethod paymentMethod;
  Order order;
  ValueChanged<Order> onChanged;
  GlobalKey<FormState> _cardBrandFormKey = new GlobalKey<FormState>();

  CardBrandDialog({this.context, this.paymentMethod, this.order}) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
//            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            titlePadding: EdgeInsets.fromLTRB(16, 25, 16, 0),
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.credit_card_outlined,
                  color: Theme.of(context).hintColor,
                ),
                SizedBox(width: 10),
                Text(
                  'Adicionar bandeira do cartão',
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            children: <Widget>[
              Form(
                key: _cardBrandFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: 'Mastercard, Visa, Elo...',
                            labelText: 'Bandeira'),
                        initialValue: null,
                        validator: (input) => input.trim().length == 0
                            ? 'Bandeira não é válida'
                            : null,
                        onSaved: (input) => atualizaCardBrand(input),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      S.of(context).cancel,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                  MaterialButton(
                    onPressed: _submit,
                    child: Text(
                      'Finalizar',
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
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  void atualizaCardBrand(String value) async {
    print('atualiza card brand: ' + value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("card_brand", value);
  }

  void _submit() {
    if (_cardBrandFormKey.currentState.validate()) {
      _cardBrandFormKey.currentState.save();
      // onChanged(order);
      Navigator.of(context).pushNamed(this.paymentMethod.route);
      print(this.paymentMethod.name);
    }
  }
}
