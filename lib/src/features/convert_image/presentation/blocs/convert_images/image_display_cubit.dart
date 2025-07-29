import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/enums/convert_mode.dart';
import '../../../../../core/utils/utils.dart';
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

  Future<void> convertImage({
    required Uint8List bytes,
    required int compressAmount,
    required bool isGrayScale,
    required ConvertMode convertMode,
  }) async {
    emit(state.copyWith(isLoadingImage: true, isLoadingSize: true));

    final image = await convertImageUsecase.convertImage(
      bytes: bytes,
      compressAmount: compressAmount,
      isGrayScale: isGrayScale,
      convertMode: convertMode,
    );

    print("Dung luong : ${state.size}");

    emit(
      state.copyWith(
        image: image,
        size: Utils.formatSize(image.length),
        isLoadingImage: false,
        isLoadingSize: false,
      ),
    );
  }
}
