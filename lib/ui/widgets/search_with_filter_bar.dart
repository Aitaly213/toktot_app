import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../themes/app_colors.dart';
import 'filter_bottom_sheet.dart';

class SearchWithFilterBar extends StatelessWidget {
  final SearchController searchController;
  final List<String> suggestions;
  final void Function(String value) onItemSelected;
  final double elevation;

  const SearchWithFilterBar({
    super.key,
    required this.searchController,
    required this.suggestions,
    required this.onItemSelected,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 34,
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    backgroundColor: WidgetStateProperty.all(AppColors.lightGray),
                    elevation: WidgetStatePropertyAll(elevation),
                    hintText: "Поиск места для парковки",
                    hintStyle: WidgetStateProperty.all(
                      GoogleFonts.comfortaa(
                        textStyle: const TextStyle(
                          color: AppColors.blueGray,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    controller: controller,
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 10),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onTap: () => controller.openView(),
                    onChanged: (_) => controller.openView(),
                    leading: const Icon(
                      Icons.search,
                      size: 14,
                      color: AppColors.blue,
                    ),
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(suggestions.length, (index) {
                    final item = suggestions[index];
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        controller.closeView(item);
                        onItemSelected(item);
                      },
                    );
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 34,
            height: 34,
            child: FloatingActionButton(
              elevation: elevation,
              backgroundColor: AppColors.blue,
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  builder: (context) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: const FilterBottomSheet(),
                  ),
                );
              },
              shape: const CircleBorder(),
              child: SvgPicture.asset('assets/images/ic_filter.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
