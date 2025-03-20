import 'package:finance_app/constants/space.dart';
import 'package:finance_app/screens/finance_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/finance_provider.dart';

class Trans extends ConsumerWidget {
  const Trans({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions =
        ref.watch(financeProvider);

    if (transactions.isEmpty) {
      return const Center(child: Text('No transactions found.'));
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final finance = transactions[index];
        print(finance.status);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FinanceDetails(finance: finance),
              ),
            );
          },
          child: Container(
            // height: 100,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
              color: finance.type == 'Income' ? Colors.green : Colors.red[400],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
             contentPadding: const EdgeInsets.symmetric(vertical: 17,horizontal: 10),
              title: Text(
                finance.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              leading: Column(
                children: [
                  Text(
                    finance.date.toString().split(' ')[0],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpaces.height10,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: finance.status == 'Paid' ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      finance.status, // Show "Paid" or "Due"
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              // Format date
              subtitle: Text(
                finance.category,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\Rs ${finance.amount.toString()}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpaces.width10,
                  IconButton(
                    onPressed: () {
                      ref
                          .read(financeProvider.notifier)
                          .deleteFinance(finance.id!);
                    },
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
