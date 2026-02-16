import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/expense_viewmodel.dart';
import '../models/category.dart';
import '../models/expense.dart';

// Screen (stateful widget) for adding or editing an existing expense.
class AddExpenseView extends StatefulWidget {
  final Expense? expenseToEdit;

  const AddExpenseView({super.key, this.expenseToEdit});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Fields I needed to create a new expense.
    _titleController = TextEditingController(text: widget.expenseToEdit?.title ?? "");
    _amountController = TextEditingController(text: widget.expenseToEdit?.amount.toString() ?? "");
    _descriptionController = TextEditingController(text: widget.expenseToEdit?.description ?? "");
    _selectedCategory = widget.expenseToEdit?.category;
  }

  // Get the inputted data.
  void _submitData() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text) ?? 0;
    final description = _descriptionController.text;

    if (title.isEmpty || amount <= 0 || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid title, category, and amount")),
      );
      return;
    }

    final vm = Provider.of<ExpenseViewModel>(context, listen: false);

    // Check if editing or not.
    if (widget.expenseToEdit == null) {
      vm.addExpense(title, amount, _selectedCategory!, description);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Expense Added!")));
    } else {
      vm.updateExpense(
        widget.expenseToEdit!.id,
        title,
        amount,
        _selectedCategory!,
        description,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Expense Updated!")));
      Navigator.pop(context);
    }

    if (widget.expenseToEdit == null) {
      _titleController.clear();
      _amountController.clear();
      _descriptionController.clear();
      setState(() => _selectedCategory = null);
    }

    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // UI for adding/editing an expense.
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expenseToEdit != null;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        children: [
          Text(
              isEditing ? "Edit Expense" : "Add New Expense",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 5)
          ),
          const SizedBox(height: 15),

          DropdownButtonFormField<Category>(
            initialValue: _selectedCategory,
            decoration: InputDecoration(
              labelText: "Select Category",
              prefixIcon: const Icon(Icons.label_important_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: appCategories.map((category) {
              return DropdownMenuItem<Category>(
                value: category,
                child: Row(
                  children: [
                    Icon(category.icon, color: category.color, size: 20),
                    const SizedBox(width: 12),
                    Text(category.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) => setState(() => _selectedCategory = val),
          ),
          const SizedBox(height: 10),

          TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title")
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: "Amount"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),

          TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description (Optional)")
          ),
          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(isEditing ? "Save Changes" : "Add Expense"),
            ),
          ),
        ],
      ),
    );
  }
}