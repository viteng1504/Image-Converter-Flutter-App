// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../../../../../core/enums/convert.dart';
import '../../../domain/entities/original_image.dart';
import 'image_display_cubit.dart';

part 'convert_images_state.freezed.dart';

@freezed
class ConvertImagesState with _$ConvertImagesState {
  const factory ConvertImagesState({
    required bool isConvertingImageToBytes,
    required bool isConvertingToFiles,
    required List<OriginalImage> images,
    required int compressAmount,
    required bool isGrayScale,
    required ConvertMode convertMode,
    required List<ImageDisplayCubit> cubits,
    required int convertedImageQty,
    required Color? filledColor,
  }) = _ConvertImagesState;

  factory ConvertImagesState.initial() {
    return const ConvertImagesState(
      isConvertingImageToBytes: false,
      images: [],
      compressAmount: 0,
      isGrayScale: false,
      convertMode: ConvertMode.jpg,
      cubits: [],
      isConvertingToFiles: false,
      convertedImageQty: 0,
      filledColor: null
    );
  }
}
