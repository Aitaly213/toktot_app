// 📁 lib/presentation/screens/photo/cubit/photo_process_cubit.dart

import 'dart:io';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'photo_process_state.dart';

class PhotoProcessCubit extends Cubit<PhotoProcessState> {
  PhotoProcessCubit() : super(PhotoInitial());

  Future<void> analyzeImage(File image) async {
    emit(PhotoLoading());

    await Future.delayed(const Duration(seconds: 2));

    final success = Random().nextBool();
    if (success) {
      final fakePlate = 'X777XX77RUS';
      emit(PhotoSuccess(plate: fakePlate));
    } else {
      emit(PhotoError());
    }
  }
}
