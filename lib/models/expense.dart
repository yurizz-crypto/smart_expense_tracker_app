import 'category.dart';

// Model for expense with the Category model.
class Expense {
  final String id;
  final String title;
  final String? description;
  final double amount;
  final Category category;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    this.description,
    required this.amount,
    required this.category,
    required this.date,
  });
}