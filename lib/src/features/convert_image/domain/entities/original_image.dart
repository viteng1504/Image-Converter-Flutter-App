import 'dart:typed_data';

class OriginalImage {
  final Uint8List bytes;
  final Uint8List? halfSizeImagebytes;
  final String name;

  OriginalImage({
    required this.halfSizeImagebytes,
    required this.bytes,
    required this.name,
  });
}
