import 'package:flutter/material.dart';
import 'package:personal_expenses/widgets/chart_bar.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTrasactions;

  Chart(this.recentTrasactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for (var i = 0; i < recentTrasactions.length; i++) {
        if (recentTrasactions[i].date.day == weekDay.day &&
            recentTrasactions[i].date.month == weekDay.month &&
            recentTrasactions[i].date.year == weekDay.year) {
          totalSum += recentTrasactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    });
  }
  double get totalSpeding{
    return groupedTransactionValues.fold(0.0, (sum, transaction){
      return sum + transaction['amount'];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row(
        children: groupedTransactionValues.map((data) {
          return ChartBar(
            data['day'],
            data['amount'],
            totalSpeding == 0 ? 0 : (data['amount'] as double) / totalSpeding
          );
        }).toList(),
      ),
    );
  }
}
