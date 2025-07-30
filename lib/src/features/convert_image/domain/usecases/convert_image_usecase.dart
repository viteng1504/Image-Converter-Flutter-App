import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../../core/enums/convert_mode.dart';
import '../entities/original_image.dart';
import '../repositories/images_repository.dart';

class ConvertImageUsecase {
  ImagesRepository repo;

  ConvertImageUsecase(this.repo);

  Future<Uint8List> convertImage({
    required OriginalImage originalImage,
    required int compressAmount,
    required bool isGrayScale,
    required ConvertMode convertMode,
  }) async {
    return await repo.convertImage(
      originalImage: originalImage,
      compressAmount: compressAmount,
      isGrayScale: isGrayScale,
      convertMode: convertMode,
    );
  }

  Future<List<OriginalImage>> encodeImage(List<XFile> images) {
    return repo.encodeImages(images);
  }
}
