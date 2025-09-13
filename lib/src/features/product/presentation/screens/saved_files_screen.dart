// Dart imports:
import 'dart:io';
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import '../../../../core/resources/app_assets.dart';
import '../../../convert_image/domain/entities/saved_file.dart';

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
    final List<SavedFile> savedFiles = args["savedFiles"];

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
                Text(
                  "${savedFiles.length} File Saved, 0 Skipped",
                  style: const TextStyle(
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
              onPressed: () async {
                final url = Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.psoffritti.compress.video',
                );
                await launchUrl(url, mode: LaunchMode.externalApplication);
              },
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
            const SizedBox(height: 14),
            Expanded(
              // height: 480,
              child: ListView.builder(
                itemCount: savedFiles.length,

                itemBuilder: (context, index) {
                  final savedFile = savedFiles[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: index != 9 ? 8.0 : 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            final result = await OpenFile.open(savedFile.path);
                            if (result.type != ResultType.done) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Không mở được file'),
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                  ),
                                  child: Image.memory(
                                    savedFile.image,
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
                                        savedFile.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        savedFile.size,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        savedFile.path,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
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
                          decoration: const BoxDecoration(
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
                                icon: const Icon(
                                  Icons.open_in_new,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  final result = await OpenFile.open(
                                    savedFile.path,
                                  );
                                  if (result.type != ResultType.done) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Không mở được file'),
                                      ),
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.save_as,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: const Icon(
                                    Icons.reply,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  final params = ShareParams(
                                    files: [XFile(savedFile.path)],
                                  );
                                  await SharePlus.instance.share(params);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          28,
                                          26,
                                          26,
                                        ),
                                        title: const Column(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: AppColors.primary,
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: const Text(
                                          'Are you sure you want to delete this file?',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              final file = File(savedFile.path);
                                              if (await file.exists()) {
                                                await file.delete();
                                              }

                                              setState(() {
                                                savedFiles.removeAt(index);
                                              });
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            //bottom options
            SizedBox(
              height: 100,
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
                    onTap: () async {
                      if (index == 0) {
                      } else if (index == 1) {
                        final paragrams = ShareParams(
                          files: savedFiles.map((e) => XFile(e.path)).toList(),
                        );
                        await SharePlus.instance.share(paragrams);
                      } else if (index == 2) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: const Color.fromARGB(
                                255,
                                28,
                                26,
                                26,
                              ),
                              title: const Column(
                                children: [
                                  Icon(Icons.delete, color: AppColors.primary),
                                  SizedBox(height: 16),
                                  Text(
                                    'Delete All',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'Are you sure you want to delete all these files?',
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    for (var file in savedFiles) {
                                      final f = File(file.path);
                                      if (await f.exists()) {
                                        await f.delete();
                                      }
                                    }
                                    setState(() {
                                      savedFiles.clear();
                                    });
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (index == 3) {
                        showDialog(
                          context: context,

                          builder: (context) {
                            return Dialog(
                              backgroundColor: AppColors.sliderInactiveTrack,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  spacing: 14,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Rate this app',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Image.asset(
                                      AppIcons.app,
                                      width: 60,
                                      height: 60,
                                    ),
                                    const Text(
                                      textAlign: TextAlign.center,
                                      'You like this app? Then take a little bit of your time to leave a rating',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    Row(
                                      spacing: 10,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        5,

                                        (index) => GestureDetector(
                                          onTap: () async {
                                            if (index == 4) {
                                              final url = Uri.parse(
                                                'https://play.google.com/store/apps/details?id=com.psoffritti.convertimage',
                                              );
                                              await launchUrl(
                                                url,
                                                mode:
                                                    LaunchMode
                                                        .externalApplication,
                                              );
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Icon(
                                            Icons.star_border,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Align(
                                    //   alignment: Alignment.centerRight,
                                    //   child: TextButton(
                                    //     onPressed: () => Navigator.pop(context),
                                    //     child: const Text(
                                    //       'OK',
                                    //       style: TextStyle(
                                    //         fontSize: 16,
                                    //         color: AppColors.primary,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24.0),
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
