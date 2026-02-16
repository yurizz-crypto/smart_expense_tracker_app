import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final Color color;

  const Category({
    required this.name,
    required this.icon,
    required this.color,
  });
}

const List<Category> appCategories = [
  Category(name: 'Food', icon: Icons.restaurant, color: Colors.orange),
  Category(name: 'Transport', icon: Icons.directions_car, color: Colors.blue),
  Category(name: 'Bills', icon: Icons.receipt_long, color: Colors.red),
  Category(name: 'Entertainment', icon: Icons.movie, color: Colors.purple),
  Category(name: 'Shopping', icon: Icons.shopping_bag, color: Colors.green),
  Category(name: 'Others', icon: Icons.category, color: Colors.blueGrey),
];