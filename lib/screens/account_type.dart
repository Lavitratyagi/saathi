import 'package:flutter/material.dart';
import 'package:saathi/screens/acc_attendee.dart';

class AccountType extends StatefulWidget {
  const AccountType({super.key});

  @override
  _AccountTypeState createState() => _AccountTypeState();
}

class _AccountTypeState extends State<AccountType> {
  String accountType = "Attendee"; // Default selected type

  void _navigateToNextPage() {
    if (accountType == "Admin") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AdminPage()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccountAttendee()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Transparent AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Removes shadow
        title: Row(
          children: [
            Icon(Icons.person_add, color: Colors.white), // Icon next to text
            SizedBox(width: 8),
            Text(
              "Create Account",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"), // Same background
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Type of Account" Text
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text: "Type of ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: "Account",
                              style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32),

                  // Admin Selection Box
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        accountType = "Admin";
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent, // Transparent background
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.black, width: 2), // Black border
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.admin_panel_settings, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            "Admin",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          Spacer(),
                          Icon(
                            accountType == "Admin"
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // User Selection Box
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        accountType = "Attendee";
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent, // Transparent background
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.black, width: 2), // Black border
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            "Attendee",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          Spacer(),
                          Icon(
                            accountType == "Attendee"
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Continue Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _navigateToNextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy Pages (Replace with actual pages)
class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Admin Page")),
    );
  }
}

