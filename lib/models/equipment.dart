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
