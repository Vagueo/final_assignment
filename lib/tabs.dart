import './pages/News.dart';
import 'package:flutter/material.dart';
import 'icon_fonts.dart';
import './pages/detail.dart';
import './pages/accounting.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => TabsState();
}

class TabsState extends State<Tabs> {
  int currentIndex = 0;
  final List<Widget> _pages = const [
    DetailPage(),
    NewsPage(),
  ];
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
      body: _pages[currentIndex],
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