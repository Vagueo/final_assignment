import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import './detail.dart';
import 'package:intl/intl.dart';


class CalculatorScreen extends StatefulWidget {
  final Function(String, String, double) onEntryAdded;

  const CalculatorScreen(this.onEntryAdded);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  double _currentValue = 0;
  DateTime chooseDate = DateTime.now();
  DateFormat formatter = DateFormat('yyyy年MM月dd日 EEEE'); 
  String currentNote = " ";
  final TextEditingController controller = TextEditingController();

  void _addEntry() {
    String currentDate = formatter.format(chooseDate);
    widget.onEntryAdded(currentDate, currentNote, _currentValue);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = formatter.format(chooseDate);
    var calc = SimpleCalculator(
      value: _currentValue,
      hideExpression: false,
      hideSurroundingBorder: true,
      autofocus: true,
      onChanged: (key, value, expression) {
        setState(() {
          _currentValue = value ?? 0;
        });
        if (kDebugMode) {
          print('$key\t$value\t$expression');
        }
      },
      onTappedDisplay: (value, details) {
        if (kDebugMode) {
          print('$value\t${details.globalPosition}');
        }
      },
      theme: const CalculatorThemeData(
        borderColor: Colors.black,
        borderWidth: 2,
        displayColor: Color.fromARGB(255, 137, 200, 239),
        displayStyle: TextStyle(fontSize: 80, color: Colors.white),
        expressionColor: Color.fromARGB(255, 137, 200, 239),
        expressionStyle: TextStyle(fontSize: 20, color: Colors.white),
        operatorColor: Color.fromARGB(255, 247, 135, 172),
        operatorStyle: TextStyle(fontSize: 30, color: Colors.white),
        commandColor: Color.fromARGB(255, 239, 196, 132),
        commandStyle: TextStyle(fontSize: 30, color: Colors.white),
        numColor: Color.fromARGB(255, 210, 194, 194),
        numStyle: TextStyle(fontSize: 50, color: Colors.white),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "计算界面",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 101, 101, 101),
          ),
        ),
        centerTitle: true, // 文字居中
        backgroundColor: Colors.yellow,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.grey, 
          onPressed: () {  
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: Text("计算器页面：$_currentValue"),
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: calc,
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 100),
            SizedBox(
              height: 30,
              width: 300,
              child: TextField(
                textAlign: TextAlign.center,
                controller: controller,
                decoration: const InputDecoration(
                  hintText: '备注',
                ),
                onChanged: (text) {
                  // 当文本发生变化时更新note变量
                  currentNote = text;
                },
              ),
            ),
            const SizedBox(height: 100),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                chooseDate = (await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ))!;
                // 如果用户选择了日期，则格式化并使用该日期
                currentDate = formatter.format(chooseDate);
              },
            ),
            const SizedBox(height: 100),
            TextButton(
              onPressed: () {
                _addEntry();
                Navigator.of(context).pop();
              },
              child: const Text("完成"),
            )
          ],
        ),
      )
    );
  }
}