import 'package:finance_app/constants/space.dart';
import 'package:finance_app/screens/spend_pie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/finance_provider.dart';

class FinanceOverviewScreen extends ConsumerWidget {
  const FinanceOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorySpendings =
        ref.watch(financeProvider.notifier).getSpendingByCategory();

    final categoryIncome =
        ref.watch(financeProvider.notifier).getIncomeByCategory();

    final totalIncome = ref.watch(financeProvider.notifier).getTotalIncome();
    final totalExpense = ref.watch(financeProvider.notifier).getTotalExpense();
    final netBalance = totalIncome - totalExpense;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Income : $totalIncome',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              AppSpaces.height10,
              Text('Total Expense : $totalExpense',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              AppSpaces.height10,
              Text('Net Balance : $netBalance',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              AppSpaces.height20,
              const Center(
                child: Text(
                  'Expense Overview',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              Center(
                child: categorySpendings.isEmpty
                    ? const Text('No expenses to display')
                    : SpendingPieChart(categoryAmount: categorySpendings),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Income Overview',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ),
              categoryIncome.isEmpty
                  ? const Center(child: Text('No incomes to display'))
                  : SpendingPieChart(categoryAmount: categoryIncome),
            ],
          ),
        ),
      ),
    );
  }
}
