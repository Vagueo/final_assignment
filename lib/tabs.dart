import 'package:final_exam/pages/expenditure.dart';
import 'package:final_exam/pages/income.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'icon_fonts.dart';
import './pages/News.dart';
import './pages/detail.dart';
import './pages/accounting.dart';


class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => TabsState();
}

class TabsState extends State<Tabs> {
  int currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 从shared_preferences加载数据
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accountEntriesData = prefs.getString('accountEntries');
    final String? tabsIndexEntriesData = prefs.getString('tabsIndexEntries');
    final String? indexEntriesData = prefs.getString('indexEntries');


    if (accountEntriesData != null) {
      setState(() {
        DetailPageState.accountEntries = (json.decode(accountEntriesData) as List)
            .map((item) => AccountEntry.fromJson(item))
            .toList();
      });
    }
    if (tabsIndexEntriesData != null) {
      setState(() {
        DetailPageState.tabsIndexEntries = List<int>.from(json.decode(tabsIndexEntriesData));
      });
    }

    if (indexEntriesData != null) {
      setState(() {
        DetailPageState.indexEntries = List<int>.from(json.decode(indexEntriesData));
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "云云记账",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 101, 101, 101),
          ),
        ),
        backgroundColor:const Color.fromARGB(245, 124, 228, 136),
        centerTitle: true, // 文字居中
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          ListView.builder(
            itemCount: DetailPageState.accountEntries.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(DetailPageState.accountEntries[index].date),
                subtitle: Row(
                  children: [
                    Icon((DetailPageState.tabsIndexEntries[index] == 0 ? ExpenditureState.buttonData:IncomeState.buttonData)[DetailPageState.indexEntries[index]]['icon'], size: 25, color: const Color.fromARGB(253, 159, 147, 147)),
                    Text('${(DetailPageState.tabsIndexEntries[index] == 0 ? "支出":"收入")}: ${(DetailPageState.tabsIndexEntries[index] == 0 ? "-":"+")}${DetailPageState.accountEntries[index].amount}\t   ${DetailPageState.accountEntries[index].note}'),
                  ],
                )
              );
            },
          ),
          const NewsPage(), // Add other pages as needed
        ],
      ),
      // 设置悬浮的按钮“记账”
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor:const Color.fromARGB(245, 124, 228, 136),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder:(BuildContext context) {
                return const AccountPage();
              },
            )
          );
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(IconFont.accounting, size: 25, color: Color.fromARGB(253, 159, 147, 147)),
            // 出现的问题：通过selectionColor:设置悬浮按钮名称的字体颜色无效
            // 解决方案：通过TextStyle来设置字体颜色
            Text("记账",style: TextStyle(color: Color.fromARGB(253, 159, 147, 147))),
          ],
        ) 
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: const Color.fromARGB(172, 241, 67, 125),   // 选中的颜色
        backgroundColor: const Color.fromARGB(245, 124, 228, 136),
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconFont.detail, size: 30, color: Color.fromARGB(253, 159, 147, 147)),
            label: "明细",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconFont.news, size: 30, color: Color.fromARGB(253, 159, 147, 147)),
            label: "新闻",
          ),
        ],
      ),
    );
  }
}