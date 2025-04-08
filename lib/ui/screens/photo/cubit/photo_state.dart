// 📁 lib/presentation/screens/photo/cubit/photo_state.dart

import 'dart:io';
import 'package:equatable/equatable.dart';

class PhotoState extends Equatable {
  final File? image;
  final String? plate;
  final bool isLoading;
  final bool showConfirmUI;
  final String? error;

  const PhotoState({
    this.image,
    this.plate,
    this.isLoading = false,
    this.showConfirmUI = false,
    this.error,
  });

  factory PhotoState.initial() => const PhotoState();

  PhotoState copyWith({
    File? image,
    String? plate,
    bool? isLoading,
    bool? showConfirmUI,
    String? error,
  }) {
    return PhotoState(
      image: image ?? this.image,
      plate: plate ?? this.plate,
      isLoading: isLoading ?? this.isLoading,
      showConfirmUI: showConfirmUI ?? this.showConfirmUI,
      error: error,
    );
  }

  @override
  List<Object?> get props => [image, plate, isLoading, showConfirmUI, error];
}
