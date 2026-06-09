import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wuwares/models/transaction.dart';
import 'package:wuwares/services/cart_service.dart';
import 'package:wuwares/services/db_service.dart';
import 'package:wuwares/services/transaction_service.dart';
import '../../services/mock_database.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = context.watch<DbService>();
    final usercart = context.watch<ShoppingCartService>();
    final cartItems = usercart.cart.entries.toList();
    final usertransaction = context.watch<TransactionService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final entry = cartItems[index];
                      final equipment = db.equipmentList.firstWhere((e) => e.id == entry.key);
                      return ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image),
                        ),
                        title: Text(equipment.name),
                        subtitle: Text('\$${equipment.price} x ${entry.value}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => db.reduceStock(equipment.id, 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => usercart.addToCart(equipment.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${usercart.totalCartPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF39C12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            usertransaction.checkout();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Purchase successful!')),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
