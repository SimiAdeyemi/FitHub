import 'package:firebase_core/firebase_core.dart';
import 'package:group_project/LogInScreens/SignInPage.dart';
import 'package:flutter/material.dart';

//MyApp is our root widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //makes sure Firebase is initialized before we run the app
  await Firebase.initializeApp();
  runApp(const MyApp());
}

//This widget loads the SignInPage when app is run.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignInPage(),
    );
  }
}

//Test test