import '../models/product.dart';

const List<Product> dummyProducts = [
  Product(
    name: 'Galon Aqua',
    image: 'assets/images/gallon_aqua.jpg',
    tag: 'BEST SELLER',
    type: 'Mineral',
    liters: 19,
    price: 69000,
    description:
    'Galon Aqua is our premium mineral water, rich in essential minerals for a refreshing taste.',
  ),
  Product(
    name: 'Vit Purified',
    image: 'assets/images/vit_purified.jpg',
    tag: 'ECO PACK',
    type: 'Distilled',
    liters: 19,
    price: 65000,
    description:
    'Vit Purified is our distilled water, perfect for those who prefer a clean, neutral taste.',
  ),
  Product(
    name: 'Pristine 8+',
    image: 'assets/images/pristine.jpg',
    tag: '',
    type: 'Alkaline',
    liters: 15,
    price: 82000,
    description:
    'Pristine 8+ is our premium alkaline water with a pH of 8.5, providing a refreshing taste and potential health benefits.',
  ),
  Product(
    name: 'Le Minerale',
    image: 'assets/images/le_minerale.jpg',
    tag: '',
    type: 'Mountain',
    liters: 15,
    price: 58000,
    description:
    'Our 19L Spring Water is captured at the source and undergoes a multi-stage filtration process while maintaining its natural mineral integrity.',
  ),
];