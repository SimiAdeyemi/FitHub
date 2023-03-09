import 'package:flutter/material.dart';
import 'package:group_project/ChatBot.dart';
import 'package:group_project/FoodTracker.dart';
import 'package:group_project/SocialMedia.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  //This allows us to do our coding in separate files for each function of the app.
  static const List<Widget> _pages = <Widget>[FoodTracker(), SocialMedia(), ChatBot()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),

        //This widget is how we get a tab bar at the bottom of the screen
        bottomNavigationBar: BottomNavigationBar(
          //Stylistic changes: Making icon appear bigger when selected, among other things
          iconSize: 25,
          selectedFontSize: 10,
          selectedIconTheme: const IconThemeData(color: Colors.blueAccent, size: 30),
          selectedItemColor: Colors.blue,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

          //Displays a tab bar at bottom of screen containing icons and labels
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank_outlined),
              label: 'Food Tracker',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.phone_android),
              label: 'Social Media',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.computer),
              label: 'Chat Bot',
            ),
          ],
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped,
        ),

        //IndexedStack allows us to preserve the state in a tab after another has been selected
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        )
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
