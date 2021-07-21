import 'package:flutter/material.dart';
import 'package:markets/src/controllers/settings_controller.dart';
import 'package:markets/src/models/cidade.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../elements/CircularLoadingWidget.dart';
//import '../elements/PaymentSettingsDialog.dart';
import '../elements/ProfileSettingsDialog.dart';
//import '../elements/SearchBarWidget.dart';
import '../helpers/helper.dart';
import '../repository/user_repository.dart';
import '../repository/settings_repository.dart' as settingsRepository;

class Cidadela2Widget extends StatefulWidget {
  @override
  _Cidadela2WidgetState createState() => _Cidadela2WidgetState();
}

class _Cidadela2WidgetState extends StateMVC<Cidadela2Widget> {
  SettingsController _con;
  
  _Cidadela2WidgetState() : super(SettingsController()) {
    _con = controller;
    inicializaChecagem();
  }

  void inicializaChecagem() async{
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,                
        body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: Text(               
                "Selecione a sua cidade",
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
              itemCount: settingsRepository.setting.value.cidades.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                Cidade _cidade = settingsRepository.setting.value.cidades.elementAt(index);                
                return InkWell(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString('cidade_escolhida',_cidade.id);
                    Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);                    
                    /*var _lang = _language.code.split("_");
                    if (_lang.length > 1)
                      settingRepo.setting.value.mobileLanguage.value = new Locale(_lang.elementAt(0), _lang.elementAt(1));
                    else
                      settingRepo.setting.value.mobileLanguage.value = new Locale(_lang.elementAt(0));
                    settingRepo.setting.notifyListeners();
                    languagesList.languages.forEach((_l) {
                      setState(() {
                        _l.selected = false;
                      });
                    });
                    _language.selected = !_language.selected;
                    settingRepo.setDefaultLanguage(_language.code);*/
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[   
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _cidade.cidade,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                _cidade.uf,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ]
              )));
  }
}
