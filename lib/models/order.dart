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
}