class Order {
  final String storeName;
  final String item;
  final String image;
  final int quantity;
  final int totalPrice;
  final String status;

  const Order({
    required this.storeName,
    required this.item,
    required this.image,
    required this.quantity,
    required this.totalPrice,
    required this.status,
  });

  Order copyWith({
    String? storeName,
    String? item,
    String? image,
    int? quantity,
    int? totalPrice,
    String? status,
  }) {
    return Order(
      storeName: storeName ?? this.storeName,
      item: item ?? this.item,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
    );
  }
}
