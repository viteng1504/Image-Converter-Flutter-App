import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pool/pool.dart';

class DeviceInfo {
  static int deviceWidth = 0;
  static int deviceHeihgt = 0;
  static int maxSize = 0;
  static final pool = Pool(4);

  static void init() {
    final size = WidgetsBinding.instance.window.physicalSize;
    maxSize = max(size.width.toInt(), size.height.toInt());
  }
}
