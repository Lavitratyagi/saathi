import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  Location _location = Location();
  late MapController _mapController;
  LatLng _currentPosition = LatLng(20.5937, 78.9629); // Default to India
  double _currentZoom = 18.0; // Increased for building-level detail

  List<LatLng> heatPoints = []; // Stores heatmap points

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation();
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

    setState(() {
      _currentPosition = LatLng(
        _locationData.latitude ?? 20.5937,
        _locationData.longitude ?? 78.9629,
      );
      _generateHeatmap(_currentPosition); // Generate heatmap points
    });

    _location.onLocationChanged.listen((newLoc) {
      setState(() {
        _currentPosition = LatLng(newLoc.latitude!, newLoc.longitude!);
        _generateHeatmap(_currentPosition);
      });
      _mapController.move(_currentPosition, _currentZoom);
    });
  }

  void _generateHeatmap(LatLng center) {
    setState(() {
      heatPoints = [
        center,
        LatLng(center.latitude + 0.00005, center.longitude + 0.00005),
        LatLng(center.latitude - 0.00005, center.longitude - 0.00005),
        LatLng(center.latitude + 0.00007, center.longitude - 0.00003),
        LatLng(center.latitude - 0.00007, center.longitude + 0.00003),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFEE3030),
        title: Text("Indoor Heatmap"),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition,
          initialZoom: _currentZoom,
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
              return CircleMarker(
                point: point,
                color: Color.fromARGB(135, 221, 92, 92), // Semi-transparent red
                radius: 20, // Adjust radius to control heatmap size
                useRadiusInMeter: true,
              );
            }).toList(),
          ),
          // Marker for Current Position
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: _currentPosition,
                child: Icon(
                  Icons.location_pin,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
