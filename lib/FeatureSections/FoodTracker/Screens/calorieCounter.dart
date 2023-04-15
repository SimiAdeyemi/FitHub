import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:group_project/FeatureSections/FoodTracker/Model/foodTask.dart';
import 'package:group_project/FeatureSections/FoodTracker/caloriesStats.dart';
import 'package:provider/provider.dart';
import 'package:group_project/FeatureSections/FoodTracker/foodDatabase/databaseFoodTracks.dart';

// import 'package:openfoodfacts/model/Product.dart';
// import 'package:openfoodfacts/openfoodfacts.dart';
import 'dart:math';
import 'package:group_project/FeatureSections/FoodTracker/colours.dart';
// import 'package:calorie_tracker_app/src/utils/constants.dart';

class calorieCounter extends StatefulWidget {
  const calorieCounter();

  @override
  State<StatefulWidget> createState() => _calorieCounterState();
}

class _calorieCounterState extends State<calorieCounter> {
  String title = 'Add Food';
  double servingSize = 0;
  String dropdownValue = 'grams';
  DateTime _value = DateTime.now();
  DateTime today = DateTime.now();
  Color _rightArrowColor = Color(0xffC1C1C1);
  Color _leftArrowColor = Color(0xffC1C1C1);
  final _addFoodKey = GlobalKey<FormState>();

  DatabaseService databaseService = new DatabaseService(
      uid: "fithub-5df39", currentDate: DateTime.now());

  late foodTask addFoodTrack;

  @override
  void initState() {
    super.initState();
    addFoodTrack = foodTask(
        foodName: "",
        calories: 0,
        carbs: 0,
        protein: 0,
        fat: 0,
        mealTime: "",
        createdOn: _value,
        grams: 0);
    databaseService.getFoodTrackData(databaseUID);
  }

  void resetFoodTrack() {
    addFoodTrack = foodTask(
        foodName: "",
        calories: 0,
        carbs: 0,
        protein: 0,
        fat: 0,
        mealTime: "",
        createdOn: _value,
        grams: 0 );
  }

  Widget _calorieCounter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.5,
                ))),
        height: 220,
        child: Row(
          children: <Widget>[
            caloriesStats(datePicked: _value),
          ],
        ),
      ),
    );
  }

  Widget _addFoodButton() {
    return IconButton(
      icon: Icon(Icons.add_box),
      iconSize: 25,
      color: Colors.white,
      onPressed: () async {
        setState(() {});
        _showFoodToAdd(context);
      },
    );
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _value,
      firstDate: new DateTime(2019),
      lastDate: new DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff5FA55A), //Head background
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _value = picked);
    _stateSetter();
  }
  void _stateSetter() {
    if (today.difference(_value).compareTo(Duration(days: 1)) == -1) {
      setState(() => _rightArrowColor = Color(0xffEDEDED));
    } else
      setState(() => _rightArrowColor = Colors.white);
  }

  checkFormValid() {
    if (addFoodTrack.calories != 0 &&
        addFoodTrack.carbs != 0 &&
        addFoodTrack.protein != 0 &&
        addFoodTrack.fat != 0 &&
        addFoodTrack.grams != 0) {
      return true;
    }
    return false;
  }

  _showFoodToAdd(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: _showAmountHad(),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () => Navigator.pop(context), // passing false
                child: Text('Cancel'),
              ),
              OutlinedButton(
                onPressed: () async {
                  if (checkFormValid()) {
                    Navigator.pop(context);
                    var random = new Random();
                    int randomMilliSecond = random.nextInt(1000);
                    addFoodTrack.createdOn = _value;
                    addFoodTrack.createdOn = addFoodTrack.createdOn
                        .add(Duration(milliseconds: randomMilliSecond));
                    databaseService.addFoodTrackEntry(addFoodTrack);
                    resetFoodTrack();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Invalid form data! All numeric fields must contain numeric values greater than 0"),
                      backgroundColor: Colors.white,
                    ));
                  }
                },
                child: Text('Ok'),
              ),
            ],
          );
        });
  }

  Widget _showAmountHad() {
    return new Scaffold(
      body: Column(children: <Widget>[
        _showAddFoodForm(),
        // _showUserAmount(),
      ]),
    );
  }

  Widget _showAddFoodForm() {
    return Form(
      key: _addFoodKey,
      child: Column(children: [
        TextFormField(
          decoration: const InputDecoration(
              labelText: "Name *", hintText: "Please enter food name"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter the food name";
            }
            return null;
          },
          onChanged: (value) {
            addFoodTrack.foodName = value;
// addFood.calories = value;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
              labelText: "Calories *",
              hintText: "Please enter a calorie amount"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a calorie amount";
            }
            return null;
          },
          keyboardType: TextInputType.number,
          onChanged: (value) {
            try {
              addFoodTrack.calories = int.parse(value);
            } catch (e) {
              // return "Please enter numeric values"
              addFoodTrack.calories = 0;
            }
// addFood.calories = value;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
              labelText: "Carbs *", hintText: "Please enter a carbs amount"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a carbs amount";
            }
            return null;
          },
          keyboardType: TextInputType.number,
          onChanged: (value) {
            try {
              addFoodTrack.carbs = int.parse(value);
            } catch (e) {
              addFoodTrack.carbs = 0;
            }
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
              labelText: "Protein *",
              hintText: "Please enter a protein amount"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a calorie amount";
            }
            return null;
          },
          onChanged: (value) {
            try {
              addFoodTrack.protein = int.parse(value);
            } catch (e) {
              addFoodTrack.protein = 0;
            }
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
              labelText: "Fat *", hintText: "Please enter a fat amount"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a fat amount";
            }
            return null;
          },
          onChanged: (value) {
            try {
              addFoodTrack.fat = int.parse(value);
            } catch (e) {
              addFoodTrack.fat = 0;
            }
          },
        ),
      ]),
    );
  }

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
    );
  }
}
