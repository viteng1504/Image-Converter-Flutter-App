import 'dart:typed_data';

class SavedFile {
  final Uint8List image;
  final String name;
  final String size;
  final String path;
  
  SavedFile({
    required this.image,
    required this.name,
    required this.size,
    required this.path,
  });
}
