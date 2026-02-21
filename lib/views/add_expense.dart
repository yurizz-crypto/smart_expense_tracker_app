import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../view_models/expense_viewmodel.dart';
import '../models/category.dart';
import '../models/expense.dart';

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
  late DateTime _selectedDate;
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expenseToEdit?.title ?? "");
    _amountController = TextEditingController(text: widget.expenseToEdit?.amount.toString() ?? "");
    _descriptionController = TextEditingController(text: widget.expenseToEdit?.description ?? "");
    _selectedDate = widget.expenseToEdit?.date ?? DateTime.now();
    _selectedCategory = widget.expenseToEdit?.category;
  }

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(), // Prevents picking future dates
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void _submitData() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText) ?? 0;
    final description = _descriptionController.text.trim();

    // Specific Error Handling
    if (title.isEmpty) {
      _showError("Title cannot be empty");
      return;
    }
    if (amountText.isEmpty) {
      _showError("Please enter an amount");
      return;
    }
    if (amount <= 0) {
      _showError("Amount must be greater than zero");
      return;
    }
    if (_selectedCategory == null) {
      _showError("Please select a category");
      return;
    }

    final vm = Provider.of<ExpenseViewModel>(context, listen: false);

    if (widget.expenseToEdit == null) {
      vm.addExpense(title, amount, _selectedCategory!, description, _selectedDate);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Expense Added!")));
    } else {
      vm.updateExpense(
        widget.expenseToEdit!.id,
        title,
        amount,
        _selectedCategory!,
        description,
        _selectedDate,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Expense Updated!")));
      Navigator.pop(context);
    }

    if (widget.expenseToEdit == null) {
      _titleController.clear();
      _amountController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedDate = DateTime.now();
      });
    }
    FocusScope.of(context).unfocus();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 6),
          ),
          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(child: Text("Date: ${DateFormat.yMMMd().format(_selectedDate)}")),
              TextButton(
                onPressed: _presentDatePicker,
                child: const Text("Choose Date", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),

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
            decoration: const InputDecoration(labelText: "Title"),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: "Amount", prefixText: "₱ "),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: "Description (Optional)"),
          ),
          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(isEditing ? "Save Changes" : "Add Expense"),
            ),
          ),
        ],
      ),
    );
  }
}