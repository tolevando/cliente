import 'package:flutter/material.dart';
import 'package:markets/src/models/cidade.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../models/credit_card.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;
import '../repository/settings_repository.dart' as settingsRepository;

class SettingsController extends ControllerMVC {
  CreditCard creditCard = new CreditCard();
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  Cidade cidadeSelecionada;

  SettingsController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void update(User user) async {
    user.deviceToken = null;
    repository.update(user).then((value) {
      setState(() {});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).profile_settings_updated_successfully),
      ));
    });
  }

  void updateCreditCard(CreditCard creditCard) {
    repository.setCreditCard(creditCard).then((value) {
      setState(() {});
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).payment_settings_updated_successfully),
      ));
    });
  }

  void listenForUser() async {
    creditCard = await repository.getCreditCard();
    setState(() {});
  }

  Future<void> refreshSettings() async {
    creditCard = new CreditCard();
  }

  Future<String> getCidadeSelecionada() async{
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.remove('cidade_escolhida');
    if(prefs.containsKey('cidade_escolhida')){    
      String cidade_id = await prefs.get('cidade_escolhida');
      return cidade_id;
    }    
    return null;    
  }


}
