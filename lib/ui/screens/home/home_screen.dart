import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const String GOOGLE_API_KEY = "AIzaSyByuplGDm9Wfby4EFaz25BbTNbgrfDyRjg";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Location _locationController = Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const _kGooglePlex = CameraPosition(
    target: LatLng(42.875639, 74.603806),
    zoom: 13,
  );

  static const _posDestination = LatLng(42.828061, 74.601591);
  static const _posOrigin = LatLng(42.808061, 74.621591);

  LatLng _currentP = LatLng(42.849306, 74.586500);

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) =>
                  _mapController.complete(controller),
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              // Disable default button
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              markers: _getMarkers(),
              polylines: Set<Polyline>.of(polylines.values),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  _cameraToPosition(_currentP);
                },
                child: Icon(Icons.my_location, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Set<Marker> _getMarkers() {
    return {
      Marker(
        markerId: MarkerId("_destinationLocation"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: _posDestination,
        infoWindow: InfoWindow(title: "Destination"),
        onTap: () => _showNavigationSheet(_posDestination),
      ),
      Marker(
        markerId: MarkerId("_originLocation"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: _posOrigin,
        infoWindow: InfoWindow(title: "Origin"),
        onTap: () => _showNavigationSheet(_posOrigin),
      ),
    };
  }

  void _showNavigationSheet(LatLng destination) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Navigate to Destination",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the sheet
                _startNavigation(destination);
              },
              child: const Text("Navigate"),
            ),
          ],
        ),
      ),
    );
  }

  void _startNavigation(LatLng destination) async {
    List<LatLng> coordinates =
        await getPolylinePointsBetween(_currentP, destination);
    generatePolylineFromPoints(coordinates);
  }

  Future<void> _cameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition =
        CameraPosition(target: position, zoom: 15);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          //_cameraToPosition(_currentP);
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    return await getPolylinePointsBetween(_currentP, _posDestination);
  }

  Future<List<LatLng>> getPolylinePointsBetween(
      LatLng origin, LatLng destination) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GOOGLE_API_KEY,
      request: PolylineRequest(
        origin: PointLatLng(origin.latitude, origin.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print("Error: ${result.errorMessage}");
    }
    return polylineCoordinates;
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }
}
