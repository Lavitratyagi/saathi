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

    if (response.statusCode == 200) {
      return true; // Login successful
    } else {
      return false; // Login failed
    }
  }
}
