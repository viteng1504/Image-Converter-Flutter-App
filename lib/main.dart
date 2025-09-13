// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'src/core/device_info.dart';
import 'src/core/resources/app_colors.dart';
import 'src/core/storages/local_storage.dart';
import 'src/features/convert_image/presentation/screens/select_images/select_images_screen.dart';
import 'src/features/convert_image/presentation/screens/welcome/welcome_main_screen.dart';
import 'src/features/product/presentation/screens/saved_files_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    DeviceInfo.init();
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isWelcomeShown = false;

  @override
  void initState() {
    super.initState();
    _loadWelcome();
  }

  Future<void> _loadWelcome() async {
    final isFirstLaunch = await LocalStorage.getIsFirstLaunch();
    setState(() {
      _isWelcomeShown = isFirstLaunch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Converter',
      theme: ThemeData(scaffoldBackgroundColor: AppColors.background),
      home:
          _isWelcomeShown
              ? const SelectImagesScreen()
              : const WelcomeMainScreen(),
      routes: {
        "/welcome": (context) => const WelcomeMainScreen(),
        "/select_images": (context) => const SelectImagesScreen(),
        "/saved_files": (context) => const SavedFilesScreen(),
      },
    );
  }
}
