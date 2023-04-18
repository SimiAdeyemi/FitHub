import 'package:firebase_core/firebase_core.dart'; // Importing firebase_core package to initialize Firebase services.
import 'firebase_options.dart'; // Importing a file containing Firebase configuration options for this app.
import 'package:group_project/LogInScreens/SignInPage.dart'; // Importing the login screen for the app.
import 'package:flutter/material.dart'; // Importing material.dart for Material Design widgets and theme.

//MyApp is our root widget.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensuring Flutter bindings are initialized before app starts.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Initializing Firebase services with configuration options.
  runApp(const MyApp()); // Running the app with the root widget MyApp.
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) { // Defining the root widget for the app.
    return const MaterialApp( // Using the MaterialApp widget to provide Material Design and app theme.
      home: SignInPage(), // Setting the SignInPage as the initial screen for the app.
    );
  }
}
