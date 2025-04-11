import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toktot_app/themes/app_colors.dart';
import 'package:toktot_app/ui/widgets/bottom_nav.dart';
import 'package:toktot_app/ui/widgets/free_park_item.dart';

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
  Location _locationController = Location();

  static const _kGooglePlex = CameraPosition(
    target: LatLng(42.875639, 74.603806),
    zoom: 13,
  );

  List<String> bestParks = ["Park 1", "Park 2"];

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    int selectedIndex = args?['selectedIndex'] ?? 1;

    final cubit = MapsCubit()..getLocationUpdates(_locationController);

    return Scaffold(
      bottomNavigationBar: BottomNavigation(
        selectedIndex: selectedIndex,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
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
                  padding: const EdgeInsets.only(left: 30, bottom: 30),
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
                            elevation: 0,
                            backgroundColor: AppColors.blue,
                            onPressed: () {
                              _showBalanceTopUpDialog(context);
                            },
                            shape: CircleBorder(),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 34,
                          child: SearchAnchor(builder: (BuildContext context,
                              SearchController controller) {
                            return SearchBar(
                              elevation: WidgetStatePropertyAll(0),
                              hintText: "Поиск места для парковки",
                              hintStyle:
                                  WidgetStateProperty.all(GoogleFonts.comfortaa(
                                      textStyle: TextStyle(
                                color: AppColors.blueGray,
                                fontSize: 10,
                              ))),
                              controller: controller,
                              padding: const WidgetStatePropertyAll<EdgeInsets>(
                                  EdgeInsets.symmetric(horizontal: 10)),
                              shape:
                                  WidgetStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                              onTap: () {
                                controller.openView();
                              },
                              onChanged: (_) {
                                controller.openView();
                              },
                              leading: const Icon(
                                size: 14,
                                Icons.search,
                                color: AppColors.blue,
                              ),
                            );
                          }, suggestionsBuilder: (BuildContext context,
                              SearchController controller) {
                            List<String> items = cubit.getMarkersNameMock();

                            return List<ListTile>.generate(items.length,
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
                            elevation: 0,
                            backgroundColor: AppColors.blue,
                            onPressed: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30)),
                                ),
                                builder: (context) => Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: FilterBottomSheet()),
                              );
                            },
                            shape: CircleBorder(),
                            child: SvgPicture.asset(
                              'assets/images/ic_filter.svg',
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.38,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                // MAKE NAVIGATION TO MapFullScreenPage     !!!!!!!!!!!!
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const MapFullScreenPage(),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BlocBuilder(
                                  bloc: cubit,
                                  builder: (context, state) {
                                    Map<PolylineId, Polyline> polylines = {};

                                    if (state is MapsInitial) {
                                      polylines = state.polylines;
                                    }

                                    return GoogleMap(
                                      onMapCreated:
                                          (GoogleMapController controller) =>
                                              cubit.mapController
                                                  .complete(controller),
                                      initialCameraPosition: _kGooglePlex,
                                      myLocationEnabled: true,
                                      myLocationButtonEnabled: false,
                                      // Disable default button
                                      mapToolbarEnabled: false,
                                      zoomControlsEnabled: false,
                                      markers: cubit.getMockMarkers(context),
                                      polylines:
                                          Set<Polyline>.of(polylines.values),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 110,
                            right: 10,
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  cubit.cameraToPosition(cubit.currentP);
                                },
                                shape: CircleBorder(),
                                child: SvgPicture.asset(
                                  'assets/images/ic_current_location.svg',
                                  colorFilter: ColorFilter.mode(
                                      Colors.black, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.flag_outlined,
                                  color: Colors.white),
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
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final responseData = bestParks[index];
                      return Column(
                        children: [FreeParkItem(title: responseData)],
                      );
                    },
                    itemCount: bestParks.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showBalanceTopUpDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (context) => Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Пополнить баланс',
                        style: GoogleFonts.comfortaa(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildBalanceOption(
                        iconPath: 'assets/icons/wallet.svg',
                        label: 'Мобильный кошелек',
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: реализация позже
                        },
                      ),
                      const Divider(height: 24),
                      _buildBalanceOption(
                        iconPath: 'assets/icons/card.svg',
                        label: 'Банковская карта',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, AppRoutes.bankCardPayment);
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -12,
                  right: -12,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildBalanceOption(
    {required String iconPath,
    required String label,
    required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: [
        SvgPicture.asset(iconPath, height: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.comfortaa(fontSize: 14),
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 14),
      ],
    ),
  );
}
