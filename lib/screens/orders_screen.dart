import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/orders_providers.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.black,
      body: ordersProvider.orders.isEmpty
          ? _buildEmptyOrders()
          : ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: ordersProvider.orders.length,
        itemBuilder: (ctx, i) {
          final order = ordersProvider.orders[i];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildEmptyOrders() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/empty_orders.json', // ✅ Add an animation file
            width: 200,
            height: 200,
            repeat: true,
          ),
          SizedBox(height: 10),
          Text(
            "No orders placed yet.",
            style: TextStyle(fontSize: 18, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: 1.0,
        child: Card(
          color: Colors.grey[900], // ✅ Dark theme card
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
          child: ListTile(
            contentPadding: EdgeInsets.all(12),
            leading: CircleAvatar(
              backgroundColor: Colors.tealAccent,
              child: Icon(Icons.shopping_bag, color: Colors.black),
            ),
            title: Text(
              'Order #${order['orderId']}',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            subtitle: Text(
              'Total: \$${order['totalPrice']}',
              style: TextStyle(color: Colors.tealAccent),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _getStatusColor(order['status']),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                order['status'],
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () {
              // TODO: Navigate to order details if needed
            },
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.greenAccent;
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.blueGrey;
    }
  }
}
