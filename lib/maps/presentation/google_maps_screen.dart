import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({super.key});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  var myMarkers = HashSet<Marker>();
  late BitmapDescriptor customMarker;

  getCustomMarker() async {
    customMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      'assets/images/custom_marker.png',
    );
  }

  Set<Polygon> myPolygon() {
    List<LatLng> polygonCoords = [];
    polygonCoords.add(const LatLng(37.43296265331129, -122.08832357078792));
    polygonCoords.add(const LatLng(37.43006265331129, -122.08832357078792));
    polygonCoords.add(const LatLng(37.43006265331129, -122.08332357078792));
    polygonCoords.add(const LatLng(37.43296265331129, -122.08832357078792));

    var polygonSet = <Polygon>{};
    polygonSet.add(
      Polygon(
        polygonId: const PolygonId('test'),
        points: polygonCoords,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.4),
      ),
    );
    return polygonSet;
  }

  Set<Circle> circles = {
    Circle(
      circleId: const CircleId('1'),
      center: const LatLng(37.43296265331129, -122.08832357078792),
      radius: 1000,
      strokeWidth: 2,
      strokeColor: Colors.green,
      fillColor: Colors.green.withOpacity(0.4),
    ),
  };

  List<Polyline> myPolylines = [];

  createPolylines() {
    myPolylines.add(
      Polyline(
        polylineId: const PolylineId('1'),
        color: Colors.red,
        width: 2,
        patterns: [
          PatternItem.dash(10),
          PatternItem.gap(10),
        ],
        points: const [
          LatLng(37.43296265331129, -122.08832357078792),
          LatLng(37.43496265331129, -122.08032357078792)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCustomMarker();
    createPolylines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Google Maps",
        ),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.43296265331129, -122.08832357078792),
          zoom: 14.4746,
        ),
        onMapCreated: (controller) {
          setState(() {
            myMarkers.add(
              Marker(
                markerId: const MarkerId("1"),
                position: const LatLng(37.43296265331129, -122.08832357078792),
                infoWindow: InfoWindow(
                  title: "Dakahlya",
                  snippet: "kasjfkmcnkncknef",
                  onTap: () {
                    debugPrint("Marker Tapped");
                  },
                ),
                //icon: customMarker,
              ),
            );
          });
        },
        markers: myMarkers,
        polygons: myPolygon(),
        circles: circles,
        polylines: myPolylines.toSet(),
      ),
    );
  }
}
///Circles-polygons-Markers-Polylines