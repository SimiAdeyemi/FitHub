import 'package:flutter/material.dart';

class calorieCounter extends StatefulWidget {
  const calorieCounter({Key? key});

  @override
  State<StatefulWidget> createState() => _calorieCounterState();
}

class _calorieCounterState extends State<calorieCounter> {
  int _caloriesConsumed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop();
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
