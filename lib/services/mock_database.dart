import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/equipment.dart';
import '../models/transaction.dart';

class MockDatabase extends ChangeNotifier {
  final List<Equipment> _equipmentList = [];
  final Map<String, int> _cart = {}; // Equipment ID -> Quantity
  final List<Transaction> _transactionHistory = [];

  List<Equipment> get equipmentList => List.unmodifiable(_equipmentList);
  Map<String, int> get cart => Map.unmodifiable(_cart);
  List<Transaction> get transactionHistory => List.unmodifiable(_transactionHistory);

  MockDatabase() {
    _initMockData();
  }

  void _initMockData() {
    final uuid = const Uuid();
    _equipmentList.addAll([
      Equipment(
        id: uuid.v4(),
        name: 'Resonator Blade',
        type: 'Weapon',
        description: 'A standard-issue resonator blade for frontline combat.',
        stock: 15,
        image: 'https://placeholder.com/blade',
        price: 250.0,
      ),
      Equipment(
        id: uuid.v4(),
        name: 'Terminal Supply Pack',
        type: 'Consumable',
        description: 'Essential supplies for long expeditions.',
        stock: 50,
        image: 'https://placeholder.com/pack',
        price: 45.0,
      ),
      Equipment(
        id: uuid.v4(),
        name: 'Echo Core',
        type: 'Material',
        description: 'A high-energy core used for equipment upgrades.',
        stock: 5,
        image: 'https://placeholder.com/core',
        price: 1200.0,
      ),
    ]);
    notifyListeners();
  }

  // Admin CRUD
  void addEquipment(Equipment equipment) {
    _equipmentList.add(equipment);
    notifyListeners();
  }

  void updateEquipment(Equipment updatedEquipment) {
    final index = _equipmentList.indexWhere((e) => e.id == updatedEquipment.id);
    if (index != -1) {
      _equipmentList[index] = updatedEquipment;
      notifyListeners();
    }
  }

  void deleteEquipment(String id) {
    _equipmentList.removeWhere((e) => e.id == id);
    _cart.remove(id);
    notifyListeners();
  }

  // User Cart Actions
  void addToCart(String equipmentId) {
    final equipment = _equipmentList.firstWhere((e) => e.id == equipmentId);
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

  void checkout() {
    final List<TransactionItem> items = [];
    double total = 0;

    for (var entry in _cart.entries) {
      final index = _equipmentList.indexWhere((e) => e.id == entry.key);
      if (index != -1) {
        final equipment = _equipmentList[index];
        _equipmentList[index] = equipment.copyWith(
          stock: equipment.stock - entry.value,
        );
        items.add(TransactionItem(
          equipmentName: equipment.name,
          quantity: entry.value,
          priceAtTime: equipment.price,
        ));
        total += equipment.price * entry.value;
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
    }

    _cart.clear();
    notifyListeners();
  }

  double get totalCartPrice {
    double total = 0;
    _cart.forEach((id, qty) {
      final equipment = _equipmentList.firstWhere((e) => e.id == id);
      total += equipment.price * qty;
    });
    return total;
  }
}
