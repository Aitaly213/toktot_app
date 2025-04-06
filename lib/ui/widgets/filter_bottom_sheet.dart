import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../themes/app_colors.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

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
          // Индикатор сверху
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
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

          _buildSection("Доступность мест", [
            _buildChip("Какой то текст", selected: true),
            _buildChip("Какой то текст"),
          ]),

          _buildSection("Расстояние", [
            _buildChip("Ближайшие"),
            _buildChip("Все", selected: true),
          ]),

          _buildSection("Часы работы", [
            _buildChip("Только круглосуточные"),
            _buildChip("Все парковки", selected: true),
          ]),

          _buildSection("Цена", [], inputFields: true),

          _buildSection("Рейтинг", [
            _buildChip("⭐ 4.5 и выше"),
            _buildChip("⭐ 4 и выше", selected: true),
            _buildChip("⭐ 3.5 и выше"),
            _buildChip("⭐ 3 и выше"),
          ]),

          const SizedBox(height: 30),
          SizedBox(
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
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> chips,
      {bool inputFields = false}) {
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
              : Wrap(spacing: 10, runSpacing: 10, children: chips),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool selected = false}) {
    return ChoiceChip(
      label: Text(
        label,
        style: GoogleFonts.comfortaa(
          color: selected ? Colors.white : AppColors.blueGeraint,
          fontSize: 12,
        ),
      ),
      selected: selected,
      onSelected: (_) {},
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
