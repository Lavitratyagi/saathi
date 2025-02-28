import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

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

  static final String buzzerUrl = "http://192.168.207.18/buzzer";
  static final String imageUrl = "http://192.168.207.18/capture";
  static final String websocketUrl =
      "ws://192.168.207.212:8000/broadcast/image";

  static Future<bool> sendSOS() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.207.18/buzzer"),
      );

      // Connect to WebSocket
      final channel = IOWebSocketChannel.connect(websocketUrl);
      print("WebSocket connected...");

      for (int i = 0; i < 10; i++) {
        try {
          print("Fetching image $i...");

          final imageResponse = await http.get(Uri.parse(imageUrl));

          if (imageResponse.statusCode == 200) {
            try {
              Uint8List imageBytes = imageResponse.bodyBytes;
              print("Image decoded successfully!");

              // Send image via WebSocket
              channel.sink.add(imageBytes);
              print("Image $i sent via WebSocket.");
            } catch (decodeError) {
              print("Base64 Decoding Error: $decodeError");
            }
          } else {
            print(
                "Image request failed with status: ${imageResponse.statusCode}");
          }
        } catch (httpError) {
          print("Error fetching image: $httpError");
        }

        await Future.delayed(Duration(seconds: 5));
      }

      channel.sink.close();
      print("WebSocket closed.");
      return true;
    } catch (e) {
      print("Error in SOS process: $e");
      return false;
    }
  }
}
