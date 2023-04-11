import 'package:flutter/material.dart';

class SocialMedia extends StatelessWidget {
  const SocialMedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          child: const Text("Upload"),
          onPressed: () {
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            elevation: 0,
          ),

        ),
      ),
    );
  }







}//entire class
