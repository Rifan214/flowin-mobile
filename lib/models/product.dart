class Product {
  final String name;
  final String image;
  final String tag;
  final String type;
  final int liters;
  final int price;
  final String description;

  const Product({
    required this.name,
    required this.image,
    required this.tag,
    required this.type,
    required this.liters,
    required this.price,
    required this.description,
  });

  Product copyWith({
    String? name,
    String? image,
    String? tag,
    String? type,
    int? liters,
    int? price,
    String? description,
  }) {
    return Product(
      name: name ?? this.name,
      image: image ?? this.image,
      tag: tag ?? this.tag,
      type: type ?? this.type,
      liters: liters ?? this.liters,
      price: price ?? this.price,
      description: description ?? this.description,
    );
  }
}
