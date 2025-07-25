import 'package:flutter/material.dart';

import 'src/core/resources/app_colors.dart';
import 'src/features/convert_image/presentation/screens/select_images/select_images_screen.dart';
import 'src/features/convert_image/presentation/screens/welcome/welcome_main_screen.dart';
import 'src/features/product/presentation/screens/saved_files_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Converter',
      theme: ThemeData(scaffoldBackgroundColor: AppColors.background),
      home: const SavedFilesScreen(),
      routes: {
        "welcome": (context) => const WelcomeMainScreen(),
        "select_images": (context) => const SelectImagesScreen(),
        "saved_files": (context) => const SavedFilesScreen(),
      },
    );
  }
}
