// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
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
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headerText,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 40,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                bodyText,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
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
