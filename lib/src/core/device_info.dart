import 'dart:math';

import 'package:flutter/material.dart';

class DeviceInfo {
  static int deviceWidth = 0;
  static int deviceHeihgt = 0;
  static int maxSize = 0;

  static void init() {
    final size = WidgetsBinding.instance.window.physicalSize;
    maxSize = max(size.width.toInt(), size.height.toInt());
  }
}
