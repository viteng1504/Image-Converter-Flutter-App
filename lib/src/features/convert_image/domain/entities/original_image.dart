import 'dart:typed_data';

class OriginalImage {
  final Uint8List bytes;
  final String name;
  int width;
  int height;

  OriginalImage({
    required this.width,
    required this.height,
    required this.bytes,
    required this.name,
  });

  void changedImageSize(int width, int height) {
    this.width = width;
    this.height = height;
  }
}
