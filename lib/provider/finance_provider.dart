import 'package:finance_app/database_helper.dart';
import 'package:finance_app/models/finance_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinanceNotifier extends StateNotifier<List<Finance>> {
  FinanceNotifier() : super([]) {
    loadFinances();
  }

  Future<void> loadFinances() async {
    final transactions = await DatabaseHelper.instance.getAllTransactions();
    state = transactions; // Updates state
  }

  Future<void> addFinance(Finance finance) async {
    int id = await DatabaseHelper.instance.addTransaction(finance);
    state = [...state, finance.copyWith(id: id)];
  }

  Future<void> updateFinance(Finance finance) async {
    await DatabaseHelper.instance.updateFinance(finance, finance.id!);
    state = state.map((f) => f.id == finance.id ? finance : f).toList();
  }

  Future<void> deleteFinance(int id) async {
    await DatabaseHelper.instance.deleteFinance(id);
    state = state.where((f) => f.id != id).toList();
  }

  double getTotalIncome() {
    return state
        .where((f) => f.type == 'Income')
        .fold(0, (sum, finance) => sum + finance.amount);
  }

  double getTotalExpense() {
    return state
        .where((f) => f.type == 'Expense' && f.status == 'Paid')
        .fold(0, (sum, finance) => sum + finance.amount);
  }

  List<Finance> getDuePayments() {
    return state.where((f) => f.status == 'Due').toList();
  }

  Future<void> markAsPaid(int id) async {
    final finance = state.firstWhere((f) => f.id == id);
    final updatedFinance = finance.copyWith(status: 'Paid');

    await DatabaseHelper.instance.updateFinance(updatedFinance, id);
    state = state.map((f) => f.id == id ? updatedFinance : f).toList();
  }

  // Function to group spending by category
  Map<String, double> getSpendingByCategory() {
    final Map<String, double> categorySpendings = {};

    for (var finance in state) {
      if (finance.type == 'Expense') {
        // Only consider expenses
        categorySpendings[finance.category] =
            (categorySpendings[finance.category] ?? 0) + finance.amount;
      }
    }

    return categorySpendings;
  }

  // Function to group income by category
  Map<String, double> getIncomeByCategory() {
    final Map<String, double> categoryIncome = {};

    for (var finance in state) {
      if (finance.type == 'Income') {
        // Only consider income
        categoryIncome[finance.category] =
            (categoryIncome[finance.category] ?? 0) + finance.amount;
      }
    }

    return categoryIncome;
  }
}

// Provider for FinanceNotifier
final financeProvider =
    StateNotifierProvider<FinanceNotifier, List<Finance>>((ref) {
  return FinanceNotifier();
});
