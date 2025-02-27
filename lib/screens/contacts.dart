import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEE3030),
        title: Text("Contacts"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: "Your Contacts"),
            Tab(text: "Emergency Contacts"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildYourContactsTab(),
          buildEmergencyContactsTab(),
        ],
      ),
    );
  }

  Widget buildYourContactsTab() {
    final yourContacts = [
      {'name': 'Mom', 'phone': '+91 9876543210'},
      {'name': 'Dad', 'phone': '+91 9123456780'},
      {'name': 'Brother', 'phone': '+91 9012345678'},
      {'name': 'Sister', 'phone': '+91 9098765432'},
    ];

    return ListView.builder(
      itemCount: yourContacts.length,
      itemBuilder: (context, index) {
        return buildContactTile(
          yourContacts[index]['name']!,
          yourContacts[index]['phone']!,
          Icons.person,
        );
      },
    );
  }

  Widget buildEmergencyContactsTab() {
    final emergencyContacts = [
      {'name': 'National Commission for Women Helpline', 'phone': '1091'},
      {'name': 'Police Station', 'phone': '100'},
      {'name': 'Ambulance/Medical', 'phone': '102'},
      {'name': 'Fire Emergency', 'phone': '101'},
      {'name': 'Women Helpline (All India)', 'phone': '181'},
    ];

    return ListView.builder(
      itemCount: emergencyContacts.length,
      itemBuilder: (context, index) {
        return buildContactTile(
          emergencyContacts[index]['name']!,
          emergencyContacts[index]['phone']!,
          Icons.local_phone,
        );
      },
    );
  }

  Widget buildContactTile(String name, String phone, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFFEE6262),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(phone),
        trailing: IconButton(
          icon: Icon(Icons.call, color: Color(0xFFEE3030)),
          onPressed: () {
            // Placeholder for call functionality
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Calling $name...")),
            );
          },
        ),
      ),
    );
  }
}
