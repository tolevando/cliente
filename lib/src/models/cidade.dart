import '../helpers/custom_trace.dart';


class Cidade {
  String id;
  String uf;
  String cidade;
  

  Cidade();

  Cidade.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      uf = jsonMap['uf'];
      cidade = jsonMap['cidade'];      
    } catch (e) {
      id = '';
      uf = '';
      cidade = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}
