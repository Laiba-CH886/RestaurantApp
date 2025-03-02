// lib/widgets/custom_button.dart

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double width;
  final double height;

  CustomButton({
    required this.label,
    required this.onPressed,
    this.color = Colors.blue,  // Default button color is blue
    this.textColor = Colors.white,  // Default text color is white
    this.width = double.infinity,  // Default width is set to infinity (full width)
    this.height = 50.0,  // Default height is 50px
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,  // Width of the button
      height: height,  // Height of the button
      child: ElevatedButton(
        onPressed: onPressed,  // The function to call when the button is pressed
        style: ElevatedButton.styleFrom(
          backgroundColor: color,  // Button color (use backgroundColor instead of primary)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),  // Rounded corners for the button
          ),
        ),
        child: Text(
          label,  // Text displayed on the button
          style: TextStyle(
            color: textColor,  // Color of the text on the button
            fontSize: 16.0,  // Text font size
          ),
        ),
      ),
    );
  }
}
