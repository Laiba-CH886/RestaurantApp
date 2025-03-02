import 'cart_item.dart';

class FoodItem {
  final String id; // Keeping as String to match Firestore
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String? imagePath;
  final int quantity;
  final String category;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.imagePath,
    this.quantity = 1,
    required this.category,
  });

  // Convert FoodItem to CartItem safely
  CartItem toCartItem(int quantity) {
    return CartItem(
      id: id, // Safe conversion
      name: name,
      imageUrl: imageUrl ?? '',
      price: price,
      quantity: quantity,
      food: this,
    );
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed',
      description: json['description'] as String? ?? 'No description available',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String?,
      imagePath: json['imagePath'] as String?,
      quantity: json['quantity'] as int? ?? 1,
      category: json['category'] as String? ?? 'Uncategorized',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'quantity': quantity,
      'category': category,
    };
  }
}
