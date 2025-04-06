import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  MapsCubit() : super(MapsInitial()){
    emit(MapsInitial(polylines: {}));
  }
  Map<PolylineId, Polyline> polylines = {};
  static const String GOOGLE_API_KEY =
      "AIzaSyByuplGDm9Wfby4EFaz25BbTNbgrfDyRjg";

  Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  static const _posDestination = LatLng(42.828061, 74.601591);
  static const _posOrigin = LatLng(42.808061, 74.621591);

 // bool isLocated = false;
  LatLng currentP = LatLng(42.828061, 74.991591);

  Future<void> cameraToPosition(
    LatLng position,
  ) async {
    final GoogleMapController controller = await mapController.future;
    CameraPosition _newCameraPosition =
        CameraPosition(target: position, zoom: 15);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates(Location locationController) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        currentP =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        // if(currentP != null){
        //   isLocated = true;
        // }
        //cameraToPosition(currentP!);
      }
    });
  }

  void startNavigation(LatLng destination) async {
    List<LatLng> coordinates =
        await getPolylinePointsBetween(currentP!, destination);
    print(coordinates);
    generatePolylineFromPoints(coordinates);
  }

  Future<List<LatLng>> getPolylinePoints() async {
    return await getPolylinePointsBetween(currentP!, _posDestination);
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

    polylines[id] = polyline;
    emit(MapsInitial(polylines: Map.of(polylines)));
  }

  Set<Marker> getMarkers(BuildContext context) {
    return {
      Marker(
        markerId: MarkerId("_destinationLocation"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: _posDestination,
        infoWindow: InfoWindow(title: "Destination"),
        onTap: () => _showNavigationSheet(_posDestination, context),
      ),
      Marker(
        markerId: MarkerId("_originLocation"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: _posOrigin,
        infoWindow: InfoWindow(title: "Origin"),
        onTap: () => _showNavigationSheet(_posOrigin, context),
      ),
    };
  }

  List<String> getMarkersNameMock() {
    return ["Park1", "Park2", "Park3", "Park4", "Park5"];
  }


  void _showNavigationSheet(LatLng destination,BuildContext context) {
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
                startNavigation(destination);
              },
              child: const Text("Navigate"),
            ),
          ],
        ),
      ),
    );
  }

}
