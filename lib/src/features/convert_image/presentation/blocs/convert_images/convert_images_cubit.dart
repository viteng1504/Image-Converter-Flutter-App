import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../../../core/enums/convert_mode.dart';
import '../../../domain/entities/original_image.dart';
import '../../../domain/usecases/convert_image_usecase.dart';
import 'convert_images_state.dart';

class ConvertImagesCubit extends Cubit<ConvertImagesState> {
  ConvertImageUsecase selectImageUsecase;

  ConvertImagesCubit(this.selectImageUsecase)
    : super(ConvertImagesState.initial());

  void isLoadingFalse() {
    emit(state.copyWith(isConvertingImageToBytes: false));
  }

  Future<void> onConvertImages(List<XFile> imageXFiles) async {
    emit(state.copyWith(isConvertingImageToBytes: true));

    final List<OriginalImage> originalImages = await selectImageUsecase
        .encodeImage(imageXFiles);
    print(originalImages.length);
    emit(
      state.copyWith(images: originalImages, isConvertingImageToBytes: false),
    );
  }

  //select convert mode
  void onSelectConvertMode(ConvertMode convertMode) {
    emit(state.copyWith(convertMode: convertMode));
  }

  // compression amount changed
  void onCompressionAmountChanged(int value) {
    emit(state.copyWith(compressAmount: value));
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
