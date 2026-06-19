import '../models/order.dart';

const List<Order> dummyOrders = [
  Order(
    storeName: 'Tirta Sejuk Mandiri',
    item: 'Gallon Spring Water',
    image: 'assets/images/order_1.jpg',
    quantity: 2,
    totalPrice: 36000,
    status: 'In Progress',
  ),
  Order(
    storeName: 'Aqua Center Raya',
    item: 'Mineral Water Box',
    image: 'assets/images/order_2.jpg',
    quantity: 1,
    totalPrice: 45000,
    status: 'Completed',
  ),
  Order(
    storeName: 'Sumber Air Jernih',
    item: 'Gallon Refill',
    image: 'assets/images/order_3.jpg',
    quantity: 3,
    totalPrice: 54000,
    status: 'Completed',
  ),
  Order(
    storeName: 'Bening Abadi Store',
    item: '600ml Bottle Case',
    image: 'assets/images/order_4.jpg',
    quantity: 5,
    totalPrice: 120000,
    status: 'Completed',
  ),
];