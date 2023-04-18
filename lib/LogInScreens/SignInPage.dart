import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/HomePage.dart';
import 'package:group_project/LogInScreens/ResetPassword.dart';
import 'package:group_project/LogInScreens/SignUpPage.dart';
import '../ReusableWidgets.dart';
import 'package:group_project/globals.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Creating TextEditingController objects to access the user input from email and password text boxes.
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  // Creating GlobalKey objects to identify the form and the scaffold and enable form validation.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Creating a FirebaseFirestore instance to access the Firebase Cloud Firestore database.
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) { // Defining the layout for the widget.
    return Scaffold( // Creating a Scaffold to provide a layout structure for the app.
      key: _scaffoldKey, // Setting the GlobalKey for the Scaffold.
      body: SingleChildScrollView( // Creating a SingleChildScrollView to enable scrolling.
        child: Padding( // Adding padding to the SingleChildScrollView.
          padding: EdgeInsets.fromLTRB(25, MediaQuery.of(context).size.height * 0.2, 25, 0), // Setting the padding for the content.
          child: Form( // Creating a Form to retrieve user input.
            key: _formKey, // Setting the GlobalKey for the Form.
            child: Column( // Creating a Column to display the content.
              children: <Widget>[
                const Text("FitHub", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.green)), // Adding a title for the page.
                const SizedBox(height: 10), // Adding a SizedBox for spacing.
                TextFormField( // Creating a TextFormField for the email field.
                  controller: _emailTextController, // Setting the TextEditingController for the email field.
                  decoration: const InputDecoration( // Adding decoration to the email field.
                    labelText: "Email", // Adding a label for the email field.
                    prefixIcon: Icon(Icons.email_outlined), // Adding an icon for the email field.
                    border: OutlineInputBorder(), // Adding a border to the email field.
                    contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0), // Adding padding to the content of the email field.
                  ),
                  validator: (value) { // Adding a validator to the password field.
                    if (value == null || value.isEmpty) { // Checking if the password field is empty.
                      return 'Please enter your password.'; // Returning an error message if the password field is empty.
                    } else if (value.length < 6) { // Checking if the password is less than 6 characters.
                      return 'Your password must be at least 6 characters long.'; // Returning an error message if the password is less than 6 characters.
                    }
                    return null; // Returning null if the password is valid.
                  },
                ),
                const SizedBox(height: 5), // Adding a SizedBox for spacing.
                forgotPassword(context), // Adding a "Forgot Password?" option for the user.
                firebaseButton(context, "Sign In", () async { // Creating a button to submit the user's email and password and sign them in.
                  if (_formKey.currentState!.validate()) { // Validating the form.
                    // Signing in the user with Firebase Authentication and retrieving their user auth info.
                    UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    );
                    // Retrieving the user's uid.
                    String? uid = user.user?.uid;
                    // Querying the "Users" collection in Firebase Cloud Firestore using the uid and retrieving the displayName.
                    QuerySnapshot userQuery = await FirebaseFirestore.instance
                        .collection('Users')
                        .where('uid', isEqualTo: uid)
                        .get();
                    displayName = userQuery.docs.first['displayName'];
                    // Navigating to the HomePage after successful sign in.
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(initialIndex: 1,)));
                  }
                }),
                signUpOption() // Adding an option to sign up for the app.
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Code for Sign Up button
  Row signUpOption() { // Creating a Row to display the "Sign Up" option.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Aligning the Row to the center.
      children: [
        const Text("Don't have an account?", // Displaying text for the "Sign Up" option.
            style: TextStyle(color: Colors.black54)),
        GestureDetector( // Adding a GestureDetector to enable user interaction.
          onTap: () { // Creating a callback function for the gesture.
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage())); // Navigating to the SignUpPage when the user taps on the "Sign Up" option.
          },
          child: const Text( // Displaying text for the "Sign Up" option.
            " Sign Up",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }


  //Code for forgotPassword button
  Widget forgotPassword(BuildContext context) { // Creating a function for the "Forgot Password?" option.
    return Container(
      width: MediaQuery.of(context).size.width, // Setting the width of the container to the width of the device screen.
      height: 40, // Setting the height of the container to 40 pixels.
      alignment: Alignment.bottomRight, // Aligning the text to the bottom right of the container.
      child: TextButton( // Creating a TextButton for the "Forgot Password?" option.
          child: const Text( // Adding text to the button.
            "Forgot Password?",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.right, // Aligning the text to the right.
          ),
          onPressed: () => Navigator.push(context, // Navigating to the ResetPassword page when the user taps on the "Forgot Password?" option.
              MaterialPageRoute(builder: (context) => ResetPassword()))
      ),
    );
  }
}
