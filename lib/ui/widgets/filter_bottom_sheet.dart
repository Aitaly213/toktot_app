import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../themes/app_colors.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String selectedAvailability = "Какой то текст";
  String selectedDistance = "Все";
  String selectedHours = "Все парковки";
  String selectedRating = "⭐ 4 и выше";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildDragIndicator(),
          const SizedBox(height: 20),
          Center(
            child: Text(
              "Фильтрация",
              style: GoogleFonts.comfortaa(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          _buildSection(
            "Доступность мест",
            ["Какой то текст", "Какой то текст 2"],
            selectedAvailability,
                (value) => setState(() => selectedAvailability = value),
          ),

          _buildSection(
            "Расстояние",
            ["Ближайшие", "Все"],
            selectedDistance,
                (value) => setState(() => selectedDistance = value),
          ),

          _buildSection(
            "Часы работы",
            ["Только круглосуточные", "Все парковки"],
            selectedHours,
                (value) => setState(() => selectedHours = value),
          ),

          _buildSection(
            "Цена",
            [],
            "",
                (_) {},
            inputFields: true,
          ),

          _buildSection(
            "Рейтинг",
            ["⭐ 4.5 и выше", "⭐ 4 и выше", "⭐ 3.5 и выше", "⭐ 3 и выше"],
            selectedRating,
                (value) => setState(() => selectedRating = value),
          ),

          const SizedBox(height: 30),
          _buildSaveButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDragIndicator() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          "Сохранить изменения",
          style: GoogleFonts.comfortaa(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      String title,
      List<String> options,
      String selectedValue,
      void Function(String) onSelected, {
        bool inputFields = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.comfortaa(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          inputFields
              ? Row(
            children: [
              _buildInputField("0 сом"),
              const SizedBox(width: 10),
              _buildInputField("1350 сом"),
            ],
          )
              : Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options
                .map((label) =>
                _buildChip(label, selectedValue, onSelected))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
      String label,
      String selectedValue,
      void Function(String) onSelected,
      ) {
    final isSelected = label == selectedValue;
    return ChoiceChip(
      label: Text(
        label,
        style: GoogleFonts.comfortaa(
          color: isSelected ? Colors.white : AppColors.blueGeraint,
          fontSize: 12,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) onSelected(label);
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: AppColors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
    );
  }

  Widget _buildInputField(String hint) {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.comfortaa(fontSize: 12),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
