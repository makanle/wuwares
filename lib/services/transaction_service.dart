import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:wuwares/models/transaction.dart';
import 'package:wuwares/services/cart_service.dart';
import 'package:wuwares/services/db_service.dart';

class TransactionService extends ChangeNotifier {
  final DbService localdb;
  final ShoppingCartService _shoppingCartService;
  final List<Transaction> _transactionHistory = [];

  TransactionService(this.localdb, this._shoppingCartService);

  List<Transaction> get transactionHistory => List.unmodifiable(_transactionHistory);

  void checkout() {
    final cartItems = _shoppingCartService.cart;
    if (cartItems.isEmpty) return;

    final List<TransactionItem> items = [];
    double total = 0;

    for (var entry in cartItems.entries) {
      final equipmentId = entry.key;
      final quantity = entry.value;

      final index = localdb.equipmentList.indexWhere((e) => e.id == equipmentId);
      if (index != -1) {
        final equipment = localdb.equipmentList[index];
        
        // Deduct stock from Inventory
        localdb.reduceStock(equipmentId, quantity);

        // Record item details for the receipt
        items.add(TransactionItem(
          equipmentName: equipment.name,
          quantity: quantity,
          priceAtTime: equipment.price,
        ));
        total += equipment.price * quantity;
      }
    }

    if (items.isNotEmpty) {
      _transactionHistory.insert(
        0,
        Transaction(
          id: const Uuid().v4(),
          items: items,
          totalAmount: total,
          date: DateTime.now(),
        ),
      );
      notifyListeners();
    }

    // Reset the cart state post-checkout
    _shoppingCartService.clearCart();
  }
}