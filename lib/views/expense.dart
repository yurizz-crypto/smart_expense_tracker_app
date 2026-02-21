import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import './components/expense_details.dart';
import '../view_models/expense_viewmodel.dart';
import '../models/category.dart';
import '../models/expense.dart';

// Main screen of the application.
class ExpenseListView extends StatefulWidget {
  const ExpenseListView({super.key});

  @override
  State<ExpenseListView> createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {
  Category? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ExpenseViewModel>(context);

    // Check if there's a selected category.
    final filteredExpenses = _selectedFilter == null
        ? vm.expenses
        : vm.expenses.where((e) => e.category.name == _selectedFilter!.name).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Smart Tracker")),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text("Total Expenses", style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 10),
                Text(
                  "₱ ${vm.totalExpenses.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          _buildFilterBar(),

          // Checks if the list from the provider is empty.
          // If not shows the contents.
          Expanded(
            child: filteredExpenses.isEmpty
                ? _buildEmptyState()
                : _showContent(context, filteredExpenses, vm),
          ),
        ],
      ),
    );
  }

  // Changes the selected category on tap.
  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          FilterChip(
            label: const Text("All"),
            selected: _selectedFilter == null,
            onSelected: (_) => setState(() => _selectedFilter = null),
          ),
          const SizedBox(width: 8),
          ...appCategories.map((category) => Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              avatar: Icon(category.icon,
                  size: 16, color: _selectedFilter == category ? Colors.white : category.color),
              label: Text(category.name),
              selected: _selectedFilter == category,
              selectedColor: category.color,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: _selectedFilter == category ? Colors.white : Colors.black,
              ),
              onSelected: (selected) {
                setState(() => _selectedFilter = selected ? category : null);
              },
            ),
          )),
        ],
      ),
    );
  }

  // To tell the user if the list is empty or a particular category is empty.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.filter_list_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _selectedFilter == null ? "No expenses added yet!" : "No expenses in this category",
            style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Widget to show all the expenses with the selected category filtered or not as parameter.
  Widget _showContent(BuildContext context, List<Expense> expenses, ExpenseViewModel vm) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, i) {
        final expense = expenses[i];
        return ListTile(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              builder: (ctx) => ExpenseDetailSheet(expense: expense),
            );
          },
          leading: CircleAvatar(
            backgroundColor: expense.category.color.withAlpha(50),
            child: Icon(expense.category.icon, color: expense.category.color),
          ),
          title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          // Updated subtitle to use DateFormat
          subtitle: Text("${expense.category.name} • ${DateFormat.yMMMd().format(expense.date)}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Updated to Peso Sign
              Text("₱ ${expense.amount.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _confirmDelete(context, vm, expense.id),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show a dialog to confirm if the user is actually going to delete a certain expense.
  void _confirmDelete(BuildContext context, ExpenseViewModel vm, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to remove this expense?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              vm.deleteExpense(id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Expense deleted")),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}