import 'package:cloud_firestore/cloud_firestore.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = FirebaseFirestore.instance;


  @override
  //We return a Widget and the build function is whats builds our widget tree.
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(25, MediaQuery.of(context).size.height * 0.2, 25, 0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const Text("FitHub", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailTextController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    } else if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordTextController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 19.0, horizontal: 16.0),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    } else if (value.length < 6) {
                      return 'Your password must be at least 6 characters long.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                forgotPassword(context),
                firebaseButton(context, "Sign In", () async {
                  if (_formKey.currentState!.validate()) {
                    //Sign in the user with auth and get the user auth info back
                    UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    );
                    //Get the user's uid
                    String? uid = user.user?.uid;
                    //Query the "Users" collection in Firestore using the uid and retrieve the displayName
                    QuerySnapshot userQuery = await FirebaseFirestore.instance
                        .collection('Users')
                        .where('uid', isEqualTo: uid)
                        .get();
                    String displayName = userQuery.docs.first['displayName'];

                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                  }
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
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
      height: 40,
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