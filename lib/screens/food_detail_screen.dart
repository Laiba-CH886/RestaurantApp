import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';

class FoodDetailScreen extends StatelessWidget {
  final FoodItem foodItem;

  FoodDetailScreen({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // Debugging: Check if imagePath is null or incorrect
    print("Food Item Image Path: ${foodItem.imagePath}");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Image (Handles both assets and network images)
          Positioned.fill(
            child: _buildImage(foodItem.imagePath),
          ),
          // Gradient Overlay for better readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          // Content Section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildContent(cartProvider, context),
          ),
        ],
      ),
    );
  }

  /// Handles both asset images and network images
  Widget _buildImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return _errorImage();
    } else if (imagePath.startsWith("http")) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _errorImage(),
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _errorImage(),
      );
    }
  }

  /// Default error image when the actual image fails to load
  Widget _errorImage() {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: 80,
          color: Colors.white54,
        ),
      ),
    );
  }

  /// UI Content for Food Item Details
  Widget _buildContent(CartProvider cartProvider, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Ensures content doesn't take extra space
        children: [
          Text(
            foodItem.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "\$${foodItem.price.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.tealAccent,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Text(
            foodItem.description,
            style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.category, color: Colors.white54),
              SizedBox(width: 5),
              Text("Category: ${foodItem.category}",
                  style: TextStyle(color: Colors.white54)),
            ],
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              cartProvider.addItem(foodItem);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${foodItem.name} added to Cart!"),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(
              "Add to Cart",
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
