import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../cubit/maps_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Location _locationController = Location();

  static const _kGooglePlex = CameraPosition(
    target: LatLng(42.875639, 74.603806),
    zoom: 13,
  );

  @override
  Widget build(BuildContext context) {
    final cubit = MapsCubit()..getLocationUpdates(_locationController);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Expanded(
              child: BlocBuilder(
                bloc: cubit,
                builder: (context, state) {
                  Map<PolylineId, Polyline> polylines = {};

                  if (state is MapsInitial) {
                    polylines = state.polylines;
                  }

                  return Container(
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) =>
                          cubit.mapController.complete(controller),
                      initialCameraPosition: _kGooglePlex,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      // Disable default button
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      markers: cubit.getMarkers(context, cubit),
                      polylines: Set<Polyline>.of(polylines.values),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  cubit.cameraToPosition(cubit.currentP!);
                },
                child: Icon(Icons.my_location, color: Colors.blue),
              ),
            ),
            Positioned(
              bottom: 100,
              child: ElevatedButton.icon(
                icon: Icon(Icons.flag_outlined, color: Colors.white),
                iconAlignment: IconAlignment.start,
                onPressed: () {},
                label: Text("Найти ближайшую парковку"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(20.0),

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
