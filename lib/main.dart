import 'package:flutter/material.dart';
import 'HomePage.dart';

//MaterialApp is our root widget.
void main() => runApp(const MaterialApp(
    //Our LogIn widget we made is what appears on the home page.
    home: LogIn(),
  ));

//We create our own widget "LogIn" as it enables hot reload and makes our code reusable.
class LogIn extends StatelessWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  //We return a Widget and the build function is whats builds our widget tree.
  Widget build(BuildContext context) {
    //The Scaffold widget allows us to create a layout in our app.
    return Scaffold(
      appBar: AppBar(
        title: const Text("FitHub"),
        centerTitle: true,
      ),

      //The Center widget physically centers our items.
      body: Center(
        //We use a Column widget as it allows us to use multiple text boxes and buttons.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //Code for "Email" text box
            const SizedBox(
              width: 300,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 10),

            //Code for "Password" text box
            const SizedBox(
              width: 300,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  labelStyle: TextStyle(fontSize: 20)
                ),
              ),
            ),
            const SizedBox(height: 15),

            //Code for "Log In" button
            SizedBox(
              width: 300,
              height: 30,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const HomePage();
                    })
                    );
                  },
                  child: const Text("Log In",
                  style: TextStyle(fontSize: 18),),
              ),
            ),

            //Code for "Sign Up" button
            TextButton(
                onPressed: () {  },
                child: const Text("Sign Up"),
              ),

            TextButton(
              onPressed: () {  },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text("Forgot Password?"),
            )
          ],
        ),
      ),
    );
  }
}

