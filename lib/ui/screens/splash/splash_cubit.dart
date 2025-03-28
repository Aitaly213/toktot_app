import 'package:bloc/bloc.dart';

/// Cubit for managing the state of the splash screen.
class SplashCubit extends Cubit<void> {
  SplashCubit() : super(null);

  /// Starts a timer that emits a state change after a delay of 2 seconds.
  void startTimer() {
    Future.delayed(Duration(seconds: 2), () {
      emit(null);
    });
  }
}