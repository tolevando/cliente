import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:markets/src/controllers/user_controller.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:markets/src/models/user.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helpers/app_config.dart' as config;
import '../helpers/helper.dart';
import '../repository/user_repository.dart' as userRepo;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FacebookLogin extends StatefulWidget {
  @override
  _FacebookLoginState createState() => _FacebookLoginState();
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

class _FacebookLoginState extends StateMVC<FacebookLogin> {
  UserController _con;
  bool carregouTudo = false;
  FirebaseMessaging _firebaseMessaging;
  String deviceToken = "";
  Random _rnd = Random();
  String securityToken = "";
  
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  _FacebookLoginState() : super(UserController()) {
    _con = controller;
  }
  @override
  void initState() {
    super.initState();
    //print("oioioioioi "+userRepo.currentUser.value.deviceToken);
    //print("oioioioioi2 "+GlobalConfiguration().getString("base_url"));
    this.securityToken = getRandomString(30);
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {      
      this.deviceToken = _deviceToken;              
      setState(() { 
        this.carregouTudo = true;      
      });
    }).catchError((e) {
      //mesmo nao tendo o device a gente faz o login
      setState(() { 
        this.carregouTudo = true;
      });
      print('Notification not configured');
    });
    
    Timer timer = new Timer.periodic(new Duration(seconds: 5), (timer) async{
      print("Vou checar");
      final client = new http.Client();
      print(GlobalConfiguration().getString("base_url")+"checaLogin/facebookLoginCheck?security_token="+this.securityToken);
      final response = await client.post(
        GlobalConfiguration().getString("base_url")+"checaLogin/facebookLoginCheck",
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode({
          'security_token':this.securityToken
        }),
      );
      if (response.statusCode == 200) {        
        if (json.decode(response.body)['data'] != null) {
          print("To logadao");          
          await userRepo.setCurrentUser(response.body);            
          userRepo.currentUser.value = User.fromJSON(json.decode(response.body)['data']);
          //setState(){};
          timer.cancel();
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
        }else{
          print("Chequei mas nao logou ainda");
        }
        
      } else {
        //throw new Exception(response.body);
        print("Teve um erro no statusCode");
      }
      print(response.body);
    });

  }

  @override  
  Widget build(BuildContext context) {
    
    if(carregouTudo){
      this._launchURL(GlobalConfiguration().getString("base_url")+"login/facebook?mobile=true&deviceToken="+this.deviceToken+"&security_token="+this.securityToken);
    }
    
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text("Aguardando você realizar o login no navegador",          
          ),
      ),
    );
  }

  void _launchURL(String _url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}