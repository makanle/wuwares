import 'dart:convert';

import 'package:http/http.dart';
import 'package:wuwares/models/equipment.dart';
import 'package:wuwares/models/item.dart';

Future<dynamic> getItems() async {
  String urlPath = "https://10.0.2.2:3000/catalog/";
  var response = await get(Uri.parse(urlPath));
  if(response.statusCode == 200){
    return EquipmentList.fromJson(jsonDecode(response.body));
  }else{
    throw Exception('failed to load item');
  }
}

Future<bool> addItem(Equipment equipment) async{
  String urlPath = "https://10.0.2.2:3000/catalog/add";
  var response = await post(
    Uri.parse(urlPath), 
    headers: {"Content-Type": 'application/json '},
    body: jsonEncode({equipment.toJson()}),
  );
  if(response.statusCode == 200){
    return true;
  } else{
    return false;
  }
}

Future<bool> deleteItem(String id) async{
  String urlPath = 'https://10.0.2.2/catalog/remove/$id';
  var response = await delete(
    Uri.parse(urlPath),
    headers: {"Content-Type": "application/json"},
  );
  if(response.statusCode == 200){
    return true;
  }else {
    return false;
  }
}

Future<bool> editItem(Equipment item) async{
  String urlPath = 'https://10.0.2.2/catalog/remove/${item.id}';
  var response = await put(
    Uri.parse(urlPath),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(item.toJson()),
  );
  if(response.statusCode == 200){
    return true;
  }else {
    return false;
  }
}
