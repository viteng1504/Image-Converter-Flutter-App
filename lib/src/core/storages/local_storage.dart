import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/convert.dart';
import '../resources/app_assets.dart';

class LocalStorage {
  static Future<void> setIsFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isFirstLaunch", true);
  }

  static Future<void> removeIsFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("isFirstLaunch");
  }

  static Future<bool> getIsFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool("isFirstLaunch") ?? false;

    return isFirstLaunch;
  }

  //get Storage paths
  static Future<String> getDefaultStoragePath(ConvertFile convertFile) async {
    if (Platform.isAndroid) {
      final Directory? externalDir = await getExternalStorageDirectory();

      if (externalDir == null) {
        throw Exception("Can not access external storage");
      }

      final String path = externalDir.path.split("/Android")[0];

      final convertPath = switch (convertFile) {
        ConvertFile.image => "$path/Pictures",
        ConvertFile.pdf => "$path/Download",
      };

      return convertPath;
    } else if (Platform.isIOS) {
      final iosDir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOCUMENTS,
      );

      final convertPath = switch (convertFile) {
        ConvertFile.image => "$iosDir/Images",
        ConvertFile.pdf => "$iosDir/PDFs",
      };

      return convertPath;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  //get select store path
  static Future<String?> getSelectStoragePath(BuildContext context) async {
    try {
      // get root path
      final externalPath = await ExternalPath.getExternalStorageDirectories();
      if (externalPath == null || externalPath.isEmpty) {
        return null;
      }

      print(externalPath.toString());
      final rootDir = Directory(externalPath.first);

      // make sure path exists
      if (!await rootDir.exists()) {
        await rootDir.create(recursive: true);
      }

      if (!context.mounted) return null;

      final path = await FilesystemPicker.open(
        title: 'Select Folder',
        context: context,
        rootDirectory: rootDir,
        // shortcuts: ,
        fsType: FilesystemType.folder,
        pickText: 'Select this folder',
        folderIconColor: AppColors.fontGray,
        requestPermission: () async => true,

        // show New folder button
        contextActions: [FilesystemPickerNewFolderContextAction()],

        theme: FilesystemPickerTheme(
          topBar: FilesystemPickerTopBarThemeData(
            backgroundColor: AppColors.primary,
            titleTextStyle: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.white,
          fileList: FilesystemPickerFileListThemeData(
            // folderTextStyle: const TextStyle(color: Colors.white),
          ),
        ),
      );

      debugPrint('getSelectStoragePath => $path');
      return path;
    } catch (e, s) {
      debugPrint('getSelectStoragePath error: $e\n$s');
      return null;
    }
  }

  // request permission
  static Future<void> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return;
      }

      if (await Permission.manageExternalStorage.isPermanentlyDenied) {
        await openAppSettings();
        return;
      }

      final status = await Permission.manageExternalStorage.request();

      if (status.isGranted) {
        print('permission granted');
      } else {
        print('permission denied');
      }
    } else {}
  }
}
