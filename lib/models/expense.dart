import 'category.dart';

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