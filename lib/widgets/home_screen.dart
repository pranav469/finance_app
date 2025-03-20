import 'package:finance_app/provider/finance_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/space.dart';
import '../models/finance_model.dart';
import 'date_picker.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String paymentStatus = 'Paid';
  DateTime? dueDate;

  String transactionType = 'Income';
  DateTime? selectedDate;
  bool isDue = false;

  void saveFinanceDate() {
    if (_formKey.currentState!.validate()) {
      final finance = Finance(
        title: titleController.text,
        amount: double.parse(amountController.text),
        category: categoryController.text,
        date: selectedDate!,
        type: transactionType,
        status: paymentStatus,
        dueDate: dueDate.toString(),
      );

      ref.read(financeProvider.notifier).addFinance(finance);

      titleController.clear();
      amountController.clear();
      categoryController.clear();
      setState(() {
        selectedDate = null;
        isDue = false;
        dueDate = null;
      });
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
    return Material(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 20),
              child: Text(
                'Enter Your Transactions',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        labelText: 'Enter title',
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
                  AppSpaces.height20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        labelText: 'Enter amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Amount cannot be empty';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  AppSpaces.height20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Category cannot be empty';
                        }
                        return null;
                      },
                      controller: categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Enter category',
                        border: OutlineInputBorder(
                          gapPadding: 15,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppSpaces.height20,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButtonFormField<String>(
                      value: paymentStatus,
                      items: ['Paid', 'Due'].map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          paymentStatus = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Payment Status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  AppSpaces.height20,
                  const Text(
                    'Select the transaction date',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: DatePicker(
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),
                  ),
                  if (paymentStatus == 'Due') ...[
                    AppSpaces.height20,
                    Column(
                      children: [
                        const Text(
                          'Select the Due-date',
                          style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Center(
                          child: DatePicker(
                            onDateSelected: (date) {
                              setState(() {
                                dueDate = date;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                  AppSpaces.height10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text('Income'),
                        selected: transactionType == 'Income',
                        onSelected: (bool selected) {
                          setState(() {
                            transactionType = 'Income';
                          });
                        },
                        selectedColor: Colors.blue,
                      ),
                      AppSpaces.width15,
                      ChoiceChip(
                        label: const Text('Expense'),
                        selected: transactionType == 'Expense',
                        onSelected: (bool selected) {
                          setState(() {
                            transactionType = 'Expense';
                          });
                        },
                        selectedColor: Colors.blue,
                      ),
                    ],
                  ),
                  AppSpaces.height20,
                  ElevatedButton(
                      onPressed: () {
                        saveFinanceDate();
                        titleController.clear();
                        amountController.clear();
                        categoryController.clear();
                      },
                      child: const Text('Submit')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
