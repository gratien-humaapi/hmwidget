# HM Widget

Easy to use open source UI library with Widgets to build flutter app.

## Installation

1. Add the latest version of package to your pubspec.yaml (and run`flutter pub get`):

```yaml
dependencies:
  hmwidget: ^0.0.3
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

```dart
import 'package:flutter/material.dart';
import 'package:hmwidget/hmwidget.dart';
void main() => runApp(
      const MaterialApp(
        home: Material(
          child:Scaffold(
            body: Center(
            child: HMButton(
                  onPressed: () => print("Pressed"),
                  buttonVariant: HMButtonVariant.outlined,
                  content: 'Press',
                  textColor: Colors.blue,
              ),
          ),
        ),
      ),
      ),
    );
```

See the example app for more complex examples.
