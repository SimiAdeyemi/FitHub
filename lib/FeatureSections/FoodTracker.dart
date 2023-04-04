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
  bool _isMetric = true;
  double _feet = 0;
  double _inches = 0;

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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Use metric units?'),
              const SizedBox(width: 16),
              Switch(
                value: _isMetric,
                onChanged: (value) {
                  setState(() {
                    _isMetric = value;
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
                _buildHeightField(),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: _isMetric ? 'Weight (kg)' : 'Weight (lbs)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _weight = double.tryParse(value) ?? 0;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _calculateBMI();
                  },
                  child: const Text('Calculate BMI'),
                ),
              ],
            ),
          if (_showBmi)
            Text('Your BMI is: $_bmi'),
        ],
      ),
    );
  }

  void _calculateBMI() {
    if (_isMetric) {
      _bmi = _weight / ((_height / 100) * (_height / 100));
    } else {
      double totalInches = (_feet * 12) + _inches;
      double heightInMeters = totalInches * 0.0254;
      _bmi = _weight / (heightInMeters * heightInMeters);
    }

    // Round the BMI to 1 decimal place
    _bmi = double.parse(_bmi.toStringAsFixed(1));

    setState(() {
      _showBmi = true;
    });
  }

  Widget _buildHeightField() {
    if (_isMetric) {
      return TextField(
        decoration: const InputDecoration(
          labelText: 'Height (cm)',
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          setState(() {
            _height = double.tryParse(value) ?? 0;
          });
        },
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Feet',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _feet = double.tryParse(value) ?? 0;
              });
            },
          ),
          const SizedBox(width: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Inches',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _inches = double.tryParse(value) ?? 0;
              });
            },
          ),
        ],
      );
    }
  }
}
