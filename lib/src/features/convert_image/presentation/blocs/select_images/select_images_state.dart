import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_images_state.freezed.dart';

@freezed
class SelectImagesState with _$SelectImagesState {
  const factory SelectImagesState({required bool isShowSnackBar}) =
      _SelectImagesState;

  factory SelectImagesState.initial() =>
      const SelectImagesState(isShowSnackBar: false);
}
