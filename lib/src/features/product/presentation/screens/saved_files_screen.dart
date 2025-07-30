import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../../../../core/resources/app_assets.dart';

class SavedFilesScreen extends StatefulWidget {
  const SavedFilesScreen({super.key});

  @override
  State<SavedFilesScreen> createState() => _SavedFilesScreenState();
}

class _SavedFilesScreenState extends State<SavedFilesScreen> {
  final List<String> options = [
    "Replace All",
    "Share All",
    "Delete All",
    "Rate the App",
  ];
  final List<IconData> iconsOp = [
    Icons.save_as,
    Icons.reply,
    Icons.delete,
    Icons.star,
  ];
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final pdfFile = args["pdfFile"];
    final Uint8List firstImage = args["firstImage"];
    final String fileName = pdfFile.uri.pathSegments.last;
    final int fileSize = pdfFile.lengthSync();
    final String filePath = pdfFile.parent.path;
    String readableSize;
    if (fileSize < 1024) {
      readableSize = '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      readableSize = '${(fileSize / 1024).toStringAsFixed(2)} kB';
    } else if (fileSize < 1024 * 1024 * 1024) {
      readableSize = '${(fileSize / (1024 * 1024)).toStringAsFixed(2)} mB';
    } else if (fileSize < 1024 * 1024 * 1024 * 1024) {
      readableSize =
          '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    } else {
      readableSize =
          '${(fileSize / (1024 * 1024 * 1024 * 1024)).toStringAsFixed(2)} TB';
    }
    final List<Map<String, dynamic>> savedFiles = [
      {
        "fileName": fileName,
        "fileSize": readableSize,
        "filePath": filePath,
        "thumbnail": firstImage,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Saved Files',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              AppIcons.pro,
              color: Colors.white,
              width: 20,
              height: 20,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                //icon
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.green.shade400,
                  child: Image.asset(AppIcons.check, width: 30, height: 30),
                ),
                const SizedBox(width: 16),
                //title-result
                const Text(
                  "1 File Saved, 0 Skipped",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppIcons.compress,
                    width: 45,
                    height: 45,
                    color: Colors.black,
                  ),
                  const Text(
                    "Compress Videos",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            SizedBox(
              height: 480,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final file = savedFiles[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: index != 9 ? 8.0 : 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            final result = await OpenFile.open(pdfFile.path);
                            if (result.type != ResultType.done) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Không mở được file')),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                  ),
                                  child: Image.memory(
                                    file['thumbnail'],
                                    width: 120,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        file['fileName'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        file['fileSize'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        file['filePath'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.open_in_new,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.save_as, color: Colors.white),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: Icon(Icons.reply, color: Colors.white),
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.white),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: savedFiles.length,
              ),
            ),
            SizedBox(height: 14),
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Số cột
                  crossAxisSpacing: 16, // Khoảng cách giữa các cột
                  mainAxisSpacing: 16, // Khoảng cách giữa các hàng
                  childAspectRatio: 4.0,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: Colors.blue.withOpacity(0.2),
                    highlightColor: Colors.blue.withOpacity(0.2),
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          spacing: 16,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            index == 1
                                ? Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: Icon(
                                    iconsOp[index],
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                )
                                : Icon(
                                  iconsOp[index],
                                  color:
                                      index == 3
                                          ? Colors.yellowAccent
                                          : AppColors.primary,
                                  size: 24,
                                ),
                            Text(
                              options[index],
                              style: TextStyle(
                                color:
                                    index == 3
                                        ? Colors.yellowAccent
                                        : AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
