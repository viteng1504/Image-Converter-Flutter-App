import 'package:flutter/material.dart';

import '../../../../../core/resources/app_colors.dart';
import 'widgets/convert_button.dart';
import 'widgets/convert_mode_button.dart';
import 'widgets/display_image.dart';
import 'widgets/select_mode.dart';

enum ConvertTo { jpg, png, webp, pdf }

class ConvertImagesScreen extends StatefulWidget {
  const ConvertImagesScreen({super.key});

  @override
  _ConvertImagesScreenState createState() => _ConvertImagesScreenState();
}

class _ConvertImagesScreenState extends State<ConvertImagesScreen> {
  ConvertTo _selectedConvert = ConvertTo.jpg;
  double sliderValue = 0;

  void onSelectConvertMode(ConvertTo convertTo) {
    setState(() {
      _selectedConvert = convertTo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return const DisplayImage();
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            onSelectConvertMode(ConvertTo.jpg);
                          },
                          label: "JPG",
                          isSelected: _selectedConvert == ConvertTo.jpg,
                          isFirst: true,
                        ),
                        ConvertModeButton(
                          onPressed: () {
                            onSelectConvertMode(ConvertTo.png);
                          },
                          label: "PNG",
                          isSelected: _selectedConvert == ConvertTo.png,
                          isFirst: false,
                        ),
                        ConvertModeButton(
                          onPressed: () {
                            onSelectConvertMode(ConvertTo.webp);
                          },
                          label: "WEBP",
                          isSelected: _selectedConvert == ConvertTo.webp,
                          isFirst: false,
                        ),
                        ConvertModeButton(
                          onPressed: () {
                            onSelectConvertMode(ConvertTo.pdf);
                          },
                          label: "PDF",
                          isSelected: _selectedConvert == ConvertTo.pdf,
                          isFirst: false,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // select mode
                SelectMode(
                  sliderValue: sliderValue,
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;
                    });
                  },
                ),

                Center(child: ConvertButton(onPressed: () {})),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
