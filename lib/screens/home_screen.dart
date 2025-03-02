import 'package:flutter/material.dart';
import 'dart:ui';
import 'menu_screen.dart'; // Import the MenuScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _scaleAnimations;
  bool _animationsInitialized = false;

  final List<String> categoryNames = [
    "Appetizers",
    "Main Courses",
    "Desserts",
    "Drinks",
    "Specials",
    "Sides",
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );

    _scaleAnimations = List.generate(
      categoryNames.length,
          (index) => Tween<double>(begin: 1.0, end: 1.08).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animationsInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToMenu(String category) {
    _animationController.forward().then((_) {
      _animationController.reverse();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuScreen(selectedCategory: category),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Makes the background go behind AppBar
      appBar: AppBar(
        title: Text(
          "KKG Restaurant",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white, // White color for better visibility
            shadows: [
              Shadow(
                blurRadius: 5,
                color: Colors.black45,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildBackgroundImage(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryTitle(),
                _buildCategoryGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/image/home background.jpeg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3), // Soft overlay for readability
            BlendMode.darken,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0, bottom: 16.0),
      child: Text(
        "CATEGORIES",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Expanded(
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.5,
        ),
        itemCount: categoryNames.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _navigateToMenu(categoryNames[index]),
            child: _animationsInitialized
                ? ScaleTransition(
              scale: _scaleAnimations[index],
              child: _buildCategoryTile(categoryNames[index]),
            )
                : _buildCategoryTile(categoryNames[index]),
          );
        },
      ),
    );
  }

  Widget _buildCategoryTile(String categoryName) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Glassmorphic effect
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15), // Transparent white glass effect
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              categoryName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    blurRadius: 5,
                    color: Colors.black26,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
