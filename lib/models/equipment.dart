class Equipment {
  final String id;
  final String name;
  final String type;
  final String description;
  final int stock;
  final String image;
  final double price;

  Equipment({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.stock,
    required this.image,
    required this.price,
  });
  factory Equipment.fromJson(Map<String, dynamic> json){
    return Equipment(
      id: json['id'] as String,
      price: json['price'] as double,
      stock: json['stock'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      image: json['imageurl'] as String
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
      'image': image,
    };
  }
  Equipment copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    int? stock,
    String? image,
    double? price,
  }) {
    return Equipment(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      image: image ?? this.image,
      price: price ?? this.price,
    );
  }
}

class EquipmentList{
  final List<Equipment> equipments;

  EquipmentList(
    this.equipments
  );

  List<Equipment> get equipmentList => List.unmodifiable(equipments);

  factory EquipmentList.fromJson(List<dynamic> parsedJson){
    var temp = parsedJson.map((itemJson) => Equipment.fromJson(itemJson as Map<String, dynamic>));
    final List<Equipment> result = temp.toList();
    
    return EquipmentList(result);
  }
}
