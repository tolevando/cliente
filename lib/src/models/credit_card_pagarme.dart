import '../helpers/custom_trace.dart';

class CreditCardPagarme {
  String id;

  String cpf = '';
  String nome = '';  
  String endereco_endereco = '';
  String endereco_cep = '';
  String endereco_numero = '';
  String endereco_complemento = '';
  String endereco_cidade = '';
  String endereco_bairro = '';
  String endereco_uf = '';
  //dados do cartao
  String card_name = '';
  String number = '';
  String expMonth = '';
  String expYear = '';
  String cvc = '';
  

  CreditCardPagarme();

  CreditCardPagarme.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      cpf = jsonMap['cpf'].toString();
      nome = jsonMap['nome'].toString();
      endereco_endereco = jsonMap['endereco_endereco'].toString();
      endereco_cep = jsonMap['endereco_cep'].toString();
      endereco_numero = jsonMap['endereco_numero'].toString();
      endereco_complemento = jsonMap['endereco_complemento'].toString();
      endereco_cidade = jsonMap['endereco_cidade'].toString();
      endereco_uf = jsonMap['endereco_uf'].toString();
      endereco_bairro = jsonMap['endereco_bairro'].toString();
      card_name = jsonMap['pagarme_name'].toString();
      number = jsonMap['pagarme_number'].toString();
      expMonth = jsonMap['pagarme_exp_month'].toString();
      expYear = jsonMap['pagarme_exp_year'].toString();
      cvc = jsonMap['pagarme_cvc'].toString();
    } catch (e) {
      id = '';
      cpf = '';
      nome = '';
      endereco_endereco = '';
      endereco_cep = '';
      endereco_numero = '';
      endereco_complemento = '';
      endereco_cidade = '';
      endereco_bairro = '';
      endereco_uf = '';
      card_name = '';
      number = '';
      expMonth = '';
      expYear = '';
      cvc = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    
    map["cpf"] = cpf;
    map["nome"] = nome;
    map["endereco_endereco"] = endereco_endereco;
    map["endereco_cep"] = endereco_cep;
    map["endereco_numero"] = endereco_numero;
    map["endereco_complemento"] = endereco_complemento;
    map["endereco_cidade"] = endereco_cidade;
    map["endereco_bairro"] = endereco_bairro;    
    map["endereco_uf"] = endereco_uf;    
    
    map["pagarme_name"] = card_name;
    map["pagarme_number"] = number;
    map["pagarme_exp_month"] = expMonth;
    map["pagarme_exp_year"] = expYear;
    map["pagarme_cvc"] = cvc;
    return map;
  }

  bool validated() {
    return cpf != null && cpf != '' && 
    nome != null && nome != '' && 
    endereco_cep != null && endereco_cep != '' && 
    endereco_uf != null && endereco_uf != '' && 
    endereco_endereco != null && endereco_endereco != '' && 
    endereco_numero != null && endereco_numero != '' && 
    endereco_cidade != null && endereco_cidade != '' && 
    endereco_bairro != null && endereco_bairro != '' && 
    card_name != null && card_name != '' && 
    number != null && number != '' && 
    expMonth != null && expMonth != '' && 
    expYear != null && expYear != '' && 
    cvc != null && cvc != '';
  }
}
