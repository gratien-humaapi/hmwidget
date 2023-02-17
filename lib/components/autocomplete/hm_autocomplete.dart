import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

class HMAutocomplete extends HookWidget {
  const HMAutocomplete(
      {super.key,
      this.disabled = false,
      this.hidden = false,
      required this.optionsBuilder,
      this.optionsViewBuilder,
      this.fieldViewBuilder,
      this.initialValue,
      this.onSelected,
      required this.value});
  final ValueNotifier value;
  final bool disabled;
  final bool hidden;
  final List Function(String value) optionsBuilder;
  final Widget Function(BuildContext, void Function(String), List<String>)?
      optionsViewBuilder;
  final Widget Function(
          BuildContext, TextEditingController, ValueNotifier<bool>)?
      fieldViewBuilder;
  final void Function(String)? onSelected;
  final String? initialValue;

  Widget _styledBox({
    required Widget child,
  }) =>
      Visibility(visible: !hidden, child: child);

  Widget _styledSelectPannel({
    required ValueNotifier controller,
    required ValueNotifier<bool> showClearButton,
    required BuildContext context,
    required List list,
    required ValueNotifier<String> tempValue,
  }) {
    return Column(
      children: <Widget>[
        if (fieldViewBuilder != null)
          defaultfieldViewBuilder(context, controller, showClearButton)
        else
          fieldViewBuilder!(context, controller.value as TextEditingController,
              showClearButton),
        // fieldViewBuilder != null
        //     ? fieldViewBuilder!(context, controller.value, () {})
        //     : fieldViewBuilder(context, controller, showClearButton, tempValue),
        // const SizedBox(height: 10),
        if (controller.value.text.isEmpty as bool && showClearButton.value)
          Container()
        else
          Align(
            alignment: Alignment.topLeft,
            child: ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                final option = list.elementAt(index);
                return GestureDetector(
                  onTap: () {
                    value.value = option;
                    Navigator.pop(context, option);
                  },
                  child: Container(
                    // width: double.infinity,
                    color: index == 0 ? Colors.grey[200] : null,
                    padding: const EdgeInsets.all(16.0),
                    child: Text('$option'),
                  ),
                );
              },
            ),
          )
      ],
    );
  }

  Widget defaultfieldViewBuilder(
    BuildContext context,
    ValueNotifier controller,
    ValueNotifier<bool> showClearButton,
  ) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      titleSpacing: 5.0,
      title: Container(
        height: 45,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              splashRadius: 20,
              icon: const Icon(
                Icons.keyboard_backspace,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller.value as TextEditingController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                style: const TextStyle(fontSize: 16, height: 1.5),
                decoration: const InputDecoration(
                  // filled: true,
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                ),
              ),
            ),
            if (showClearButton.value)
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: InkWell(
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.black,
                  ),
                  onTap: () {
                    controller.value.text = '';
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  // Widget? getClearButton(bool showClearButton) {
  //   if (showClearButton) {
  //     return null;
  //   }

  //   return IconButton(
  //     onPressed: () => controller.clear(),
  //     icon: Icon(Icons.clear),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List> list = useState([]);
    final ValueNotifier<String> tempValue = useState('');
    final controller = useTextEditingController(text: initialValue ?? '');
    final ValueNotifier<bool> showClearButton = useState(false);
    void _onChangedField() {
      final List options = optionsBuilder(
        controller.value.text,
      );
      list.value = options;
    }

    controller.addListener(() {
      showClearButton.value = controller.value.text.isNotEmpty;
      // if (controller.value.text != value.value) value.value = "";
      _onChangedField();
    });

    // print('value.value :${value.value}');
    return AbsorbPointer(
        absorbing: disabled,
        child: _styledSelectPannel(
          list: list.value,
          controller: controller,
          tempValue: tempValue,
          showClearButton: showClearButton,
          context: context,
        ).parent(({required Widget child}) => _styledBox(
              child: child,
            )));
  }
}
