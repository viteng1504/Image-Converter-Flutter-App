// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../../../../../core/enums/convert.dart';
import '../../../../../../core/resources/app_assets.dart';

enum Mode { compress, other }

class SelectMode extends StatefulWidget {
  final Function(double) onChangedEnd;
  final Function(String) onChangedTextField;
  final VoidCallback onChecked;
  final bool isGrayScaleChecked;
  final ConvertMode convertMode;
  final TextEditingController controller;
  const SelectMode({
    super.key,
    required this.onChangedTextField,
    required this.isGrayScaleChecked,
    required this.onChangedEnd,
    required this.onChecked,
    required this.convertMode,
    required this.controller,
  });

  @override
  _SelectModeState createState() => _SelectModeState();
}

class _SelectModeState extends State<SelectMode> {
  Mode _modeSelected = Mode.compress;
  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          if (_modeSelected == Mode.compress) _compressTab() else _otherTab(),
          // const SizedBox(height: 32),
          const Divider(thickness: 0.2),

          const SizedBox(height: 8),

          Row(
            spacing: 10,
            children: [
              _modeButton(Mode.compress, "Compress"),
              _modeButton(Mode.other, "Other"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _compressTab() {
    return SizedBox(
      height: 115,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Compression amount",
            style: TextStyle(
              color: AppColors.fontGray,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),
          Row(
            spacing: 0,
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  "${sliderValue.round().toString()}%",
                  style: const TextStyle(
                    color: AppColors.fontGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: const SliderThemeData(
                    padding: EdgeInsets.all(0),
                    trackHeight: 12,
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.sliderInactiveTrack,
                    // trackHeight: 8,
                    thumbColor: AppColors.primary,
                    // overlayColor: Color(0x557B9BFF),
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14),
                    trackShape: RoundedRectSliderTrackShape(),
                  ),
                  child: Slider(
                    value: sliderValue,
                    onChanged: (value) {
                      setState(() {
                        // widget.onChanged(value);
                        // sliderChanged(value);
                        sliderValue = value;
                      });
                    },
                    onChangeEnd: widget.onChangedEnd,
                    min: 0,
                    max: 100,
                    divisions: 100,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _otherTab() {
    return SizedBox(
      height: 115,
      child: Column(
        children: [
          widget.convertMode != ConvertMode.pdf
              ? InkWell(
                onTap: () {
                  // showModalBottomSheet(context: context, ;
                },
                child: const Row(
                  spacing: 20,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(13),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.fontGray,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: SizedBox(width: 23, height: 23),
                      ),
                    ),
                    Text(
                      "Fill transparency color",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.fontGray,
                      ),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: TextField(
                  controller: widget.controller,
                  scrollPadding: const EdgeInsets.only(bottom: 300),
                  cursorColor: AppColors.primary,

                  onChanged: widget.onChangedTextField,

                  style: const TextStyle(color: AppColors.fontGray),

                  decoration: const InputDecoration(
                    filled: true,
                    labelText: "File name",
                    labelStyle: TextStyle(color: AppColors.fontGray),
                    floatingLabelStyle: TextStyle(
                      color: AppColors.fontGray,
                      fontWeight: FontWeight.w500,
                    ),

                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.fontGray),
                    ),

                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    focusColor: AppColors.white,
                    fillColor: AppColors.sliderInactiveTrack,
                  ),
                ),
              ),
          InkWell(
            onTap: () {
              widget.onChecked();
            },
            child: Row(
              spacing: 20,
              children: [
                Checkbox(
                  side: const BorderSide(color: AppColors.fontGray, width: 2),
                  checkColor: AppColors.white,
                  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primary;
                    }
                    return Colors.transparent;
                  }),
                  value: widget.isGrayScaleChecked,
                  onChanged: (_) {
                    widget.onChecked();
                  },
                ),

                const Text(
                  "Gray scale (black and white)",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.fontGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //button widget
  Widget _modeButton(Mode mode, String label) {
    final bool isSelected = _modeSelected == mode;
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? AppColors.sliderInactiveTrack : AppColors.background,
        ),
        onPressed: () {
          setState(() {
            _modeSelected = mode;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          // mainAxisSize: MainAxisSize.max,
          children: [
            if (mode == Mode.compress && sliderValue != 0)
              const DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: SizedBox(width: 7, height: 7),
              ),
            if (mode == Mode.other && widget.isGrayScaleChecked == true)
              const DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: SizedBox(width: 7, height: 7),
              ),
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: AppColors.fontGray),
            ),
          ],
        ),
      ),
    );
  }
}
