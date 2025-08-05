// Dart imports:
import 'dart:math';
import 'dart:typed_data';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../../core/enums/convert.dart';
import '../../../../../core/utils/utils.dart';
import '../../../domain/entities/original_image.dart';
import '../../../domain/usecases/convert_image_usecase.dart';
import 'image_display_state.dart';

class ImageDisplayCubit extends Cubit<ImageDisplayState> {
  final ConvertImageUsecase convertImageUsecase;

  ImageDisplayCubit(this.convertImageUsecase)
    : super(ImageDisplayState.initial());

  void loadingSize() async {
    emit(state.copyWith(isLoadingSize: true));
    final random = Random();
    int num1 = 1000 + random.nextInt(3000);
    await Future.delayed(Duration(milliseconds: num1));
    emit(state.copyWith(isLoadingSize: false));
  }

  void loadingImage() async {
    emit(state.copyWith(isLoadingImage: true));
    final random = Random();
    int num1 = 1000 + random.nextInt(3000);
    await Future.delayed(Duration(milliseconds: num1));
  }

  // void saveImageState()

  Future<Uint8List> convertImage({
    required OriginalImage originalImage,
    required int compressAmount,
    required bool isGrayScale,
    required ConvertMode convertMode,
  }) async {
    emit(state.copyWith(isLoadingImage: true, isLoadingSize: true));

    final image = await convertImageUsecase.convertImage(
      originalImage: originalImage,
      compressAmount: compressAmount,
      isGrayScale: isGrayScale,
      convertMode: convertMode,
    );

    print(
      "________________________________________________________________________________${image.length}",
    );

    // emit(
    //   state.copyWith(
    //     image: image,
    //     // cachedImage: image,
    //     size: Utils.formatSize(image.length),
    //     isLoadingImage: false,
    //     isLoadingSize: false,
    //   ),
    // );
    return image;
  }

  void updateImageUI(Uint8List image) {
    emit(
      state.copyWith(
        image: image,
        // cachedImage: image,
        size: Utils.formatSize(image.length),
        isLoadingImage: false,
        isLoadingSize: false,
      ),
    );
  }

  Future<void> onGrayScaling({
    required OriginalImage originalImage,
    required int compressAmount,
    required bool isGrayScale,
    required ConvertMode convertMode,
  }) async {
    emit(state.copyWith(isLoadingImage: true, isLoadingSize: true));

    final image = await convertImageUsecase.convertImage(
      originalImage: originalImage,
      compressAmount: compressAmount,
      isGrayScale: isGrayScale,
      convertMode: convertMode,
    );

    emit(
      state.copyWith(
        image: image,
        // cachedImage: image,
        size: Utils.formatSize(image.length),
        isLoadingSize: false,
        isLoadingImage: false,
      ),
    );
  }

  void onLoading() {
    emit(state.copyWith(isLoadingImage: true, isLoadingSize: true));
  }

  void onGrayScaleLoading() {
    emit(state.copyWith(isLoadingImage: false, isLoadingSize: true));
  }

  void onStopLoading() {
    emit(state.copyWith(isLoadingImage: false, isLoadingSize: false));
  }
}
