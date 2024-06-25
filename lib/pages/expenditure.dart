import 'package:flutter/material.dart';
import '../icon_fonts.dart'; 
import 'accounting.dart'; 

class Expenditure extends StatefulWidget {
  const Expenditure({super.key});

  @override
  ExpenditureState createState() => ExpenditureState();
}

class ExpenditureState extends State<Expenditure> {
  static int currentIndex = 0;
  static List<Map<String, dynamic>> buttonData = [
    { 'icon': IconFont.dailyUse, 'text': "日用", },
    { 'icon': IconFont.repast, 'text': "餐饮", },
    { 'icon': IconFont.amusement, 'text': "娱乐", },
    { 'icon': IconFont.love, 'text': "恋爱", },
    { 'icon': IconFont.study, 'text': "学习", },
    { 'icon': IconFont.traffic, 'text': "交通", },
  ];

  void handleButtonPress(int index) {
    setState(() {
      currentIndex = index;
      print('Selected index: $currentIndex');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 90,
        mainAxisSpacing: 25,
      ),
      itemCount: buttonData.length,
      itemBuilder: (BuildContext context, int index) {
        return Buttons(
          index,
          Icon(buttonData[index]['icon'], size: 20, color: const Color.fromARGB(253, 159, 147, 147)),
          Text(buttonData[index]['text'], style: const TextStyle(color: Color.fromARGB(253, 159, 147, 147), fontSize: 10)),
          onPressed: handleButtonPress,
        );
      },
    );
  }
}
