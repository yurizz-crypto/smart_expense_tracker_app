import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';

// This class manages the communication between the Firestore database and the UI, handling all data logic for expenses.
class ExpenseViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // This stream listens for real-time database changes and converts raw Firestore documents into a list of Expense objects.
  Stream<List<Expense>> get expensesStream {
    return _firestore.collection('expenses').orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        // The logic here matches the category name saved in the database with the corresponding local Category object.
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

  // This function pushes a new expense entry into the Firestore collection with the provided details.
  Future<void> addExpense(String title, double amount, Category category, String description, DateTime date) async {
    await _firestore.collection('expenses').add({
      'title': title,
      'amount': amount,
      'category': category.name,
      'description': description,
      'date': date,
    });
  }

  // This method locates a specific document by its unique ID and updates its fields with new user input.
  Future<void> updateExpense(String id, String title, double amount, Category category, String description, DateTime date) async {
    await _firestore.collection('expenses').doc(id).update({
      'title': title,
      'amount': amount,
      'category': category.name,
      'description': description,
      'date': date,
    });
  }

  // This method permanently removes an expense record from the cloud storage based on its ID.
  Future<void> deleteExpense(String id) async {
    await _firestore.collection('expenses').doc(id).delete();
  }
}