import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:toktot_app/main.dart';

part 'parking_state.dart';

class ParkingCubit extends Cubit<ParkingState> {
  ParkingCubit() : super(ParkingInitial());

  Timer? _timer;
  DateTime? _startTime;

  String get time {
    if (_startTime == null) return "00:00";
    final diff = DateTime.now().difference(_startTime!);
    return _formatDuration(diff);
  }

  void startClock() {
    _startTime = DateTime.now();
    _timer?.cancel();
    emit(ParkingTicking(time: time));

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(ParkingTicking(time: time));
    });

    Future.delayed(const Duration(seconds: 30), () {
      stopClockAndNotify();
    });
  }

  void stopClockAndNotify() async {
    _timer?.cancel();
    emit(ParkingFinished(time: time));
    await showLocalNotification(
      title: "Парковка завершена",
      body: "Общее время: $time",
    );
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return hours > 0
        ? "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}"
        : "${twoDigits(minutes)}:${twoDigits(seconds)}";
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'parking_channel',
      'Парковочные уведомления',
      channelDescription: 'Уведомления при завершении парковки',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
