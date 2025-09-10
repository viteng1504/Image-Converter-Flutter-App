// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'select_images_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SelectImagesState {
  bool get isResetState => throw _privateConstructorUsedError;
  bool get isShowSnackBar => throw _privateConstructorUsedError;
  bool get isConvertingImageToBytes => throw _privateConstructorUsedError;
  List<OriginalImage> get images => throw _privateConstructorUsedError;
  List<XFile> get imageXFiles => throw _privateConstructorUsedError;

  /// Create a copy of SelectImagesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectImagesStateCopyWith<SelectImagesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectImagesStateCopyWith<$Res> {
  factory $SelectImagesStateCopyWith(
    SelectImagesState value,
    $Res Function(SelectImagesState) then,
  ) = _$SelectImagesStateCopyWithImpl<$Res, SelectImagesState>;
  @useResult
  $Res call({
    bool isResetState,
    bool isShowSnackBar,
    bool isConvertingImageToBytes,
    List<OriginalImage> images,
    List<XFile> imageXFiles,
  });
}

/// @nodoc
class _$SelectImagesStateCopyWithImpl<$Res, $Val extends SelectImagesState>
    implements $SelectImagesStateCopyWith<$Res> {
  _$SelectImagesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectImagesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isResetState = null,
    Object? isShowSnackBar = null,
    Object? isConvertingImageToBytes = null,
    Object? images = null,
    Object? imageXFiles = null,
  }) {
    return _then(
      _value.copyWith(
            isResetState:
                null == isResetState
                    ? _value.isResetState
                    : isResetState // ignore: cast_nullable_to_non_nullable
                        as bool,
            isShowSnackBar:
                null == isShowSnackBar
                    ? _value.isShowSnackBar
                    : isShowSnackBar // ignore: cast_nullable_to_non_nullable
                        as bool,
            isConvertingImageToBytes:
                null == isConvertingImageToBytes
                    ? _value.isConvertingImageToBytes
                    : isConvertingImageToBytes // ignore: cast_nullable_to_non_nullable
                        as bool,
            images:
                null == images
                    ? _value.images
                    : images // ignore: cast_nullable_to_non_nullable
                        as List<OriginalImage>,
            imageXFiles:
                null == imageXFiles
                    ? _value.imageXFiles
                    : imageXFiles // ignore: cast_nullable_to_non_nullable
                        as List<XFile>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SelectImagesStateImplCopyWith<$Res>
    implements $SelectImagesStateCopyWith<$Res> {
  factory _$$SelectImagesStateImplCopyWith(
    _$SelectImagesStateImpl value,
    $Res Function(_$SelectImagesStateImpl) then,
  ) = __$$SelectImagesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isResetState,
    bool isShowSnackBar,
    bool isConvertingImageToBytes,
    List<OriginalImage> images,
    List<XFile> imageXFiles,
  });
}

/// @nodoc
class __$$SelectImagesStateImplCopyWithImpl<$Res>
    extends _$SelectImagesStateCopyWithImpl<$Res, _$SelectImagesStateImpl>
    implements _$$SelectImagesStateImplCopyWith<$Res> {
  __$$SelectImagesStateImplCopyWithImpl(
    _$SelectImagesStateImpl _value,
    $Res Function(_$SelectImagesStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SelectImagesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isResetState = null,
    Object? isShowSnackBar = null,
    Object? isConvertingImageToBytes = null,
    Object? images = null,
    Object? imageXFiles = null,
  }) {
    return _then(
      _$SelectImagesStateImpl(
        isResetState:
            null == isResetState
                ? _value.isResetState
                : isResetState // ignore: cast_nullable_to_non_nullable
                    as bool,
        isShowSnackBar:
            null == isShowSnackBar
                ? _value.isShowSnackBar
                : isShowSnackBar // ignore: cast_nullable_to_non_nullable
                    as bool,
        isConvertingImageToBytes:
            null == isConvertingImageToBytes
                ? _value.isConvertingImageToBytes
                : isConvertingImageToBytes // ignore: cast_nullable_to_non_nullable
                    as bool,
        images:
            null == images
                ? _value._images
                : images // ignore: cast_nullable_to_non_nullable
                    as List<OriginalImage>,
        imageXFiles:
            null == imageXFiles
                ? _value._imageXFiles
                : imageXFiles // ignore: cast_nullable_to_non_nullable
                    as List<XFile>,
      ),
    );
  }
}

/// @nodoc

class _$SelectImagesStateImpl
    with DiagnosticableTreeMixin
    implements _SelectImagesState {
  const _$SelectImagesStateImpl({
    required this.isResetState,
    required this.isShowSnackBar,
    required this.isConvertingImageToBytes,
    required final List<OriginalImage> images,
    required final List<XFile> imageXFiles,
  }) : _images = images,
       _imageXFiles = imageXFiles;

  @override
  final bool isResetState;
  @override
  final bool isShowSnackBar;
  @override
  final bool isConvertingImageToBytes;
  final List<OriginalImage> _images;
  @override
  List<OriginalImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<XFile> _imageXFiles;
  @override
  List<XFile> get imageXFiles {
    if (_imageXFiles is EqualUnmodifiableListView) return _imageXFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageXFiles);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SelectImagesState(isResetState: $isResetState, isShowSnackBar: $isShowSnackBar, isConvertingImageToBytes: $isConvertingImageToBytes, images: $images, imageXFiles: $imageXFiles)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SelectImagesState'))
      ..add(DiagnosticsProperty('isResetState', isResetState))
      ..add(DiagnosticsProperty('isShowSnackBar', isShowSnackBar))
      ..add(
        DiagnosticsProperty(
          'isConvertingImageToBytes',
          isConvertingImageToBytes,
        ),
      )
      ..add(DiagnosticsProperty('images', images))
      ..add(DiagnosticsProperty('imageXFiles', imageXFiles));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectImagesStateImpl &&
            (identical(other.isResetState, isResetState) ||
                other.isResetState == isResetState) &&
            (identical(other.isShowSnackBar, isShowSnackBar) ||
                other.isShowSnackBar == isShowSnackBar) &&
            (identical(
                  other.isConvertingImageToBytes,
                  isConvertingImageToBytes,
                ) ||
                other.isConvertingImageToBytes == isConvertingImageToBytes) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(
              other._imageXFiles,
              _imageXFiles,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isResetState,
    isShowSnackBar,
    isConvertingImageToBytes,
    const DeepCollectionEquality().hash(_images),
    const DeepCollectionEquality().hash(_imageXFiles),
  );

  /// Create a copy of SelectImagesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectImagesStateImplCopyWith<_$SelectImagesStateImpl> get copyWith =>
      __$$SelectImagesStateImplCopyWithImpl<_$SelectImagesStateImpl>(
        this,
        _$identity,
      );
}

abstract class _SelectImagesState implements SelectImagesState {
  const factory _SelectImagesState({
    required final bool isResetState,
    required final bool isShowSnackBar,
    required final bool isConvertingImageToBytes,
    required final List<OriginalImage> images,
    required final List<XFile> imageXFiles,
  }) = _$SelectImagesStateImpl;

  @override
  bool get isResetState;
  @override
  bool get isShowSnackBar;
  @override
  bool get isConvertingImageToBytes;
  @override
  List<OriginalImage> get images;
  @override
  List<XFile> get imageXFiles;

  /// Create a copy of SelectImagesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectImagesStateImplCopyWith<_$SelectImagesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
