class Item{
  final int id;
  final double price;
  final int stock;
  final String name;
  final String type;
  final String description;
  final String imageurl;

  Item({
    required this.id,
    required this.price,
    required this.stock,
    required this.name,
    required this.type,
    required this.description,
    required this.imageurl
  });
  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
      id: json['id'] as int,
      price: json['price'] as double,
      stock: json['stock'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
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
      'type': type,
      'description': description,
      'imageurl': imageurl,
    };
  }
}

class ItemList{
  final List<Item> items;

  ItemList(
    this.items
  );

  factory ItemList.fromJson(List<dynamic> parsedJson){
    var temp = parsedJson.map((itemJson) => Item.fromJson(itemJson as Map<String, dynamic>));
    final List<Item> result = temp.toList();
    
    return ItemList(result);
  }
}
