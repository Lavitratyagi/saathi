import 'package:flutter/material.dart';
import 'package:saathi/screens/account_type.dart';
import 'package:saathi/screens/bottom_nav_bar.dart';
import 'package:saathi/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() async {
    bool success = await ApiService.login(
      aadhar: aadharController.text,
      password: passwordController.text,
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please check your credentials.')),
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
          children: [
            Icon(Icons.lock_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Login Account",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // "SaAthi" Text
                  RichText(
                    text: TextSpan(
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: "Sa", style: TextStyle(color: Colors.black)),
                        TextSpan(text: "Athi", style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),

                  // Aadhaar Number Text Field
                  TextField(
                    controller: aadharController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Aadhaar Number",
                      prefixIcon: Icon(Icons.credit_card),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Password Text Field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Create Account Text
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AccountType()),
                      );
                    },
                    child: Text(
                      "Not registered yet? Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
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
