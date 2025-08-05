// Package imports:
import 'package:flutter_image_compress/flutter_image_compress.dart';

// Project imports:
import '../repositories/images_repository.dart';

class SelectImageUsecase {
  ImagesRepository repo;

  SelectImageUsecase(this.repo);

  Future<List<XFile>> selectImages() {
    return repo.selectImages();
  }
}
