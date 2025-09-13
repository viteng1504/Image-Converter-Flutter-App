// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

// Project imports:
import '../../../../../core/enums/convert.dart';
import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/utils/utils.dart';
import '../../../domain/entities/original_image.dart';
import '../../../domain/entities/saved_file.dart';
import '../../../domain/usecases/convert_image_usecase.dart';
import 'convert_images_state.dart';
import 'image_display_cubit.dart';

class ConvertImagesCubit extends Cubit<ConvertImagesState> {
  ConvertImageUsecase convertImageUsecase;
  final Map<String, Uint8List?> cachedImages = {};
  final Set<String> convertingImageKeys = {};

  ConvertImagesCubit(this.convertImageUsecase)
    : super(ConvertImagesState.initial());

  void isLoadingFalse() {
    emit(state.copyWith(isConvertingImageToBytes: false));
  }

  String buildImageKeyMap({
    required int index,
    required ConvertMode convertMode,
    required int compressAmount,
    required bool isGrayScale,
    required Color? filledColor,
  }) {
    if (convertMode == ConvertMode.pdf) {
      convertMode = ConvertMode.jpg;
    }
    return "i${index}_m${convertMode.name}_ca${compressAmount}_gr${isGrayScale}_c$filledColor";
  }

  //create cubit list for each image
  Future<void> onCreateImageDisplayCubits(
    List<OriginalImage> originalImages,
  ) async {
    final isGrayScale = state.isGrayScale;
    final oldConvertMode = state.convertMode;
    final compressAmount = state.compressAmount;
    int i = 0;
    final List<ImageDisplayCubit> cubits = [];

    for (final image in originalImages) {
      final key = buildImageKeyMap(
        index: i,
        convertMode: state.convertMode,
        compressAmount: state.compressAmount,
        isGrayScale: state.isGrayScale,
        filledColor: state.filledColor,
      );
      final cubit = ImageDisplayCubit(convertImageUsecase);

      convertingImageKeys.add(key);

      final convertedImage = await cubit.convertImage(
        originalImage: image,
        compressAmount: state.compressAmount,
        isGrayScale: state.isGrayScale,
        convertMode: state.convertMode,
        filledColor: state.filledColor,
      );

      cachedImages[key] = convertedImage;
      convertingImageKeys.remove(key);

      if (isGrayScale == state.isGrayScale &&
          compressAmount == state.compressAmount &&
          oldConvertMode == state.convertMode) {
        cubit.updateImageUI(convertedImage);
      }

      cubits.add(cubit);
      i++;
    }

    emit(state.copyWith(cubits: cubits, images: originalImages));
  }

  //convert to original images from xfiles
  Future<void> onConvertImages(List<XFile> imageXFiles) async {
    emit(state.copyWith(isConvertingImageToBytes: true));

    final List<OriginalImage> originalImages = await convertImageUsecase
        .encodeImage(imageXFiles);

    await onCreateImageDisplayCubits(originalImages);
    emit(state.copyWith(isConvertingImageToBytes: false));
  }

  //select convert mode

  void onImageConversionOptionChanged({
    ConvertMode? convertMode,
    bool? isGrayScale,
    int? compressAmount,
    Color? filledColor,
  }) async {
    ConvertMode newConvertMode = convertMode ?? state.convertMode;
    final newIsGrayScale = isGrayScale ?? state.isGrayScale;
    final newCompressAmount = compressAmount ?? state.compressAmount;
    final newFilledColor = filledColor ?? state.filledColor;

    emit(
      state.copyWith(
        convertMode: newConvertMode,
        isGrayScale: newIsGrayScale,
        compressAmount: newCompressAmount,
        filledColor: newFilledColor,
      ),
    );

    if (newConvertMode == ConvertMode.pdf) {
      newConvertMode = ConvertMode.jpg;
    }

    // loading all image
    for (final cubit in state.cubits) {
      cubit.onLoading();
    }

    for (int i = 0; i < state.cubits.length; i++) {
      final index = i;
      final cubit = state.cubits[index];
      final image = state.images[index];

      final key = buildImageKeyMap(
        index: index,
        convertMode: newConvertMode,
        compressAmount: newCompressAmount,
        isGrayScale: newIsGrayScale,
        filledColor: newFilledColor,
      );

      if (cachedImages.containsKey(key)) {
        cubit.updateImageUI(cachedImages[key]!);
        continue;
      }
      cachedImages[key] = null;

      if (convertingImageKeys.contains(key)) continue;
      convertingImageKeys.add(key);

      Future(() async {
        final convertedImage = await cubit.convertImage(
          originalImage: image,
          compressAmount: newCompressAmount,
          isGrayScale: newIsGrayScale,
          convertMode: newConvertMode,
          filledColor: newFilledColor,
        );

        cachedImages[key] = convertedImage;
        convertingImageKeys.remove(key);

        // check if state is changed to prevent emit old state
        if (state.isGrayScale == newIsGrayScale &&
            state.convertMode == newConvertMode &&
            state.compressAmount == newCompressAmount &&
            state.filledColor == newFilledColor) {
          cubit.updateImageUI(convertedImage);
        }
      });
    }
  }

  //
  void onSelectConvertMode(ConvertMode convertMode) {
    emit(state.copyWith(filledColor: null));
    onImageConversionOptionChanged(convertMode: convertMode);
  }

  // compression amount changed
  void onCompressionAmountChanged(int value) {
    onImageConversionOptionChanged(compressAmount: value);
  }

  // isGrayScale checked
  void onGrayScalePressed() {
    onImageConversionOptionChanged(isGrayScale: !state.isGrayScale);
  }

  // filled transparency color changed
  void onFilledColorChanged(Color? filledColor) {
    onImageConversionOptionChanged(filledColor: filledColor);
  }

  //get Storage path
  Future<String> getDefaultStoragePath(ConvertFile convertFile) async {
    final Directory? externalDir = await getExternalStorageDirectory();

    if (externalDir == null) {
      throw Exception("Cannot access external storage");
    }

    final String path = externalDir.path.split("/Android")[0];

    final convertPath = switch (convertFile) {
      ConvertFile.image => "$path/Pictures",
      ConvertFile.pdf => "$path/Download",
    };

    print(convertPath);

    return convertPath;
  }

  //get select store path
  Future<String?> getSelectStoragePath(BuildContext context) async {
    try {
      // get root path
      final appDocsDir = await getApplicationDocumentsDirectory();
      final rootDir = Directory(appDocsDir.path);

      // make sure path exists
      if (!await rootDir.exists()) {
        await rootDir.create(recursive: true);
      }

      if (!context.mounted) return null;

      final path = await FilesystemPicker.open(
        title: 'Select Folder',
        context: context,
        rootDirectory: rootDir,
        fsType: FilesystemType.folder,
        pickText: 'Select this folder',
        folderIconColor: AppColors.fontGray,
        requestPermission: () async => true,

        // show New folder button
        contextActions: [FilesystemPickerNewFolderContextAction()],

        theme: FilesystemPickerTheme(
          topBar: FilesystemPickerTopBarThemeData(
            backgroundColor: Colors.teal,
            titleTextStyle: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.white,
          fileList: FilesystemPickerFileListThemeData(
            // folderTextStyle: const TextStyle(color: Colors.white),
          ),
        ),
      );

      debugPrint('getSelectStoragePath => $path');
      return path;
    } catch (e, s) {
      debugPrint('getSelectStoragePath error: $e\n$s');
      return null;
    }
  }

  //check if image name exist or not
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

  // convert to pdf
  Future<SavedFile> convertToPdf(String basePdfName, String storagePath) async {
    Uint8List firstImage = state.cubits[0].state.image!;

    final PdfDocument document = PdfDocument();
    for (final cubit in state.cubits) {
      final imageBytes = cubit.state.image;

      final PdfImage image = PdfBitmap(imageBytes!);

      final page = document.pages.add();
      final originalWidth = image.width;
      final originalHeight = image.height;

      final double widthRatio = page.getClientSize().width / originalWidth;
      final double heightRatio = page.getClientSize().height / originalHeight;
      final double scale = widthRatio < heightRatio ? widthRatio : heightRatio;

      final double imageWidth = originalWidth * scale;
      final double imageHeight = originalHeight * scale;

      final double x = (page.getClientSize().width - imageWidth) / 2;
      final double y = (page.getClientSize().height - imageHeight) / 2;

      page.graphics.drawImage(
        image,
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

  Future<StorePathChose> showPathSelectDialog(BuildContext context) async {
    StorePathChose? result = await showDialog<StorePathChose>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          content: const Text(
            "Do you want to use Default Path or your Select Path?",
            style: TextStyle(color: AppColors.white),
          ),

          title: const Text(
            'Choose Storage Path',
            style: TextStyle(color: AppColors.primary),
          ),
          actions: [
            TextButton(
              onPressed:
                  () => Navigator.pop(context, StorePathChose.defaultPath),
              child: const Text(
                'Default Path',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed:
                  () => Navigator.pop(context, StorePathChose.selectPath),
              child: const Text(
                'Select Path',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );

    return result ?? StorePathChose.none;
  }

  Future<void> onConvertToFile(BuildContext context, String basePdfName) async {
    //choose path
    final storePathChose = await showPathSelectDialog(context);
    if (storePathChose == StorePathChose.none) return;
    print(
      "_________________cubit______________convert to file_______________storepath$storePathChose",
    );
    final List<SavedFile> savedFiles = [];

    //check if any image is converting and wait
    while (convertingImageKeys.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 2000));
      if (convertingImageKeys.isEmpty) {
        break;
      }
    }
    final convertMode = state.convertMode;

    //Check convert to image or pdf
    final convertFile = switch (convertMode) {
      ConvertMode.jpg ||
      ConvertMode.png ||
      ConvertMode.webp => ConvertFile.image,
      ConvertMode.pdf => ConvertFile.pdf,
    };

    String? storagePath;

    switch (storePathChose) {
      case StorePathChose.selectPath:
        if (!context.mounted) return;
        storagePath = await getSelectStoragePath(context);
        break;

      case StorePathChose.defaultPath:
        storagePath = await getDefaultStoragePath(convertFile);
        break;

      case StorePathChose.none:
        storagePath = null;
        break;
    }

    if (storagePath == null) return;
    emit(state.copyWith(isConvertingToFiles: true));

    if (convertFile == ConvertFile.pdf) {
      if (storePathChose == StorePathChose.defaultPath) {
        storagePath = "/storage/emulated/0/Download/pdf files";
      }
      final pdfSavedFile = await convertToPdf(basePdfName, storagePath);
      savedFiles.add(pdfSavedFile);
    } else {
      //convert to image

      storagePath = path.join(
        storagePath,
        "${getExtensionFromConvertMode(state.convertMode)} images",
      );

      // create store images path
      final dir = Directory(storagePath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      print(storagePath);

      for (int i = 0; i < state.cubits.length; i++) {
        final imageKey = buildImageKeyMap(
          index: i,
          convertMode: state.convertMode,
          compressAmount: state.compressAmount,
          isGrayScale: state.isGrayScale,
          filledColor: state.filledColor,
        );
        final image = cachedImages[imageKey];

        final imageName = state.images[i].name;

        if (image != null) {
          print(state.convertMode);
          final savedFile = await convertImageUsecase.convertToImage(
            convertMode: convertMode,
            image: image,
            imageName: imageName,
            storagePath: storagePath,
          );
          emit(state.copyWith(convertedImageQty: state.convertedImageQty + 1));

          savedFiles.add(savedFile);
        }
      }
    }

    emit(state.copyWith(isConvertingToFiles: false));

    if (state.isConvertingImageToBytes == false &&
        convertingImageKeys.isEmpty) {
      emit(state.copyWith(convertedImageQty: 0));
      await Navigator.pushNamed(
        context,
        "/saved_files",
        arguments: {
          "savedFiles": savedFiles,
          // "firstImage": firstImage,
        },
      );
    }

    // return savedFiles;
  }
}
