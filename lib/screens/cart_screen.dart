import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        elevation: 4,
      ),
      body: cartProvider.cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.cartItems[index];
                return _buildCartItem(cartItem, cartProvider);
              },
            ),
          ),
          _buildTotalSection(cartProvider, context),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_shopping_cart, color: Colors.redAccent, size: 100),
          SizedBox(height: 10),
          Text("Your cart is empty", style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem cartItem, CartProvider cartProvider) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      color: Colors.white,
      child: ListTile(
        leading: _buildItemImage(cartItem.imageUrl),
        title: Text(cartItem.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        subtitle: Text("\$${cartItem.price.toStringAsFixed(2)}", style: TextStyle(color: Colors.indigo)),
        trailing: _buildItemActions(cartItem, cartProvider),
      ),
    );
  }

  Widget _buildItemImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl ?? 'assets/images/placeholder.png',
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildItemActions(CartItem cartItem, CartProvider cartProvider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle, color: Colors.redAccent),
          onPressed: () => cartProvider.removeItem(cartItem.id),
        ),
        Text(cartItem.quantity.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        IconButton(
          icon: Icon(Icons.add_circle, color: Colors.green),
          onPressed: () => cartProvider.addItem(cartItem.food),
        ),
      ],
    );
  }

  Widget _buildTotalSection(CartProvider cartProvider, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent),
            onPressed: () {
              if (cartProvider.cartItems.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckoutScreen()),
                );
              }
            },
            child: Text("Checkout", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
