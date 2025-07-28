import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/original_image.dart';

class ConvertApi {
  Future<List<XFile>> selectImages() async {
    final ImagePicker picker = ImagePicker();

    final List<XFile> images = await picker.pickMultiImage();

    return images;
  }

  Future<List<OriginalImage>> encodeImages(List<XFile> images) async {
    final List<OriginalImage> imageList = [];

    for (final image in images) {
      final bytes = await image.readAsBytes();

      imageList.add(OriginalImage(bytes: bytes, name: image.name));
    }
    return imageList;
  }
}
