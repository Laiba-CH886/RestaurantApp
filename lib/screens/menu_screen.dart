import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import 'food_detail_screen.dart';
import '../models/food_item.dart';

class MenuScreen extends StatelessWidget {
  final String selectedCategory;

  MenuScreen({required this.selectedCategory});

  // ✅ Menu items categorized properly
  final List<Map<String, dynamic>> menuItems = [
    // ⭐ Appetizers
    {"name": "Spring Rolls", "category": "Appetizers", "price": 5.99, "image": "assets/image/spring rolls.jpeg"},
    {"name": "Mozzarella Sticks", "category": "Appetizers", "price": 6.49, "image": "assets/image/Mozzarella Sticks.jpeg"},
    {"name": "Chicken Wings", "category": "Appetizers", "price": 7.99, "image": "assets/image/chicken wings.jpeg"},

    // ⭐ Main Courses
    {"name": "Biryani", "category": "Main Courses", "price": 16.99, "image": "assets/image/biryani.jpeg"},
    {"name": "Karahi Chicken", "category": "Main Courses", "price": 17.49, "image": "assets/image/chicken karahi.jpeg"},
    {"name": "Nihari", "category": "Main Courses", "price": 18.99, "image": "assets/image/nihari.jpeg"},
    {"name": "Beef Steaks", "category": "Main Courses", "price": 22.99, "image": "assets/image/beef steak.jpeg"},

    // ⭐ Desserts
    {"name": "Chocolate Cake", "category": "Desserts", "price": 4.99, "image": "assets/image/chocolate cake.jpeg"},
    {"name": "Cheesecake", "category": "Desserts", "price": 5.99, "image": "assets/image/cheese cake.jpeg"},
    {"name": "Brownie Sundae", "category": "Desserts", "price": 6.99, "image": "assets/image/brownie sundae.jpeg"},
    {"name": "Apple Pie", "category": "Desserts", "price": 5.49, "image": "assets/image/apple pie.jpeg"},

    // ⭐ Drinks
    {"name": "Orange Juice", "category": "Drinks", "price": 3.99, "image": "assets/image/orange juice.jpeg"},
    {"name": "Lemonade", "category": "Drinks", "price": 3.49, "image": "assets/image/lemonade.jpeg"},
    {"name": "Iced Coffee", "category": "Drinks", "price": 4.99, "image": "assets/image/iced coffee.jpeg"},
    {"name": "Chocolate Shake", "category": "Drinks", "price": 5.49, "image": "assets/image/chocholate shake.jpg"},

    // ⭐ Specials (Signature Dishes)
    {"name": "Seekh Kabab", "category": "Specials", "price": 14.99, "image": "assets/image/Kabab.jpeg"},
    {"name": "Haleem", "category": "Specials", "price": 15.99, "image": "assets/image/Haleem.jpeg"},

    // ⭐ Sides
    {"name": "Garlic Breadsticks", "category": "Sides", "price": 5.49, "image": "assets/image/garlic breadsticks.jpeg"},
    {"name": "Fries", "category": "Sides", "price": 4.99, "image": "assets/image/fries.jpeg"},
    {"name": "Mashed Potatoes", "category": "Sides", "price": 4.49, "image": "assets/image/mashed potatoes.jpeg"},
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ Filter menu items by selected category
    List<Map<String, dynamic>> filteredItems =
    menuItems.where((item) => item["category"] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: filteredItems.isEmpty
            ? Center(
          child: Text(
            "No items available in this category.",
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
        )
            : ListView.builder(
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];

            return GestureDetector(
              onTap: () {
                try {
                  FoodItem foodItem = FoodItem(
                    id: item["name"],
                    name: item["name"],
                    description:
                    "${item["name"]} - Delicious ${item["category"]}",
                    price: item["price"],
                    imageUrl: item["image"],
                    category: item["category"],
                  );
                  print("Navigating with image URL: ${foodItem.imageUrl}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FoodDetailScreen(foodItem: foodItem),
                    ),
                  );
                } catch (e) {
                  debugPrint(
                      "Error navigating to FoodDetailScreen: $e");
                }
              },
              child: Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      child: Image.asset(
                        item["image"],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _placeholderImage();
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["name"],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "\$${item["price"].toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white54),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ✅ Placeholder Image Widget
  Widget _placeholderImage() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey,
      child: Icon(Icons.image_not_supported, color: Colors.white),
    );
  }

  // ✅ AppBar with Cart Button
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black87,
      elevation: 2,
      title: Text(
        "$selectedCategory Menu",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      actions: [
        Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            int cartCount = cartProvider.itemCount; // ✅ Ensure itemCount exists
            return Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()),
                    );
                  },
                ),
                if (cartCount > 0)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$cartCount',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
