import 'package:flutter/material.dart';
import 'FeatureSections/ChatBot.dart';
import 'FeatureSections/FoodTracker/FoodTracker.dart';
import 'FeatureSections/More.dart';
import 'FeatureSections/SocialMedia.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const List<Widget> _pages = <Widget>[SocialMedia(), FoodTracker(), ChatBot(), More()];

    return Scaffold(
      appBar: AppBar(
        title: const Text("FitHub"),
        centerTitle: true,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        selectedFontSize: 10,
        selectedIconTheme: const IconThemeData(color: Colors.blueAccent, size: 30),
        selectedItemColor: Colors.blue,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_android),
            label: 'Social Media',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_outlined),
            label: 'Food Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.computer),
            label: 'Chat Bot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_outlined),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

