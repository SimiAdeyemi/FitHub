import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:group_project/LogInScreens/SignInPage.dart';
import 'package:flutter/material.dart';

//MyApp is our root widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
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

//new feature test
//
//