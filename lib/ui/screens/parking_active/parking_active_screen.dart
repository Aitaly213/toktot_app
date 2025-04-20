import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toktot_app/themes/app_colors.dart';
import 'package:toktot_app/ui/screens/parking_active/cubit/parking_cubit.dart';

class ParkingActiveScreen extends StatelessWidget {
  const ParkingActiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = ParkingCubit();


    return Scaffold(
      appBar: AppBar(
        title: Text("Парковка Активна"),
        centerTitle: true,
      ),
      body: BlocBuilder<ParkingCubit, ParkingState>(
          bloc: cubit,
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          cubit.time,
                          style: GoogleFonts.comfortaa(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Информация",
                            style: GoogleFonts.comfortaa(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(height: 10,),
                          buildInfoItem("Номер машины", "X777XX77RUS"),
                          Divider(thickness: 1,color: AppColors.blueGeraint,),
                          buildInfoItem("Время", "10:00"),
                          Divider(thickness: 1,color: AppColors.blueGeraint,),
                          buildInfoItem("Дата", "7 апреля 2025г."),
                          Divider(thickness: 1,color: AppColors.blueGeraint,),
                          buildInfoItem("Место",
                              "Улица Максима Горького 1/2 / улица Анкaра 1/2"),
                          Divider(thickness: 1,color: AppColors.blueGeraint,),
                          buildInfoItem("Номер стоянки", "123"),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        "Сумма: 200 сом",
                        style: GoogleFonts.comfortaa(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Spacer(),
                      Text(
                        "После выезда из стоянки активность автоматически сбрасывается и с баланса снимаются деньги",
                        style: GoogleFonts.comfortaa(
                            fontSize: 12,
                            color: Colors.black),
                      ),

                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget buildInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            style: GoogleFonts.comfortaa(
                fontSize: 14, color: AppColors.blueGeraint),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.comfortaa(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }
}
