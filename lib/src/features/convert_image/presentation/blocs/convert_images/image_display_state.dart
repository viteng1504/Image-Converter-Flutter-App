import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_display_state.freezed.dart';

@freezed
class ImageDisplayState with _$ImageDisplayState {
  const factory ImageDisplayState({
    required bool isLoadingImage,
    required bool isLoadingSize,
    Uint8List? image,
    String? size,
  }) = _ImageDisplayState;

  factory ImageDisplayState.initial() =>
      const ImageDisplayState(isLoadingImage: true, isLoadingSize: true);
}
