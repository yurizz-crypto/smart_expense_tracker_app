import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';

class ExpenseViewModel extends ChangeNotifier {
  final List<Expense> _expenses = [];

  // Get the list.
  List<Expense> get expenses => [..._expenses];

  // Calculate total expenses.
  double get totalExpenses {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  // Add new Expense instance.
  void addExpense(String title, double amount, Category category, String description) {
    final newExpense = Expense(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      description: description,
      date: DateTime.now(),
      category: category,
    );

    _expenses.add(newExpense);
    notifyListeners();
  }

  // Finds an existing expense by ID and replaces it with new values.
  void updateExpense(String id, String title, double amount, Category category, String description) {
    final index = _expenses.indexWhere((e) => e.id == id);

    // Creating a new expense instead of editing an existing expense in the list but keeps previous unchanged data.
    if (index != -1) {
      _expenses[index] = Expense(
        id: id,
        title: title,
        amount: amount,
        category: category,
        description: description,
        date: _expenses[index].date
      );
      notifyListeners();
    }
  }

  // Remove item from the list based on its ID.
  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}