import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LiveMapScreen extends StatefulWidget {
  @override
  _LiveMapScreenState createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  late IOWebSocketChannel channel;
  StreamSubscription<LocationData>? _locationSubscription;

  LatLng _currentPosition = LatLng(0,0); // Default (India)
  double _currentZoom = 15.0;
  String username = "Unknown";
  bool _shouldFollowUser = true; // Track if map should auto-follow user

  Map<String, LatLng> users = {};
  Map<String, Color> userColors = {};

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('user_name') ?? "User${Random().nextInt(1000)}";
    });
    username = prefs.getString('user_name')!;
    print(username);
    _connectToWebSocket();
    _getUserLocation();
  }

  void _connectToWebSocket() {
    channel = IOWebSocketChannel.connect("ws://192.168.207.212:8000/broadcast/location");

    channel.stream.listen((message) {
      Map<String, dynamic> data = jsonDecode(message);
      String receivedUser = data['username'];
      double lat = data['lat'];
      double lon = data['lon'];

      if (!userColors.containsKey(receivedUser)) {
        userColors[receivedUser] = _getRandomColor();
      }

      if (mounted) {
        setState(() {
          users[receivedUser] = LatLng(lat, lon);
        });
      }
    }, onError: (error) {
      print("WebSocket error: $error");
    }, onDone: () {
      print("WebSocket connection closed");
    });
  }

  Future<void> _getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _locationData = await _location.getLocation();

    if (mounted) {
      setState(() {
        _currentPosition = LatLng(
          _locationData.latitude ?? 20.5937,
          _locationData.longitude ?? 78.9629,
        );
        users[username] = _currentPosition;
        userColors[username] = _getRandomColor();
      });

      // Move map to user's location initially
      if (_shouldFollowUser) {
        _mapController.move(_currentPosition, _currentZoom);
      }
    }

    _sendLocationToServer();

    _locationSubscription = _location.onLocationChanged.listen((newLoc) {
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(newLoc.latitude!, newLoc.longitude!);
          users[username] = _currentPosition;
        });

        // Move map only if user hasn't manually moved it
        if (_shouldFollowUser) {
          _mapController.move(_currentPosition, _currentZoom);
        }
      }
      _sendLocationToServer();
    });
  }

  void _sendLocationToServer() {
    if (channel.sink != null) {
      Map<String, dynamic> locationData = {
        'username': username,
        'lat': _currentPosition.latitude,
        'lon': _currentPosition.longitude,
      };
      channel.sink.add(jsonEncode(locationData));
    }
  }

  Color _getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEE3030),
        title: Text("Live Location Sharing"),
      ),
      body: Column(
        children: [
          // Legend - Shows usernames and colors
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: users.keys.map((user) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: userColors[user] ?? Colors.grey,
                        radius: 10,
                      ),
                      SizedBox(height: 4),
                      Text(user, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition,
                initialZoom: _currentZoom,
                onMapEvent: (event) {
                  if (event is MapEventMoveEnd) {
                    _shouldFollowUser = false; // Stop auto-centering after user moves map
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: users.entries.map((entry) {
                    return Marker(
                      width: 60.0,
                      height: 60.0,
                      point: entry.value,
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: userColors[entry.key] ?? Colors.red,
                            size: 40,
                          ),
                          Text(
                            entry.key,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
