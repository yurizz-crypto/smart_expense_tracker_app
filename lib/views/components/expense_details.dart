import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/expense.dart';
import '../add_expense.dart';

class ExpenseDetailSheet extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailSheet({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              CircleAvatar(
                backgroundColor: expense.category.color.withAlpha(50),
                child: Icon(expense.category.icon, color: expense.category.color),
              ),

              IconButton(
                icon: const Icon(Icons.edit_note, size: 30),
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => AddExpenseView(expenseToEdit: expense),
                  );
                },
              ),

            ],
          ),
          const SizedBox(height: 16),

          Text(expense.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

          Text("${expense.category.name} • ${DateFormat.yMMMd().format(expense.date)}",
              style: const TextStyle(color: Colors.grey)),

          const Divider(height: 32),

          const Text("Amount", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          Text("\$${expense.amount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20)),

          const SizedBox(height: 16),

          const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          Text(
            expense.description?.isNotEmpty == true ? expense.description! : "No description provided.",
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}