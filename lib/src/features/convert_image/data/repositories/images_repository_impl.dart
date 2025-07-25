import '../../domain/entities/original_image.dart';
import '../../domain/repositories/images_repository.dart';

class ImagesRepositoryImpl implements ImagesRepository {
  @override
  Future<List<OriginalImage>> selectImage() async {
    return [OriginalImage(image: "image")];
  }
}
