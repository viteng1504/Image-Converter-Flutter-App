// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../../../domain/entities/original_image.dart';

part 'select_images_state.freezed.dart';

@freezed
class SelectImagesState with _$SelectImagesState {
  const factory SelectImagesState({
    required bool isResetState,
    required bool isShowSnackBar,
    required bool isConvertingImageToBytes,
    required List<OriginalImage> images,
    required List<XFile> imageXFiles,
  }) = _SelectImagesState;

  factory SelectImagesState.initial() => const SelectImagesState(
    isConvertingImageToBytes: false,
    isShowSnackBar: false,
    images: [],
    imageXFiles: [],
    isResetState: false,
  );
}
