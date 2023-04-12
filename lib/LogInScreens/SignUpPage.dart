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
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                padding: const EdgeInsets.fromLTRB(25, 120, 25, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _userNameTextController,
                        decoration: const InputDecoration(
                          labelText: "Enter Username",
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailTextController,
                        decoration: const InputDecoration(
                          labelText: "Enter Email",
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordTextController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Enter Password",
                          prefixIcon: Icon(Icons.lock_outlined),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password.';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      firebaseButton(context, "Sign Up", () async {
                         if (_formKey.currentState!.validate()) {
                            FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text).then((value) {
                                print("Created New Account");
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                          }).onError((error, stackTrace) {
                              print("Error ${error.toString()}");
                            });
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
}

