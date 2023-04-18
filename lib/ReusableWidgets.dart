import 'package:flutter/material.dart';

//Reusable widget that allows us the create multiple buttons more efficiently.
Container firebaseButton(
    BuildContext context, // The context in which the button is created
    String title, // The text to display in the button
    Function onTap, // The function to call when the button is tapped
    ) {
  return Container(
    width: MediaQuery.of(context).size.width, // Sets the button width to the device width
    height: 50, // Sets the button height
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20), // Adds some margin to the button
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)), // Sets the button border radius
    child: ElevatedButton(
      onPressed: () {
        onTap(); // Calls the onTap function when the button is pressed
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) { // Changes the button color when pressed
              return Colors.black26;
            }
            return Colors.green; // Sets the default button color
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)) // Sets the button shape
          )
      ),
      child: Text(
        title, // Displays the button text
        style: const TextStyle(
            color: Colors.black87, // Sets the text color
            fontSize: 16 // Sets the text size
        ),
      ),
    ),
  );
}
