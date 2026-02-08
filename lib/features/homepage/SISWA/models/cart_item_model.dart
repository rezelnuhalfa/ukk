import '../models/menumodel.dart';

class CartItem {
  final MenuModel menu;
  int qty;

  CartItem({
    required this.menu,
    this.qty = 1,
  });
}
