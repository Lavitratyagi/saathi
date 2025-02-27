import 'package:flutter/material.dart';
import 'package:saathi/screens/bottom_nav_bar.dart';

class CreateAccountAttendee extends StatefulWidget {
  const CreateAccountAttendee({super.key});

  @override
  _CreateAccountAttendeeState createState() => _CreateAccountAttendeeState();
}

class _CreateAccountAttendeeState extends State<CreateAccountAttendee> {
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _createAccount() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Transparent AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // No shadow
        title: Row(
          children: [
            Icon(Icons.person, color: Colors.white), // User Icon
            SizedBox(width: 8),
            Text(
              "Create Account",
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
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
                image: AssetImage("assets/images/bg.png"), // Background Image
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
                  // "Create Your Account" Text
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: "Create ", style: TextStyle(color: Colors.black)),
                        TextSpan(text: "Account", style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Aadhar Card Number Field
                  _buildTextField("Aadhar Card Number", aadharController, Icons.credit_card),
                  SizedBox(height: 15),

                  // Full Name Field
                  _buildTextField("Full Name", nameController, Icons.person),
                  SizedBox(height: 15),

                  // Phone Number Field
                  _buildTextField("Phone Number", phoneController, Icons.phone),
                  SizedBox(height: 15),

                  // Password Field
                  _buildTextField("Password", passwordController, Icons.lock, obscureText: true),
                  SizedBox(height: 30),

                  // Create Account Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _createAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Create Account",
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

  // Custom TextField Widget
  Widget _buildTextField(String hintText, TextEditingController controller, IconData icon, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: hintText == "Phone Number" || hintText == "Aadhar Card Number"
          ? TextInputType.number
          : TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(icon, color: Colors.black),
        filled: true,
        fillColor: Colors.transparent, // Transparent Background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 2), // Black Border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2), // Red Border on Focus
        ),
      ),
      style: TextStyle(color: Colors.black), // Text Color
    );
  }
}

