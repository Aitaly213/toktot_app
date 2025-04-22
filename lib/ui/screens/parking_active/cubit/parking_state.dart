part of 'parking_cubit.dart';

abstract class ParkingState {}

class ParkingInitial extends ParkingState {}

class ParkingTicking extends ParkingState {
  final String time;

  ParkingTicking({required this.time});
}

class ParkingFinished extends ParkingState {
  final String time;

  ParkingFinished({required this.time});
}
