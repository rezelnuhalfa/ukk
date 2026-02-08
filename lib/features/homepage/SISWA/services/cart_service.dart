import 'package:flutter_application_1/features/homepage/SISWA/models/menumodel.dart';
import '../models/cart_item_model.dart';

class CartService {
  static List<CartItem> items = [];

  static void add(MenuModel menu) {
    final index = items.indexWhere((e) => e.menu.idMenu == menu.idMenu);

    if (index >= 0) {
      items[index].qty++;
    } else {
      items.add(CartItem(menu: menu));
    }
  }

  static void clear() {
    items.clear();
  }

  static bool isEmpty() {
    return items.isEmpty;
  }
}
