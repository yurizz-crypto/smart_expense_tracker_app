import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';

class ExpenseViewModel extends ChangeNotifier {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => [..._expenses];

  double get totalExpenses {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  void addExpense(String title, double amount, Category category, String description, DateTime date) {
    final newExpense = Expense(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      description: description,
      date: date,
      category: category,
    );

    _expenses.add(newExpense);
    notifyListeners();
  }

  void updateExpense(String id, String title, double amount, Category category, String description, DateTime date) {
    final index = _expenses.indexWhere((e) => e.id == id);

    if (index != -1) {
      _expenses[index] = Expense(
          id: id,
          title: title,
          amount: amount,
          category: category,
          description: description,
          date: date
      );
      notifyListeners();
    }
  }

  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}