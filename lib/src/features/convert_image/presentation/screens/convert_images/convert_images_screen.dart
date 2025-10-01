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
  late TextEditingController _controller;
  String basePdfName = "";

  @override
  void initState() {
    super.initState();
    final randomNumber = (100 + (DateTime.now().millisecondsSinceEpoch % 900));
    basePdfName = 'MyPdf_$randomNumber';
    _controller = TextEditingController(text: basePdfName);
    //get device max size
    if (DeviceInfo.maxSize == 0) {
      DeviceInfo.init();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConvertImageUsecase convertImageUsecase = ConvertImageUsecase(
      ImagesRepositoryImpl(ConvertApi()),
    );

    // measure size from appbar to bottom
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 32),
        color: AppColors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    final availableHeight =
        mediaQuery.size.height -
        mediaQuery.padding.top - // Status bar
        appBar.preferredSize.height;

    return SafeArea(
      child: MultiBlocProvider(
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

            return context
                    .watch<ConvertImagesCubit>()
                    .state
                    .isConvertingImageToBytes
                ? const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
                : Scaffold(
                  appBar: appBar,
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: availableHeight - 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.isConvertingToFiles)
                              Expanded(
                                child: Center(
                                  child: Column(
                                    spacing: 20,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Text(
                                        "${state.convertedImageQty}/${cubits.length} images converted",
                                        style: const TextStyle(
                                          color: AppColors.fontGray,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              state.convertMode == ConvertMode.pdf
                                  ? Expanded(
                                    child: ReorderableGridView(
                                      order: state.order,
                                      imagesBytes: imageBytesList,
                                      onReOrderImages: context.read<ConvertImagesCubit>().onReOrderImages,
                                    ),
                                  )
                                  : Expanded(
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                widget.images.length == 1
                                                    ? 1
                                                    : 2,
                                            mainAxisSpacing: 16,
                                            crossAxisSpacing: 16,
                                            childAspectRatio: 0.9,
                                          ),
                                      itemCount: widget.images.length,
                                      itemBuilder: (context, index) {
                                        final imageOrder = state.order[index];
                                        final cubit = state.cubits[imageOrder];

                                        return BlocProvider.value(
                                          value: cubit,
                                          key: ValueKey(
                                            "${state.convertMode}_${state.compressAmount}_${state.isGrayScale}_$index",
                                          ),

                                          child: BlocBuilder<
                                            ImageDisplayCubit,
                                            ImageDisplayState
                                          >(
                                            builder: (
                                              imageContext,
                                              imageState,
                                            ) {
                                              return DisplayImage(
                                                bytes: imageState.image,
                                                size:
                                                    imageState.size ??
                                                    "Loading file size",
                                                isLoadingImage:
                                                    imageState.isLoadingImage,
                                                isLoadingSize:
                                                    imageState.isLoadingSize,
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
                              onChecked:
                                  context
                                      .read<ConvertImagesCubit>()
                                      .onGrayScalePressed,
                              convertMode: state.convertMode,
                              controller: _controller,
                              onChangedTextField: (value) {
                                _controller.text = value;
                              },
                              onFillTransparencyColor:
                                  context
                                      .read<ConvertImagesCubit>()
                                      .onFilledColorChanged,
                              filledColor: state.filledColor,
                            ),

                            Center(
                              child: ConvertButton(
                                onPressed: () async {
                                  await context
                                      .read<ConvertImagesCubit>()
                                      .onConvertToFile(
                                        context,
                                        _controller.text,
                                      );
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
                                  // Navigator.pushNamed(
                                  //   context,
                                  //   "/saved_files",
                                  //   arguments: {
                                  //     "savedFiles": savedFiles,
                                  //     // "firstImage": firstImage,
                                  //   },
                                  // );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
          },
        ),
      ),
    );
  }
}
