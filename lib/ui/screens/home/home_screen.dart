import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toktot_app/data/models/marker_model/marker_model.dart';
import 'package:toktot_app/navigation/routs/app_routes.dart';
import 'package:toktot_app/themes/app_colors.dart';
import 'package:toktot_app/ui/widgets/bottom_nav.dart';
import 'package:toktot_app/ui/widgets/expandable_map.dart';
import 'package:toktot_app/ui/widgets/free_park_item.dart';
import 'package:toktot_app/ui/widgets/park_active_item.dart';
import '../../widgets/search_with_filter_bar.dart';
import '../parking_active/cubit/parking_cubit.dart';
import 'cubit/maps_cubit.dart';

import '../../../navigation/routs/app_routes.dart';
import '../../cubit/maps_cubit.dart';
import '../../widgets/filter_bottom_sheet.dart';
import 'map_full_screen_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpanded = false; // ✅ состояние карты
  final searchController = SearchController();
  bool isParkingActive = true;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    int selectedIndex = args?['selectedIndex'] ?? 1;

    final cubit = context.read<MapsCubit>();

    final List<MarkerModel> model = cubit.getMarkersMock();
    final List<String> suggestions = model.map((e) => e.name).toList();

    return Scaffold(
      bottomNavigationBar:
          isExpanded ? null : BottomNavigation(selectedIndex: selectedIndex),
      body: SafeArea(
        child: Column(
          children: [
            if (!isExpanded) ...[
              /// Блок "Баланс"
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 30, bottom: 10),
                    child: Text(
                      "Балланс",
                      style: GoogleFonts.comfortaa(
                        fontSize: 14,
                        color: AppColors.blueGeraint,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 30),
                    child: Row(
                      children: [
                        Text(
                          "450,30 сом",
                          style: GoogleFonts.comfortaa(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: SizedBox(
                            height: 34,
                            width: 34,
                            child: FloatingActionButton(
                              elevation: 0,
                              backgroundColor: AppColors.blue,
                              onPressed: () {
                                _showBalanceTopUpDialog(context);                              },
                              shape: const CircleBorder(),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Поиск
                  SearchWithFilterBar(
                    searchController: searchController,
                    suggestions: suggestions,
                    onItemSelected: (selectedName) {
                      final marker =
                          model.firstWhereOrNull((e) => e.name == selectedName);
                      if (marker != null) {
                        final destination =
                            LatLng(marker.latitude, marker.longitude);
                        cubit.showNavigationSheet(destination, context, marker);
                      }
                    },
                  ),

                  Column(children: [
                    if (isParkingActive)
                      BlocBuilder<ParkingCubit, ParkingState>(
                        builder: (context, state) {
                          String time = '00:00';
                          if (state is ParkingTicking) {
                            time = state.time;
                          } else if (state is ParkingFinished) {
                            time = state.time;
                          }

                          return ParkActiveItem(
                            time: time,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.parkingActive);
                            },
                          );
                        },
                      ),
                  ]),
                ],
              )
            ],

            /// Карта
            Expanded(
              child: ExpandableMap(
                cubit: cubit,
                expanded: isExpanded,
                searchController: searchController,
                onToggleExpanded: () {
                  setState(() => isExpanded = !isExpanded);
                },
              ),
            ),

            if (!isExpanded) ...[
              /// Рекомендуемые парковки
              //if(!isParkingActive) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    "Рекомендуем парковки",
                    style: GoogleFonts.comfortaa(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              BlocBuilder<MapsCubit, MapsState>(
                builder: (context, state) {
                  final bestParks = context.read<MapsCubit>().getBestParks();

                  if (bestParks.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  double listviewSize;
                  if (isParkingActive) {
                    listviewSize = 80;
                  } else {
                    listviewSize = 100;
                  }

                  return SizedBox(
                    height: listviewSize,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: bestParks.length,
                      itemBuilder: (context, index) {
                        return FreeParkItem(
                          title: bestParks[index].name,
                          onTap: () {
                            cubit.showNavigationSheet(
                              LatLng(
                                bestParks[index].latitude,
                                bestParks[index].longitude,
                              ),
                              context,
                              bestParks[index],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              )
            ]
          ],
          // ],
        ),
      ),
    );
  }
}
