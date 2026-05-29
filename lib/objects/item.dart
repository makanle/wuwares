import 'dart:convert';

class Item{
  final int id;
  final int price;
  final int stock;
  final String name;
  final String description;
  final String imageurl;

  Item({
    required this.id,
    required this.price,
    required this.stock,
    required this.name,
    required this.description,
    required this.imageurl
  });
  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
      id: json['id'] as int,
      price: json['price'] as int,
      stock: json['stock'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      imageurl: json['imageurl'] as String
    );
  }
  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'price': price,
      'stock': stock,
      'name': name,
      'description': description,
      'imageurl': imageurl
    };
  }
}

class ItemList{
  final List<Item> items;

  ItemList(
    this.items
  );

  static ItemList fromJson(List<Object?> parsedJson){
    final List<Item> result = <Item>[];
    if(json case[
      Iterable id,
      Iterable price,
      Iterable stock,
      Iterable name,
      Iterable description,
      Iterable imageurl
    ]){
      final List idList = id.toList();
      final List priceList = price.toList();
      final List stockList = stock.toList();
      final List nameList = name.toList();
      final List descList = description.toList();
      final List imageurlList = imageurl.toList();
      for(int i = 0 ; i < id.length ; i++){
        result.add(Item(id: idList[i], price: priceList[i], stock: stockList[i], name: nameList[i], description: descList[i], imageurl: imageurlList[i]));
      }
      return ItemList(result);  
    }
    throw FormatException('result cannot be deserialized, json=$json');
  }
  // factory ItemList.fromJson(List<dynamic> parsedJson){
  //   // var maplist = List<Map<String, dynamic>>.from(json['']);
  //   final itemsdata = parsedJson[] as List<dynamic>?;  
  //   // final items = parsedJson.map((i) => Item.fromJson(i)).toList();
  // }
}
