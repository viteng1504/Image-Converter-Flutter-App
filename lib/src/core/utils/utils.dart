import '../enums/convert.dart';

class Utils {
  static String formatSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} mB";
    } else {
      return "${(bytes / 1024).toStringAsFixed(2)} kB";
    }
  }

  //check if image name exist or not
  static String getExtensionFromConvertMode(ConvertMode mode) {
    switch (mode) {
      case ConvertMode.jpg:
        return 'jpg';
      case ConvertMode.png:
        return 'png';
      case ConvertMode.webp:
        return 'webp';
      default:
        return 'jpg';
    }
  }
}
