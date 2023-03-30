import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../HomePage.dart';
import '../ReusableWidgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //This allows for access to user input from email, password and username text boxes
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                padding: EdgeInsets.fromLTRB(25, 120, 25, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Username", Icons.person_outline, false,
                        _userNameTextController),
                    const SizedBox(height: 20),
                    reusableTextField("Enter Email", Icons.email_outlined, false,
                        _emailTextController),
                    const SizedBox(height: 20),
                    reusableTextField("Enter Password", Icons.lock_outlined, true,
                        _passwordTextController),
                    const SizedBox(height: 20),
                    firebaseButton(context, "Sign Up", () {
                      FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailTextController.text,
                          password: _passwordTextController.text).then((value) {
                      print("Created New Account");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                      });
                    })
                  ],
                ),
              ))),
    );
  }
}
