import 'package:flutter/material.dart';

import '../../../../../../core/resources/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  final String image;
  final String headerText;
  final String bodyText;
  const WelcomeScreen({
    super.key,
    required this.image,
    required this.headerText,
    required this.bodyText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child:
                image == ""
                    ? const SizedBox()
                    : Image.asset(
                      image,
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headerText,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 48,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                bodyText,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
