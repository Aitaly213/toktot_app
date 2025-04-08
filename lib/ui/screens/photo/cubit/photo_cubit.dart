// 📁 lib/presentation/screens/photo/cubit/photo_cubit.dart

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  final ImagePicker _picker = ImagePicker();

  PhotoCubit() : super(PhotoState.initial());

  Future<void> pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source);
    if (picked == null) return;

    emit(state.copyWith(isLoading: true, plate: null, showConfirmUI: false, error: null));

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Обрезать',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Обрезать'),
      ],
    );

    if (cropped == null) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    final File imageFile = File(cropped.path);
    emit(state.copyWith(image: imageFile));

    await Future.delayed(const Duration(seconds: 2));
    final success = Random().nextBool();
    final plate = success ? '01 KG ${Random().nextInt(900) + 100} ${['AAB', 'AAR', 'BAP'][Random().nextInt(3)]}' : null;

    emit(
      state.copyWith(
        isLoading: false,
        plate: plate,
        showConfirmUI: success,
        error: success ? null : 'Номер не распознан. Сделайте более чёткое фото.',
      ),
    );
  }

  void reset() {
    emit(PhotoState.initial());
  }
}