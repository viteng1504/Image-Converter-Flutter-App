// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

// Project imports:
import '../../../../core/enums/convert.dart';
import '../entities/original_image.dart';
import '../entities/saved_file.dart';
import '../repositories/images_repository.dart';

class ConvertImageUsecase {
  ImagesRepository repo;

  ConvertImageUsecase(this.repo);

  Future<Uint8List> convertImage({
    required OriginalImage originalImage,
    required int compressAmount,
    required bool isGrayScale,
    required ConvertMode convertMode,
    required Color? filledColor,
  }) async {
    return await repo.convertImage(
      originalImage: originalImage,
      compressAmount: compressAmount,
      isGrayScale: isGrayScale,
      convertMode: convertMode,
      filledColor: filledColor,
    );
  }

  Future<List<OriginalImage>> encodeImage(List<XFile> images) {
    return repo.encodeImages(images);
  }

  Future<SavedFile> convertToImage({
    required ConvertMode convertMode,
    required Uint8List image,
    required String imageName,
    required String storagePath,
  }) async {
    return repo.convertToImage(
      convertMode: convertMode,
      image: image,
      imageName: imageName,
      storagePath: storagePath,
    );
  }

  Future<SavedFile> convertToPdf({
    required String basePdfName,
    required String storagePath,
    required List<Uint8List> images,
  }) async {
    return repo.convertToPdf(
      basePdfName: basePdfName,
      storagePath: storagePath,
      images: images,
    );
  }
}
