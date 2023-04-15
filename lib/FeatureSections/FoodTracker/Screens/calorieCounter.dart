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
