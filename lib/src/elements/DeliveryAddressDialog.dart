import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/checkbox_form_field.dart';
import '../models/address.dart';

// ignore: must_be_immutable
class DeliveryAddressDialog {
  BuildContext context;
  Address address;
  ValueChanged<Address> onChanged;
  GlobalKey<FormState> _deliveryAddressFormKey = new GlobalKey<FormState>();

  DeliveryAddressDialog({this.context, this.address, this.onChanged}) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
//            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            titlePadding: EdgeInsets.fromLTRB(16, 25, 16, 0),
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.place,
                  color: Theme.of(context).hintColor,
                ),
                SizedBox(width: 10),
                Text(
                  S.of(context).add_delivery_address,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            children: <Widget>[
              Form(
                key: _deliveryAddressFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: S.of(context).home_address,
                            labelText: S.of(context).description),
                        initialValue: address.description?.isNotEmpty ?? false
                            ? address.description
                            : null,
                        validator: (input) => input.trim().length == 0
                            ? 'Descrição não é válida'
                            : null,
                        onSaved: (input) => address.description = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: 'Avenida Brasil...',
                            labelText: 'Endereço'),
                        initialValue: address.address?.isNotEmpty ?? false
                            ? address.address
                            : null,
                        validator: (input) {
                          if (input.trim().length == 0) {
                            return 'Endereço não é válido';
                          }

                          // if (!input.contains(new RegExp(r'[0-9]'))) {
                          //   return 'Informar o número da residência';
                          // }

                          return null;
                        },
                        onSaved: (input) => address.address = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: "Nº 130...",
                            labelText: 'Número da residência'),
                        initialValue: address.number?.isNotEmpty ?? false
                            ? address.number
                            : null,
                        validator: (input) {
                          if (input.trim().length == 0) {
                            return 'Informar o número da residência';
                          }

                          if (!input.contains(new RegExp(r'[0-9]'))) {
                            return 'Número da residência não é válido';
                          }

                          return null;
                        },
                        onSaved: (input) => address.number = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: "Nome do bairro...", labelText: 'Bairro'),
                        initialValue: address.bairro?.isNotEmpty ?? false
                            ? address.bairro
                            : null,
                        validator: (input) {
                          if (input.trim().length == 0) {
                            return 'Informar o bairro';
                          }

                          return null;
                        },
                        onSaved: (input) => address.bairro = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: new TextFormField(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        keyboardType: TextInputType.text,
                        decoration: getInputDecoration(
                            hintText: "Bloco A, Apart. 2...",
                            labelText: 'Complemento'),
                        initialValue: address.complement?.isNotEmpty ?? false
                            ? address.complement
                            : null,
                        onSaved: (input) => address.complement = input,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CheckboxFormField(
                        context: context,
                        initialValue: address.isDefault ?? false,
                        onSaved: (input) => address.isDefault = input,
                        title: Text('Tornar endereço padrão'),
                      ),
                    )
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

  void _submit() {
    if (_deliveryAddressFormKey.currentState.validate()) {
      _deliveryAddressFormKey.currentState.save();
      onChanged(address);
      Navigator.pop(context);
    }
  }
}
