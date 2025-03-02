import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';

class FoodCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: cartProvider.cartItems.isEmpty
          ? _buildEmptyCart()
          : _buildCartList(cartProvider),
      bottomNavigationBar: _buildBottomBar(cartProvider, context),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Text(
        "Your cart is empty.",
        style: TextStyle(color: Colors.white54, fontSize: 18),
      ),
    );
  }

  Widget _buildCartList(CartProvider cartProvider) {
    return ListView.builder(
      itemCount: cartProvider.cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = cartProvider.cartItems[index];

        return Card(
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: ListTile(
            leading: _buildItemImage(cartItem.imageUrl),
            title: Text(
              cartItem.name,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "\$${cartItem.price.toStringAsFixed(2)} x ${cartItem.quantity}",
              style: TextStyle(color: Colors.greenAccent),
            ),
            trailing: _buildItemActions(cartItem, cartProvider),
          ),
        );
      },
    );
  }

  Widget _buildItemImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl ?? "https://via.placeholder.com/80", // ✅ Fallback placeholder
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 80,
            height: 80,
            color: Colors.grey,
            child: Icon(Icons.broken_image, color: Colors.white),
          );
        },
      ),
    );
  }

  Widget _buildItemActions(CartItem cartItem, CartProvider cartProvider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove, color: Colors.redAccent),
          onPressed: () {
            cartProvider.removeItem(cartItem.id);
          },
        ),
        Text(
          "${cartItem.quantity}",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.greenAccent),
          onPressed: () {
            cartProvider.addItem(cartItem.toFoodItem());
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.white70),
          onPressed: () {
            cartProvider.removeItem(cartItem.id, removeAll: true);
          },
        ),
      ],
    );
  }

  Widget _buildBottomBar(CartProvider cartProvider, BuildContext context) {
    return cartProvider.cartItems.isEmpty
        ? SizedBox.shrink()
        : BottomAppBar(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Proceeding to Checkout")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text("Checkout", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Convert CartItem back to FoodItem
extension CartItemExtension on CartItem {
  FoodItem toFoodItem() {
    return FoodItem(
      id: id,
      name: name,
      description: "No description available",
      price: price,
      imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      category: "Miscellaneous",
    );
  }
}
