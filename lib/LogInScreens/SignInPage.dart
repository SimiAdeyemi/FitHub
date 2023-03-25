import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_project/HomePage.dart';
import 'package:group_project/LogInScreens/ResetPassword.dart';
import 'package:group_project/LogInScreens/SignUpPage.dart';
import '../ReusableWidgets.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  //This allows for access to user input from email and password text boxes
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  //We return a Widget and the build function is whats builds our widget tree.
  Widget build(BuildContext context) {
    //The Scaffold widget allows us to create a layout in our app.
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(25, MediaQuery.of(context).size.height * 0.2, 25, 0),
            child: Column( //Allows us to display multiple items vertically
              children: <Widget>[
                const Text("FitHub", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 10),
                reusableTextField("Email", Icons.email_outlined, false, _emailTextController),
                const SizedBox(height: 10),
                reusableTextField("Password", Icons.lock_outline, true, _passwordTextController),
                const SizedBox(height: 5),
                forgotPassword(context),
                firebaseButton(context, "Sign In", () { //when pressed the values are checked if account exists in Firebase
                  FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text).then((value) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
                signUpOption()
              ],
            ),
          ),
        )
    );
  }

  //Code for Sign Up button
  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Colors.black54)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpPage()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  //Code for forgotPassword button
  Widget forgotPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.right,
          ),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ResetPassword()))
      ),
    );
  }

}