import 'dart:convert';

import 'package:final_exam/pages/accounting.dart';
import 'package:final_exam/pages/expenditure.dart';
import 'package:final_exam/pages/income.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  List<Map<String, dynamic>> buttonData = AccountPageState.selectedTabIndex == 0 ? ExpenditureState.buttonData:IncomeState.buttonData;
  static List<AccountEntry> accountEntries = [];
  static List<int> tabsIndexEntries = [];    // 存储选择了支出还是收入的索引值,支出的索引值为“0”；收入的索引值为“1”
  static List<int> indexEntries = [];       // 存储选择了支出/收入中的按钮的索引值

  void addEntry(String date, String note, double amount) {
    setState(() {
      DetailPageState.accountEntries.add(AccountEntry(date, note, amount));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: accountEntries.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(accountEntries[index].date),
            subtitle: Row(
              children: [
                Icon((tabsIndexEntries[index] == 0 ? ExpenditureState.buttonData:IncomeState.buttonData)[indexEntries[index]]['icon'], size: 25, color: const Color.fromARGB(253, 159, 147, 147)),
                Text('${(tabsIndexEntries[index] == 0 ? "支出":"收入")}: ${(tabsIndexEntries[index] == 0 ? "-":"+")}${accountEntries[index].amount}\t   ${accountEntries[index].note}'),
              ],
            )
          );
        },
    );
  }
}
class AccountEntry {
  final String date;
  final String note;
  final double amount;
  
  AccountEntry(this.date, this.note, this.amount);

  // 将AccountEntry对象转换为Map对象，以便将其转换为JSON字符串
  Map<String, dynamic> toJson() => {
    'date': date,
    'note': note,
    'amount': amount,
  };

  // 从Map对象创建AccountEntry对象
  factory AccountEntry.fromJson(Map<String, dynamic> json) {
    return AccountEntry(
      json['date'],
      json['note'],
      json['amount'],
    );
  }
}

