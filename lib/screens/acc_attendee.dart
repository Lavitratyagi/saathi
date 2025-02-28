import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saathi/screens/bottom_nav_bar.dart';
import 'package:saathi/services/api_service.dart';

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

  // Function to store Aadhar number and Name in SharedPreferences
  Future<void> _storeUserData(String aadhar, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('aadhar', aadhar);
    await prefs.setString('user_name', name);
  }

  // Function to create an account and store Aadhar number & Name
  void _createAccount() async {
    bool success = await ApiService.createAccount(
      aadhar: aadharController.text,
      name: nameController.text,
      phoneNumber: phoneController.text,
      password: passwordController.text,
      emergencyContacts: [], // Add emergency contacts if needed
    );
    print(success);

    if (success) {
      print("Success");
      await _storeUserData(aadharController.text, nameController.text); // Store data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavScreen()),
      );
    } else {
      print("Failed");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create account.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.person, color: Colors.white),
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
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
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
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: "Create ", style: TextStyle(color: Colors.black)),
                        TextSpan(text: "Account", style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildTextField("Aadhar Card Number", aadharController, Icons.credit_card),
                  const SizedBox(height: 15),

                  _buildTextField("Full Name", nameController, Icons.person),
                  const SizedBox(height: 15),

                  _buildTextField("Phone Number", phoneController, Icons.phone),
                  const SizedBox(height: 15),

                  _buildTextField("Password", passwordController, Icons.lock, obscureText: true),
                  const SizedBox(height: 30),

                  Center(
                    child: ElevatedButton(
                      onPressed: _createAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
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
  Widget _buildTextField(
      String hintText, TextEditingController controller, IconData icon,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType:
          hintText == "Phone Number" || hintText == "Aadhar Card Number"
              ? TextInputType.number
              : TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black),
        prefixIcon: Icon(icon, color: Colors.black),
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
