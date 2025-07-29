import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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

  //create cubit list for each image
  Future<void> onCreateImageDisplayCubits(
    List<OriginalImage> originalImages,
  ) async {
    for (final image in originalImages) {
      final bytes = image.bytes;

      final cubit = ImageDisplayCubit(convertImageUsecase)..convertImage(
        bytes: bytes,
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

    await onCreateImageDisplayCubits(originalImages);

    print(originalImages.length);
    emit(
      state.copyWith(images: originalImages, isConvertingImageToBytes: false),
    );
  }

  Future<void> onHalfImagesSize(List<XFile> imageXFiles) async {
    List<OriginalImage> newOriginalImages = await convertImageUsecase
        .onHalfImagesSize(imageXFiles);
    print(imageXFiles.length);
    emit(state.copyWith(images: newOriginalImages));
  }

  //select convert mode
  void onSelectConvertMode(ConvertMode convertMode) async {
    emit(state.copyWith(convertMode: convertMode));

    for (int i = 0; i < state.cubits.length; i++) {
      final image = state.images[i];
      final bytes = image.bytes;

      final cubit = state.cubits[i];
      cubit.convertImage(
        bytes: bytes,
        compressAmount: state.compressAmount,
        isGrayScale: state.isGrayScale,
        convertMode: convertMode,
      );
    }
  }

  // compression amount changed
  void onCompressionAmountChanged(int value) {
    emit(state.copyWith(compressAmount: value));

    for (int i = 0; i < state.cubits.length; i++) {
      final image = state.images[i];
      final bytes = image.bytes;

      final cubit = state.cubits[i];
      cubit
        ..onLoading()
        ..convertImage(
          bytes: bytes,
          compressAmount: state.compressAmount,
          isGrayScale: state.isGrayScale,
          convertMode: state.convertMode,
        );
    }
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
