import 'package:flutter/material.dart';
import 'FeatureSections/ChatBot/ChatBot.dart';
import 'FeatureSections/FoodTracker/Screens/FoodTracker.dart';
import 'FeatureSections/More.dart';
import 'FeatureSections/SocialMedia/SocialMedia.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  HomePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Index of currently selected tab.

  @override
  void initState() { // Initializing the state of the widget.
    super.initState();
    _selectedIndex = widget.initialIndex; // Setting the initial tab index.
  }

  Widget build(BuildContext context) { // Defining the layout for the widget.
    const List<Widget> _pages = <Widget>[FoodTracker(), SocialMedia(), ChatBot()]; // Creating a list of the tabs available in the app.

    return Scaffold( // Creating a Scaffold to provide a layout structure for the app.
      appBar: AppBar( // Creating an AppBar for the app.
        title: const Text("FitHub"), // Setting the title of the AppBar.
        centerTitle: true, // Centering the title of the AppBar.
        backgroundColor: Colors.green, // Setting the background color of the AppBar.
        automaticallyImplyLeading: false, // Disabling the back button in the AppBar.
        actions: [ // Adding action buttons to the AppBar.
          IconButton(
            icon: const Icon(Icons.more_horiz), // Adding an icon for the button.
            onPressed: () { // Adding an onPressed event for the button.
              Navigator.of(context).push(_createMorePageRoute()); // Navigating to the More screen when the button is pressed.
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar( // Creating a bottom navigation bar for the app.
        iconSize: 25, // Setting the size of the icons in the bottom navigation bar.
        selectedFontSize: 10, // Setting the size of the selected tab label in the bottom navigation bar.
        selectedIconTheme: const IconThemeData(color: Colors.blueAccent, size: 30), // Setting the color and size of the selected tab icon in the bottom navigation bar.
        selectedItemColor: Colors.blue, // Setting the color of the selected tab label in the bottom navigation bar.
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold), // Setting the style of the selected tab label in the bottom navigation bar.
        type: BottomNavigationBarType.fixed, // Setting the type of the bottom navigation bar.
        items: const <BottomNavigationBarItem>[ // Adding tabs to the bottom navigation bar.
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank_outlined), // Adding an icon for the Food Tracker tab.
            label: 'Food Tracker', // Adding a label for the Food Tracker tab.
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_android), // Adding an icon for the Social Media tab.
            label: 'Social Media', // Adding a label for the Social Media tab.
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.computer), // Adding an icon for the Chat Bot tab.
            label: 'Chat Bot', // Adding a label for the Chat Bot tab.
          ),
        ],
        currentIndex: _selectedIndex, // Setting the current tab index.
        onTap: _onItemTapped, // Adding an onTap event for the tabs.
      ),
      body: IndexedStack( // Creating an IndexedStack to display the content of the tabs.
        index: _selectedIndex, // Setting the current tab index.
        children: _pages, // Adding the content of the tabs to the IndexedStack.
      ),
    );
  }

  void _onItemTapped(int index) { // Defining the behavior when a tab is tapped.
    setState(() { // Updating the state of the widget.
      _selectedIndex = index; // Setting the new tab index.
    });
  }

  Route _createMorePageRoute() { // Defining the behavior for navigating to the More screen.
    return PageRouteBuilder( // Creating a PageRouteBuilder to animate the transition to the More screen.
      pageBuilder: (context, animation, secondaryAnimation) => const More(), // Creating the More screen.
      transitionsBuilder: (context, animation, secondaryAnimation, child) { // Creating the animation for the transition to the More screen.
        var begin = const Offset(1.0, 0.0); // Setting the initial position of the More screen.
        var end = Offset.zero; // Setting the final position of the More screen.
        var curve = Curves.ease; // Defining the curve of the animation.

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve)); // Creating a Tween to animate the transition.

        return SlideTransition( // Creating a SlideTransition to animate the transition.
          position: animation.drive(tween), // Applying the Tween to the animation.
          child: child, // Displaying the child widget during the transition.
        );
      },
    );
  }
}
