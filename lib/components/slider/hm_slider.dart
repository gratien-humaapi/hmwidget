import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../size/hm_slider_size.dart';
import '../../theme/slider_theme_data/slider_thumb_shape.dart';
import '../../theme/slider_theme_data/slider_track.dart';
import '../../theme/slider_theme_data/slider_value_indicator.dart';
import '../../type/hm_slider_type.dart';
import '../../utils/constant.dart';
import '../../utils/hm_radius.dart';
import '../../widget_theme.dart';

class HMSlider extends HookWidget {
  // final SliderProps customProps;
  const HMSlider({
    super.key,
    this.disabled = false,
    this.hidden = false,
    this.marks,
    this.orientation,
    required this.value,
    this.min,
    this.max,
    this.color,
    this.radius,
    this.size,
    required this.onChange,
  });
  final bool disabled;
  final bool hidden;
  final List<HMSliderMark>? marks;
  final HMOrientation? orientation;
  final int value;
  final double? min;
  final double? max;
  final Color? color;
  final HMRadius? radius;
  final HMSliderSize? size;
  final void Function(dynamic) onChange;

  void handleChange(double value) {
    onChange(value);
  }

  Widget _styledBox({
    required Widget child,
  }) =>
      Visibility(visible: !hidden, child: child);

  Widget _styledSlider({
    required ValueNotifier<int> sliderValue,
    required List? marks,
    required SliderThemeData themeData,
    required TextStyle textStyle,
    required HMSliderSize sliderSize,
    required HMOrientation sliderOrientation,
    required Color sliderColor,
    required HMRadius sliderRadius,
  }) {
    return marks == null
        ? getSimpleSlider(sliderValue, themeData, sliderSize.value)
        : getSliderWithMark(
            marks, sliderValue, themeData, textStyle, sliderOrientation);
  }

  @override
  Widget build(BuildContext context) {
    final HMSliderTheme? sliderTheme =
        Theme.of(context).extension<HMSliderTheme>();
    final sliderSize = size ?? sliderTheme?.size ?? HMSliderSize.md;
    final sliderRadius = radius ?? sliderTheme?.radius ?? HMRadius.md;
    final sliderColor = color ?? sliderTheme?.color ?? defaultColor;
    final sliderOrientation =
        orientation ?? sliderTheme?.orientation ?? HMOrientation.horizontal;

    final SliderThemeData sliderThemeData = SliderThemeData(
      trackHeight: sliderSize.value / 2,
      trackShape: SliderTrack(radius: sliderRadius.value),
      activeTrackColor:
          disabled ? const Color.fromRGBO(196, 198, 200, 1) : sliderColor,
      inactiveTrackColor: disabled
          ? const Color.fromRGBO(228, 229, 230, 1)
          : sliderColor.withOpacity(0.5),
      thumbShape: SliderThumbShape(thumbRadius: sliderSize.value),
      minThumbSeparation: 10,
      thumbColor:
          disabled ? const Color.fromRGBO(196, 198, 200, 1) : sliderColor,
      overlayColor: sliderColor.withOpacity(0.3),
      // overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 15),
      tickMarkShape: RoundSliderTickMarkShape(
          tickMarkRadius: (sliderSize.value * 15) / 100),
      activeTickMarkColor:
          disabled ? const Color.fromRGBO(228, 229, 230, 1) : Colors.white,
      inactiveTickMarkColor: Colors.white60,
      valueIndicatorShape:
          ValueIndicatorShape(sliderValue: 10, orientation: sliderOrientation),
      valueIndicatorColor: sliderColor,
      showValueIndicator: ShowValueIndicator.always,
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    );

    final TextStyle textStyle = TextStyle(
        color: disabled ? const Color.fromRGBO(177, 178, 179, 1) : Colors.black,
        fontSize: 12);
    final sliderValue = useState(value);
    return SizedBox(
      child: Transform.rotate(
        angle: sliderOrientation == HMOrientation.horizontal ? 0 : -math.pi / 2,
        child: AbsorbPointer(
            absorbing: disabled,
            child: _styledSlider(
              textStyle: textStyle,
              themeData: sliderThemeData,
              sliderValue: sliderValue,
              sliderSize: sliderSize,
              sliderRadius: sliderRadius,
              sliderOrientation: sliderOrientation,
              sliderColor: sliderColor,
              marks: marks,
            ).parent(({required child}) => _styledBox(
                  child: child,
                ))),
      ),
    );
  }

  Widget getSimpleSlider(ValueNotifier<num> sValue,
      SliderThemeData sliderThemeData, double sliderSize) {
    final double maxValue = max ?? 100;
    return Container(
      height: sliderSize + 5,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: SliderTheme(
        data: sliderThemeData,
        child: Slider(
          min: min ?? 0.0,
          max: maxValue,
          value: sValue.value.toDouble(),
          divisions: maxValue.toInt(),
          label: '${sValue.value}',
          onChanged: (value) {
            sValue.value = value.toInt();
          },
          onChangeEnd: (value) {
            onChange(sValue.value);
          },
        ),
      ),
    );
  }

  Widget getSliderWithMark(
      List marks,
      ValueNotifier<int> sValue,
      SliderThemeData sliderThemeData,
      TextStyle textStyle,
      HMOrientation sliderOrientation) {
    final List a = marks.map((e) => e.value).toList();
    final sliderVal =
        useState(a.contains(sValue.value) ? a.indexOf(sValue.value) : 0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SliderTheme(
            data: sliderThemeData,
            child: Slider(
              max: marks.length - 1.0,
              value: sliderVal.value.toDouble(),
              divisions: marks.length - 1,
              label: '${marks[sliderVal.value].label}',
              onChanged: (value) {
                sliderVal.value = value.toInt();
              },
              onChangeEnd: (value) {
                onChange(sliderVal.value);
              },
            ),
          ),
        ),
        if (sliderOrientation == HMOrientation.vertical)
          const SizedBox(height: 6)
        else
          Container(),
        Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: marks.map((e) {
              return Transform.rotate(
                angle: sliderOrientation == HMOrientation.horizontal
                    ? 0
                    : math.pi / 2,
                child: SizedBox(
                    // color: Colors.amber,
                    width: 40,
                    child: Text(
                      '${e.label}',
                      textAlign: TextAlign.center,
                      style: textStyle,
                    )),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
