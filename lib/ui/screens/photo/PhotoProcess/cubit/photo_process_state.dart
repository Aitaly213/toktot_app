// 📁 lib/presentation/screens/photo/cubit/photo_process_state.dart

sealed class PhotoProcessState {}

class PhotoInitial extends PhotoProcessState {}

class PhotoLoading extends PhotoProcessState {}

class PhotoSuccess extends PhotoProcessState {
  final String plate;
  PhotoSuccess({required this.plate});
}

class PhotoError extends PhotoProcessState {}
