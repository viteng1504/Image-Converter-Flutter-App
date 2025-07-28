class Utils {
  String formatSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} mB";
    } else {
      return "${(bytes / 1024).toStringAsFixed(2)} kB";
    }
  }
}
