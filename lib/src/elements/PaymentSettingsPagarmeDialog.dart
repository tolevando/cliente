import 'package:flutter/material.dart';
import 'package:markets/src/models/credit_card_pagarme.dart';

import '../../generated/l10n.dart';

// ignore: must_be_immutable
class PaymentSettingsPagarmeDialog extends StatefulWidget {
  CreditCardPagarme creditCard;
  VoidCallback onChanged;

  PaymentSettingsPagarmeDialog({Key key, this.creditCard, this.onChanged}) : super(key: key);

  @override
  _PaymentSettingsPagarmeDialogState createState() => _PaymentSettingsPagarmeDialogState();
}

class _PaymentSettingsPagarmeDialogState extends State<PaymentSettingsPagarmeDialog> {
  GlobalKey<FormState> _paymentSettingsFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,          
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.lock),
                    SizedBox(width: 10),
                    Text(
                      "Cadastrar Cartão",
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _paymentSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(hintText: '12345678910', labelText: "CPF"),
                          initialValue: widget.creditCard.cpf.isNotEmpty ? widget.creditCard.cpf : null,
                          validator: (input) => input.trim().length != 11 ? S.of(context).not_a_valid_number : null,
                          onSaved: (input) => widget.creditCard.cpf = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.name,
                          decoration: getInputDecoration(hintText: 'Nome Completo do Titular do Cartão', labelText: "Nome Completo"),
                          initialValue: widget.creditCard.nome.isNotEmpty ? widget.creditCard.nome : null,
                          validator: (input) => input.trim().length < 4 ? "Digite o seu nome completo" : null,
                          onSaved: (input) => widget.creditCard.nome = input,
                        ),  
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(hintText: '33333333', labelText: "CEP"),
                          initialValue: widget.creditCard.endereco_cep.isNotEmpty ? widget.creditCard.endereco_cep : null,
                          validator: (input) => input.trim().length != 8 ? "Digite o cep sem pontos ou traços" : null,
                          onSaved: (input) => widget.creditCard.endereco_cep = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: 'Rua Um Dois Tres', labelText: "Endereço do Titular"),
                          initialValue: widget.creditCard.endereco_endereco.isNotEmpty ? widget.creditCard.endereco_endereco : null,
                          validator: (input) => input.trim().length < 3 ? "Digite o logradouro corretamente" : null,
                          onSaved: (input) => widget.creditCard.endereco_endereco = input,
                        ), 
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: 'Número da Casa/Apto', labelText: "Número"),
                          initialValue: widget.creditCard.endereco_numero.isNotEmpty ? widget.creditCard.endereco_numero : null,
                          validator: (input) => input.trim().length < 1 ? "Digite o número corretamnte" : null,
                          onSaved: (input) => widget.creditCard.endereco_numero = input,
                        ), 
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: 'Complemento (opcional)', labelText: "Complemento"),
                          initialValue: widget.creditCard.endereco_complemento.isNotEmpty ? widget.creditCard.endereco_complemento : null,
                          validator: (input) => null,
                          onSaved: (input) => widget.creditCard.endereco_complemento = input,
                        ),     
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: 'Ex: MG', labelText: "Estado"),
                          initialValue: widget.creditCard.endereco_uf.isNotEmpty ? widget.creditCard.endereco_uf : null,
                          validator: (input) => input.trim().length != 2  ? "Digite a UF com 2 digitos" : null,
                          onSaved: (input) => widget.creditCard.endereco_uf = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: 'Cidade do Endereço', labelText: "Cidade"),
                          initialValue: widget.creditCard.endereco_cidade.isNotEmpty ? widget.creditCard.endereco_cidade : null,
                          validator: (input) => input.trim().length < 1 ? "Digite a cidade" : null,
                          onSaved: (input) => widget.creditCard.endereco_cidade = input,
                        ),  
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: 'Bairro do Endereço', labelText: "Bairro"),
                          initialValue: widget.creditCard.endereco_bairro.isNotEmpty ? widget.creditCard.endereco_bairro : null,
                          validator: (input) => input.trim().length < 1 ? "Digite o bairro do endereço" : null,
                          onSaved: (input) => widget.creditCard.endereco_bairro = input,
                        ),                   
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(hintText: '4242 4242 4242 4242', labelText: "Número do Cartão"),
                          initialValue: widget.creditCard.number.isNotEmpty ? widget.creditCard.number : null,
                          validator: (input) => input.trim().length != 16 ? "Digite o número do cartão completo (somente numeros)" : null,
                          onSaved: (input) => widget.creditCard.number = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: 'JOSE DA SILVA', labelText: "Nome no Cartão"),
                          initialValue: widget.creditCard.card_name.isNotEmpty ? widget.creditCard.card_name : null,
                          validator: (input) => input.trim().length < 4 ? "Digite o nome como está no cartão" : null,
                          onSaved: (input) => widget.creditCard.card_name = input,
                        ),
                        new TextFormField(
                            style: TextStyle(color: Theme.of(context).hintColor),
                            keyboardType: TextInputType.text,
                            decoration: getInputDecoration(hintText: 'mm/yy', labelText: S.of(context).exp_date),
                            initialValue: widget.creditCard.expMonth.isNotEmpty ? widget.creditCard.expMonth + '/' + widget.creditCard.expYear : null,
                            // TODO validate date
                            validator: (input) => !input.contains('/') || input.length != 5 ? "Digite a data de expiração no formato mes/ano com 2 digitos" : null,
                            onSaved: (input) {
                              widget.creditCard.expMonth = input.split('/').elementAt(0);
                              widget.creditCard.expYear = input.split('/').elementAt(1);
                            }),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(hintText: '123', labelText: S.of(context).cvc),
                          initialValue: widget.creditCard.cvc.isNotEmpty ? widget.creditCard.cvc : null,
                          validator: (input) => input.trim().length != 3 ? "Digite o cvc válido" : null,
                          onSaved: (input) => widget.creditCard.cvc = input,
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
      },
      child: Text(
        S.of(context).edit,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
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

  void _submit() {
    if (_paymentSettingsFormKey.currentState.validate()) {
      //print(_paymentSettingsFormKey);
      _paymentSettingsFormKey.currentState.save();
      print(widget.creditCard.toMap());
      widget.onChanged();
      Navigator.pop(context);
    }
  }
}
