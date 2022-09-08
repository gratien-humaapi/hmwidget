import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

class HMColorPicker extends HookWidget {
  const HMColorPicker({
    super.key,
    this.disabled = false,
    this.hidden = false,
    this.displayThumbColor = true,
    this.portraitOnly = false,
    this.enableAlpha = false,
    this.currentColor,
    this.hueRingStrokeWidth = 20.0,
    this.colorPickerHeight = 250.0,
    required this.onColorChanged,
  });

  final bool disabled;
  final bool hidden;
  final bool displayThumbColor;
  final bool enableAlpha;
  final void Function(Color) onColorChanged;
  final bool portraitOnly;
  final double colorPickerHeight;
  final double hueRingStrokeWidth;
  final Color? currentColor;

  Widget _styledBox({
    required Widget child,
  }) =>
      Visibility(visible: !hidden, child: child);

  Widget _styledSelectPannel({
    required ValueNotifier<Color> pickerColor,
  }) {
    return HueRingPicker(
        displayThumbColor: displayThumbColor,
        enableAlpha: enableAlpha,
        pickerColor: pickerColor.value,
        hueRingStrokeWidth: hueRingStrokeWidth,
        colorPickerHeight: colorPickerHeight,
        onColorChanged: (color) {
          pickerColor.value = color;
          onColorChanged(color);
        });
  }

  @override
  Widget build(BuildContext context) {
    final pikerColor = useState(currentColor ?? Colors.black);
    return AbsorbPointer(
        absorbing: disabled,
        child: _styledSelectPannel(
          pickerColor: pikerColor,
        ).parent(({required child}) => _styledBox(
              child: child,
            )));
  }
}
