import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/original_image.dart';

part 'image_display_state.freezed.dart';

@freezed
class ImageDisplayState with _$ImageDisplayState {
  const factory ImageDisplayState({
    required bool isLoadingImage,
    required bool isLoadingSize,
  }) = _ImageDisplayState;

  factory ImageDisplayState.initial() =>
      const ImageDisplayState(isLoadingImage: false, isLoadingSize: false);
}
