import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'image_display_state.dart';

class ImageDisplayCubit extends Cubit<ImageDisplayState> {
  ImageDisplayCubit() : super(ImageDisplayState.initial());

  void loadingSize() async {
    emit(state.copyWith(isLoadingSize: true));
    final random = Random();
    int num1 = 1000 + random.nextInt(3000);
    await Future.delayed(Duration(milliseconds: num1));
    emit(state.copyWith(isLoadingSize: false));
  }

  void loadingImage() async {
    emit(state.copyWith(isLoadingImage: true));
    final random = Random();
    int num1 = 1000 + random.nextInt(3000);
    await Future.delayed(Duration(milliseconds: num1));
    emit(state.copyWith(isLoadingImage: false));
  }
}
