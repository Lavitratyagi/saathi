import 'package:flutter/material.dart';
import 'package:saathi/screens/contacts.dart';
import 'package:saathi/screens/event_list.dart';
import 'package:saathi/screens/map_screen.dart';
import 'package:saathi/screens/saathi_finder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saathi/services/api_service.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Loading...";
  String? aadharNumber;

  @override
  void initState() {
    super.initState();
    loadAadharAndFetchUser();
  }

  Future<void> loadAadharAndFetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    final storedAadhar = prefs.getString('aadhar');

    if (storedAadhar != null) {
      setState(() {
        aadharNumber = storedAadhar;
      });
      fetchUserName(storedAadhar);
    } else {
      setState(() {
        userName = "Aadhaar not found";
      });
    }
  }

  Future<void> fetchUserName(String aadhar) async {
    String? fetchedName = await ApiService.fetchUserName(aadhar);
    setState(() {
      userName = fetchedName ?? "User not found";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xF6F6D8D8),
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Sa',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextSpan(
                text: 'Athi',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                ),
                const SizedBox(height: 10),
                Text(
                  'Hi, $userName!!',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                menuCard(Icons.app_registration, 'Registration', RegistrationScreen()),
                menuCard(Icons.location_on, 'Saathi Locator', LiveMapScreen()),
                menuCard(Icons.warning, 'HotSpots', MapsScreen()),
                menuCard(Icons.contact_phone, 'Emergency Contacts', ContactsScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget menuCard(IconData icon, String title, Widget screen) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        leading: Icon(icon, size: 30, color: Colors.redAccent),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
