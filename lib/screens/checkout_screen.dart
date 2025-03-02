import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.tealAccent,
      ),
      backgroundColor: Colors.black,
      body: cartProvider.cartItems.isEmpty
          ? _buildEmptyCheckout()
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.cartItems[index];
                return _buildCheckoutItem(cartItem);
              },
            ),
          ),
          _buildTotalSection(cartProvider, context),
        ],
      ),
    );
  }

  Widget _buildEmptyCheckout() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_shopping_cart, color: Colors.redAccent, size: 100),
          SizedBox(height: 10),
          Text("Your cart is empty.", style: TextStyle(color: Colors.white54, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildCheckoutItem(cartItem) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      shadowColor: Colors.tealAccent,
      child: ListTile(
        leading: _buildItemImage(cartItem.imageUrl),
        title: Text(cartItem.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text("\$${cartItem.price.toStringAsFixed(2)} x ${cartItem.quantity}",
            style: TextStyle(color: Colors.tealAccent)),
      ),
    );
  }

  Widget _buildItemImage(String imageUrl) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : AssetImage('assets/images/placeholder.png') as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTotalSection(CartProvider cartProvider, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 15)],
      ),
      child: Column(
        children: [
          Text(
            "Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (cartProvider.cartItems.isNotEmpty) {
                double totalAmount = cartProvider.totalPrice;
                cartProvider.clearCart();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderConfirmationScreen(totalAmount: totalAmount),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text("Confirm Order", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
