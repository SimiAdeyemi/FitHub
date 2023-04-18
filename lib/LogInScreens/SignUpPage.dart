import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../HomePage.dart';
import '../ReusableWidgets.dart';
import 'package:group_project/globals.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _passwordTextController = TextEditingController(); // Creating a TextEditingController for the password input.
  final TextEditingController _emailTextController = TextEditingController(); // Creating a TextEditingController for the email input.
  final TextEditingController _userNameTextController = TextEditingController(); // Creating a TextEditingController for the username input.
  final _formKey = GlobalKey<FormState>(); // Creating a GlobalKey for the form.

  final db = FirebaseFirestore.instance; // Creating a reference to Firestore.
  FirebaseAuth auth = FirebaseAuth.instance; // Creating an instance of FirebaseAuth.

  @override
  Widget build(BuildContext context) { // Building the widget tree for the Sign Up page.
    return Scaffold(
      extendBodyBehindAppBar: true, // Setting extendBodyBehindAppBar to true to allow the background image to be visible behind the app bar.
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 120, 25, 0),
                child: Form(
                  key: _formKey, // Assigning the GlobalKey to the form.
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _userNameTextController, // Assigning the username TextEditingController to the username input field.
                        decoration: const InputDecoration(
                          labelText: "Enter Username",
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username.'; // Displaying an error message if the username field is empty.
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailTextController, // Assigning the email TextEditingController to the email input field.
                        decoration: const InputDecoration(
                          labelText: "Enter Email",
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email.'; // Displaying an error message if the email field is empty.
                          } else if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email address.'; // Displaying an error message if the email format is invalid.
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20), // Adds some vertical spacing
                      TextFormField(
                        controller: _passwordTextController, // Controller for password input
                        obscureText: true, // Hides the password input
                        decoration: const InputDecoration(
                          labelText: "Enter Password", // Label for password input
                          prefixIcon: Icon(Icons.lock_outlined), // Lock icon for password input
                          border: OutlineInputBorder(), // Adds a border to the input field
                          contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0), // Adds some padding to the input field
                        ),
                        validator: (value) { // Validates the input
                          if (value == null || value.isEmpty) { // Checks if the input is empty
                            return 'Please enter a password.';
                          } else if (value.length < 6) { // Checks if the password is less than 6 characters
                            return 'Password must be at least 6 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20), // Adds some vertical spacing
                      firebaseButton(context, "Sign Up", () async { // A custom widget that creates a button and handles button clicks
                        if (_formKey.currentState!.validate()) { // Validates the form input
                          await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: _emailTextController.text, // Gets the user's email input
                              password: _passwordTextController.text // Gets the user's password input
                          );
                          userSetup(_userNameTextController.text); // Adds the user to Firestore
                          displayName = _userNameTextController.text; // Sets the display name to the user's name
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(initialIndex: 1,))); // Navigates to the home page
                         }}
                      )
                    ],
                  ),
                )
              )
            )
        ),
    );
  }

  // This method is used to create the user in Firestore
  Future<void> userSetup(String displayName) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users'); // Gets the 'Users' collection in Firestore
    FirebaseAuth auth = FirebaseAuth.instance; // Gets the current user's authentication data
    String? uid = auth.currentUser?.uid; // Gets the user's UID
    users.doc(uid).set({'displayName': displayName, 'uid': uid}); // Adds the user's display name and UID to Firestore
    return;
  }

}

