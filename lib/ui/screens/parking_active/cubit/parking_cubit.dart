import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'parking_state.dart';

class ParkingCubit extends Cubit<ParkingState> {
  ParkingCubit() : super(ParkingInitial());


  String time = "12:33";
}
