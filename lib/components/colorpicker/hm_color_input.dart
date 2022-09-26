import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../components/button/hm_button.dart';
import '../../components/colorpicker/hm_color_piker.dart';
import '../../type/hm_button_type.dart';
import 'logic.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}

class HMColorIpnut extends HookWidget {
  HMColorIpnut(
      {super.key,
      this.initialColor,
      required this.onColorChange,
      this.inputRadius = 8});
  final String? initialColor;
  final double inputRadius;
  final void Function(String) onColorChange;

  TextEditingController colorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> myColor = useState(initialColor ?? '#FF000000');
    colorController.value = TextEditingValue(
        text: myColor.value,
        selection: TextSelection.collapsed(offset: myColor.value.length));

    // myColor.addListener(() {});
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            showColorDialog(context, myColor.value).then((dynamic value) {
              // print(value);
              if (value != null && value != myColor.value.toColor()) {
                myColor.value = colorToString(value as Color);
                onColorChange(myColor.value);
              }
            });
          },
          child: CircleAvatar(
            backgroundColor: myColor.value.toColor(),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          width: 100,
          height: 40,
          // color: Colors.blue,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(238, 238, 239, 1),
            borderRadius: BorderRadius.circular(inputRadius),
          ),
          child: TextField(
            controller: colorController,
            style: const TextStyle(height: 1.5),
            readOnly: true,
            maxLength: 8,
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
              // filled: true,
              isDense: true,
              // prefix: Text("#"),
            ),
          ),
        ),
      ],
    ).center();
  }

  Future<dynamic> showColorDialog(BuildContext context, String currentColor) {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          Color cValue = currentColor.toColor();
          return AlertDialog(
            titlePadding: const EdgeInsets.all(10),
            // titleTextStyle: const TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 20,
            //     color: Colors.black),
            title: const Text('Color picker').fontSize(20),
            content: SingleChildScrollView(
              child: HMColorPicker(
                currentColor: currentColor.toColor(),
                onColorChanged: (Color color) {
                  cValue = color;
                },
              ),
            ),
            actions: [
              HMButton(
                onPressed: () => Navigator.pop(context),
                buttonVariant: HMButtonVariant.outlined,
                content: 'Cancel',
                textColor: Colors.blue,
              ),
              HMButton(
                onPressed: () => Navigator.pop(context, cValue),
                buttonVariant: HMButtonVariant.filled,
                content: 'Save',
                fillColor: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          );
        });
  }
}
