import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

import '../../../../../core/enums/convert_mode.dart';
import '../../../domain/entities/original_image.dart';
import '../../../domain/usecases/convert_image_usecase.dart';
import 'convert_images_state.dart';
import 'image_display_cubit.dart';

class ConvertImagesCubit extends Cubit<ConvertImagesState> {
  ConvertImageUsecase convertImageUsecase;
  final List<ImageDisplayCubit> cubits = [];

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
    for (final image in originalImages) {
      final cubit = ImageDisplayCubit(convertImageUsecase)..convertImage(
        originalImage: image,
        compressAmount: state.compressAmount,
        isGrayScale: state.isGrayScale,
        convertMode: state.convertMode,
      );

      cubits.add(cubit);
    }

    emit(state.copyWith(cubits: cubits));
  }

  //convert to original images from xfiles
  Future<void> onConvertImages(List<XFile> imageXFiles) async {
    emit(state.copyWith(isConvertingImageToBytes: true));

    final List<OriginalImage> originalImages = await convertImageUsecase
        .encodeImage(imageXFiles);

    emit(state.copyWith(isConvertingImageToBytes: false));

    await onCreateImageDisplayCubits(originalImages);

    print(originalImages.length);
    emit(state.copyWith(images: originalImages));
  }

  //select convert mode
  void onSelectConvertMode(ConvertMode convertMode) async {
    print("-----------------------------------------------${convertMode.name}");
    emit(state.copyWith(convertMode: convertMode));

    for (int i = 0; i < state.cubits.length; i++) {
      final image = state.images[i];

      final cubit = state.cubits[i];
      cubit.convertImage(
        originalImage: image,
        compressAmount: state.compressAmount,
        isGrayScale: state.isGrayScale,
        convertMode: state.convertMode,
      );
    }
  }

  // compression amount changed
  void onCompressionAmountChanged(int value) {
    emit(state.copyWith(compressAmount: value));

    for (int i = 0; i < state.cubits.length; i++) {
      final image = state.images[i];

      final cubit = state.cubits[i];
      cubit
        ..onLoading()
        ..convertImage(
          originalImage: image,
          compressAmount: state.compressAmount,
          isGrayScale: state.isGrayScale,
          convertMode: state.convertMode,
        );
    }
  }

  // isGrayScale checked
  void onGrayScalePressed() {
    final newIsGrayScale = !state.isGrayScale;
    final convertMode = state.convertMode;
    final compressAmount = state.compressAmount;
    final cubits = state.cubits;
    final images = state.images;

    emit(state.copyWith(isGrayScale: newIsGrayScale));

    for (int i = 0; i < cubits.length; i++) {
      final image = images[i];
      final cubit = cubits[i];

      cubit.convertImage(
        originalImage: image,
        compressAmount: compressAmount,
        isGrayScale: newIsGrayScale,
        convertMode: convertMode,
      );
    }
  }

  Future<Uint8List> grayscaleWorker(Uint8List bytes, ConvertMode convertMode) {
    return Isolate.run(() {
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

  // Future<void> convertImage({
  //   required Uint8List bytes,
  //   required int compressAmount,
  //   required bool isGrayScale,
  //   required ConvertMode convertMode,
  // }) async {
  //   emit(state.copyWith(isLoadingImage: true, isLoadingSize: true));

  //   final image = await convertImageUsecase.convertImage(
  //     bytes: bytes,
  //     compressAmount: compressAmount,
  //     isGrayScale: isGrayScale,
  //     convertMode: convertMode,
  //   );

  //   print("Dung luong : ${state.size}");

  //   emit(
  //     state.copyWith(
  //       image: image,
  //       size: Utils.formatSize(image.length),
  //       isLoadingImage: false,
  //       isLoadingSize: false,
  //     ),
  //   );
  // }
}
