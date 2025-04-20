import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toktot_app/themes/app_colors.dart';

class ParkActiveItem extends StatelessWidget {
  final String currentTime;
  final VoidCallback onTap;

  const ParkActiveItem({
    super.key,
    required this.currentTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30,right: 30,top: 30),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blue, // Синий фон
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          child: Row(
            children: [
              // Красная точка
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),

              // Текст
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Парковка активна",
                      style: GoogleFonts.comfortaa(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Текущее время: $currentTime",
                      style: GoogleFonts.comfortaa(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Кнопка со стрелкой
              InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Color(0xFF3366FF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
