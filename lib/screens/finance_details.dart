import 'package:finance_app/models/finance_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/finance_provider.dart';

class FinanceDetails extends ConsumerStatefulWidget {
  final Finance finance;

  const FinanceDetails({super.key, required this.finance});

  @override
  ConsumerState<FinanceDetails> createState() => _FinanceDetailsState();
}

class _FinanceDetailsState extends ConsumerState<FinanceDetails> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController amountController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.finance.title);
    amountController =
        TextEditingController(text: widget.finance.amount.toString());
    categoryController = TextEditingController(text: widget.finance.category);
  }

  void _updateFinance() {
    if (_formKey.currentState!.validate()) {
      final updatedFinance = widget.finance.copyWith(
        title: titleController.text,
        amount: double.tryParse(amountController.text) ?? widget.finance.amount,
        category: categoryController.text,
      );
      ref.read(financeProvider.notifier).updateFinance(updatedFinance);

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    amountController.dispose();
    categoryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'FIN',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 28,
              ),
            ),
            Text(
              'APP',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category cannot be empty';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Amount cannot be empty';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: _updateFinance,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
