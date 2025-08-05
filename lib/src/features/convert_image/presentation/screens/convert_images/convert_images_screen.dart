// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

// Project imports:
import '../../../../../core/device_info.dart';
import '../../../../../core/enums/convert.dart';
import '../../../../../core/resources/app_assets.dart';
import '../../../data/data_sources/local/convert_api.dart';
import '../../../data/repositories/images_repository_impl.dart';
import '../../../domain/usecases/convert_image_usecase.dart';
import '../../blocs/convert_images/convert_images_cubit.dart';
import '../../blocs/convert_images/convert_images_state.dart';
import '../../blocs/convert_images/image_display_cubit.dart';
import '../../blocs/convert_images/image_display_state.dart';
import 'widgets/convert_button.dart';
import 'widgets/convert_mode_bar.dart';
import 'widgets/display_image.dart';
import 'widgets/reorderable_grid_view.dart';
import 'widgets/select_mode.dart';

class ConvertImagesScreen extends StatefulWidget {
  final List<XFile> images;
  const ConvertImagesScreen({super.key, required this.images});

  @override
  _ConvertImagesScreenState createState() => _ConvertImagesScreenState();
}

class _ConvertImagesScreenState extends State<ConvertImagesScreen> {
  int compressAmount = 0;

  @override
  void initState() {
    super.initState();
    //get device max size
    if (DeviceInfo.maxSize == 0) {
      DeviceInfo.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ConvertImageUsecase convertImageUsecase = ConvertImageUsecase(
      ImagesRepositoryImpl(ConvertApi()),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  ConvertImagesCubit(convertImageUsecase)
                    ..onConvertImages(widget.images),
        ),

        BlocProvider(
          create: (context) => ImageDisplayCubit(convertImageUsecase),
        ),
      ],

      child: BlocConsumer<ConvertImagesCubit, ConvertImagesState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubits = context.watch<ConvertImagesCubit>().state.cubits;
          final List<Uint8List?> imageBytesList =
              cubits.map((cubit) => cubit.state.image).toList();
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
                      state.convertMode == ConvertMode.pdf
                          ? Expanded(
                            child: ReorderableGridView(
                              imagesBytes: imageBytesList,
                            ),
                          )
                          : Expanded(
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
                                return BlocProvider.value(
                                  value: cubits[index],
                                  key: ValueKey(
                                    "${state.convertMode}_${state.compressAmount}_${state.isGrayScale}_$index",
                                  ),

                                  child: BlocBuilder<
                                    ImageDisplayCubit,
                                    ImageDisplayState
                                  >(
                                    builder: (imageContext, imageState) {
                                      return DisplayImage(
                                        bytes: imageState.image,
                                        size:
                                            imageState.size ??
                                            "Loading file size",
                                        isLoadingImage:
                                            imageState.isLoadingImage,
                                        isLoadingSize: imageState.isLoadingSize,
                                        isGrayScale: state.isGrayScale,
                                      );
                                    },
                                  ),
                                );
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
                      ConvertModeBar(
                        convertMode: state.convertMode,
                        onPressed:
                            context
                                .read<ConvertImagesCubit>()
                                .onSelectConvertMode,
                      ),

                      const SizedBox(height: 16),

                      // select mode
                      SelectMode(
                        onChangedEnd: (value) {
                          context
                              .read<ConvertImagesCubit>()
                              .onCompressionAmountChanged(value.toInt());
                        },
                        isGrayScaleChecked: state.isGrayScale,
                        onChecked: (isChecked) {
                          context
                              .read<ConvertImagesCubit>()
                              .onGrayScalePressed();
                        },
                      ),

                      Center(
                        child: ConvertButton(
                          onPressed: () async {
                            final savedFiles =
                                await context
                                    .read<ConvertImagesCubit>()
                                    .onConvertToFile();
                            // if (state.convertMode == ConvertMode.pdf) {
                            //   final List<Uint8List> imageBytesList =
                            //       state.images
                            //           .map((image) => image.bytes)
                            //           .toList();
                            //   Uint8List firstImage = imageBytesList[0];
                            //   final file = await Convert().convertImageToPdf(
                            //     imageBytesList,
                            //   );
                            // }
                            Navigator.pushNamed(
                              context,
                              "/saved_files",
                              arguments: {
                                "savedFiles": savedFiles,
                                // "firstImage": firstImage,
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
        },
      ),
    );
  }
}
