import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';
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
      final externalDir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD,
      );

      return externalDir;
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

  //show invalid path snackbar
  static void showPathErrorSnackbar(BuildContext context) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Can only choose 1 folder Download, Pictures or Documents.',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.sliderInactiveTrack,
        ),
      );
    }
  }

  //get select store path

  static Future<String?> getSelectStoragePath(BuildContext context) async {
    try {
      //release permission
      await Saf.releasePersistedPermissions();

      String path = "";
      const List<String> allowedRootFolders = [
        'Download',
        'Pictures',
        'Documents',
      ];

      //get external directories
      final externalPath = await ExternalPath.getExternalStorageDirectories();

      if (externalPath == null) {
        debugPrint("Cant get any external storages");
        return null;
      }
      //get external storage, not in SD card
      final rootPath = externalPath.first;

      bool? isGranted = await Saf.getDynamicDirectoryPermission();

      if (isGranted != null && isGranted) {
        final directories = await Saf.getPersistedPermissionDirectories();

        if (directories!.isEmpty) {
          debugPrint("Cant get directories");
          return null;
        }

        String selectedDirectory = directories.last;

        bool isValidPath = allowedRootFolders.any(
          (folder) => selectedDirectory.startsWith(folder),
        );

        if (!isValidPath) {
          showPathErrorSnackbar(context);

          return null;
        }

        path = "$rootPath/$selectedDirectory";
      } else {
        debugPrint('User dont grant access SAF');
        return null;
      }

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
      if (await Permission.storage.isGranted) {
        return;
      }

      if (await Permission.storage.isPermanentlyDenied) {
        await openAppSettings();
        return;
      }

      final status = await Permission.storage.request();

      if (status.isGranted) {
        print(
          'permission granted____________________________________________________________________________',
        );
      } else {
        print('permission denied');
      }
    } else {}
  }
}
