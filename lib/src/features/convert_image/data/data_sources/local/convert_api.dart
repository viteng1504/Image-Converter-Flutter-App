import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/image_size_getter.dart';

import '../../../../../core/device_info.dart';
import '../../../../../core/enums/convert_mode.dart';
import '../../../domain/entities/original_image.dart';

enum ImageFormat { png, jpg, webp, unknown }

class ConvertApi {
  Future<List<XFile>> selectImages() async {
    final ImagePicker picker = ImagePicker();

    final List<XFile> images = await picker.pickMultiImage();

    return images;
  }

  Future<List<OriginalImage>> encodeImages(
    List<XFile> images,
    int maxSize,
  ) async {
    final List<OriginalImage> imageList = [];

    for (final image in images) {
      final bytes = await image.readAsBytes();

      final memoryImageSizeResult = ImageSizeGetter.getSizeResult(
        MemoryInput(bytes),
      );

      final imageSize = memoryImageSizeResult.size;
      int imageWidth = imageSize.width;
      int imageHeight = imageSize.height;

      final int imageMaxSize = max(imageWidth, imageHeight);

      //decrease size if image too big
      Uint8List resizeImage = bytes;

      // if (imageMaxSize > maxSize) {
      //   double scale = maxSize / imageMaxSize;
      //   resizeImage = await FlutterImageCompress.compressWithList(
      //     bytes,
      //     minHeight: (imageHeight * scale).toInt(),
      //     minWidth: (imageWidth * scale).toInt(),
      //     quality: 90,
      //   );
      // }

      print(
        "imageListimageListimageListimageListimageListimageListimageListimageListimageListimageListimageList",
      );

      // add to list
      imageList.add(
        OriginalImage(
          bytes: resizeImage,
          name: image.name,
          width: imageWidth,
          height: imageHeight,
        ),
      );
    }
    return imageList;
  }

  Future<Uint8List> convertImageIsolate({
    required OriginalImage originalImage,
    required int compressAmount,
    required bool isGrayScale,
    required ConvertMode convertMode,
  }) async {
    Uint8List compressed;
    final bytes = originalImage.bytes;
    final width = originalImage.width;
    final height = originalImage.height;

    print(
      "compress image compress image compress image compress image compress image compress image convert ${bytes.length == width * height * 3}",
    );

    //change image size if too big (bigger than screen size)
    final double newScale = DeviceInfo.maxSize / max(width, height);

    if (newScale < 1) {
      originalImage.changedImageSize(
        (width * newScale).toInt(),
        (height * newScale).toInt(),
      );
    }

    final scale = 1.0 - (compressAmount.clamp(0, 100) / 100.0 * 0.9);

    final format = switch (convertMode) {
      ConvertMode.jpg => CompressFormat.jpeg,
      ConvertMode.png => CompressFormat.png,
      ConvertMode.webp => CompressFormat.webp,
      _ => CompressFormat.jpeg,
    };

    if (format == CompressFormat.png) {
      compressed = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: (originalImage.width * scale).toInt(),
        minHeight: (originalImage.height * scale).toInt(),
        format: format,
      );
    } else {
      compressed = await FlutterImageCompress.compressWithList(
        bytes,
        quality: (90 - (compressAmount * 0.9)).round().clamp(0, 90),
        format: format,
      );
    }

    print("compress image convert ${compressed.length}");

    return compressed;
  }
}
