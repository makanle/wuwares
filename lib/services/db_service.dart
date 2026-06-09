import 'package:flutter/foundation.dart';
import 'package:wuwares/api/ItemApi.dart';
import '../models/equipment.dart';

class DbService extends ChangeNotifier {
  final List<Equipment> _equipmentList = [];

  List<Equipment> get equipmentList => List.unmodifiable(_equipmentList);

  void fetchItems(){
    EquipmentList temp = getItems() as EquipmentList;
    _equipmentList.setAll(0, temp.equipments);
  }

  // Admin CRUD
  void addEquipment(Equipment equipment) {
    addItem(equipment);
    fetchItems();
    notifyListeners();
  }

  void updateEquipment(Equipment updatedEquipment) {
    updateEquipment(updatedEquipment);
    fetchItems();
  }

  void deleteEquipment(String id) {
    deleteItem(id);
    fetchItems();
    notifyListeners();
  }
  void reduceStock(String equipmentId, int quantity) {
    final index = _equipmentList.indexWhere((e) => e.id == equipmentId);
    if (index != -1) {
      final equipment = _equipmentList[index];
      _equipmentList[index] = equipment.copyWith(
        stock: equipment.stock - quantity,
      );
      notifyListeners();
    }
  }
}
