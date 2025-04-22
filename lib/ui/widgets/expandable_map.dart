import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toktot_app/ui/widgets/search_with_filter_bar.dart';

import '../../themes/app_colors.dart';
import '../screens/home/cubit/maps_cubit.dart';
import 'bottom_nav.dart';

class ExpandableMap extends StatelessWidget {
  final MapsCubit cubit;
  final bool expanded;
  final SearchController searchController;
  final VoidCallback? onToggleExpanded;

  const ExpandableMap({
    Key? key,
    required this.cubit,
    required this.searchController,
    this.expanded = false,
    this.onToggleExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapContent = Stack(
      children: [
        /// Карта
        Positioned.fill(
          child: GestureDetector(
            onDoubleTap: onToggleExpanded,
            child: BlocBuilder<MapsCubit, MapsState>(
              builder: (context, state) {
                // final polylines = (state is MapsInitial)
                //     ? state.polylines
                //     : <PolylineId, Polyline>{};

                return GoogleMap(
                  onMapCreated: (controller) {
                    cubit.setController(controller);
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(42.875639, 74.603806),
                    zoom: 13,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  markers: cubit.getMockMarkers(context),
                  polylines: Set<Polyline>.of(state.polylines.values),
                );
              },
            ),
          ),
        ),

        /// Развёрнутый UI
        if (expanded) ...[
          /// Zoom controls
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    shape: const CircleBorder(),
                    heroTag: "zoom_in",
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      final controller = cubit.controller;
                      if (controller != null) {
                        controller.animateCamera(CameraUpdate.zoomIn());
                      } else {
                        print("🟥 controller is null");
                      }
                    },
                    child: const Icon(Icons.add, color: AppColors.blue),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton.small(
                    shape: const CircleBorder(),
                    heroTag: "zoom_out",
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      final controller = cubit.controller;
                      if (controller != null) {
                        controller.animateCamera(CameraUpdate.zoomOut());
                      } else {
                        print("🟥 controller is null");
                      }
                    },
                    child: const Icon(Icons.remove, color: AppColors.blue),
                  ),
                ],
              ),
            ),
          ),

          /// Bottom bar + поиск
          Positioned(
            bottom: 20,
            left: 6,
            right: 6,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SearchWithFilterBar(
                    searchController: searchController,
                    suggestions: cubit.getMarkersNameMock(),
                    onItemSelected: (selectedName) {
                      print('Выбран: $selectedName');
                    },
                    elevation: 5,
                  ),
                  const BottomNavigation(
                    selectedIndex: 1,
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),

          /// Back button
          Positioned(
            top: 60,
            left: 26,
            child: SizedBox(
              width: 34,
              height: 34,
              child: FloatingActionButton(
                elevation: 5,
                backgroundColor: AppColors.blue,
                onPressed: onToggleExpanded,
                shape: const CircleBorder(),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
        ] else ...[
          /// Центрировать на себе
          Positioned(
            bottom: 110,
            right: 10,
            child: FloatingActionButton(
              heroTag: "location_btn",
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                if (cubit.currentP != null) {
                  cubit.cameraToPosition(cubit.currentP!);
                } else {
                  print("⚠️ currentP is null");
                }
              },
              shape: const CircleBorder(),
              child: SvgPicture.asset(
                'assets/images/ic_current_location.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          /// Кнопка найти парковку
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: ElevatedButton.icon(
              onPressed: () {
                final nearest = cubit.getNearestMarker();
                if (nearest != null) {
                  cubit.startNavigation(
                    LatLng(nearest.latitude, nearest.longitude),
                  );
                } else {
                  print("⚠️ nearest is null");
                }
              },
              icon: const Icon(Icons.flag_outlined, color: Colors.white),
              label: Text(
                "Найти ближайшую парковку",
                style: GoogleFonts.comfortaa(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ],
    );

    // финальный виджет
    return expanded
        ? mapContent // занимает всё благодаря Stack в родителе
        : Padding(
      padding: const EdgeInsets.all(30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.34,
          child: mapContent,
        ),
      ),
    );
  }
}
