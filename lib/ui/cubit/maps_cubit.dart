import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toktot_app/data/models/marker_model/marker_model.dart';
import 'package:toktot_app/themes/app_colors.dart';

import '../../data/models/marker_model/mock_markers.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  MapsCubit() : super(MapsInitial()) {
    emit(MapsInitial(polylines: {}));
  }

  Map<PolylineId, Polyline> polylines = {};
  final apiKey = dotenv.env['GOOGLE_API_KEY'];

  Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  static const _posDestination = LatLng(42.828061, 74.601591);

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
    return await getPolylinePointsBetween(currentP, _posDestination);
  }

  Future<List<LatLng>> getPolylinePointsBetween(
      LatLng origin, LatLng destination) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: apiKey,
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

  Set<Marker> getMockMarkers(BuildContext context) {
    return mockMarkers.map((markerModel) {
      return Marker(
        markerId: MarkerId(markerModel.id.toString()),
        position: LatLng(
          markerModel.latitude.toDouble(),
          markerModel.longitude.toDouble(),
        ),
        infoWindow: InfoWindow(title: markerModel.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onTap: () {
          _showNavigationSheet(
            LatLng(
              markerModel.latitude,
              markerModel.longitude,
            ),
            context,
            markerModel,
          );
        },
      );
    }).toSet();
  }

  List<String> getMarkersNameMock() {
    return mockMarkers.map((marker) => marker.name).toList();
  }

  void _showNavigationSheet(
      LatLng destination, BuildContext context, MarkerModel marker) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return DefaultTabController(
            length: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Название
                  Text(
                    marker.name,
                    style: GoogleFonts.comfortaa(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    marker.address,
                    style: GoogleFonts.comfortaa(
                      fontSize: 12,
                      color: AppColors.blueGeraint,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(Icons.star, size: 20, color: AppColors.blueGeraint),
                      const SizedBox(width: 4),
                      Text(
                        marker.rating.toString(),
                        style: GoogleFonts.comfortaa(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Занято: ${marker.carsInTheParking}/${marker.maxCarsInTheParking}',
                        style: GoogleFonts.comfortaa(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${marker.pricePerHour} сом/час',
                          style: GoogleFonts.comfortaa(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          startNavigation(destination);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: SvgPicture.asset(
                          "assets/images/ic_route.svg",
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                        label: Text(
                          'Маршрут',
                          style: GoogleFonts.comfortaa(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // TabBar
                  TabBar(
                    indicatorColor: AppColors.blue,
                    labelColor: AppColors.blue,
                    unselectedLabelColor: Colors.black,
                    labelStyle: GoogleFonts.comfortaa(fontWeight: FontWeight.bold),
                    tabs: [
                      const Tab(text: 'Обзор'),
                      Tab(child: _tabWithBadge('Отзывы', 120)),
                      Tab(child: _tabWithBadge('Фото', 120)),
                    ],
                  ),

                  const Divider(height: 1),

                  // TabBarView
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView(
                          padding: const EdgeInsets.all(20),
                          children: const [
                            SizedBox(height: 20),
                            Text('Контент вкладки "Обзор"'),
                          ],
                        ),
                        ListView(
                          padding: const EdgeInsets.all(20),

                          children: const [
                            SizedBox(height: 20),
                            Text('Отзывы пользователей...'),
                          ],
                        ),
                        ListView(
                          padding: const EdgeInsets.all(20),

                          children: const [
                            SizedBox(height: 20),
                            Text('Фотографии парковки...'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _tabWithBadge(String label, int count) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: GoogleFonts.comfortaa()),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: GoogleFonts.comfortaa(fontSize: 12, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

}
