import 'dart:io';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Convert {
  Future<File> convertImageToPdf(List<Uint8List> imageByteList) async {
    final PdfDocument document = PdfDocument();
    for (final imageBytes in imageByteList) {
      final PdfImage image = PdfBitmap(imageBytes);

      final page = document.pages.add();
      const double imageWidth = 500;
      const double imageHeight = 500;
      final double pageWidth = page.getClientSize().width;
      final double pageHeight = page.getClientSize().height;
      final double x = (pageWidth - imageWidth) / 2;
      final double y = (pageHeight - imageHeight) / 2;
      page.graphics.drawImage(
        image,
        Rect.fromLTWH(x, y, imageWidth, imageHeight),
      );
    }

    final List<int> bytes = await document.save();
    document.dispose();

    final downloadDir = Directory('/storage/emulated/0/Download/pdf files');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    // Tạo tên file ngẫu nhiên và kiểm tra trùng
    final randomNumber = (100 + (DateTime.now().millisecondsSinceEpoch % 900));
    String baseName = 'MyPdf_$randomNumber';
    String fileName = baseName;
    int count = 1;
    while (File('${downloadDir.path}/$fileName.pdf').existsSync()) {
      fileName = '$baseName($count)';
      count++;
    }

    final file = File('${downloadDir.path}/$fileName.pdf');
    await file.writeAsBytes(bytes);

    print('Đã lưu PDF tại: ${file.path}');
    return file;
  }
}
