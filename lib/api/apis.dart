import 'dart:convert';

import 'package:http/http.dart';
import 'package:wuwares/objects/item.dart';


Future<dynamic> getItems() async {
  String urlPath = "localhost:3000/catalog/";
  var response = await get(Uri.parse(urlPath));
  if(response.statusCode == 200){
    return Item.fromJson(jsonDecode(response.body));
  }else{
    throw Exception('failed to load item');
  }

}