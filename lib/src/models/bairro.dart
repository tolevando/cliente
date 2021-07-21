import '../helpers/custom_trace.dart';


class Bairro {
  String id;
  String nome;
  String valor;
  

  Bairro();

  Bairro.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      nome = jsonMap['nome'].toString();
      valor = jsonMap['valor'].toString();      
    } catch (e) {
      id = '';
      nome = '';
      valor = '';
      //print(jsonMap);
      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}
