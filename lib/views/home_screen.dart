import 'package:flutter/material.dart';
import 'expense.dart';
import 'add_expense.dart';

// This root widget manages the bottom navigation and controls which screen is currently visible.
class SmartTrackerHome extends StatefulWidget {
  const SmartTrackerHome({super.key});

  @override
  State<SmartTrackerHome> createState() => _SmartTrackerHomeState();
}

class _SmartTrackerHomeState extends State<SmartTrackerHome> {
  // This index tracks the active tab to ensure the correct page is displayed.
  int _selectedIndex = 0;

  // This list holds the main views of the application for quick switching between the list and the input form.
  final List<Widget> _pages = [
    const ExpenseListView(),
    const AddExpenseView(expenseToEdit: null),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body updates dynamically based on the current selection in the navigation bar.
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        // This callback updates the state so the UI reflects the user's choice immediately.
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Tracker'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add'),
        ],
      ),
    );
  }
}