import 'package:flutter/foundation.dart';
import 'package:wuwares/services/db_service.dart';

class ShoppingCartService extends ChangeNotifier {
  final DbService localdb;
  final Map<String, int> _cart = {}; // Equipment ID -> Quantity

  ShoppingCartService(this.localdb);

  Map<String, int> get cart => Map.unmodifiable(_cart);

  void addToCart(String equipmentId) {
    final equipment = localdb.equipmentList.firstWhere((e) => e.id == equipmentId);
    final currentInCart = _cart[equipmentId] ?? 0;

    if (equipment.stock > currentInCart) {
      _cart[equipmentId] = currentInCart + 1;
      notifyListeners();
    }
  }

  void removeFromCart(String equipmentId) {
    if (_cart.containsKey(equipmentId)) {
      if (_cart[equipmentId]! > 1) {
        _cart[equipmentId] = _cart[equipmentId]! - 1;
      } else {
        _cart.remove(equipmentId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  double get totalCartPrice {
    double total = 0;
    _cart.forEach((id, qty) {
      final equipment = localdb.equipmentList.firstWhere((e) => e.id == id);
      total += equipment.price * qty;
    });
    return total;
  }
}