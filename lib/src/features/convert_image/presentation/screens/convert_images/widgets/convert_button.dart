import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/resources/app_colors.dart';
import '../../../../../../core/resources/app_icons.dart';

class ConvertButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ConvertButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),

        backgroundColor: AppColors.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          SvgPicture.asset(AppIcons.save, color: AppColors.font, width: 30,),
          const Text(
            "Convert",
            style: TextStyle(color: AppColors.font, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
