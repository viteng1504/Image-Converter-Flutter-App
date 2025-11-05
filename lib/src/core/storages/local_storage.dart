import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/convert.dart';

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

  //get select store path
  static Future<String?> getSelectStoragePath(BuildContext context) async {
    try {
      String path = "";

      bool? isGranted = await Saf.getDynamicDirectoryPermission();

      if (isGranted != null && isGranted) {
        List<String>? directories =
            await Saf.getPersistedPermissionDirectories();

        if (directories == null) {
          print("Cant get directories");
          return null;
        }

        //get external directories
        final externalPath = await ExternalPath.getExternalStorageDirectories();

        if (externalPath == null) {
          print("Cant get any external storages");
          return null;
        }
        //get external storage, not in SD card
        final rootPath = externalPath.first;

        String selectedDirectory = directories.last;
        print(
          "selectedDirectory:______________________________________________$selectedDirectory",
        );

        path = "$rootPath/$selectedDirectory";

        print("FinalPath:______________________________________________$path");

        Saf.releasePersistedPermissions();
      } else {
        print('User dont grant access SAF');
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
