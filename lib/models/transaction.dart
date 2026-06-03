class Transaction {
  final String id;
  final List<TransactionItem> items;
  final double totalAmount;
  final DateTime date;

  Transaction({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
  });
}

class TransactionItem {
  final String equipmentName;
  final int quantity;
  final double priceAtTime;

  TransactionItem({
    required this.equipmentName,
    required this.quantity,
    required this.priceAtTime,
  });
}
