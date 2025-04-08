import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../cubit/maps_cubit.dart';

class MapFullScreenPage extends StatelessWidget {
  const MapFullScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Карта"),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<MapsCubit, MapsState>(
        builder: (context, state) {
          Map<PolylineId, Polyline> polylines = {};
          if (state is MapsInitial) {
            polylines = state.polylines;
          }

          return GoogleMap(
            onMapCreated: (controller) =>
                cubit.mapController.complete(controller),
            initialCameraPosition: CameraPosition(
              target: LatLng(42.8746, 74.6122),
              zoom: 13,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: cubit.getMockMarkers(context),
            polylines: Set<Polyline>.of(polylines.values),
          );
        },
      ),
    );
  }
}
