import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/resources/app_assets.dart';

class DisplayImage extends StatefulWidget {
  final Uint8List bytes;
  final String size;
  final bool isLoadingImage;
  final bool isLoadingSize;
  const DisplayImage({
    super.key,
    required this.bytes,
    required this.size,
    required this.isLoadingImage,
    required this.isLoadingSize,
  });

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
                widget.isLoadingImage
                    ? const ColoredBox(
                      color: AppColors.indicatorDot,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                    : Image.memory(
                      widget.bytes,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
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
    );
  }
}
