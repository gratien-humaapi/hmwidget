import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    this.modalRadius,
    this.optionsPaddding,
    this.selectedIcon,
    required this.onSelected,
    this.hintText,
    this.selectPanelDecoration,
    this.selectedBgColor,
    this.selectedValueTextStyle,
    this.radius,
    this.size,
    this.optionsTextStyle,
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
  final double? modalRadius;
  final Widget? selectedIcon;
  final TextStyle? optionsTextStyle;
  final EdgeInsets? optionsPaddding;
  final Color? selectedBgColor;
  final List<String> Function(String value) optionsBuilder;
  final Widget Function(BuildContext, void Function(String), List<String>)?
      optionsViewBuilder;
  final Widget Function(BuildContext, TextEditingController, bool,
      void Function(String value))? fieldViewBuilder;
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

    final bool hasValue = initialValue != null && initialValue!.isNotEmpty;

    return AbsorbPointer(
      absorbing: disabled,
      child: DetailsPage(
        radius: modalRadius,
        destinationPage: _SelectPannel(
            initialValue: initialValue ?? '',
            selectedBgColor: activeOptionColor,
            onSelected: onSelected,
            fieldViewBuilder: fieldViewBuilder,
            optionsPaddding: optionsPaddding,
            optionsViewBuilder: optionsViewBuilder,
            optionsTextStyle: optionsTextStyle,
            selectedIcon: selectedIcon,
            radius: boxRadius.value,
            optionsBuilder: optionsBuilder),
        isModal: isModalView,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 15),
          decoration: selectPanelDecoration ??
              BoxDecoration(
                  color: inputColor,
                  borderRadius: BorderRadius.circular(boxRadius.value)),
          height: autocompleteSize.value,
          child: Row(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: hasValue
                    ? Text(
                        '$initialValue',
                        overflow: TextOverflow.ellipsis,
                        style: selectedValueTextStyle ??
                            TextStyle(
                                fontSize: _getTextSize(autocompleteSize),
                                height: 1.5),
                      )
                    : Text(
                        hintText ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: _getTextSize(autocompleteSize)),
                      ),
              )),
              if (hasValue)
                Container(
                  decoration: BoxDecoration(
                      color: inputColor,
                      borderRadius: BorderRadius.circular(boxRadius.value)),
                  width: 50,
                  child: Center(
                    child: Icon(
                      Icons.close_rounded,
                      size: autocompleteSize.value * 0.5,
                      color: Colors.grey,
                    ),
                  ),
                ).gestures(
                  onTap: () => onSelected(''),
                ),
            ],
          ),
        ).parent(({required Widget child}) => _styledBox(
              child: child,
            )),
      ),
    );
  }
}

class _SelectPannel extends HookWidget {
  const _SelectPannel({
    required this.initialValue,
    required this.optionsBuilder,
    this.selectedBgColor,
    this.optionsTextStyle,
    this.radius,
    this.selectedIcon,
    this.optionsViewBuilder,
    this.fieldViewBuilder,
    this.optionsPaddding,
    required this.onSelected,
  });
  final List<String> Function(String value) optionsBuilder;
  final Color? selectedBgColor;
  final String initialValue;
  final Widget? selectedIcon;
  final TextStyle? optionsTextStyle;
  final double? radius;
  final Widget Function(BuildContext context, void Function(String) onSelected,
      List<String> options)? optionsViewBuilder;
  final Widget Function(BuildContext, TextEditingController, bool,
      void Function(String value))? fieldViewBuilder;
  final void Function(String) onSelected;
  final EdgeInsets? optionsPaddding;

  @override
  Widget build(BuildContext context) {
    final list = useState([]);
    final showClearButton = useState(false);
    final controller = useTextEditingController(text: initialValue);
    // Call when value change
    void _onChangedField(String value) {
      showClearButton.value = value.isNotEmpty;
      final List<String> options = optionsBuilder(value
          // controller.text,
          );
      // print(options);
      list.value = options;
      // print(list.value);
    }

    useEffect(() {
      // showClearButton.value = controller.text.isNotEmpty;
      // print('showCloseButton ${showClearButton.value}');
      _onChangedField(initialValue);
      return null;
    }, []);

    // controller.value.addListener(() {
    //   showClearButton.value = controller.value.text.isNotEmpty;
    //   print(showClearButton.value);
    //   // if (controller.value.text != value.value) value.value = "";
    //   _onChangedField();
    // });

    // _onChangedField(initialValue);

    return Column(
      children: <Widget>[
        if (fieldViewBuilder != null)
          fieldViewBuilder!(
              context, controller, showClearButton.value, _onChangedField)
        else
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            titleSpacing: 5.0,
            toolbarHeight: 60,
            title: Container(
              height: 45,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(radius ?? 8)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    splashRadius: 20,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      // autofocus: true,
                      // focusNode: myFocusNode,
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
                        _onChangedField(value);
                        // _onChangedField(
                        //   value,
                        // );
                      },
                    ),
                  ),
                  if (showClearButton.value)
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: InkWell(
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.black,
                        ),
                        onTap: () {
                          controller.clear();
                          _onChangedField('');
                        },
                      ),
                    )
                ],
              ),
            ),
          ),

        // if (controller.value.text.isEmpty && showClearButton.value)
        //   Container()
        // else
        if (optionsViewBuilder != null)
          optionsViewBuilder!(context, onSelected, list.value as List<String>)
        else
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: optionsPaddding ??
                    const EdgeInsets.only(bottom: 20, left: 15, right: 15),
                controller: ScrollController(),
                physics: const BouncingScrollPhysics(),
                // shrinkWrap: true,
                itemCount: list.value.length,
                itemBuilder: (BuildContext context, int index) {
                  final option = list.value.elementAt(index) as String;
                  return GestureDetector(
                    onTap: () {
                      // value = option;
                      onSelected(option);
                      controller.clear();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      dense: true,
                      title: Text(
                        option,
                        overflow: TextOverflow.ellipsis,
                        style: optionsTextStyle,
                      ),
                    ),
                  );
                },
              ),
            ),
          )
      ],
    );
  }
}
