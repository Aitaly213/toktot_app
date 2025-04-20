import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../themes/app_colors.dart';
import 'PhotoProcess/photo_preview_screen.dart';
import 'cubit/photo_cubit.dart';
import 'cubit/photo_state.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoCubit(),
      child: BlocBuilder<PhotoCubit, PhotoState>(
        builder: (context, state) {
          final cubit = context.read<PhotoCubit>();

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 47),
                    Image.asset(
                      'assets/images/make_photo.jpg',
                      width: 300,
                      height: 230,
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'Сфотографируйте номер вашего авто',
                      style: GoogleFonts.comfortaa(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 38),
                    ElevatedButton(
                      onPressed: () => _showImagePickerDialog(context, cubit),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Сделать фото',
                        style: GoogleFonts.comfortaa(
                          textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _pickAndNavigate(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    final file = File(picked.path);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoPreviewScreen(imageFile: file),
      ),
    );
  }

  void _showImagePickerDialog(BuildContext context, PhotoCubit cubit) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset('assets/icons/camera.svg', height: 64, fit: BoxFit.fill),
                      Container(
                        width: 2,
                        height: 100,
                        color: Colors.black,
                      ),
                      SvgPicture.asset('assets/icons/gallery.svg', height: 64, fit: BoxFit.fill),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickAndNavigate(context, ImageSource.camera),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: Text(
                            'Сделать фото',
                            style: GoogleFonts.comfortaa(
                              textStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickAndNavigate(context, ImageSource.gallery),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: Text(
                            'Добавить фото',
                            style: GoogleFonts.comfortaa(
                              textStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: -12,
                right: -12,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}