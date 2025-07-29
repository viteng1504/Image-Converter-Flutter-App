import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../../core/enums/convert_mode.dart';
import '../entities/original_image.dart';

abstract class ImagesRepository {
  Future<List<XFile>> selectImages();
  Future<List<OriginalImage>> encodeImages(List<XFile> images);
  Future<Uint8List> convertImage({
    required Uint8List bytes,
    required int compressAmount,
    required bool isGrayScale,
    required ConvertMode convertMode,
  });
}
