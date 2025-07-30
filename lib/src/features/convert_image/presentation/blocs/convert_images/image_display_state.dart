import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_display_state.freezed.dart';

@freezed
class ImageDisplayState with _$ImageDisplayState {
  const factory ImageDisplayState({
    required bool isLoadingImage,
    required bool isLoadingSize,
    required bool isGrayScaling,
    Uint8List? image,
    Uint8List? cachedImage,
    String? size,
  }) = _ImageDisplayState;

  factory ImageDisplayState.initial() => const ImageDisplayState(
    isLoadingImage: true,
    isLoadingSize: true,
    isGrayScaling: false,
  );
}
