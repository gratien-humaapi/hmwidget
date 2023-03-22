import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hmwidget/utils/constant.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../size/hm_autocomplete_size.dart';
import '../../utils/hm_radius.dart';
import '../../widget_theme.dart';
import '../detailspage/hm_details_page.dart';

class HMAutocomplete extends HookWidget {
  const HMAutocomplete({
    super.key,
    this.disabled = false,
    this.hidden = false,
    this.isModalView = true,
    required this.optionsBuilder,
    this.optionsViewBuilder,
    this.fieldViewBuilder,
    this.fillColor,
    this.initialValue,
    required this.onSelected,
    this.hintText,
    this.selectPanelDecoration,
    this.selectedBgColor,
    this.selectedValueTextStyle,
    this.radius,
    this.size,
  });
  final bool disabled;
  final HMAutocompleteSize? size;
  final HMRadius? radius;
  final bool hidden;
  final bool isModalView;
  final String? initialValue;
  final BoxDecoration? selectPanelDecoration;
  final TextStyle? selectedValueTextStyle;
  final Color? fillColor;
  final Color? selectedBgColor;
  final List<String> Function(String value) optionsBuilder;
  final Widget Function(BuildContext, void Function(String), List<String>)?
      optionsViewBuilder;
  final Widget Function(BuildContext, TextEditingController, bool)?
      fieldViewBuilder;
  final void Function(String) onSelected;
  final String? hintText;

//
  double _getTextSize(HMAutocompleteSize size) {
    switch (size) {
      case HMAutocompleteSize.xs:
        return 12.0;
      case HMAutocompleteSize.sm:
        return 14.0;
      case HMAutocompleteSize.md:
        return 16.0;
      case HMAutocompleteSize.lg:
        return 18.0;
      case HMAutocompleteSize.xl:
        return 20.0;
    }
  }

//
  Widget _styledBox({
    required Widget child,
  }) =>
      Visibility(visible: !hidden, child: child);

  @override
  Widget build(BuildContext context) {
    final selectTheme = Theme.of(context).extension<HMAutocompleteTheme>();
    final HMAutocompleteSize autocompleteSize =
        size ?? selectTheme?.size ?? HMAutocompleteSize.md;
    final HMRadius boxRadius = radius ?? selectTheme?.radius ?? HMRadius.md;
    final Color inputColor =
        fillColor ?? selectTheme?.fillColor ?? Colors.grey.shade200;
    final Color activeOptionColor =
        selectedBgColor ?? selectTheme?.selectedBgColor ?? Colors.grey.shade300;

    return AbsorbPointer(
      absorbing: disabled,
      child: DetailsPage(
        destinationPage: _SelectPannel(
                initialValue: initialValue ?? '',
                selectedBgColor: activeOptionColor,
                onSelected: onSelected,
                optionsBuilder: optionsBuilder)
            .parent(({required Widget child}) => _styledBox(
                  child: child,
                )),
        isModal: isModalView,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: selectPanelDecoration ??
              BoxDecoration(
                  color: inputColor,
                  borderRadius: BorderRadius.circular(boxRadius.value)),
          height: autocompleteSize.value,
          child: Align(
            alignment: Alignment.centerLeft,
            child: initialValue != null && initialValue!.isEmpty
                ? Text(
                    hintText ?? '',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: _getTextSize(autocompleteSize)),
                  )
                : Text(
                    '$initialValue',
                    style: selectedValueTextStyle,
                  ),
          ),
        ),
      ),
    );
  }
}

class _SelectPannel extends HookWidget {
  const _SelectPannel({
    super.key,
    required this.initialValue,
    required this.optionsBuilder,
    this.selectedBgColor,
    this.optionsViewBuilder,
    this.fieldViewBuilder,
    required this.onSelected,
  });
  final List<String> Function(String value) optionsBuilder;
  final Color? selectedBgColor;
  final String initialValue;
  final Widget Function(BuildContext context, void Function(String) onSelected,
      List<String> options)? optionsViewBuilder;
  final Widget Function(BuildContext, TextEditingController, bool)?
      fieldViewBuilder;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<String>> list = useState([]);
    final ValueNotifier<bool> showClearButton = useState(false);
    final controller = useState(TextEditingController(text: initialValue));
    // Call when value change
    void _onChangedField() {
      final List<String> options = optionsBuilder(
        controller.value.text,
      );
      list.value = options;
      print(list.value);
    }

    controller.value.addListener(() {
      showClearButton.value = controller.value.text.isNotEmpty;
      print(showClearButton.value);
      // if (controller.value.text != value.value) value.value = "";
      _onChangedField();
    });
    return Column(
      children: <Widget>[
        if (fieldViewBuilder == null)
          AppBar(
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
                      controller: controller.value,
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
                      onChanged: (value) {
                        // _onChangedField(
                        //   value,
                        // );
                      },
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
                          controller.value.clear();
                        },
                      ),
                    )
                ],
              ),
            ),
          )
        else
          fieldViewBuilder!(context, controller.value, showClearButton.value),
        if (controller.value.text.isEmpty && showClearButton.value)
          Container()
        else
          optionsViewBuilder != null
              ? optionsViewBuilder!(context, onSelected, list.value)
              : Align(
                  alignment: Alignment.topLeft,
                  child: ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: list.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = list.value.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          // value = option;
                          Navigator.pop(context);
                          controller.value.clear();

                          onSelected(option);
                        },
                        child: Container(
                          // width: double.infinity,
                          color: index == 0 ? selectedBgColor : null,
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
}
