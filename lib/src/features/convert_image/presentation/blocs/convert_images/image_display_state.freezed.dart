// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_display_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ImageDisplayState {
  bool get isLoadingImage => throw _privateConstructorUsedError;
  bool get isLoadingSize => throw _privateConstructorUsedError;
  Uint8List? get image => throw _privateConstructorUsedError;
  String? get size => throw _privateConstructorUsedError;

  /// Create a copy of ImageDisplayState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImageDisplayStateCopyWith<ImageDisplayState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageDisplayStateCopyWith<$Res> {
  factory $ImageDisplayStateCopyWith(
    ImageDisplayState value,
    $Res Function(ImageDisplayState) then,
  ) = _$ImageDisplayStateCopyWithImpl<$Res, ImageDisplayState>;
  @useResult
  $Res call({
    bool isLoadingImage,
    bool isLoadingSize,
    Uint8List? image,
    String? size,
  });
}

/// @nodoc
class _$ImageDisplayStateCopyWithImpl<$Res, $Val extends ImageDisplayState>
    implements $ImageDisplayStateCopyWith<$Res> {
  _$ImageDisplayStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImageDisplayState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoadingImage = null,
    Object? isLoadingSize = null,
    Object? image = freezed,
    Object? size = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoadingImage:
                null == isLoadingImage
                    ? _value.isLoadingImage
                    : isLoadingImage // ignore: cast_nullable_to_non_nullable
                        as bool,
            isLoadingSize:
                null == isLoadingSize
                    ? _value.isLoadingSize
                    : isLoadingSize // ignore: cast_nullable_to_non_nullable
                        as bool,
            image:
                freezed == image
                    ? _value.image
                    : image // ignore: cast_nullable_to_non_nullable
                        as Uint8List?,
            size:
                freezed == size
                    ? _value.size
                    : size // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ImageDisplayStateImplCopyWith<$Res>
    implements $ImageDisplayStateCopyWith<$Res> {
  factory _$$ImageDisplayStateImplCopyWith(
    _$ImageDisplayStateImpl value,
    $Res Function(_$ImageDisplayStateImpl) then,
  ) = __$$ImageDisplayStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoadingImage,
    bool isLoadingSize,
    Uint8List? image,
    String? size,
  });
}

/// @nodoc
class __$$ImageDisplayStateImplCopyWithImpl<$Res>
    extends _$ImageDisplayStateCopyWithImpl<$Res, _$ImageDisplayStateImpl>
    implements _$$ImageDisplayStateImplCopyWith<$Res> {
  __$$ImageDisplayStateImplCopyWithImpl(
    _$ImageDisplayStateImpl _value,
    $Res Function(_$ImageDisplayStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImageDisplayState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoadingImage = null,
    Object? isLoadingSize = null,
    Object? image = freezed,
    Object? size = freezed,
  }) {
    return _then(
      _$ImageDisplayStateImpl(
        isLoadingImage:
            null == isLoadingImage
                ? _value.isLoadingImage
                : isLoadingImage // ignore: cast_nullable_to_non_nullable
                    as bool,
        isLoadingSize:
            null == isLoadingSize
                ? _value.isLoadingSize
                : isLoadingSize // ignore: cast_nullable_to_non_nullable
                    as bool,
        image:
            freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                    as Uint8List?,
        size:
            freezed == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$ImageDisplayStateImpl
    with DiagnosticableTreeMixin
    implements _ImageDisplayState {
  const _$ImageDisplayStateImpl({
    required this.isLoadingImage,
    required this.isLoadingSize,
    this.image,
    this.size,
  });

  @override
  final bool isLoadingImage;
  @override
  final bool isLoadingSize;
  @override
  final Uint8List? image;
  @override
  final String? size;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ImageDisplayState(isLoadingImage: $isLoadingImage, isLoadingSize: $isLoadingSize, image: $image, size: $size)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ImageDisplayState'))
      ..add(DiagnosticsProperty('isLoadingImage', isLoadingImage))
      ..add(DiagnosticsProperty('isLoadingSize', isLoadingSize))
      ..add(DiagnosticsProperty('image', image))
      ..add(DiagnosticsProperty('size', size));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageDisplayStateImpl &&
            (identical(other.isLoadingImage, isLoadingImage) ||
                other.isLoadingImage == isLoadingImage) &&
            (identical(other.isLoadingSize, isLoadingSize) ||
                other.isLoadingSize == isLoadingSize) &&
            const DeepCollectionEquality().equals(other.image, image) &&
            (identical(other.size, size) || other.size == size));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoadingImage,
    isLoadingSize,
    const DeepCollectionEquality().hash(image),
    size,
  );

  /// Create a copy of ImageDisplayState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageDisplayStateImplCopyWith<_$ImageDisplayStateImpl> get copyWith =>
      __$$ImageDisplayStateImplCopyWithImpl<_$ImageDisplayStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ImageDisplayState implements ImageDisplayState {
  const factory _ImageDisplayState({
    required final bool isLoadingImage,
    required final bool isLoadingSize,
    final Uint8List? image,
    final String? size,
  }) = _$ImageDisplayStateImpl;

  @override
  bool get isLoadingImage;
  @override
  bool get isLoadingSize;
  @override
  Uint8List? get image;
  @override
  String? get size;

  /// Create a copy of ImageDisplayState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageDisplayStateImplCopyWith<_$ImageDisplayStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
