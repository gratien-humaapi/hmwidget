import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hmwidget/size/hm_slider_size.dart';
import 'package:hmwidget/theme/slider_theme_data/range_slider_thunb_shape.dart';
import 'package:hmwidget/theme/slider_theme_data/range_slider_track.dart';
import 'package:hmwidget/theme/slider_theme_data/range_value_indicator.dart';
import 'package:styled_widget/styled_widget.dart';
import 'dart:math' as math;
import '../../type/hm_slider_type.dart';
import '../../utils/hm_raduis.dart';

class HMRangeSlider extends HookWidget {
  // final SliderCustomProps customProps;
  HMRangeSlider({
    Key? key,
    this.disabled = false,
    this.hidden = false,
    this.marks,
    this.orientation = HMOrientation.horizontal,
    this.sliderType,
    this.rangeValues,
    this.rangeMinValue = 0,
    this.rangeMaxValue = 100,
    this.color,
    this.radius = HMRadius.xl,
    this.size = HMSliderSize.md,
    required this.onChange,
  }) : super(key: key);
  final bool disabled;
  final bool hidden;
  final List<HMSliderMark>? marks;
  final HMOrientation orientation;
  final SliderType? sliderType;
  final RangeValues? rangeValues;
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
  }) {
    return marks == null
        ? getRangeSlider(rangeValues, themeData)
        : getRangeSliderwithMark(marks, rangeValues, themeData, textStyle);
  }

  @override
  Widget build(BuildContext context) {
    SliderThemeData sliderThemeData = SliderThemeData(
      trackHeight: size!.value / 2,
      rangeTrackShape: RangeSliderTrack(radius: radius!.value),
      rangeTickMarkShape: RoundRangeSliderTickMarkShape(
          tickMarkRadius: (size!.value * 15) / 100),
      activeTrackColor: disabled
          ? const Color.fromRGBO(196, 198, 200, 1)
          : const Color.fromRGBO(121, 80, 242, 1),
      inactiveTrackColor: disabled
          ? const Color.fromRGBO(228, 229, 230, 1)
          : const Color.fromRGBO(121, 80, 242, 0.4),
      rangeThumbShape: RangeThumbShape(
        thumbRadius: size!.value,
      ),
      minThumbSeparation: 10,
      thumbColor: disabled
          ? const Color.fromRGBO(196, 198, 200, 1)
          : color ?? const Color.fromRGBO(121, 80, 242, 1),
      // overlayColor: const Color.fromRGBO(121, 80, 242, 0.5),
      // overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
      overlayShape: SliderComponentShape.noOverlay,
      activeTickMarkColor:
          disabled ? const Color.fromRGBO(228, 229, 230, 1) : Colors.white,
      inactiveTickMarkColor: Colors.white60,
      rangeValueIndicatorShape:
          // PaddleRangeSliderValueIndicatorShape(),
          RangeValueIndicatorShape(sliderValue: 10, orientation: orientation),
      valueIndicatorColor: color ?? const Color.fromRGBO(121, 80, 242, 1),
      showValueIndicator: ShowValueIndicator.always,
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
    );

    TextStyle textStyle = TextStyle(
        color: disabled ? const Color.fromRGBO(177, 178, 179, 1) : Colors.black,
        fontSize: 12);
    final initialValue =
        rangeValues ?? RangeValues(rangeMinValue, rangeMaxValue);
    final selectedRange = useState(initialValue);
    return SizedBox(
      child: Transform(
        alignment: FractionalOffset.center,
        // Rotate sliders by 90 degrees
        transform: Matrix4.identity()
          ..rotateZ(
            orientation == HMOrientation.horizontal ? 0 : -math.pi / 2,
          ),

        child: AbsorbPointer(
            absorbing: disabled,
            child: _styledSlider(
              textStyle: textStyle,
              themeData: sliderThemeData,
              marks: marks,
              rangeValues: selectedRange,
            ).parent(({required child}) => _styledBox(
                  child: child,
                ))).alignment(Alignment.center),
      ),
    );
  }

  Widget getRangeSlider(
      ValueNotifier<RangeValues> rangeValues, SliderThemeData sliderThemeData) {
    var max = rangeMaxValue;
    var min = rangeMinValue;
    return Container(
      height: size!.value + 5,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: SliderTheme(
        data: sliderThemeData,
        child: RangeSlider(
          values: rangeValues.value,
          min: min,
          max: max,
          divisions: max.toInt(),
          labels: RangeLabels("${rangeValues.value.start.toInt()}",
              "${rangeValues.value.end.toInt()}"),
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
      TextStyle textStyle) {
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
              min: 0.0,
              max: marks.length - 1.0,
              divisions: marks.length - 1,
              labels: RangeLabels("${marks[range.value.start.toInt()].label}",
                  "${marks[range.value.end.toInt()].label}"),
              onChanged: (newRanges) {
                range.value = newRanges;
              },
              onChangeEnd: (newRanges) {
                onChange([range.value.start.toInt(), range.value.end.toInt()]);
              },
            ),
          ),
        ),
        orientation == HMOrientation.vertical
            ? const SizedBox(height: 6)
            : Container(),
        Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: marks.map((e) {
              return Transform.rotate(
                angle:
                    orientation == HMOrientation.horizontal ? 0 : math.pi / 2,
                child: SizedBox(
                    width: 40,
                    child: Text(
                      "${e.label}",
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
