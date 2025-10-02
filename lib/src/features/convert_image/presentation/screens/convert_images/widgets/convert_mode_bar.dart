// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../../../core/enums/convert.dart';
import '../../../../../../core/resources/app_assets.dart';
import 'convert_mode_button.dart';

class ConvertModeBar extends StatefulWidget {
  final ConvertMode convertMode;
  final Function(ConvertMode)? onPressed;
  final bool isConvertingToFiles;
  const ConvertModeBar({
    super.key,
    required this.convertMode,
    required this.onPressed,
    required this.isConvertingToFiles,
  });

  @override
  _ConvertModeBarState createState() => _ConvertModeBarState();
}

class _ConvertModeBarState extends State<ConvertModeBar> {
  Widget _buildModeButton({
    required String label,
    required ConvertMode mode,
    required bool isSelected,
    required bool isFirst,
  }) {
    return ConvertModeButton(
      onPressed:
          widget.isConvertingToFiles
              ? null
              : () {
                if (!isSelected) {
                  widget.onPressed?.call(mode);
                }
              },
      label: label,
      isSelected: isSelected,
      isFirst: isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final modes = [
      {"label": "JPG", "mode": ConvertMode.jpg},
      {"label": "PNG", "mode": ConvertMode.png},
      {"label": "WEBP", "mode": ConvertMode.webp},
      {"label": "PDF", "mode": ConvertMode.pdf},
    ];

    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color:
              widget.isConvertingToFiles
                  ? AppColors.fontGray
                  : AppColors.primary,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(modes.length, (index) {
            final label = modes[index]["label"] as String;
            final mode = modes[index]["mode"] as ConvertMode;
            final isSelected = widget.convertMode == mode;
            return _buildModeButton(
              label: label,
              mode: mode,
              isSelected: isSelected,
              isFirst: index == 0,
            );
          }),
        ),
      ),
    );
  }
}
