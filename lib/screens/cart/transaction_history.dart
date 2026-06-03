import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/mock_database.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.watch<MockDatabase>();
    final history = db.transactionHistory;

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction History')),
      body: history.isEmpty
          ? const Center(child: Text('No transactions yet'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final tx = history[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    title: Text('Order #${tx.id.substring(0, 8)}'),
                    subtitle: Text(
                      '${DateFormat('MMM dd, yyyy HH:mm').format(tx.date)} - Total: \$${tx.totalAmount.toStringAsFixed(2)}',
                    ),
                    children: tx.items.map((item) {
                      return ListTile(
                        title: Text(item.equipmentName),
                        subtitle: Text('Qty: ${item.quantity}'),
                        trailing: Text('\$${(item.priceAtTime * item.quantity).toStringAsFixed(2)}'),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
