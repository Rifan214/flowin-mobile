class CartItem {
  final String name;
  final String image;
  final String description;
  final double price;
  final int quantity;

  const CartItem({
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.quantity,
  });
}