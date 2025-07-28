import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../../../core/enums/convert_mode.dart';
import '../../../domain/entities/original_image.dart';
import '../../../domain/usecases/select_image_usecase.dart';
import 'convert_images_state.dart';

class ConvertImagesCubit extends Cubit<ConvertImagesState> {
  SelectImageUsecase selectImageUsecase;

  ConvertImagesCubit(this.selectImageUsecase)
    : super(ConvertImagesState.initial());

  void isLoadingFalse() {
    emit(state.copyWith(isConvertingImageToBytes: false));
  }

  //select images
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
}
