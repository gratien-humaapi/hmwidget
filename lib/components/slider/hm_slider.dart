import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hmwidget/size/hm_slider_size.dart';
import 'package:hmwidget/theme/slider_theme_data/range_slider_thunb_shape.dart';
import 'package:hmwidget/theme/slider_theme_data/range_slider_track.dart';
import 'package:hmwidget/theme/slider_theme_data/range_value_indicator.dart';
import 'package:hmwidget/theme/slider_theme_data/slider_thumb_shape.dart';
import 'package:hmwidget/theme/slider_theme_data/slider_track.dart';
import 'package:hmwidget/theme/slider_theme_data/slider_value_indicator.dart';

import 'package:styled_widget/styled_widget.dart';
import 'dart:math' as math;
import '../../type/hm_slider_type.dart';
import '../../utils/hm_raduis.dart';

class HMSlider extends HookWidget {
  // final SliderCustomProps customProps;
  HMSlider({
    Key? key,
    this.disabled = false,
    this.hidden = false,
    this.marks,
    this.orientation = HMOrientation.horizontal,
    required this.value,
    this.min,
    this.max,
    this.color,
    this.radius = HMRadius.md,
    this.size = HMSliderSize.md,
    required this.onChange,
  }) : super(key: key);
  final bool disabled;
  final bool hidden;
  final List<HMSliderMark>? marks;
  final HMOrientation orientation;
  final int value;
  final double? min;
  final double? max;
  final Color? color;
  final HMRadius radius;
  final HMSliderSize size;
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
  }) {
    return marks == null
        ? getSimpleSlider(sliderValue, themeData)
        : getSliderWithMark(marks, sliderValue, themeData, textStyle);
  }

  @override
  Widget build(BuildContext context) {
    SliderThemeData sliderThemeData = SliderThemeData(
      trackHeight: size.value / 2,
      trackShape: SliderTrack(radius: radius.value),
      activeTrackColor: disabled
          ? const Color.fromRGBO(196, 198, 200, 1)
          : const Color.fromRGBO(121, 80, 242, 1),
      inactiveTrackColor: disabled
          ? const Color.fromRGBO(228, 229, 230, 1)
          : const Color.fromRGBO(121, 80, 242, 0.4),
      thumbShape: SliderThumbShape(thumbRadius: size.value),
      minThumbSeparation: 10,
      thumbColor: disabled
          ? const Color.fromRGBO(196, 198, 200, 1)
          : color ?? const Color.fromRGBO(121, 80, 242, 1),
      // overlayColor: const Color.fromRGBO(121, 80, 242, 0.5),
      // overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
      overlayShape: SliderComponentShape.noOverlay,
      tickMarkShape:
          RoundSliderTickMarkShape(tickMarkRadius: (size.value * 15) / 100),
      activeTickMarkColor:
          disabled ? const Color.fromRGBO(228, 229, 230, 1) : Colors.white,
      inactiveTickMarkColor: Colors.white60,
      valueIndicatorShape:
          ValueIndicatorShape(sliderValue: 10, orientation: orientation),
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
    final sliderValue = useState(value);
    return SizedBox(
      child: Transform.rotate(
        angle: orientation == HMOrientation.horizontal ? 0 : -math.pi / 2,
        child: AbsorbPointer(
            absorbing: disabled,
            child: _styledSlider(
              textStyle: textStyle,
              themeData: sliderThemeData,
              sliderValue: sliderValue,
              marks: marks,
            ).parent(({required child}) => _styledBox(
                  child: child,
                ))),
      ),
    );
  }

  Widget getSimpleSlider(
      ValueNotifier<num> sValue, SliderThemeData sliderThemeData) {
    double maxValue = max ?? 100;
    return Container(
      height: size.value + 5,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: SliderTheme(
        data: sliderThemeData,
        child: Slider(
          min: 0.0,
          max: maxValue,
          value: sValue.value.toDouble(),
          divisions: maxValue.toInt(),
          label: "${sValue.value}",
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

  Widget getSliderWithMark(List marks, ValueNotifier<int> sValue,
      SliderThemeData sliderThemeData, TextStyle textStyle) {
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
              min: 0.0,
              max: marks.length - 1.0,
              value: sliderVal.value.toDouble(),
              divisions: marks.length - 1,
              label: "${marks[sliderVal.value].label}",
              onChanged: (value) {
                sliderVal.value = value.toInt();
              },
              onChangeEnd: (value) {
                onChange(sliderVal.value);
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
                child: Container(
                    // color: Colors.amber,
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
