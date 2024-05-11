import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';



class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMapController? mapController;
  final center = LatLng(26.313258, 50.144962); // Kfupm coordinates


  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _addAdMarker();

    // mapController?.onSymbolTapped.add(_onSymbolTapped);
  }

  void _addAdMarker() {
    mapController?.addSymbol(SymbolOptions(
      geometry: LatLng(26.313258, 50.144962), // Ad location
      iconImage: "marker-15", // Default marker icon
      iconSize: 4,
      textField: 'Your Ad Here', // Ad text
      textOffset: Offset(0, 3),
    ));
  }

  void _onSymbolTapped(Symbol symbol) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250, // Adjust the height as needed
          color: Colors.white, // Background color for the sheet
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Vacuum', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10), // For spacing
                Text('824 views', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10), // For spacing
                Text('3 min ago', style: TextStyle(fontSize: 18)),
                // Add more widgets for additional ad information
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Remove the symbol tap listener
    mapController?.onSymbolTapped.remove(_onSymbolTapped);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'), // Optional: provide a title for the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // Pop current screen off the stack
        ),
      ),
      body: MapboxMap(
        accessToken: "pk.eyJ1Ijoib3NhbWFtb3JzeSIsImEiOiJjbHQxdHlhZ3UwbWFkMmxyemM4Y2Q4NHhwIn0.MGm82-efGfGUOo43szgmfA", // Replace with your access token
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: center,
          zoom: 14.0,
        ),
      ),
    );
  }
}