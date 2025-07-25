import '../entities/original_image.dart';

abstract class ImagesRepository {
  Future<List<OriginalImage>> selectImage();
}
