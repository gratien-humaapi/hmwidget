import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../size/hm_slider_size.dart';
import '../../theme/slider_theme_data/range_slider_thunb_shape.dart';
import '../../theme/slider_theme_data/range_slider_track.dart';
import '../../theme/slider_theme_data/range_value_indicator.dart';
import '../../type/hm_slider_type.dart';
import '../../utils/constant.dart';
import '../../utils/hm_radius.dart';
import '../../widget_theme.dart';

class HMRangeSlider extends HookWidget {
  // final SliderProps customProps;
  const HMRangeSlider({
    super.key,
    this.disabled = false,
    this.hidden = false,
    this.marks,
    this.orientation,
    required this.rangeValues,
    this.rangeMinValue = 0,
    this.rangeMaxValue = 100,
    this.color,
    this.radius,
    this.size,
    required this.onChange,
  });
  final bool disabled;
  final bool hidden;
  final List<HMSliderMark>? marks;
  final HMOrientation? orientation;
  final RangeValues rangeValues;
  final double rangeMinValue;
  final double rangeMaxValue;
  final Color? color;
  final HMRadius? radius;
  final HMSliderSize? size;
  final void Function(List<int>) onChange;

  Widget _styledBox({
    required Widget child,
  }) =>
      Visibility(visible: !hidden, child: child);

  Widget _styledSlider({
    required List? marks,
    required ValueNotifier<RangeValues> rangeValues,
    required SliderThemeData themeData,
    required TextStyle textStyle,
    required HMSliderSize sliderSize,
    required HMOrientation sliderOrientation,
    required Color sliderColor,
    required HMRadius sliderRadius,
  }) {
    return marks == null
        ? getRangeSlider(rangeValues, themeData, sliderSize.value)
        : getRangeSliderwithMark(
            marks, rangeValues, themeData, textStyle, sliderOrientation);
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
      rangeTrackShape: RangeSliderTrack(radius: sliderRadius.value),
      rangeTickMarkShape: RoundRangeSliderTickMarkShape(
          tickMarkRadius: (sliderSize.value * 15) / 100),
      activeTrackColor:
          disabled ? const Color.fromRGBO(196, 198, 200, 1) : sliderColor,
      inactiveTrackColor: disabled
          ? const Color.fromRGBO(228, 229, 230, 1)
          : sliderColor.withOpacity(0.5),
      rangeThumbShape: RangeThumbShape(
        thumbRadius: sliderSize.value,
      ),
      minThumbSeparation: 10,
      thumbColor:
          disabled ? const Color.fromRGBO(196, 198, 200, 1) : sliderColor,
      overlayColor: sliderColor.withOpacity(0.3),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 15),
      activeTickMarkColor:
          disabled ? const Color.fromRGBO(228, 229, 230, 1) : Colors.white,
      inactiveTickMarkColor: Colors.white60,
      rangeValueIndicatorShape:
          // PaddleRangeSliderValueIndicatorShape(),
          RangeValueIndicatorShape(
              sliderValue: 10, orientation: sliderOrientation),
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
    final initialValue = rangeValues;
    final selectedRange = useState(initialValue);
    return SizedBox(
      child: Transform(
        alignment: FractionalOffset.center,
        // Rotate sliders by 90 degrees
        transform: Matrix4.identity()
          ..rotateZ(
            sliderOrientation == HMOrientation.horizontal ? 0 : -math.pi / 2,
          ),

        child: AbsorbPointer(
            absorbing: disabled,
            child: _styledSlider(
              textStyle: textStyle,
              themeData: sliderThemeData,
              marks: marks,
              rangeValues: selectedRange,
              sliderSize: sliderSize,
              sliderRadius: sliderRadius,
              sliderOrientation: sliderOrientation,
              sliderColor: sliderColor,
            ).parent(({required child}) => _styledBox(
                  child: child,
                ))),
      ),
    );
  }

  Widget getRangeSlider(ValueNotifier<RangeValues> rangeValues,
      SliderThemeData sliderThemeData, double sliderSize) {
    final max = rangeMaxValue;
    final min = rangeMinValue;
    return Container(
      height: sliderSize + 5,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: SliderTheme(
        data: sliderThemeData,
        child: RangeSlider(
          values: rangeValues.value,
          min: min,
          max: max,
          divisions: max.toInt(),
          labels: RangeLabels('${rangeValues.value.start.toInt()}',
              '${rangeValues.value.end.toInt()}'),
          onChanged: (RangeValues newRanges) {
            rangeValues.value = newRanges;
          },
          onChangeEnd: (RangeValues newRanges) {
            onChange([
              rangeValues.value.start.toInt(),
              rangeValues.value.end.toInt()
            ]);
          },
        ),
      ),
    );
  }

  Widget getRangeSliderwithMark(
      List marks,
      ValueNotifier<RangeValues> rangeValues,
      SliderThemeData sliderThemeData,
      TextStyle textStyle,
      HMOrientation sliderOrientation) {
    final List a = marks.map((e) => e.value).toList();
    final range = useState(RangeValues(
        a.contains(rangeValues.value.start)
            ? a.indexOf(rangeValues.value.start).toDouble()
            : 0.0,
        a.contains(rangeValues.value.end)
            ? a.indexOf(rangeValues.value.end).toDouble()
            : marks.length - 1));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SliderTheme(
            data: sliderThemeData,
            child: RangeSlider(
              values: range.value,
              max: marks.length - 1.0,
              divisions: marks.length - 1,
              labels: RangeLabels('${marks[range.value.start.toInt()].label}',
                  '${marks[range.value.end.toInt()].label}'),
              onChanged: (newRanges) {
                range.value = newRanges;
              },
              onChangeEnd: (newRanges) {
                onChange([range.value.start.toInt(), range.value.end.toInt()]);
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
