// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:flutter_image_compress/flutter_image_compress.dart';

// Project imports:
import '../../../../core/device_info.dart';
import '../../../../core/enums/convert.dart';
import '../../domain/entities/original_image.dart';
import '../../domain/entities/saved_file.dart';
import '../../domain/repositories/images_repository.dart';
import '../data_sources/local/convert_api.dart';

class ImagesRepositoryImpl implements ImagesRepository {
  final ConvertApi api;

  ImagesRepositoryImpl(this.api);

  @override
  Future<List<XFile>> selectImages() async {
    final images = await api.selectImages();
    return images;
  }

  @override
  Future<List<OriginalImage>> encodeImages(List<XFile> images) async {
    return await api.encodeImages(images, DeviceInfo.maxSize);
  }

  @override
  Future<Uint8List> convertImage({
    required OriginalImage originalImage,
    required int compressAmount,
    required bool isGrayScale,
    required ConvertMode convertMode,
  }) async {
    return await api.convertImageIsolate(
      originalImage: originalImage,
      compressAmount: compressAmount,
      isGrayScale: isGrayScale,
      convertMode: convertMode,
    );
  }

  @override
  Future<SavedFile> convertToImage({
    required ConvertMode convertMode,
    required Uint8List image,
    required String imageName,
    required String storagePath,
  }) async {
    return api.convertToImage(
      convertMode: convertMode,
      image: image,
      imageName: imageName,
      storagePath: storagePath,
    );
  }
}
