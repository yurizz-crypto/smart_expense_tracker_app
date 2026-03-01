import 'package:flutter/material.dart';

// This class acts like a blueprint to bundle a label, an icon, and a specific color for each expense.
class Category {
  final String name;
  final IconData icon;
  final Color color;

  // I use required parameters to ensure every category always has its unique details set.
  const Category({
    required this.name,
    required this.icon,
    required this.color,
  });
}

// This hardcoded list provides a quick way to load common spending categories into menus or filters.
const List<Category> appCategories = [
  Category(name: 'Food', icon: Icons.restaurant, color: Colors.orange),
  Category(name: 'Transport', icon: Icons.directions_car, color: Colors.blue),
  Category(name: 'Bills', icon: Icons.receipt_long, color: Colors.red),
  Category(name: 'Entertainment', icon: Icons.movie, color: Colors.purple),
  Category(name: 'Shopping', icon: Icons.shopping_bag, color: Colors.green),
  Category(name: 'Others', icon: Icons.category, color: Colors.blueGrey),
];