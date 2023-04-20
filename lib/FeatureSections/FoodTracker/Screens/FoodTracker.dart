import 'package:flutter/material.dart';
import 'calorieCounter.dart';

class FoodTracker extends StatefulWidget {
  const FoodTracker({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FoodTrackerState();
}

class _FoodTrackerState extends State<FoodTracker> {
  //variables

  String? _gender;
  bool _isOver18 = false;
  double _height = 0;
  double _weight = 0;
  double _bmi = 0;
  bool _showBmi = false;
  bool _useMetricUnits = true;
  double _inches = 0;
  bool isVisible = true; // will be visible for the first frame

  // do not make these variables into final variables
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _poundWeightController = TextEditingController();
  TextEditingController _inchesHeightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const calorieCounter()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Skip BMI Calculation'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please select your gender:',
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
                  value: _useMetricUnits,
                  onChanged: (value) {
                    setState(() {
                      _useMetricUnits = value;
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
                  if (_useMetricUnits)
                    _buildWeightField()
                  else
                    _buildPoundWeightField(),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: isVisible,
                    child: ElevatedButton(
                      onPressed: () {
                        _calculateBMI();
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      child: const Text('Calculate BMI'),
                    ),
                  ),
                  Visibility(
                    visible: !isVisible,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const calorieCounter()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Continue'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Reset the text fields
                        _heightController.text = '';
                        _weightController.text = '';
                        _poundWeightController.text = '';
                        _inchesHeightController.text = '';
                        // reset the bmi
                        _showBmi = false;
                        isVisible = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text('Reset'),
                  ),
                ],
              ),
            if (_showBmi) Text('Your BMI is: $_bmi'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Height: '),
        SizedBox(
          width: 100,
          child: TextField(
            controller: _heightController,
            decoration: InputDecoration(
              labelText: _useMetricUnits ? 'Centimetres' : 'Feet',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _height = double.tryParse(value) ?? 0;
              });
            },
          ),
        ),
        if (!_useMetricUnits) const Text('\''),
        if (!_useMetricUnits) const SizedBox(width: 16),
        if (_useMetricUnits)
          const SizedBox.shrink()
        else
          SizedBox(
            width: 100,
            child: TextField(
              controller: _inchesHeightController,
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
          ),
      ],
    );
  }

  Widget _buildWeightField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Weight: '),
        SizedBox(
          width: 100,
          child: TextField(
            controller: _weightController,
            decoration: const InputDecoration(
              labelText: 'Kilograms',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _weight = double.tryParse(value) ?? 0;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPoundWeightField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Weight: '),
        SizedBox(
          width: 100,
          child: TextField(
            controller: _poundWeightController,
            decoration: const InputDecoration(
              labelText: 'Pounds',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _weight = double.tryParse(value) ?? 0;
              });
            },
          ),
        ),
      ],
    );
  }

  void _calculateBMI() {
    double heightInMeters = _height / 100;
    double bmi;

    if (!_useMetricUnits) {
      heightInMeters = ((_height * 12) + _inches) * 0.0254;
      _weight = _weight * 0.453592;
    }

    bmi = _weight / (heightInMeters * heightInMeters);

    setState(() {
      _bmi = bmi;
      _showBmi = true;
    });

    _bmi = double.parse(_bmi.toStringAsFixed(1)); // format to one decimal place
  }
}
