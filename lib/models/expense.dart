import 'category.dart';

// This model handles all the specific details for an individual transaction, linking it to a category.
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