import 'package:flutter/material.dart';
import '../icon_fonts.dart';
import 'accounting.dart'; 

class Income extends StatefulWidget {
  const Income({super.key});

  @override
  IncomeState createState() => IncomeState();
}

class IncomeState extends State<Income> {
  static int currentIndex = 0;
  static List<Map<String, dynamic>> buttonData = [
    { 'icon': IconFont.salary, 'text': "工资", },
    { 'icon': IconFont.investment, 'text': "投资", },
    { 'icon': IconFont.other, 'text': "其他", },
  ];

  void handleButtonPress(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(30),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 每行三个网格项
        crossAxisSpacing: 90, // 横轴间距
        mainAxisSpacing: 97, // 纵轴间距
      ),
      itemCount: buttonData.length, // 网格项的数量
      itemBuilder: (BuildContext context, int index) {
        currentIndex = index;
        return Buttons(
          index,
          Icon(buttonData[index]['icon'], size: 20, color: const Color.fromARGB(253, 159, 147, 147)),
          Text(buttonData[index]['text'], style: const TextStyle(color: Color.fromARGB(253, 159, 147, 147),fontSize: 10)),
          onPressed: handleButtonPress,
        );
      },
    );
  }
}