import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/enums/convert.dart';
import '../../../domain/entities/original_image.dart';
import 'image_display_cubit.dart';

part 'convert_images_state.freezed.dart';

@freezed
class ConvertImagesState with _$ConvertImagesState {
  const factory ConvertImagesState({
    required bool isConvertingImageToBytes,
    required List<OriginalImage> images,
    required List<OriginalImage> halfSizeImages,
    required int compressAmount,
    required bool isGrayScale,
    required ConvertMode convertMode,
    required List<ConvertImagesState> imageStateList,
    required List<ImageDisplayCubit> cubits,
  }) = _ConvertImagesState;

  factory ConvertImagesState.initial() => const ConvertImagesState(
    isConvertingImageToBytes: false,
    images: [],
    compressAmount: 0,
    isGrayScale: false,
    convertMode: ConvertMode.jpg,
    imageStateList: [],
    halfSizeImages: [],
    cubits: [],
  );
}
