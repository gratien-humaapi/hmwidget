<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# HM Widget

Easy to use open source UI library with Widgets to build flutter app.

## Installation 

1. Add the latest version of package to your pubspec.yaml (and run`flutter pub get`):
```yaml
dependencies:
  hmwidget: ^0.0.1
```
2. Import the package and use it in your Flutter App.
```dart
import 'package:hmwidget/hmwidget.dart';
```

## Get started

There are a number of widget that you can customize:

- HMButton
- HMIconButton
- HMCheckBox
- HMSwitch
- HMSlider
- HMRangeSlider
- HMTextField
- HMRadio
- HMSelect
- HMAutoComplete

### Example

<?code-excerpt "basic.dart (basic-example)"?>
``` dart
import 'package:flutter/material.dart';
import 'package:hmwidget/hmwidget.dart';
void main() => runApp(
      const MaterialApp(
        home: Material(
          child: Center(
            child: HMButton(
                  onPressed: () => print("Pressed"),
                  buttonVariant: HMButtonVariant.outlined,
                  content: 'Press',
                  textColor: Colors.blue,
              ),
          ),
        ),
      ),
    );
}
```

See the example app for more complex examples.

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
