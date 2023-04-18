// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_project/FeatureSections/FoodTracker/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class foodTask {
  late String id;
  late String foodName;
  late num calories;
  late num carbs;
  late num fat;
  late num protein;
  late String mealTime;
  late DateTime createdOn;
  late num grams;

  foodTask({
    required this.foodName,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.mealTime,
    required this.createdOn,
    required this.grams,
    String? id,
  }) : id = id ?? Uuid().generateV4();

  factory foodTask.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return foodTask(
      foodName: data['foodName'],
      calories: data['calories'],
      carbs: data['carbs'],
      protein: data['protein'],
      fat: data['fat'],
      mealTime: data['mealTime'],
      grams: data['grams'],
      createdOn: data['createdOn'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mealTime': mealTime,
      'foodName': foodName,
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'grams': grams,
      'createdOn': createdOn,
    };
  }

  factory foodTask.fromJson(Map<String, dynamic> json) {
    return foodTask(
      foodName: json['foodName'],
      calories: json['calories'],
      carbs: json['carbs'],
      protein: json['protein'],
      fat: json['fat'],
      mealTime: json['mealTime'],
      grams: json['grams'],
      createdOn: DateTime.parse(json['createdOn']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'mealTime': mealTime,
        'foodName': foodName,
        'calories': calories,
        'carbs': carbs,
        'protein': protein,
        'fat': fat,
        'grams': grams,
        'createdOn': createdOn.toString(),
      };
}
