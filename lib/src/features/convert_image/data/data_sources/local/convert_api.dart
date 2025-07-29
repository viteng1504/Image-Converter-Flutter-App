import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

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

  // detect image format png, jpg, webp
  ImageFormat detectImageFormat(Uint8List bytes) {
    if (bytes.length < 12) return ImageFormat.unknown;

    // PNG: 89 50 4E 47 0D 0A 1A 0A
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A) {
      return ImageFormat.png;
    }

    // JPEG: FF D8 FF
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return ImageFormat.jpg;
    }

    // WebP (RIFF....WEBP)
    if (bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return ImageFormat.webp;
    }

    return ImageFormat.unknown;
  }

  Uint8List encodeImageWithFormat(img.Image image, ImageFormat format) {
    return switch (format) {
      ImageFormat.jpg => img.encodeJpg(image),
      ImageFormat.png => img.encodePng(image),
      ImageFormat.webp => img.encodeJpg(image),
      _ => throw UnimplementedError('Unsupported format: $format'),
    };
  }

  Future<List<OriginalImage>> encodeImages(
    List<XFile> images,
    int maxSize,
  ) async {
    final List<OriginalImage> imageList = [];

    for (final image in images) {
      final bytes = await image.readAsBytes();
      print(
        "maxsize1111111111111111111111111111111111111111111111111111111111111111 ${bytes.length}",
      );
      img.Image decodedImage = img.decodeImage(bytes)!;
      int width = decodedImage.width;
      int height = decodedImage.height;
      int imageMaxSize = max(width, height);

      //decrease size if image too big
      if (imageMaxSize > DeviceInfo.maxSize) {
        double scale = maxSize / imageMaxSize;

        decodedImage = img.copyResize(
          decodedImage,
          width: (decodedImage.width * scale).round(),
          height: (decodedImage.height * scale).round(),
        );
      }

      // save half size image
      final halfSizeImage = img.copyResize(
        decodedImage,
        width: (decodedImage.width * 0.5).round(),
        height: (decodedImage.height * 0.5).round(),
      );

      //encode image to bytes
      final halfSizeImageBytes = encodeImageWithFormat(
        halfSizeImage,
        detectImageFormat(bytes),
      );

      final originalImage = encodeImageWithFormat(
        decodedImage,
        detectImageFormat(bytes),
      );

      print(
        "encode iamge 1111111111111111111111111111111111111111111111111111111111 ${originalImage.length}",
      );

      // add to list
      imageList.add(
        OriginalImage(
          bytes: originalImage,
          name: image.name,
          halfSizeImagebytes: halfSizeImageBytes,
        ),
      );
    }
    return imageList;
  }

  Future<List<OriginalImage>> encodeImagesIsolate(List<XFile> images) async {
    final int maxSize = DeviceInfo.maxSize;
    return await Isolate.run(() {
      return encodeImages(images, maxSize);
    });
  }

  Future<Uint8List> convertImageIsolate({
    required Uint8List bytes,
    required int compressAmount,
    required bool isGrayScale,
    required ConvertMode convertMode,
  }) async {
    Uint8List imageBytes;
    imageBytes = bytes;

    print("iamge size convert ${imageBytes.length}");

    final format = switch (convertMode) {
      ConvertMode.jpg => CompressFormat.jpeg,
      ConvertMode.png => CompressFormat.png,
      ConvertMode.webp => CompressFormat.webp,
      _ => CompressFormat.jpeg,
    };

    if (format == CompressFormat.png) {
      final Uint8List resizedEncoded = await Isolate.run(() {
        final decoded = img.decodeImage(bytes);
        if (decoded == null) throw Exception("Decode failed");

        final scale = 1.0 - (compressAmount.clamp(0, 100) / 100.0 * 0.9);
        final resized = img.copyResize(
          decoded,
          width: (decoded.width * scale).round(),
          height: (decoded.height * scale).round(),
        );

        return switch (convertMode) {
          ConvertMode.jpg => Uint8List.fromList(img.encodeJpg(resized)),
          ConvertMode.png => Uint8List.fromList(img.encodePng(resized)),
          ConvertMode.webp => Uint8List.fromList(img.encodeJpg(resized)),
          _ => bytes,
        };
      });

      return resizedEncoded;
    }

    final compressed = await FlutterImageCompress.compressWithList(
      imageBytes,
      quality: (90 - (compressAmount * 0.8)).round().clamp(0, 90),
      format: format,
    );

    print("compress image convert ${compressed.length}");

    return compressed;
  }

  Future<List<OriginalImage>> onHalfImagesSize(List<XFile> imageXFiles) async {
    return await Isolate.run(() async {
      List<OriginalImage> list = [];
      for (final image in imageXFiles) {
        final bytes = await image.readAsBytes();
        final decodeImage = img.decodeImage(bytes);

        final resizeImage = img.resize(
          decodeImage!,
          width: (decodeImage.width * 0.5).toInt(),
          height: (decodeImage.height * 0.5).toInt(),
        );

        final encodeImage = img.encodeJpg(resizeImage);

        final originalImageBytes = await FlutterImageCompress.compressWithList(
          encodeImage,
          quality: 90,
          format: CompressFormat.jpeg,
        );
        print("half size image test ${originalImageBytes.length} ");

        list.add(
          OriginalImage(
            halfSizeImagebytes: encodeImage,
            bytes: bytes,
            name: image.name,
          ),
        );
      }
      return list;
    });
  }
}
