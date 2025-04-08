import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toktot_app/navigation/routs/app_routes.dart';
import '../../../../themes/app_colors.dart';
import 'cubit/photo_process_cubit.dart';
import 'cubit/photo_process_state.dart';

class PhotoPreviewScreen extends StatelessWidget {
  final File imageFile;

  const PhotoPreviewScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => PhotoProcessCubit()..analyzeImage(imageFile),
      child: BlocBuilder<PhotoProcessCubit, PhotoProcessState>(
        builder: (context, state) {
          final cubit = context.read<PhotoProcessCubit>();
          final bool isProcessing = state is PhotoLoading;
          final bool isSuccess = state is PhotoSuccess;
          final bool isError = state is PhotoError;

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight - MediaQuery.of(context).padding.top - 40,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: isSuccess || isProcessing ? 0.3 : 1.0,
                                child: Image.file(
                                  imageFile,
                                  width: screenWidth - 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (isProcessing)
                                const CircularProgressIndicator(),
                              if (isSuccess)
                                const Icon(Icons.check_circle, size: 80, color: Colors.green),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.edit, size: 16),
                            label: Text(
                              'Изменить фото',
                              style: GoogleFonts.comfortaa(fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        if (isSuccess)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Номер машины',
                                style: GoogleFonts.comfortaa(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F1F1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.edit, size: 16),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        (state as PhotoSuccess).plate,
                                        style: GoogleFonts.comfortaa(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        if (isError)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Ваши данные не корректны.',
                              style: GoogleFonts.comfortaa(color: Colors.red, fontSize: 16),
                            ),
                          ),
                        if (isProcessing)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'Обрабатываем данные... Это займет несколько секунд.',
                              style: GoogleFonts.comfortaa(fontSize: 14, decoration: TextDecoration.underline),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: isSuccess
                              ? () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.home,
                                (route) => false,
                          )
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSuccess ? AppColors.blue : AppColors.blueGray,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: Text(
                            'Далее',
                            style: GoogleFonts.comfortaa(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}