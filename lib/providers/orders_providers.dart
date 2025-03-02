// lib/providers/orders_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';  // For encoding/decoding orders

class OrdersProvider with ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get orders => _orders;

  // Fetch saved orders
  Future<void> fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final orderData = prefs.getStringList('orders');

    if (orderData != null) {
      // Deserialize the saved orders from JSON format
      _orders = orderData
          .map((orderString) => jsonDecode(orderString) as Map<String, dynamic>)
          .toList();
      notifyListeners();
    }
  }

  // Save a new order
  Future<void> saveOrder(Map<String, dynamic> order) async {
    final prefs = await SharedPreferences.getInstance();

    // Add new order to the list
    _orders.add(order);

    // Serialize orders to a list of strings (JSON encoded)
    List<String> savedOrders = _orders
        .map((order) => jsonEncode(order))  // Convert order map to JSON string
        .toList();

    // Save the serialized orders list in SharedPreferences
    prefs.setStringList('orders', savedOrders);
    notifyListeners();
  }

  // Optionally, clear all orders (useful for debugging or testing)
  Future<void> clearOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('orders'); // Clear saved orders from SharedPreferences
    _orders.clear(); // Clear local list
    notifyListeners();
  }
}
