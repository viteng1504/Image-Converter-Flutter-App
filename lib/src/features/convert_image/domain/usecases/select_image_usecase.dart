import '../entities/original_image.dart';
import '../repositories/images_repository.dart';

class SelectImageUsecase {
  ImagesRepository repo;

  SelectImageUsecase(this.repo);

  Future<List<OriginalImage>> call() {
    return repo.selectImage();
  }
}
