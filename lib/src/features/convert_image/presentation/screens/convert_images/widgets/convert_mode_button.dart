// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../../../core/resources/app_assets.dart';

class ConvertModeButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isSelected;
  final bool isFirst;

  const ConvertModeButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isSelected,
    required this.isFirst,
  });

  @override
  _ConvertModeButtonState createState() => _ConvertModeButtonState();
}

class _ConvertModeButtonState extends State<ConvertModeButton> {
  @override
  Widget build(BuildContext context) {
    final color =
        widget.onPressed == null ? AppColors.fontGray : AppColors.primary;
    return Expanded(
      flex: 1,
      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: widget.onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: widget.isSelected ? color : null,
              border:
                  widget.isFirst
                      ? null
                      : Border(left: BorderSide(color: color, width: 2)),
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16,
                  color: widget.isSelected ? AppColors.font : color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
