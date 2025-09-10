// Flutter imports:
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

// Project imports:
import '../../../../../../core/enums/convert.dart';
import '../../../../../../core/resources/app_assets.dart';

enum Mode { compress, other }

class SelectMode extends StatefulWidget {
  final Function(double) onChangedEnd;
  final Function(String) onChangedTextField;
  final VoidCallback onChecked;
  final Function(Color?) onFillTransparencyColor;
  final Color? filledColor;
  final bool isGrayScaleChecked;
  final ConvertMode convertMode;
  final TextEditingController controller;
  const SelectMode({
    super.key,
    required this.onChangedTextField,
    required this.onFillTransparencyColor,
    required this.filledColor,
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
  Color? pickerColor;
  final Color _fallbackColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    pickerColor = widget.filledColor;
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
    bool isJpg = widget.convertMode == ConvertMode.jpg;

    return SizedBox(
      height: 115,
      child: Column(
        children: [
          widget.convertMode != ConvertMode.pdf
              ? InkWell(
                onTap: () async {
                  final Color? result = await showModalBottomSheet<Color?>(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: false,
                    backgroundColor: AppColors.sliderInactiveTrack,
                    builder: (BuildContext context) {
                      return _customColorPicker(
                        context,
                        isJpg,
                        widget.filledColor,
                      );
                    },
                  );

                  if (!mounted) return;
                  setState(() {
                    pickerColor = result;
                    widget.onFillTransparencyColor(result);
                  });
                },
                child: Row(
                  spacing: 20,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(13),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.indicatorDotActive,
                            width: 1.4,
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),

                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child:
                                isJpg
                                    ? ColoredBox(
                                      color:
                                          widget.filledColor ?? AppColors.white,
                                    )
                                    : Stack(
                                      children: [
                                        Image.asset(
                                          AppImages.transparent,
                                          fit: BoxFit.fill,
                                        ),
                                        ColoredBox(
                                          color:
                                              widget.filledColor ??
                                              _fallbackColor,
                                          child: const SizedBox(
                                            height: 24,
                                            width: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ),
                    ),
                    const Text(
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

  // color picker
  Widget _customColorPicker(
    BuildContext context,
    bool isJpg,
    Color? initialColor,
  ) {
    // Color? localColor = initialColor;
    final defaultColor =
        widget.convertMode == ConvertMode.jpg
            ? Colors.white
            : Colors.transparent;

    return StatefulBuilder(
      builder: (context, setSheetState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Card(
                elevation: 0,
                color: AppColors.sliderInactiveTrack,
                child: ColorPicker(
                  padding: const EdgeInsets.all(0),
                  color: pickerColor ?? defaultColor,
                  hasBorder: true,
                  elevation: 4,
                  columnSpacing: 14,
                  pickersEnabled: const {ColorPickerType.primary: false},
                  borderColor: AppColors.indicatorDot,
                  enableShadesSelection: false,
                  enableTonalPalette: true,
                  tonalColorSameSize: true,
                  enableOpacity: !isJpg,
                  opacityTrackHeight: 14,
                  opacityThumbRadius: 18,
                  spacing: 10,
                  runSpacing: 10,
                  onColorChanged: (Color color) {
                    setSheetState(() {
                      pickerColor = color;
                    });
                  },
                  width: 35,
                  height: 35,
                  borderRadius: 22,
                  heading: const Text(
                    'Choose color',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  tonalSubheading: const Text(
                    'Select color shade',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  opacitySubheading: const Text(
                    'Opacity',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      setSheetState(() {
                        pickerColor = defaultColor;
                      });
                    },
                    child: const Text(
                      "Reset",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop<Color?>(context, pickerColor);
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: AppColors.background),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
