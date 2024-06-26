import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import './calculator.dart';
import 'package:flutter/material.dart';
import './expenditure.dart';
import './income.dart';
import './detail.dart';


class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      selectedTabIndex = _tabController.index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(   // 设置路由返回按键
        backgroundColor: Colors.yellow,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.grey, 
          onPressed: () {  
            Navigator.pop(context);
          },
        ),
        elevation: 1,
        title: TabBar(
          indicatorColor: const Color.fromARGB(172, 241, 67, 125),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: const Color.fromARGB(172, 241, 67, 125),
          unselectedLabelColor: Colors.grey,  // label未选中的颜色
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text("支出"),
            ),
            Tab(
              child: Text("收入"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Expenditure(),
          Income(),
        ],
      ),
    );
  }
}

// 支出或收入类别的按钮
class Buttons extends StatefulWidget {
  final int index;
  final Icon icon;
  final Text text;
  final Function(int) onPressed;
  const Buttons(this.index, this.icon, this.text, {required this.onPressed, super.key});

  @override
  ButtonsState createState() => ButtonsState();
}

class ButtonsState extends State<Buttons> {
  int index = 0;
  int currentIndex = 0;
  
  void addEntry(String date, String note, double amount) {
    setState(() {
      DetailPageState.accountEntries.add(AccountEntry(date, note, amount));
      index = AccountPageState.selectedTabIndex;
      DetailPageState.tabsIndexEntries.add(index);
      currentIndex = AccountPageState.selectedTabIndex == 0 ? ExpenditureState.currentIndex:IncomeState.currentIndex;
      DetailPageState.indexEntries.add(currentIndex);
      _saveData();
    });
  }

  // 将数据保存到shared_preferences
  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('accountEntries', json.encode(DetailPageState.accountEntries.map((entry) => entry.toJson()).toList()));
    prefs.setString('tabsIndexEntries', json.encode(DetailPageState.tabsIndexEntries));
    prefs.setString('indexEntries', json.encode(DetailPageState.indexEntries));
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0, 
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 255, 247, 172)),
        ),
        onPressed: () {
          widget.onPressed(widget.index);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalculatorScreen(addEntry)
            )
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon,
            widget.text,
          ],
        ),
      ),
    );
  }
}