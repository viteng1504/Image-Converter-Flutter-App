// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import '../../../../../../core/resources/app_assets.dart';

class DisplayImage extends StatefulWidget {
  final Uint8List? bytes;
  final String size;
  final bool isLoadingImage;
  final bool isLoadingSize;
  final bool isGrayScale;
  const DisplayImage({
    super.key,
    this.bytes,
    required this.size,
    required this.isLoadingImage,
    required this.isLoadingSize,
    required this.isGrayScale,
  });

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.indicatorDot,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(
          children: [
            // Image.asset(AppIcons.selectImage, fit: BoxFit.cover),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child:
                  (widget.isLoadingImage || widget.bytes == null)
                      ? const ColoredBox(
                        color: AppColors.indicatorDot,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                      : ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.dst,
                        ),
                        child: Image.memory(
                          widget.bytes!,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          // gaplessPlayback: true,
                          frameBuilder: (
                            context,
                            child,
                            frame,
                            wasSynchronouslyLoaded,
                          ) {
                            //loading if image.memory doenst finish decoding
                            if (wasSynchronouslyLoaded || frame != null) {
                              return child;
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ); //
                            }
                          },
                        ),
                      ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.sliderInactiveTrack,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(9),
                  ),
                ),
                child: Text(
                  widget.isLoadingSize ? "Loading file size" : widget.size,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
