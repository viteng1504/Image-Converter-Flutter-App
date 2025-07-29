import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../../../core/enums/convert_mode.dart';
import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/utils/utils.dart';
import '../../../data/data_sources/local/convert_api.dart';
import '../../../data/repositories/images_repository_impl.dart';
import '../../../domain/entities/original_image.dart';
import '../../../domain/usecases/convert_image_usecase.dart';
import '../../blocs/convert_images/convert_images_cubit.dart';
import '../../blocs/convert_images/convert_images_state.dart';
import '../../blocs/convert_images/image_display_cubit.dart';
import '../../blocs/convert_images/image_display_state.dart';
import 'convert_to_pdf.dart';
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
  int compressAmount = 0;

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
                    ..onConvertImages(widget.images)
                    ..onHalfImagesSize(widget.images),
        ),

        BlocProvider(
          create: (context) => ImageDisplayCubit(convertImageUsecase),
        ),
      ],

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
                      // Expanded(
                      //   child: SingleChildScrollView(
                      //     child: Column(
                      //       children:
                      //           state.images.asMap().entries.map((entry) {
                      //             final index = entry.key;
                      //             final originalImage = entry.value;

                      //             final Uint8List bytes = originalImage.bytes;
                      //             final String size = Utils.formatSize(
                      //               bytes.length,
                      //             );

                      //             return BlocProvider(
                      //               key: ValueKey(
                      //                 "${state.convertMode}_${state.compressAmount}_${state.isGrayScale}_$index",
                      //               ),
                      //               create:
                      //                   (context) => ImageDisplayCubit(
                      //                     convertImageUsecase,
                      //                   )..convertImage(
                      //                     bytes: bytes,
                      //                     compressAmount: state.compressAmount,
                      //                     isGrayScale: state.isGrayScale,
                      //                     convertMode: state.convertMode,
                      //                   ),
                      //               child: BlocBuilder<
                      //                 ImageDisplayCubit,
                      //                 ImageDisplayState
                      //               >(
                      //                 builder: (context, imageState) {
                      //                   return DisplayImage(
                      //                     bytes: imageState.image,
                      //                     size:
                      //                         imageState.size ??
                      //                         "Loading file size",
                      //                     isLoadingImage:
                      //                         imageState.isLoadingImage,
                      //                     isLoadingSize:
                      //                         imageState.isLoadingSize,
                      //                   );
                      //                 },
                      //               ),
                      //             );
                      //           }).toList(),
                      //     ),
                      //   ),
                      //   // GridView.builder(
                      //   //   gridDelegate:
                      //   //       SliverGridDelegateWithFixedCrossAxisCount(
                      //   //         crossAxisCount:
                      //   //             widget.images.length == 1 ? 1 : 2,
                      //   //         mainAxisSpacing: 16,
                      //   //         crossAxisSpacing: 16,
                      //   //         childAspectRatio: 0.9,
                      //   //       ),
                      //   //   itemCount: widget.images.length,
                      //   //   itemBuilder: (context, index) {

                      //   //     // return const SizedBox();
                      //   //   },
                      //   // ),
                      // ),
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
                            Uint8List bytes =
                                state.compressAmount != 0 &&
                                        image.halfSizeImagebytes != null
                                    ? image.halfSizeImagebytes!
                                    : image.bytes;
                            final String size = Utils.formatSize(
                              image.bytes.length,
                            );

                            return BlocProvider(
                              key: ValueKey(
                                "${state.convertMode}_${state.compressAmount}_${state.isGrayScale}_$index",
                              ),
                              create:
                                  (context) =>
                                      ImageDisplayCubit(convertImageUsecase)
                                        ..convertImage(
                                          bytes: bytes,
                                          compressAmount: state.compressAmount,
                                          isGrayScale: state.isGrayScale,
                                          convertMode: state.convertMode,
                                        ),
                              child: BlocBuilder<
                                ImageDisplayCubit,
                                ImageDisplayState
                              >(
                                builder: (context, imageState) {
                                  return DisplayImage(
                                    bytes: imageState.image,
                                    size:
                                        imageState.size ?? "Loading file size",
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
                        sliderValue: compressAmount.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            compressAmount = value.toInt();
                          });
                        },
                        onChangedEnd: (value) {
                          context
                              .read<ConvertImagesCubit>()
                              .onCompressionAmountChanged(value.toInt());
                        },
                      ),

                      Center(
                        child: ConvertButton(
                          onPressed: () async {
                            if (state.convertMode == ConvertMode.pdf) {
                              final List<Uint8List> imageBytesList =
                                  state.images
                                      .map((image) => image.bytes)
                                      .toList();
                              Uint8List firstImage = imageBytesList[0];
                              final file = await Convert().convertImageToPdf(
                                imageBytesList,
                              );
                              Navigator.pushNamed(
                                context,
                                "/saved_files",
                                arguments: {
                                  "pdfFile": file,
                                  "firstImage": firstImage,
                                },
                              );
                            }
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
