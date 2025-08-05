// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../../../core/enums/convert.dart';
import '../../../../../../core/resources/app_assets.dart';
import 'convert_mode_button.dart';

class ConvertModeBar extends StatefulWidget {
  final ConvertMode convertMode;
  final Function(ConvertMode) onPressed;
  const ConvertModeBar({
    super.key,
    required this.convertMode,
    required this.onPressed,
  });

  @override
  _ConvertModeBarState createState() => _ConvertModeBarState();
}

class _ConvertModeBarState extends State<ConvertModeBar> {
  @override
  Widget build(BuildContext context) {
    bool isJpgSelected = widget.convertMode == ConvertMode.jpg;
    bool isPngSelected = widget.convertMode == ConvertMode.png;
    bool isWebpSelected = widget.convertMode == ConvertMode.webp;
    bool isPdfSelected = widget.convertMode == ConvertMode.pdf;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConvertModeButton(
              onPressed: () {
                if (!isJpgSelected) {
                  widget.onPressed(ConvertMode.jpg);
                }
              },
              label: "JPG",
              isSelected: isJpgSelected,
              isFirst: true,
            ),
            ConvertModeButton(
              onPressed: () {
                if (!isPngSelected) {
                  widget.onPressed(ConvertMode.png);
                }
              },
              label: "PNG",
              isSelected: isPngSelected,
              isFirst: false,
            ),
            ConvertModeButton(
              onPressed: () {
                if (!isWebpSelected) {
                  widget.onPressed(ConvertMode.webp);
                }
              },
              label: "WEBP",
              isSelected: isWebpSelected,
              isFirst: false,
            ),
            ConvertModeButton(
              onPressed: () {
                if (!isPdfSelected) {
                  widget.onPressed(ConvertMode.pdf);
                }
              },
              label: "PDF",
              isSelected: isPdfSelected,
              isFirst: false,
            ),
          ],
        ),
      ),
    );
  }
}
