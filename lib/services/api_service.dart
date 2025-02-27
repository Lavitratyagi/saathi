import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://192.168.207.212:8000';

  static Future<bool> createAccount(
      {required String aadhar,
      required String name,
      required String phoneNumber,
      required String password,
      required List<String> emergencyContacts}) async {
    final url = Uri.parse('$_baseUrl/account/create');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "aadhar": aadhar,
      "name": name,
      "phone_number": phoneNumber,
      "password": password,
      "emergency": emergencyContacts,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return true; // Success
      } else {
        return false; // Failure
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<bool> login({
    required String aadhar,
    required String password,
  }) async {
    final url =
        Uri.parse('$_baseUrl/account/login?aadhar=$aadhar&password=$password');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    if (response.body == 'true') {
      return true; // Login successful
    } else {
      return false; // Login failed
    }
  }
  static Future<String?> fetchUserName(String aadhar) async {
    final url = Uri.parse('$_baseUrl/account/info?aadhar=$aadhar');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Ensure the response contains the expected key
        if (data.containsKey('name')) {
          return data['name']; // Return the fetched username
        } else {
          return "Name not found";
        }
      } else {
        return "Failed to fetch user info: ${response.statusCode}";
      }
    } catch (e) {
      return "Error fetching user info: $e";
    }
  }
}
