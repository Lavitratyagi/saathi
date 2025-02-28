import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  late IOWebSocketChannel channel;
  StreamSubscription<LocationData>? _locationSubscription;

  LatLng _currentPosition = LatLng(20.5937, 78.9629); // Default to India
  double _currentZoom = 15.0;
  bool _shouldFollowUser = true; // Move to user location only the first time
  Map<String, LatLng> users = {}; // Stores user locations
  List<LatLng> heatPoints = []; // Stores heatmap points

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
    _getUserLocation();
  }

  void _connectToWebSocket() {
    channel = IOWebSocketChannel.connect(
        "ws://192.168.207.212:8000/broadcast/location");

    channel.stream.listen((message) {
      Map<String, dynamic> data = jsonDecode(message);
      String receivedUser = data['username'];
      double lat = data['lat'];
      double lon = data['lon'];

      if (mounted) {
        setState(() {
          users[receivedUser] = LatLng(lat, lon);
          _updateHeatmap();
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
        users["You"] = _currentPosition;
        _updateHeatmap();
      });

      if (_shouldFollowUser) {
        _mapController.move(_currentPosition, _currentZoom);
        _shouldFollowUser = false; // Stop auto-following after first move
      }
    }

    _sendLocationToServer();

    _locationSubscription = _location.onLocationChanged.listen((newLoc) {
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(newLoc.latitude!, newLoc.longitude!);
          users["You"] = _currentPosition;
          _updateHeatmap();
        });
      }
      _sendLocationToServer();
    });
  }

  void _sendLocationToServer() {
    if (channel.sink != null) {
      Map<String, dynamic> locationData = {
        'username': "You",
        'lat': _currentPosition.latitude,
        'lon': _currentPosition.longitude,
      };
      channel.sink.add(jsonEncode(locationData));
    }
  }

  void _updateHeatmap() {
    setState(() {
      heatPoints = users.values.toList();
    });
  }

  double _calculateIntensity(LatLng point) {
    int count = users.values.where((p) {
      return _haversineDistance(point, p) < 50; // 50 meters range for intensity
    }).length;

    return (count / 10).clamp(0.2, 1.0); // Intensity capped between 0.2 and 1.0
  }

  /// Haversine formula to calculate distance between two LatLng points in meters
  double _haversineDistance(LatLng p1, LatLng p2) {
    const double R = 6371000; // Earth radius in meters
    double dLat = _degreesToRadians(p2.latitude - p1.latitude);
    double dLon = _degreesToRadians(p2.longitude - p1.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(p1.latitude)) *
            cos(_degreesToRadians(p2.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
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
        title: Text("Live Heatmap"),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition,
          initialZoom: _currentZoom,
          onMapEvent: (event) {
            if (event is MapEventMoveEnd) {
              _shouldFollowUser = false;
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          // Heatmap Layer using CircleLayer
          CircleLayer(
            circles: heatPoints.map((point) {
              double intensity = _calculateIntensity(point);
              return CircleMarker(
                point: point,
                color: Color.fromARGB((255 * intensity).toInt(), 221, 92, 92),
                radius: 30 * intensity,
                useRadiusInMeter: true,
              );
            }).toList(),
          ),
          // Marker Layer for Users
          MarkerLayer(
            markers: users.entries.map((entry) {
              return Marker(
                width: 60.0,
                height: 60.0,
                point: entry.value,
                child: Icon(
                  Icons.location_pin,
                  color: entry.key == "You" ? Colors.blue : Colors.red,
                  size: 40,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
