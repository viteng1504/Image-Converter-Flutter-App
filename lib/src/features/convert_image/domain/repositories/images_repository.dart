import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../entities/original_image.dart';

abstract class ImagesRepository {
  Future<List<XFile>> selectImages();
  Future<List<OriginalImage>> encodeImages(List<XFile> images);
  Future<Uint8List> convertImageTo(Uint8List bytes);
}
