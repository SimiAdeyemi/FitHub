import 'package:firebase_auth/firebase_auth.dart'; // Imports the FirebaseAuth library
import 'package:flutter/material.dart'; // Imports the Flutter Material library
import 'package:group_project/LogInScreens/SignInPage.dart'; // Imports the SignInPage widget
import 'package:group_project/globals.dart'; // Imports the displayName variable from globals.dart

class More extends StatelessWidget { // Defines a More widget
  const More({Key? key}) : super(key: key); // The constructor for the More widget

  @override
  Widget build(BuildContext context) { // Builds the More widget
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'), // Sets the app bar title
        backgroundColor: Colors.green, // Sets the app bar background color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Sets the back button icon
          onPressed: () {
            Navigator.pop(context); // Pops the current screen off the navigation stack when the back button is pressed
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centers the column's children vertically
          children: [
            Text(
              displayName, // Displays the displayName variable
              style: TextStyle(fontSize: 24), // Sets the font size for the display name text
            ),
            const SizedBox(height: 20), // Adds some vertical spacing
            ElevatedButton(
              child: Text("Logout"), // Displays the "Logout" text
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) { // Signs out the user from Firebase
                  print("Signed Out"); // Prints a message to the console
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage())); // Navigates to the SignInPage
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
