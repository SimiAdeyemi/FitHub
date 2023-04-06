import 'package:flutter/material.dart';

class CalorieCounter extends StatefulWidget {
  const CalorieCounter({super.key});

  @override
  _CalorieCounterState createState() => _CalorieCounterState();
}

class _CalorieCounterState extends State<CalorieCounter> {
  int _caloriesConsumed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Calorie Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Calories Consumed:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$_caloriesConsumed',
              style: const TextStyle(fontSize: 48),
            ),
          ],
        ),
      ),
    );
  }
}