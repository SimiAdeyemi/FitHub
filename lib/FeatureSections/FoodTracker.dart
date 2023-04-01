import 'package:flutter/material.dart';

class FoodTracker extends StatefulWidget {
  const FoodTracker({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FoodTrackerState();
}

class _FoodTrackerState extends State<FoodTracker> {
  String? _gender;
  bool _isOver18 = false;
  double _height = 0;
  double _weight = 0;
  double _bmi = 0;
  bool _showBmi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Tracker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Please enter your gender and age:',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: _gender,
            items: const [
              DropdownMenuItem(
                value: 'male',
                child: Text('Male'),
              ),
              DropdownMenuItem(
                value: 'female',
                child: Text('Female'),
              ),
              DropdownMenuItem(
                value: 'other',
                child: Text('Other'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _gender = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Are you over 18?'),
              const SizedBox(width: 16),
              Switch(
                value: _isOver18,
                onChanged: (value) {
                  setState(() {
                    _isOver18 = value;
                  });
                },
              ),
            ],
          ),
          if (_gender != null && _isOver18)
            Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Please enter your height and weight so we can find out a bit more about you',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Height (inches)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _height = double.parse(value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Weight (lbs)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _weight = double.parse(value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _bmi = _weight / (_height * _height) * 703;
                      _showBmi = true;
                    });
                  },
                  child: const Text('Calculate BMI'),
                ),
              ],
            ),
          if (_showBmi)
            Column(
              children: [
                const Text(
                  'Your BMI is:',
                  textAlign: TextAlign.center,
                ),
                Text(
                  _bmi.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
