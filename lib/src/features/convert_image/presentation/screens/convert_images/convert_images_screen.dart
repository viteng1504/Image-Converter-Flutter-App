import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../../../core/enums/convert_mode.dart';
import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/utils/utils.dart';
import '../../../data/data_sources/local/convert_api.dart';
import '../../../data/repositories/images_repository_impl.dart';
import '../../../domain/entities/original_image.dart';
import '../../../domain/usecases/select_image_usecase.dart';
import '../../blocs/convert_images/convert_images_cubit.dart';
import '../../blocs/convert_images/convert_images_state.dart';
import '../../blocs/convert_images/image_display_cubit.dart';
import '../../blocs/convert_images/image_display_state.dart';
import 'widgets/convert_button.dart';
import 'widgets/convert_mode_button.dart';
import 'widgets/display_image.dart';
import 'widgets/select_mode.dart';

class ConvertImagesScreen extends StatefulWidget {
  final List<XFile> images;
  const ConvertImagesScreen({super.key, required this.images});

  @override
  _ConvertImagesScreenState createState() => _ConvertImagesScreenState();
}

class _ConvertImagesScreenState extends State<ConvertImagesScreen> {
  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final pixelRatio = mediaQuery.devicePixelRatio;
    final size = mediaQuery.size;
    final widthPx = (size.width * pixelRatio).toInt();
    final heightPx = (size.height * pixelRatio).toInt();

    print("Resolution: $widthPx x $heightPx px");
    return BlocProvider(
      create:
          (context) => ConvertImagesCubit(
            SelectImageUsecase(ImagesRepositoryImpl(ConvertApi())),
          )..onConvertImages(widget.images),
      child: BlocConsumer<ConvertImagesCubit, ConvertImagesState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state.isConvertingImageToBytes
              ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
              : Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.background,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 32),
                    color: AppColors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    widget.images.length == 1 ? 1 : 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.9,
                              ),
                          itemCount: widget.images.length,
                          itemBuilder: (context, index) {
                            final OriginalImage image = state.images[index];
                            final Uint8List bytes = image.bytes;
                            final String size = Utils().formatSize(
                              image.bytes.length,
                            );

                            return BlocProvider(
                              create:
                                  (context) =>
                                      ImageDisplayCubit()
                                        ..loadingImage()
                                        ..loadingSize(),
                              child: BlocBuilder<
                                ImageDisplayCubit,
                                ImageDisplayState
                              >(
                                builder: (imageContext, imageState) {
                                  return DisplayImage(
                                    bytes: bytes,
                                    size: size,
                                    isLoadingImage: imageState.isLoadingImage,
                                    isLoadingSize: imageState.isLoadingSize,
                                  );
                                },
                              ),
                            );
                            // return const SizedBox();
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Convert to",
                        style: TextStyle(
                          color: AppColors.fontGray,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 16),

                      //Select Convert Mode
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ConvertModeButton(
                                onPressed: () {
                                  context
                                      .read<ConvertImagesCubit>()
                                      .onSelectConvertMode(ConvertMode.jpg);
                                },
                                label: "JPG",
                                isSelected:
                                    state.convertMode == ConvertMode.jpg,
                                isFirst: true,
                              ),
                              ConvertModeButton(
                                onPressed: () {
                                  context
                                      .read<ConvertImagesCubit>()
                                      .onSelectConvertMode(ConvertMode.png);
                                },
                                label: "PNG",
                                isSelected:
                                    state.convertMode == ConvertMode.png,
                                isFirst: false,
                              ),
                              ConvertModeButton(
                                onPressed: () {
                                  context
                                      .read<ConvertImagesCubit>()
                                      .onSelectConvertMode(ConvertMode.webp);
                                },
                                label: "WEBP",
                                isSelected:
                                    state.convertMode == ConvertMode.webp,
                                isFirst: false,
                              ),
                              ConvertModeButton(
                                onPressed: () {
                                  context
                                      .read<ConvertImagesCubit>()
                                      .onSelectConvertMode(ConvertMode.pdf);
                                },
                                label: "PDF",
                                isSelected:
                                    state.convertMode == ConvertMode.pdf,
                                isFirst: false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // select mode
                      SelectMode(
                        sliderValue: sliderValue,
                        onChanged: (value) {
                          setState(() {
                            sliderValue = value;
                          });
                        },
                      ),

                      Center(child: ConvertButton(onPressed: () {})),
                    ],
                  ),
                ),
              );
        },
      ),
    );
  }
}
