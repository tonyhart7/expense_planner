import 'package:expense_planner/models/transaction.dart';
import 'package:expense_planner/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recenTransaction;

  Chart(this.recenTransaction);

  List<Map<String, Object>> get groupTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      for (var i = 0; i < recenTransaction.length; i++) {
        if (recenTransaction[i].date.day == weekDay.day &&
            recenTransaction[i].date.month == weekDay.month &&
            recenTransaction[i].date.year == weekDay.year) {
          totalSum += recenTransaction[i].amount;
        }
      }

      return {
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        "amount": totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupTransactionValues.fold(0.0, (sum, item) {
      return sum + item["amount"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupTransactionValues.map((e) {
            return ChartBar(
              e["day"],
              e["amount"],
              totalSpending == 0.0
                  ? 0.0
                  : (e["amount"] as double) / totalSpending,
            );
          }).toList(),
        ),
      ),
    );
  }
}
