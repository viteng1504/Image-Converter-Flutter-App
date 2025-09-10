// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import '../../../domain/usecases/select_image_usecase.dart';
import '../../screens/convert_images/convert_images_screen.dart';
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
    emit(state.copyWith(isShowSnackBar: false));
  }

  void navigateToConvertScreen(BuildContext context, List<XFile> images) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConvertImagesScreen(images: images),
      ),
    );
    emit(SelectImagesState.initial());
  }

  //select images
  Future<void> onSelectImages() async {
    emit(state.copyWith(isConvertingImageToBytes: true));

    final images = await selectImageUsecase.selectImages();

    if (images.isEmpty) {
      print(
        "sssssssssswwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
      );
      emit(
        state.copyWith(isShowSnackBar: true, isConvertingImageToBytes: false),
      );
    } else {
      emit(state.copyWith(imageXFiles: images));
    }
  }

  Future<void> onSelectImageFiles() async {
    try {
      final ImagePicker picker = ImagePicker();
      List<File> imageFiles = [];

      final List<XFile> images = await picker.pickMultiImage();
      if (images.isEmpty) emit(state.copyWith(isShowSnackBar: true));

      for (var xfile in images) {
        // 1. Đọc bytes từ XFile
        int leng = await xfile.length();
        print("Ảnh trc resize: $leng bytes");
        final bytes = await xfile.readAsBytes();

        // 2. Decode ảnh
        final originalImage = img.decodeImage(bytes);
        if (originalImage == null) throw Exception("Không đọc được ảnh");
        print("Ảnh gốc: ${originalImage.width} x ${originalImage.height}");
        // 1. Chuyển grayscale
        // final grayscaleImage = img.grayscale(originalImage);

        // 2. Resize (ví dụ: 30% kích thước gốc)
        img.Image resizedImage;

        if (originalImage.width >= 2880 || originalImage.height >= 2880) {
          final resizedHightResolutionImage = img.copyResize(
            originalImage,
            width: (originalImage.width * 0.28846 * 0.5).round(),
            height: (originalImage.height * 0.28846 * 0.5).round(),
          );
          resizedImage = resizedHightResolutionImage;
          print("anh qua to");
        } else {
          resizedImage = img.copyResize(
            originalImage,
            width: (originalImage.width * 1).round(),
            height: (originalImage.height * 1).round(),
          );
        }

        print("Resized size: ${resizedImage.width} x ${resizedImage.height}");

        // 3. Encode JPEG với chất lượng thấp
        final encodedImage = img.encodeJpg(resizedImage, quality: 100);
        // final newImageByte = Uint8List.fromList(encodedImage);

        //image compress
        final jpg = await FlutterImageCompress.compressWithList(
          encodedImage,
          quality: 0,
          format: CompressFormat.jpeg,
        );

        // 4. Lưu file
        final dir = await getTemporaryDirectory();
        final filePath =
            '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = File(filePath)..writeAsBytesSync(jpg);
        imageFiles.add(file);

        print(
          "Ảnh sau resize: ${file.lengthSync()} bytes, ${file.runtimeType}",
        );
      }

      // emit(state.copyWith(imagesFile: imageFiles));
    } catch (e, stack) {
      print("🔥 Lỗi trong onSelectImageFiles: $e");
      print(stack);
      // TODO: xử lý lỗi giao diện hoặc emit state lỗi nếu cần
    }
  }
}
