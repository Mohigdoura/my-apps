// ignore_for_file: unused_element

import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  int number = 0;
  int? previousNumber;
  String? operator;
  final List<String> operators = ['+', '-', '*', '/'];

  // Handles number button presses
  void _numbers(int index) {
    setState(() {
      if (number == 0 && index == 0) return; // Prevent multiple leading zeros
      if (number == 0) {
        number = index;
      } else if (number < 1000000) {
        // Prevent overflow
        number = number * 10 + index;
      }
    });
  }

  // Handles operator button presses
  void _setOperator(String op) {
    setState(() {
      previousNumber = number;
      number = 0;
      operator = op;
    });
  }

  // Performs calculations when "=" is pressed
  void _calculate() {
    if (previousNumber == null || operator == null) return;
    setState(() {
      switch (operator) {
        case '+':
          number = previousNumber! + number;
          break;
        case '-':
          number = previousNumber! - number;
          break;
        case '*':
          number = previousNumber! * number;
          break;
        case '/':
          if (number == 0) return; // Prevent division by zero
          number = previousNumber! ~/ number;
          break;
      }
      previousNumber = null;
      operator = null;
    });
  }

  // Clears the calculator
  void _clear() {
    setState(() {
      number = 0;
      previousNumber = null;
      operator = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Display Area
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  number.toString().replaceAllMapped(
                    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                    (match) => '${match[1]},',
                  ),
                  style: const TextStyle(fontSize: 48, color: Colors.white),
                ),
              ),
            ),
          ),

          // Buttons Area
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[700],
              child: Row(
                children: [
                  // Number Buttons (0-9 and "=")
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        // Grid for numbers 1-9
                        Expanded(
                          flex: 4,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 15,
                                ),
                            itemCount: 9,
                            itemBuilder:
                                (context, index) => ElevatedButton(
                                  onPressed: () => _numbers(index + 1),
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                          ),
                        ),

                        // Row for "0" and "="
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _numbers(0),
                                child: const Text(
                                  '0',
                                  style: TextStyle(fontSize: 24, height: 3),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _calculate,
                                child: const Text(
                                  '=',
                                  style: TextStyle(fontSize: 24, height: 3),
                                ),
                              ),
                            ),
                            SizedBox(height: 100),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Operator Buttons
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (String op in operators)
                          SizedBox(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () => _setOperator(op),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                              ),
                              child: Text(
                                op,
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        // Clear Button
                        SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _clear,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'C',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
