// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:flutter_image_compress/flutter_image_compress.dart';

// Project imports:
import '../../../../core/enums/convert.dart';
import '../entities/original_image.dart';
import '../entities/saved_file.dart';

abstract class ImagesRepository {
  Future<List<XFile>> selectImages();
  Future<List<OriginalImage>> encodeImages(List<XFile> images);
  Future<Uint8List> convertImage({
    required OriginalImage originalImage,
    required int compressAmount,
    required bool isGrayScale,
    required ConvertMode convertMode,
  });
  Future<SavedFile> convertToImage({
    required ConvertMode convertMode,
    required Uint8List image,
    required String imageName,
    required String storagePath,
  });
}
