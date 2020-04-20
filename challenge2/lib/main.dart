import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp() : super();
  final String title = "Google Maps";

  @override
  MapsState createState() => MapsState();
}

class MapsState extends State<MyApp> {
  @override
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(3.597031, 98.678513);
  final Set<Marker> _markers = {};
  LatLng _lastPosition = _center;
  MapType _currentMapType = MapType.normal;

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
  }

  _onMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onAddMark() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_lastPosition.toString()),
          position: _lastPosition,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  Widget Button(Function function, IconData iconData) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.pink,
      child: Icon(
        iconData,
        size: 36.0,
      ),
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: Colors.pink,
          ),
          body: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: _center, zoom: 11.0),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget>[
                      Button(_onMapType, Icons.map),
                      SizedBox(
                        height: 16.0,
                      ),
                      Button(_onAddMark, Icons.add_location),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
