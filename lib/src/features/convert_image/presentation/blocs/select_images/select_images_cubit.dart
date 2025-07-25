import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/select_image_usecase.dart';
import 'select_images_state.dart';

class SelectImagesCubit extends Cubit<SelectImagesState> {
  SelectImageUsecase selectImageUsecase;

  SelectImagesCubit(this.selectImageUsecase)
    : super(SelectImagesState.initial());

  void onShowSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "You haven't seleted any file",
          style: TextStyle(fontSize: 16),
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 12, left: 16, right: 16),
      ),
    );
  }
}
