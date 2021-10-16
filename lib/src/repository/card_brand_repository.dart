import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/card_brand.dart';

Future<Stream<CardBrand>> getMarketBrands(String id) async {
  Uri uri = Helper.getUri('api/markets/brands/$id');
  Map<String, dynamic> _queryParams = {};
  uri = uri.replace(queryParameters: _queryParams);

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return CardBrand.fromJSON(data);
  });
}
