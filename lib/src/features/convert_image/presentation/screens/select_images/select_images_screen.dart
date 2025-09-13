// Dart imports:
import 'dart:math';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../../../core/device_info.dart';
import '../../../../../core/resources/app_assets.dart';
import '../../../data/data_sources/local/convert_api.dart';
import '../../../data/repositories/images_repository_impl.dart';
import '../../../domain/usecases/select_image_usecase.dart';
import '../../blocs/select_images/select_images_cubit.dart';
import '../../blocs/select_images/select_images_state.dart';

class SelectImagesScreen extends StatelessWidget {
  const SelectImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final physicalScreenSize = window.physicalSize;
    final deviceWidth = physicalScreenSize.width.toInt();
    final deviceHeight = physicalScreenSize.height.toInt();
    DeviceInfo.maxSize = max(deviceWidth, deviceHeight);
    // final logicalSize = MediaQuery.of(context).size;
    // final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // final physicalWidth = (logicalSize.width * pixelRatio).round();
    // final physicalHeight = (logicalSize.height * pixelRatio).round();
    // print("$physicalWidth x $physicalHeight resolution");

    // DeviceInfo.maxSize = max(physicalWidth, physicalHeight);
    // print(DeviceInfo.maxSize);

    return BlocProvider(
      create:
          (context) => SelectImagesCubit(
            SelectImageUsecase(ImagesRepositoryImpl(ConvertApi())),
          ),
      child: BlocConsumer<SelectImagesCubit, SelectImagesState>(
        listener: (context, state) {
          final images = state.imageXFiles;
          if (state.isShowSnackBar) {
            context.read<SelectImagesCubit>().onShowSnackBar(context);
          }

          if (images.isNotEmpty) {
            context.read<SelectImagesCubit>().navigateToConvertScreen(
              context,
              images,
            );
          } else {
            // print(images[0].bytes);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.background,
                title: const Center(
                  child: Text(
                    "Convert Image",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            
              // Select Image button
              floatingActionButton: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
            
                  backgroundColor: AppColors.primary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                ),
                onPressed: () {
                  context.read<SelectImagesCubit>().onSelectImages();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: AppColors.font, size: 30),
                    SizedBox(width: 16),
                    Text(
                      "Select Images",
                      style: TextStyle(fontSize: 16, color: AppColors.font),
                    ),
                  ],
                ),
              ),
            
              body: InkWell(
                onTap: () {
                  context.read<SelectImagesCubit>().onSelectImages();
                },
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppIcons.selectImage,
                          width: 170,
                          height: 170,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Select images",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.fontGray,
                          ),
                        ),
                        const Text(
                          "or share them with the app",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.fontGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
