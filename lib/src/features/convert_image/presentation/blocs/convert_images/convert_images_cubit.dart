// Dart imports:
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;

// Project imports:
import '../../../../../core/enums/convert.dart';
import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/storages/local_storage.dart';
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

    final order = List.generate(cubits.length, (index) => index);
    print(order);

    emit(state.copyWith(cubits: cubits, images: originalImages, order: order));
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

  //reorder image
  void onReOrderImages(List<int> order) {
    emit(state.copyWith(order: order));
  }

  // convert to pdf
  Future<SavedFile> _convertToPdf(
    String basePdfName,
    String storagePath,
  ) async {
    // final List<Uint8List> listImages =
    //     state.cubits.map((cubit) => cubit.state.image!).toList();
    final List<Uint8List> listImages = [];
    for (final order in state.order) {
      listImages.add(state.cubits[order].state.image!);
    }

    final savedFile = convertImageUsecase.convertToPdf(
      basePdfName: basePdfName,
      storagePath: storagePath,
      images: listImages,
    );

    return savedFile;
  }

  Future<StorePathChose> _showPathSelectDialog(BuildContext context) async {
    await LocalStorage.requestStoragePermission();

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
    final storePathChose = await _showPathSelectDialog(context);
    if (storePathChose == StorePathChose.none) return;
    print(
      "_________________cubit______________convert to file_______________storepath$storePathChose",
    );
    List<SavedFile> savedFiles = [];

    //check if any image is converting and wait
    while (convertingImageKeys.isNotEmpty) {
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
        storagePath = await LocalStorage.getSelectStoragePath(context);
        break;

      case StorePathChose.defaultPath:
        storagePath = await LocalStorage.getDefaultStoragePath(convertFile);
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
      final pdfSavedFile = await _convertToPdf(basePdfName, storagePath);
      savedFiles.add(pdfSavedFile);
    } else {
      //convert to image

      storagePath = path.join(
        storagePath,

        //check if image name exist or not
        "${Utils.getExtensionFromConvertMode(state.convertMode)} images",
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

      savedFiles = _onOrderChanged(savedFiles, convertMode);
      await Navigator.pushNamed(
        context,
        "/saved_files",
        arguments: {"savedFiles": savedFiles},
      );
    }
  }

  List<SavedFile> _onOrderChanged(
    List<SavedFile> savedFiles,
    ConvertMode convertMode,
  ) {
    final checkOrder = List.generate(state.cubits.length, (index) => index);
    final isOrderChanged = checkOrder != state.order;
    List<SavedFile> newSavedFilesList = [];

    if (isOrderChanged && convertMode != ConvertMode.pdf) {
      for (final order in state.order) {
        final newSavedFile = savedFiles[order];
        newSavedFilesList.add(newSavedFile);
      }
    } else {
      return savedFiles;
    }

    return newSavedFilesList;
  }
}
