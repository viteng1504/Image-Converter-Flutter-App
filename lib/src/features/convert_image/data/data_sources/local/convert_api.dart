import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path/path.dart' as path;

import '../../../../../core/device_info.dart';
import '../../../../../core/enums/convert.dart';
import '../../../../../core/utils/utils.dart';
import '../../../domain/entities/original_image.dart';
import '../../../domain/entities/saved_file.dart';

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

      //decrease size if image too big
      Uint8List resizeImage = bytes;

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
    Uint8List bytes = originalImage.bytes;
    final width = originalImage.width;
    final height = originalImage.height;

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

    if (isGrayScale) {
      bytes = await DeviceInfo.pool.withResource(() async {
        return await grayscaleWorker(bytes, convertMode);
      });
    } else {
      bytes = originalImage.bytes;
    }

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

    return compressed;
  }

  Future<Uint8List> grayscaleWorker(Uint8List bytes, ConvertMode convertMode) {
    return Isolate.run(() {
      print(
        "________________________________________________________________________________________________________________________grayIam",
      );
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return bytes;

      final grayImage = img.grayscale(decoded);

      return switch (convertMode) {
        ConvertMode.jpg => Uint8List.fromList(img.encodeJpg(grayImage)),
        ConvertMode.png => Uint8List.fromList(img.encodePng(grayImage)),
        ConvertMode.webp => Uint8List.fromList(img.encodePng(grayImage)),
        _ => Uint8List.fromList(img.encodeJpg(grayImage)),
      };
    });
  }

  //convert to image and save in gallery

  Future<String> createUniquePath(
    String fileName,
    String storagePath,
    String extensionName,
  ) async {
    final baseFileName = path.basenameWithoutExtension(fileName);

    String newPath = path.join(storagePath, fileName);
    int index = 1;
    while (await File(newPath).exists()) {
      newPath = path.join(storagePath, "$baseFileName ($index)$extensionName");
      index++;
    }

    return newPath;
  }

  String getExtensionFromConvertMode(ConvertMode mode) {
    switch (mode) {
      case ConvertMode.jpg:
        return 'jpg';
      case ConvertMode.png:
        return 'png';
      case ConvertMode.webp:
        return 'webp';
      default:
        return 'jpg';
    }
  }

  Future<SavedFile> convertToImage({
    required ConvertMode convertMode,
    required Uint8List image,
    required String imageName,
    required String storagePath,
  }) async {
    final imagePath = await createUniquePath(
      imageName,
      storagePath,
      ".${getExtensionFromConvertMode(convertMode)}",
    );

    print(imagePath);

    //save image to file
    print(123);
    await File(imagePath).writeAsBytes(image);

    await MediaScanner.loadMedia(path: imagePath);

    return SavedFile(
      image: image,
      name: imageName,
      size: Utils.formatSize(image.length),
      path: imagePath,
    );
  }
}
