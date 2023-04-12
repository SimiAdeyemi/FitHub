import 'package:flutter/material.dart';

  //Reusable widget that allows us the create multiple text fields more efficiently.
TextFormField reusableTextField(String text, IconData icon, bool isPasswordType, TextEditingController controller, String? Function(String?) validator) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordType,
    decoration: InputDecoration(
      labelText: text,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
    ),
    validator: validator,
  );
}

//Reusable widget that allows us the create multiple buttons more efficiently.
  Container firebaseButton(
      BuildContext context, String title, Function onTap) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return Colors.green;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.black87, fontSize: 16),
        ),
      ),
    );
  }
