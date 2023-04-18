import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../ReusableWidgets.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailTextController = TextEditingController(); // Initializing a TextEditingController to retrieve user input from the email field.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Initializing a GlobalKey to identify the form and validate the input.

  @override
  Widget build(BuildContext context) { // Defining the layout for the widget.
    return Scaffold( // Creating a Scaffold to provide a layout structure for the app.
      extendBodyBehindAppBar: true, // Extending the app bar behind the body of the screen.
      appBar: AppBar( // Creating an AppBar for the screen.
        backgroundColor: Colors.green, // Setting the background color of the AppBar.
        elevation: 0, // Removing the elevation of the AppBar.
        title: const Text( // Adding a title to the AppBar.
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container( // Creating a Container to hold the content of the screen.
        width: MediaQuery.of(context).size.width, // Setting the width of the Container to the width of the screen.
        height: MediaQuery.of(context).size.height, // Setting the height of the Container to the height of the screen.
        child: SingleChildScrollView( // Creating a SingleChildScrollView to enable scrolling.
          child: Padding( // Adding padding to the SingleChildScrollView.
            padding: const EdgeInsets.fromLTRB(25, 120, 25, 0), // Setting the padding for the content.
            child: Form( // Creating a Form to retrieve user input.
              key: _formKey, // Setting the GlobalKey for the Form.
              child: Column( // Creating a Column to display the content.
                children: <Widget>[
                  const SizedBox( // Adding a SizedBox for spacing.
                    height: 20,
                  ),
                  TextFormField( // Creating a TextFormField for the email field.
                    controller: _emailTextController, // Setting the TextEditingController for the email field.
                    decoration: const InputDecoration( // Adding decoration to the email field.
                      labelText: "Enter Email", // Adding a label for the email field.
                      prefixIcon: Icon(Icons.email_outlined), // Adding an icon for the email field.
                      border: OutlineInputBorder(), // Adding a border to the email field.
                      contentPadding: EdgeInsets.symmetric(vertical: 19.0, horizontal: 16.0), // Adding padding to the content of the email field.
                    ),
                    validator: (value) { // Adding a validator to the email field.
                      if (value == null || value.isEmpty) { // Checking if the email field is empty.
                        return 'Please enter your email.'; // Returning an error message if the email field is empty.
                      } else if (!RegExp(r'^[\w-d]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) { // Validating the format of the email.
                        return 'Please enter a valid email address.'; // Returning an error message if the email format is invalid.
                      }
                      return null; // Returning null if the email is valid.
                    },
                  ),
                  const SizedBox( // Adding a SizedBox for spacing.
                    height: 20,
                  ),
                  firebaseButton(context, "Reset Password", () async { // Creating a custom button to reset the user's password.
                    if (_formKey.currentState!.validate()) { // Validating the form input.
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailTextController.text); // Sending the password reset email to the user's email address.
                        Navigator.of(context).pop(); // Navigating back to the previous screen after the email is sent.
                      } on FirebaseAuthException catch (e) { // Handling Firebase authentication exceptions.
                        if (e.code == 'user-not-found') { // Displaying an error message if the user is not found.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('This email is not registered.'),
                            ),
                          );
                        } else { // Displaying an error message for any other authentication error.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('There was an error resetting the password. Please try again later.'),
                            ),
                          );
                        }
                      } catch (e) { // Displaying an error message for any other error.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('There was an error resetting the password. Please try again later.'),
                          ),
                        );
                      }
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

