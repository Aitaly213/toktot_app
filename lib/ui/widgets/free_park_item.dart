import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toktot_app/themes/app_colors.dart';

class FreeParkItem extends StatelessWidget {
  String title;

  FreeParkItem({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Align children to the left
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Лучшее парковочное место рядом с тобой",
                  style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(
                      color: AppColors.blueGeraint,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            SizedBox(
              height: 34,
              width: 34,
              child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: AppColors.blue,
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(Icons.arrow_forward_ios, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
