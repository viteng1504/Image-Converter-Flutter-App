// Dart imports:
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

// Package imports:
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path/path.dart' as path;
import 'package:syncfusion_flutter_pdf/pdf.dart';

// Project imports:
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
    required Color? filledColor,
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

    if (isGrayScale || filledColor != null) {
      bytes = await DeviceInfo.pool.withResource(() async {
        return await isolateWorker(
          bytes,
          convertMode,
          isGrayScale,
          filledColor,
        );
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

  Future<Uint8List> isolateWorker(
    Uint8List bytes,
    ConvertMode convertMode,
    bool isGrayScale,
    Color? filledColor,
  ) {
    return Isolate.run(() {
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return bytes;

      img.Image result = decoded;

      // fill transparency color
      if (filledColor != null) {
        final bgR = filledColor.red; // int 0..255
        final bgG = filledColor.green; // int 0..255
        final bgB = filledColor.blue; // int 0..255
        final bgA = filledColor.alpha; // int 0..255

        final out = img.Image(width: result.width, height: result.height);

        for (int y = 0; y < result.height; y++) {
          for (int x = 0; x < result.width; x++) {
            final s = result.getPixel(x, y); // src pixel
            final sr = s.r, sg = s.g, sb = s.b, sa = s.a;

            if (sa == 0) {
              out.setPixelRgba(x, y, bgR, bgG, bgB, bgA);
              continue;
            }

            if (bgA == 0) {
              out.setPixelRgba(x, y, sr, sg, sb, sa);
              continue;
            }

            final as = sa / 255.0;
            final ab = bgA / 255.0;

            final aOut = as + ab * (1.0 - as);
            if (aOut == 0) {
              out.setPixelRgba(x, y, 0, 0, 0, 0);
              continue;
            }

            final rOut = ((sr * as + bgR * ab * (1.0 - as)) / aOut).round();
            final gOut = ((sg * as + bgG * ab * (1.0 - as)) / aOut).round();
            final bOut = ((sb * as + bgB * ab * (1.0 - as)) / aOut).round();
            final aOutInt = (aOut * 255).round().clamp(0, 255);

            out.setPixelRgba(x, y, rOut, gOut, bOut, aOutInt);
          }
        }

        result = out;
      }

      // grayscale
      if (isGrayScale) {
        result = img.grayscale(result);
      }

      switch (convertMode) {
        case ConvertMode.jpg:
          return Uint8List.fromList(img.encodeJpg(result, quality: 95));
        case ConvertMode.png:
          return Uint8List.fromList(img.encodePng(result));
        case ConvertMode.webp:
          return Uint8List.fromList(img.encodePng(result));
        default:
          return Uint8List.fromList(img.encodeJpg(result, quality: 95));
      }
    });
  }

  //convert to image and save in gallery

  Future<Map<String, String>> createUniquePath(
    String fileName,
    String storagePath,
    String extensionName,
  ) async {
    print("extension Name $extensionName");
    final baseFileName = path.basenameWithoutExtension(fileName);

    String imageName = "$baseFileName$extensionName";
    String newPath = path.join(storagePath, imageName);
    int index = 1;
    while (await File(newPath).exists()) {
      imageName = "$baseFileName ($index)$extensionName";
      newPath = path.join(storagePath, imageName);
      index++;
    }

    Map<String, String> map = {"imagePath": newPath, "imageName": imageName};

    return map;
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
        return 'png';
    }
  }

  Future<SavedFile> convertToImage({
    required ConvertMode convertMode,
    required Uint8List image,
    required String imageName,
    required String storagePath,
  }) async {
    final map = await createUniquePath(
      imageName,
      storagePath,
      ".${getExtensionFromConvertMode(convertMode)}",
    );

    final imagePath = map["imagePath"];
    if (imagePath == null || imagePath.isEmpty) {
      throw Exception(
        "imagePath is null or empty. Check createUniquePath on ConvertApi",
      );
    }

    //save image to file
    await File(imagePath).writeAsBytes(image);

    await MediaScanner.loadMedia(path: imagePath);

    return SavedFile(
      image: image,
      name: map["imageName"]!,
      size: Utils.formatSize(image.length),
      path: imagePath,
    );
  }

  // convert to pdf
  Future<SavedFile> convertToPdf({
    required String basePdfName,
    required String storagePath,
    required List<Uint8List> images,
  }) async {
    Uint8List firstImage = images[0];

    final PdfDocument document = PdfDocument();
    for (final image in images) {
      final PdfImage pdfImage = PdfBitmap(image);

      final page = document.pages.add();
      final originalWidth = pdfImage.width;
      final originalHeight = pdfImage.height;

      final double widthRatio = page.getClientSize().width / originalWidth;
      final double heightRatio = page.getClientSize().height / originalHeight;
      final double scale = widthRatio < heightRatio ? widthRatio : heightRatio;

      final double imageWidth = originalWidth * scale;
      final double imageHeight = originalHeight * scale;

      final double x = (page.getClientSize().width - imageWidth) / 2;
      final double y = (page.getClientSize().height - imageHeight) / 2;

      page.graphics.drawImage(
        pdfImage,
        Rect.fromLTWH(x, y, imageWidth, imageHeight),
      );
    }

    final List<int> bytes = await document.save();
    document.dispose();

    final downloadDir = Directory(storagePath);
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    // Tạo tên file ngẫu nhiên và kiểm tra trùng

    String fileName = basePdfName;
    int count = 1;
    while (File('${downloadDir.path}/$fileName.pdf').existsSync()) {
      fileName = '$basePdfName($count)';
      count++;
    }

    final file = File('${downloadDir.path}/$fileName.pdf');

    print("convert to pdf ${bytes.length}");
    await file.writeAsBytes(bytes);

    return SavedFile(
      image: firstImage,
      name: "$fileName.pdf",
      size: Utils.formatSize(bytes.length),
      path: "${downloadDir.path}/$fileName.pdf",
    );
  }
}
