import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_project/FeatureSections/FoodTracker/Model/foodTask.dart';

class DatabaseService {
  final String uid;
  final DateTime currentDate;

  DatabaseService({required this.uid, required this.currentDate});

  final DateTime today =
  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final DateTime weekStart = DateTime(2023, 04, 09);

  // collection reference
  final CollectionReference foodTrackCollection =
  FirebaseFirestore.instance.collection('foodTracks');

  Future addFoodTrackEntry(foodTask food) async {
    print('Adding food entry: $food');
    return await foodTrackCollection
        .doc(food.createdOn.millisecondsSinceEpoch.toString())
        .set({
      'foodName': food.foodName,
      'calories': food.calories,
      'carbs': food.carbs,
      'fat': food.fat,
      'protein': food.protein,
      'mealTime': food.mealTime,
      'createdOn': food.createdOn,
      'grams': food.grams
    });
  }

  Future deleteFoodTrackEntry(foodTask deleteEntry) async {
    print('Deleting food entry: $deleteEntry');
    return await foodTrackCollection
        .doc(deleteEntry.createdOn.millisecondsSinceEpoch.toString())
        .delete();
  }

  List<foodTask> _scanListFromSnapshot(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) {
      return [];
    }
    return snapshot.docs.map((doc) {
      return foodTask(
        id: doc.id,
        foodName: doc['foodName'] ?? '',
        calories: doc['calories'] ?? 0,
        carbs: doc['carbs'] ?? 0,
        fat: doc['fat'] ?? 0,
        protein: doc['protein'] ?? 0,
        mealTime: doc['mealTime'] ?? "",
        createdOn: doc['createdOn']?.toDate() ?? DateTime.now(),
        grams: doc['grams'] ?? 0,
      );
    }).toList();
  }

  Stream<List<foodTask>> get foodTracks {
    return foodTrackCollection.snapshots().map(_scanListFromSnapshot);
  }

  Future<List<dynamic>> getAllFoodTrackData() async {
    QuerySnapshot snapshot = await foodTrackCollection.get();
    List<dynamic> result = snapshot.docs.map((doc) => doc.data()).toList();
    return result;
  }

  Future<String> getFoodTrackData(String uid) async {
    DocumentSnapshot snapshot = await foodTrackCollection.doc(uid).get();
    return snapshot.toString();
  }
}
