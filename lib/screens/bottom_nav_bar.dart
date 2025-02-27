import 'package:flutter/material.dart';
import 'package:saathi/screens/contacts.dart';
import 'package:saathi/screens/home_screen.dart';
import 'package:saathi/screens/map_screen.dart';
import 'package:saathi/screens/sos.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0; // SOS selected by default

  final List<Widget> _screens = [
    HomeScreen(),
    MapsScreen(),
    SosScreen(),
    ContactsScreen(),
    Center(child: Text('Friends Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              buildNavItem(Icons.home, "Home", 0),
              buildNavItem(Icons.location_pin, "Map", 1),
              SizedBox(width: 48), // Space for the SOS button
              buildNavItem(Icons.contacts, "Contacts", 3),
              buildNavItem(Icons.group, "Friends", 4),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              backgroundColor: Color(0xFFEE3030),
              elevation: 4.0,
              child: Icon(Icons.notifications, color: Colors.white, size: 32),
              onPressed: () {
                setState(() => _currentIndex = 2);
              },
            ),
            SizedBox(height: 4),
            Text(
              "SOS",
              style: TextStyle(
                color: Color(0xFFEE3030),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _currentIndex == index ? Color(0xFFEE6262) : Color(0xFF802020),
          ),
          Text(
            label,
            style: TextStyle(
              color: _currentIndex == index ? Color(0xFFEE6262) : Color(0xFF802020),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
