import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toktot_app/ui/screens/home/cubit/maps_cubit.dart';

import '../../../themes/app_colors.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/search_with_filter_bar.dart';

class MapFullScreenPage extends StatelessWidget {
  const MapFullScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    Location _locationController = Location();

    const _kGooglePlex = CameraPosition(
      target: LatLng(42.875639, 74.603806),
      zoom: 13,
    );

    final cubit = context.read<MapsCubit>();

    SearchController _searchController = SearchController();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BlocBuilder(
            bloc: cubit,
            builder: (context, state) {
              Map<PolylineId, Polyline> polylines = {};
              if (state is MapsInitial) {
                polylines = state.polylines;
              }

              return GoogleMap(
                onMapCreated:
                    (GoogleMapController controller) => cubit
                    .mapController
                    .complete(controller),
                initialCameraPosition: _kGooglePlex,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                // Disable default button
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,

                markers: cubit.getMockMarkers(context),
                polylines: Set<Polyline>.of(polylines.values),

              );
            },
          ),


          Align(
            alignment: Alignment.centerRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     FloatingActionButton.small(
                        shape: CircleBorder(),
                        heroTag: "zoom_in",
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          final controller = await cubit.mapController.future;
                          controller.animateCamera(CameraUpdate.zoomIn());
                        },
                        child: const Icon(Icons.add, color: AppColors.blue),
                      ),

                    FloatingActionButton.small(
                        shape: CircleBorder(),
                        heroTag: "zoom_out",
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          final controller = await cubit.mapController.future;
                          controller.animateCamera(CameraUpdate.zoomOut());
                        },
                        child: const Icon(Icons.remove, color: AppColors.blue),
                      ),

                  ],
                ),
              ),
            ),
          ),


          Positioned(
            top: 60,
              left: 26,
              child: SizedBox(
                width: 34,
                height: 34,
                child: FloatingActionButton(
                  elevation: 5,
                  backgroundColor: AppColors.blue,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: const CircleBorder(),
                  child: Icon(Icons.arrow_back,color: Colors.white,),
                ),
              ),
          ),
          Positioned(
            bottom: 110,
            left: 10,
            right: 10,

            child: SearchWithFilterBar(
              searchController: _searchController,
              suggestions: cubit.getMarkersNameMock(),
              onItemSelected: (selectedName) {
                //TODO обработка выбранного места
                print('Выбран: $selectedName');
              },
              elevation: 5,
            ),
          ),

          Positioned(
            bottom: 1,
            left: 6,
            right: 6,
            child: BottomNavigation(selectedIndex: 1, blurRadius: 2, spreadRadius: 1,),
          ),
        ],
      ),
    );
  }
}
