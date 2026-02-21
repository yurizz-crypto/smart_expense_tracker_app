import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';

class ExpenseViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of expenses for real-time updates
  Stream<List<Expense>> get expensesStream {
    return _firestore.collection('expenses').orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        // Find the category object based on the name stored in Firestore
        final category = appCategories.firstWhere(
              (cat) => cat.name == data['category'],
          orElse: () => appCategories.last,
        );

        return Expense(
          id: doc.id,
          title: data['title'],
          amount: (data['amount'] as num).toDouble(),
          category: category,
          description: data['description'],
          date: (data['date'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  // Add Expense
  Future<void> addExpense(String title, double amount, Category category, String description, DateTime date) async {
    await _firestore.collection('expenses').add({
      'title': title,
      'amount': amount,
      'category': category.name,
      'description': description,
      'date': date,
    });
  }

  // Update Expense
  Future<void> updateExpense(String id, String title, double amount, Category category, String description, DateTime date) async {
    await _firestore.collection('expenses').doc(id).update({
      'title': title,
      'amount': amount,
      'category': category.name,
      'description': description,
      'date': date,
    });
  }

  // Delete Expense
  Future<void> deleteExpense(String id) async {
    await _firestore.collection('expenses').doc(id).delete();
  }
}