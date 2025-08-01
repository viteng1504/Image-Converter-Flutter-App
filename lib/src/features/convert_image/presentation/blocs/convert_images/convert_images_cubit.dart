import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../../../core/enums/convert_mode.dart';
import '../../../domain/entities/original_image.dart';
import '../../../domain/usecases/convert_image_usecase.dart';
import 'convert_images_state.dart';
import 'image_display_cubit.dart';

class ConvertImagesCubit extends Cubit<ConvertImagesState> {
  ConvertImageUsecase convertImageUsecase;
  final Map<String, Uint8List> cachedImages = {};
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
  }) {
    return "i${index}_m${convertMode.name}_ca${compressAmount}_gr$isGrayScale";
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
      );
      final cubit = ImageDisplayCubit(convertImageUsecase);

      convertingImageKeys.add(key);

      final convertedImage = await cubit.convertImage(
        originalImage: image,
        compressAmount: state.compressAmount,
        isGrayScale: state.isGrayScale,
        convertMode: state.convertMode,
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

    print(originalImages.length);
  }

  //select convert mode

  void onImageConversionOptionChanged({
    ConvertMode? convertMode,
    bool? isGrayScale,
    int? compressAmount,
  }) async {
    final newConvertMode = convertMode ?? state.convertMode;
    final newIsGrayScale = isGrayScale ?? state.isGrayScale;
    final newCompressAmount = compressAmount ?? state.compressAmount;

    emit(
      state.copyWith(
        convertMode: newConvertMode,
        isGrayScale: newIsGrayScale,
        compressAmount: newCompressAmount,
      ),
    );

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
      );

      if (cachedImages.containsKey(key)) {
        cubit.updateImageUI(cachedImages[key]!);
        continue;
      }

      if (convertingImageKeys.contains(key)) continue;

      Future(() async {
        final convertedImage = await cubit.convertImage(
          originalImage: image,
          compressAmount: newCompressAmount,
          isGrayScale: newIsGrayScale,
          convertMode: newConvertMode,
        );

        convertingImageKeys.add(key);
        cachedImages[key] = convertedImage;
        convertingImageKeys.remove(key);
        cubit.updateImageUI(convertedImage);

        // check if state is changed
        // if (state.isGrayScale == newIsGrayScale &&
        //     state.convertMode == newConvertMode &&
        //     state.compressAmount == newCompressAmount) {}
      });
    }
  }

  //
  void onSelectConvertMode(ConvertMode convertMode) {
    onImageConversionOptionChanged(convertMode: convertMode);
  }

  // compression amount changed
  void onCompressionAmountChanged(int value) {
    onImageConversionOptionChanged(compressAmount: value);
  }

  // isGrayScale checked
  void onGrayScalePressed() {
    onImageConversionOptionChanged(isGrayScale: !state.isGrayScale);
    print(
      "grayScale ______________________________________________________${state.isGrayScale}",
    );
  }
}
