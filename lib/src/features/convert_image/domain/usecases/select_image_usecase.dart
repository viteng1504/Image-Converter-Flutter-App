import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../entities/original_image.dart';
import '../repositories/images_repository.dart';

class SelectImageUsecase {
  ImagesRepository repo;

  SelectImageUsecase(this.repo);

  Future<List<XFile>> selectImages() {
    return repo.selectImages();
  }

  Future<List<OriginalImage>> encodeImage(List<XFile> images) {
    return repo.encodeImages(images);
  }
}
