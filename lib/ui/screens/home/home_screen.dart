import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toktot_app/themes/app_colors.dart';
import 'package:toktot_app/ui/widgets/bottom_nav.dart';
import 'package:toktot_app/ui/widgets/free_park_item.dart';

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

  List<String> bestParks = ["Park 1","Park 2"];


  @override
  Widget build(BuildContext context) {
    final cubit = MapsCubit()..getLocationUpdates(_locationController);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigation(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 60, bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("Балланс",
                    style: GoogleFonts.comfortaa(
                        textStyle: TextStyle(
                      color: AppColors.blueGeraint,
                      fontSize: 14,
                    ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 10),
              child: Row(
                children: [
                  Text(
                    "450,30 сом",
                    style: GoogleFonts.comfortaa(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                      height: 34,
                      width: 34,

                      child: FloatingActionButton(
                        backgroundColor: AppColors.blue,
                        onPressed: () {
                          cubit.cameraToPosition(cubit.currentP!);
                        },
                        shape: CircleBorder(),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                clipBehavior: Clip.hardEdge,
                child: Container(
                  padding: EdgeInsets.all(30),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BlocBuilder(
                            bloc: cubit,
                            builder: (context, state) {
                              Map<PolylineId, Polyline> polylines = {};

                              if (state is MapsInitial) {
                                polylines = state.polylines;
                              }

                              bool isLocated = false;
                              if (state is MapsLocation) {
                                isLocated = true;
                              }

                              return Container(
                                child: GoogleMap(
                                  onMapCreated:
                                      (GoogleMapController controller) => cubit
                                          .mapController
                                          .complete(controller),
                                  initialCameraPosition: _kGooglePlex,
                                  myLocationEnabled: isLocated,
                                  myLocationButtonEnabled: false,
                                  // Disable default button
                                  mapToolbarEnabled: false,
                                  zoomControlsEnabled: false,
                                  markers: cubit.getMarkers(context),
                                  polylines: Set<Polyline>.of(polylines.values),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Positioned(
                      //   bottom: 90,
                      //   right: 10,
                      //   child: FloatingActionButton(
                      //     backgroundColor: Colors.white,
                      //     onPressed: () {
                      //       cubit.cameraToPosition(cubit.currentP!);
                      //     },
                      //     shape: CircleBorder(),
                      //     child: Icon(Icons.my_location_outlined, color: Colors.blue),
                      //   ),
                      // ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.flag_outlined, color: Colors.white),
                          iconAlignment: IconAlignment.start,
                          onPressed: () {},
                          label: Text("Найти ближайшую парковку",
                              style: GoogleFonts.comfortaa(
                                  textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ))),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 10,
                          left: 10,
                          right: 10,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 34,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: 2, color: AppColors.gray)),
                                  child: SearchAnchor(builder:
                                      (BuildContext context,
                                          SearchController controller) {
                                    return SearchBar(
                                      hintText: "Поиск места для парковки",
                                      hintStyle: WidgetStateProperty.all(
                                          GoogleFonts.comfortaa(
                                              textStyle: TextStyle(
                                        color: AppColors.blueGray,
                                        fontSize: 10,
                                      ))),
                                      controller: controller,
                                      padding: const WidgetStatePropertyAll<
                                              EdgeInsets>(
                                          EdgeInsets.symmetric(horizontal: 10)),
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                      onTap: () {
                                        controller.openView();
                                      },
                                      onChanged: (_) {
                                        controller.openView();
                                      },
                                      leading: const Icon(
                                        Icons.search,
                                        color: AppColors.blue,
                                      ),
                                    );
                                  }, suggestionsBuilder: (BuildContext context,
                                      SearchController controller) {
                                    List<String> items =
                                        cubit.getMarkersNameMock();

                                    return List<ListTile>.generate(5,
                                        (int index) {
                                      final String item = items[index];
                                      return ListTile(
                                        title: Text(item),
                                        onTap: () {
                                          setState(() {
                                            controller.closeView(item);
                                          });
                                        },
                                      );
                                    });
                                  }),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 34,
                                height: 34,
                                child: FloatingActionButton(
                                    backgroundColor: AppColors.blue,
                                    onPressed: () {
                                      cubit.cameraToPosition(cubit.currentP!);
                                    },
                                    shape: CircleBorder(),
                                    child: SvgPicture.asset(
                                      'assets/images/ic_filter.svg',
                                    )),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Сейчас свободно",
                  style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),


            SizedBox(
              height: 200,
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final responseData = bestParks[index];
                  return Column(
                    children: [
                      FreeParkItem(title: responseData)
                    ],
                  );
                },
                itemCount: bestParks.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
