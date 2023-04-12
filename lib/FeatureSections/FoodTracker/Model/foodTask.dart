import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

// ignore: camel_case_types
@JsonSerializable()
class foodTask {
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
  });

  factory foodTask.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return foodTask(
      foodName: data['food_name'],
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
      'food_name': foodName,
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
      foodName: json['food_name'],
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
    'mealTime': mealTime,
    'food_name': foodName,
    'calories': calories,
    'carbs': carbs,
    'protein': protein,
    'fat': fat,
    'grams': grams,
    'createdOn': createdOn.toString(),
  };
}
