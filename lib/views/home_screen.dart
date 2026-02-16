import 'package:flutter/material.dart';
import 'expense.dart';
import 'add_expense.dart';

class SmartTrackerHome extends StatefulWidget {
  const SmartTrackerHome({super.key});

  @override
  State<SmartTrackerHome> createState() => _SmartTrackerHomeState();
}

class _SmartTrackerHomeState extends State<SmartTrackerHome> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [ExpenseListView(), AddExpenseView(expenseToEdit: null,)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Tracker'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add'),
        ],
      ),
    );
  }
}
